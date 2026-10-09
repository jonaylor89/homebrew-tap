import hashlib
import importlib.util
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

SCRIPT = Path(__file__).resolve().parents[1] / "scripts/update-mino.py"
spec = importlib.util.spec_from_file_location("update_mino", SCRIPT)
updater = importlib.util.module_from_spec(spec)
spec.loader.exec_module(updater)
DOWNLOAD_SHA256 = updater.download_sha256


class UpdateMinoTests(unittest.TestCase):
    def setUp(self):
        temporary = tempfile.TemporaryDirectory()
        self.addCleanup(temporary.cleanup)
        self.cask = Path(temporary.name) / "mino.rb"
        self.original = (f'cask "mino" do\n  version "0.1.14"\n'
                         f'  sha256 "{"a" * 64}"\n  app "Mino.app"\nend\n')
        self.cask.write_text(self.original)
        self.digest = hashlib.sha256(b"test DMG").hexdigest()
        self.manifest = self.release("0.1.15")
        self.checksums = f'{self.digest}  Mino-0.1.15.dmg\n{"b" * 64}  Mino-0.1.15.zip\n'
        self.fetch = self.enterContext(patch.object(updater, "fetch_text", side_effect=self.fetch_text))
        self.download = self.enterContext(patch.object(updater, "download_sha256", return_value=self.digest))

    def release(self, version):
        url = f"{updater.BASE_URL}/v{version}"
        return {"version": version, "dmg": f"{url}/Mino-{version}.dmg",
                "checksums": f"{url}/SHA256SUMS.txt"}

    def fetch_text(self, url):
        if url == f"{updater.BASE_URL}/latest.json":
            return json.dumps(self.manifest)
        self.assertEqual(url, self.manifest["checksums"])
        return self.checksums

    def assert_rejected(self):
        with self.assertRaises(ValueError):
            updater.update_cask(self.cask)
        self.assertEqual(self.cask.read_text(), self.original)

    def test_verified_update_changes_only_version_and_checksum(self):
        self.assertEqual(updater.update_cask(self.cask), "0.1.15")
        expected = self.original.replace('"0.1.14"', '"0.1.15"').replace("a" * 64, self.digest)
        self.assertEqual(self.cask.read_text(), expected)
        self.download.assert_called_once_with(self.manifest["dmg"])

    def test_same_version_is_noop_without_download(self):
        self.manifest = self.release("0.1.14")
        self.assertIsNone(updater.update_cask(self.cask))
        self.assertEqual(self.cask.read_text(), self.original)
        self.download.assert_not_called()
        self.assertEqual(self.fetch.call_count, 1)

    def test_refuses_downgrade(self):
        self.manifest = self.release("0.1.13")
        self.assert_rejected()
        self.download.assert_not_called()

    def test_compares_versions_numerically(self):
        self.manifest = self.release("0.1.100")
        self.checksums = f"{self.digest}  Mino-0.1.100.dmg\n"
        self.assertEqual(updater.update_cask(self.cask), "0.1.100")

    def test_rejects_prerelease_and_malformed_versions(self):
        for version in ["0.1.15-rc.1", "01.1.15", "1.2", "1.2.3\nmalicious", None, 15]:
            with self.subTest(version=version):
                self.manifest = self.release(version)
                self.assert_rejected()
        self.download.assert_not_called()

    def test_rejects_unexpected_manifest_urls(self):
        for key in ["dmg", "checksums"]:
            with self.subTest(key=key):
                self.manifest = self.release("0.1.15")
                self.manifest[key] = "https://example.com/incorrect"
                self.assert_rejected()
        self.download.assert_not_called()

    def test_rejects_missing_or_duplicate_checksum(self):
        for checksums in ["", f'{"a" * 64}  Wrong.dmg\n', self.checksums * 2]:
            with self.subTest(checksums=checksums):
                self.checksums = checksums
                self.assert_rejected()
        self.download.assert_not_called()

    def test_rejects_checksum_mismatch(self):
        self.download.return_value = "b" * 64
        self.assert_rejected()

    def test_rejects_duplicate_cask_fields(self):
        self.original += '  version "0.1.14"\n'
        self.cask.write_text(self.original)
        self.assert_rejected()
        self.fetch.assert_not_called()

    def test_network_failure_preserves_cask(self):
        self.download.side_effect = OSError("Download interrupted")
        with self.assertRaises(OSError):
            updater.update_cask(self.cask)
        self.assertEqual(self.cask.read_text(), self.original)

    def test_streamed_download_hash(self):
        payload = b"x" * (2 * 1024 * 1024 + 1)
        with patch.object(updater, "urlopen", return_value=io.BytesIO(payload)):
            self.assertEqual(DOWNLOAD_SHA256("https://example.com/test.dmg"),
                             hashlib.sha256(payload).hexdigest())


if __name__ == "__main__":
    unittest.main()
