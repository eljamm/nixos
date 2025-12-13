#!/usr/bin/env python

import datetime
import shutil
from pathlib import Path

import magic
from tqdm import tqdm

workdir: Path = Path.cwd()
files: list[Path] = [f for f in workdir.iterdir() if f.is_file()]

MIME_DIRS: dict[str, list[str]] = {
    "Software": [
        "application/x-executable",
        "application/x-dosexec",
        "application/x-msi",
        "text/x-shellscript",
        "application/octet-stream",
    ],
    "Archive": [
        "application/zip",
        "application/x-tar",
        "application/x-7z-compressed",
        "application/x-rar-compressed",
    ],
    "Audio": ["audio/mpeg", "audio/x-wav", "audio/x-m4a", "audio/midi"],
    "Books": ["application/epub+zip", "image/vnd.djvu"],
    "Images": ["image/jpeg", "image/png", "image/gif", "image/svg+xml", "image/webp"],
    "Text": [
        "application/msword",
        "text/plain",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.ms-excel",
        "text/rtf",
        "application/vnd.openxmlformats-officedocument.presentationml.presentation",
        "text/x-tex",
    ],
    "Text/PDF": ["application/pdf"],
    "Torrent": ["application/x-bittorrent"],
    "Video": ["video/mp4", "video/x-matroska"],
}


def move_file(file: Path, dest: str) -> None:
    date_str: str = datetime.date.fromtimestamp(file.stat().st_mtime).isoformat()
    dst_path: Path = Path(dest) / ".tmp" / date_str
    dst_path.mkdir(parents=True, exist_ok=True)
    src_path = str(file)
    _ = shutil.move(src_path, dst_path / file.name)


for f in tqdm(files, desc="Sorting files"):
    mime: str = magic.from_file(str(f), mime=True)
    found = False

    for dest, mimes in MIME_DIRS.items():
        if mime in mimes:
            found = True
            move_file(f, dest)
            break

    if not found:
        move_file(f, "Other")

print("Sorting Completed")
