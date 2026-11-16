"""Upload a release zip to CurseForge (run by .github/workflows/release.yml).

    CF_API_KEY=... python tools/cf_upload.py --project 1808625 --zip dist/Onward-0.4.1.zip \\
        --name "Onward 0.4.1" --changelog notes.md [--release-type beta] [--dry-run]

Uses CurseForge's author upload API (https://wow.curseforge.com/api, header X-Api-Token).
The game version is the newest one of the "Forever" version type, looked up each time so a new
Forever patch needs no change here; set CF_GAME_VERSIONS="id,id" to pin it instead.
--dry-run checks the token and prints the game version it would use, without uploading.
"""
import argparse
import json
import os
import sys
import urllib.error
import urllib.request
import uuid

API = "https://wow.curseforge.com/api"


def call(path, token, data=None, headers=None):
    req = urllib.request.Request(API + path, data=data, headers={"X-Api-Token": token, **(headers or {})})
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            return json.loads(r.read().decode("utf-8") or "null")
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", "replace")[:500]
        sys.exit(f"CurseForge {path}: HTTP {e.code} {body}")


def forever_versions(token):
    pinned = os.environ.get("CF_GAME_VERSIONS", "").strip()
    if pinned:
        return [int(v) for v in pinned.split(",") if v.strip()], "pinned by CF_GAME_VERSIONS"
    types = call("/game/version-types", token)
    ft = [t for t in types if "forever" in (t.get("name", "") + " " + t.get("slug", "")).lower()]
    if not ft:
        names = ", ".join(f"{t['id']}={t.get('name')}" for t in types)
        sys.exit(f"no 'Forever' game version type on CurseForge; types are: {names}")
    ids = {t["id"] for t in ft}
    versions = [v for v in call("/game/versions", token) if v.get("gameVersionTypeID") in ids]
    if not versions:
        sys.exit(f"the Forever version type ({ids}) has no game versions yet")
    newest = max(versions, key=lambda v: v["id"])
    return [newest["id"]], f"{newest.get('name')} (id {newest['id']}, type {ft[0].get('name')})"


def multipart(fields, file_field, path):
    boundary = uuid.uuid4().hex
    out = bytearray()
    for k, v in fields.items():
        out += f'--{boundary}\r\nContent-Disposition: form-data; name="{k}"\r\n\r\n{v}\r\n'.encode()
    with open(path, "rb") as fh:
        data = fh.read()
    name = os.path.basename(path)
    out += (f'--{boundary}\r\nContent-Disposition: form-data; name="{file_field}"; filename="{name}"\r\n'
            f"Content-Type: application/zip\r\n\r\n").encode() + data + b"\r\n"
    out += f"--{boundary}--\r\n".encode()
    return bytes(out), f"multipart/form-data; boundary={boundary}"


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--project", required=True)
    ap.add_argument("--zip")
    ap.add_argument("--name")
    ap.add_argument("--changelog")
    ap.add_argument("--release-type", default="beta", choices=("alpha", "beta", "release"))
    ap.add_argument("--dry-run", action="store_true")
    a = ap.parse_args()
    token = os.environ.get("CF_API_KEY")
    if not token:
        sys.exit("CF_API_KEY is not set")
    versions, why = forever_versions(token)
    print("game version:", why)
    if a.dry_run:
        print("dry run: token works, nothing uploaded")
        return
    if not (a.zip and os.path.isfile(a.zip)):
        sys.exit(f"no zip at {a.zip}")
    changelog = open(a.changelog, encoding="utf-8").read() if a.changelog else ""
    meta = {"changelog": changelog, "changelogType": "markdown", "releaseType": a.release_type, "gameVersions": versions}
    if a.name:
        meta["displayName"] = a.name
    body, ctype = multipart({"metadata": json.dumps(meta)}, "file", a.zip)
    r = call(f"/projects/{a.project}/upload-file", token, data=body, headers={"Content-Type": ctype})
    print("uploaded to CurseForge: file id", (r or {}).get("id"), f"({a.release_type})")


if __name__ == "__main__":
    main()
