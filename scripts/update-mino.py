#!/usr/bin/env python3
"""Update Mino's cask from its public release manifest, verifying the DMG."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
from urllib.request import Request, urlopen

BASE_URL = "https://artifacts.mino.so/releases"
VERSION = re.compile(r"(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)\.(?:0|[1-9][0-9]*)")
CASK_VERSION = re.compile(r'^  version "([^"]+)"$', re.MULTILINE)
CASK_SHA256 = re.compile(r'^  sha256 "([0-9a-f]{64})"$', re.MULTILINE)


def request(url):
    # The artifact host blocks urllib's generic Python user agent.
    return Request(url, headers={
        "User-Agent": "Mino-Homebrew-Updater/1.0 (+https://github.com/jonaylor89/homebrew-tap)",
    })


def fetch_text(url):
    with urlopen(request(url), timeout=60) as response:
        return response.read().decode("utf-8")


def download_sha256(url):
    digest = hashlib.sha256()
    with urlopen(request(url), timeout=60) as response:
        while chunk := response.read(1024 * 1024):
            digest.update(chunk)
    return digest.hexdigest()


def version_tuple(version):
    if not isinstance(version, str) or not VERSION.fullmatch(version):
        raise ValueError(f"Invalid stable release version: {version!r}")
    return tuple(int(part) for part in version.split("."))


def update_cask(path):
    original = path.read_text()
    versions = CASK_VERSION.findall(original)
    if len(versions) != 1 or len(CASK_SHA256.findall(original)) != 1:
        raise ValueError("Expected exactly one cask version and SHA-256")
    current = version_tuple(versions[0])

    manifest = json.loads(fetch_text(f"{BASE_URL}/latest.json"))
    if not isinstance(manifest, dict):
        raise ValueError("Release manifest must be a JSON object")
    version = manifest.get("version")
    latest = version_tuple(version)
    release_url = f"{BASE_URL}/v{version}"
    filename = f"Mino-{version}.dmg"
    dmg_url = f"{release_url}/{filename}"
    checksums_url = f"{release_url}/SHA256SUMS.txt"
    if manifest.get("dmg") != dmg_url or manifest.get("checksums") != checksums_url:
        raise ValueError("Unexpected release URLs in manifest")
    if latest < current:
        raise ValueError(f"Refusing downgrade from {versions[0]} to {version}")
    if latest == current:
        print(f"Mino {version} is already up to date")
        return None

    checksums = fetch_text(checksums_url)
    checksum_pattern = re.compile(rf"^([0-9a-f]{{64}}) [ *]{re.escape(filename)}$")
    matches = [match.group(1) for line in checksums.splitlines()
               if (match := checksum_pattern.fullmatch(line))]
    if len(matches) != 1:
        raise ValueError(f"Expected exactly one SHA-256 for {filename}")
    expected_sha256 = matches[0]
    if download_sha256(dmg_url) != expected_sha256:
        raise ValueError(f"SHA-256 verification failed for {filename}")

    updated = CASK_VERSION.sub(lambda _: f'  version "{version}"', original)
    updated = CASK_SHA256.sub(lambda _: f'  sha256 "{expected_sha256}"', updated)
    path.write_text(updated)
    print(f"Updated Mino from {versions[0]} to {version} (DMG checksum verified)")
    return version


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cask", type=Path,
                        default=Path(__file__).resolve().parents[1] / "Casks/mino.rb")
    args = parser.parse_args()
    version = update_cask(args.cask)
    if output := os.environ.get("GITHUB_OUTPUT"):
        with open(output, "a") as stream:
            stream.write(f"changed={'true' if version else 'false'}\n")
            if version:
                stream.write(f"version={version}\n")


if __name__ == "__main__":
    main()
