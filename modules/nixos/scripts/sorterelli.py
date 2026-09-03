#!/usr/bin/env python

import argparse
import datetime
import logging
import shutil
import sys
from pathlib import Path

import magic
from tqdm import tqdm

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

# Reverse lookup: mime -> category, built once instead of scanning MIME_DIRS per file.
MIME_TO_CATEGORY: dict[str, str] = {
    mime: category for category, mimes in MIME_DIRS.items() for mime in mimes
}

logging.basicConfig(level=logging.INFO, format="%(message)s")
log = logging.getLogger("sorter")


class Stats:
    def __init__(self) -> None:
        self.succeeded: int = 0
        self.failed: int = 0
        self.skipped: int = 0
        self.failures: list[tuple[Path, str]] = []

    def record_success(self) -> None:
        self.succeeded += 1

    def record_skip(self) -> None:
        self.skipped += 1

    def record_failure(self, file: Path, reason: str) -> None:
        self.failed += 1
        self.failures.append((file, reason))

    def has_issues(self) -> bool:
        return self.failed > 0


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Sort files into folders by MIME type and date."
    )
    parser.add_argument(
        "--source",
        type=Path,
        default=Path.cwd(),
        help="Directory to sort (default: cwd)",
    )
    parser.add_argument(
        "--dest",
        type=Path,
        default=Path.cwd(),
        help="Root directory for sorted output (default: cwd)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be moved/copied without touching anything",
    )
    parser.add_argument(
        "--copy",
        action="store_true",
        help="Copy files instead of moving them (source files are left in place)",
    )
    parser.add_argument(
        "--only",
        nargs="+",
        metavar="MIME_OR_CATEGORY",
        help="Only sort files matching these MIME types and/or categories "
        "(e.g. --only Images Books application/pdf). "
        "Category names match MIME_DIRS keys, case-insensitively. "
        "Everything else is skipped, not sent to Other.",
    )
    return parser.parse_args()


def resolve_category(mime: str) -> str:
    return MIME_TO_CATEGORY.get(mime, "Other")


def resolve_only_filter(values: list[str]) -> set[str]:
    """Expand a list of --only values (categories and/or raw MIME types) into a set of MIME types."""
    # Case-insensitive lookup of category name -> canonical category key
    category_lookup = {name.lower(): name for name in MIME_DIRS}

    allowed: set[str] = set()
    for value in values:
        matched_category = category_lookup.get(value.lower())
        if matched_category:
            allowed.update(MIME_DIRS[matched_category])
        elif "/" in value:
            # Looks like a MIME type (has a slash), accept as-is even if unknown
            allowed.add(value)
        else:
            log.warning(
                "Unrecognized --only value '%s' (not a known category or MIME type), ignoring",
                value,
            )

    return allowed


def unique_destination(dst_dir: Path, name: str) -> Path:
    """Return a non-colliding path in dst_dir for `name`, appending -1, -2, ... if needed."""
    candidate = dst_dir / name
    if not candidate.exists():
        return candidate

    stem, suffix = Path(name).stem, Path(name).suffix
    counter = 1
    while True:
        candidate = dst_dir / f"{stem}-{counter}{suffix}"
        if not candidate.exists():
            return candidate
        counter += 1


def transfer_file(
    file: Path, dest_root: Path, category: str, dry_run: bool, copy: bool, stats: Stats
) -> None:
    date_str: str = datetime.date.fromtimestamp(file.stat().st_mtime).isoformat()
    dst_dir: Path = dest_root / category / date_str
    target = unique_destination(dst_dir, file.name)
    action = "copy" if copy else "move"

    if dry_run:
        log.info("[dry-run] %s: %s -> %s", action, file, target)
        stats.record_success()
        return

    try:
        dst_dir.mkdir(parents=True, exist_ok=True)
        if copy:
            _ = shutil.copy2(str(file), str(target))
        else:
            _ = shutil.move(str(file), str(target))
        stats.record_success()
    except OSError as e:
        log.error("Failed to %s %s: %s", action, file, e)
        stats.record_failure(file, str(e))


def print_summary(stats: Stats, dry_run: bool, copy: bool) -> None:
    action = "copied" if copy else "moved"
    suffix = " (dry run)" if dry_run else ""

    if not stats.has_issues():
        log.info(
            "Sorting Completed%s: %d file(s) %s successfully.",
            suffix,
            stats.succeeded,
            action,
        )
        return

    log.info("Sorting Completed%s with issues:", suffix)
    log.info("  Succeeded: %d", stats.succeeded)
    log.info("  Failed:    %d", stats.failed)
    if stats.skipped:
        log.info("  Skipped:   %d", stats.skipped)
    log.info("Failures:")
    for file, reason in stats.failures:
        log.info("  - %s: %s", file, reason)


def main() -> None:
    args = parse_args()

    if not args.source.is_dir():
        log.error("Source directory does not exist: %s", args.source)
        sys.exit(1)

    mimeSubset: set[str] | None = resolve_only_filter(args.only) if args.only else None

    files: list[Path] = [f for f in args.source.iterdir() if f.is_file()]
    stats = Stats()

    for f in tqdm(files, desc="Sorting files"):
        try:
            mime: str = magic.from_file(str(f), mime=True)
        except Exception as e:
            log.error("Could not read MIME type for %s: %s", f, e)
            stats.record_failure(f, f"MIME detection failed: {e}")
            continue

        if mimeSubset is not None and mime not in mimeSubset:
            stats.record_skip()
            continue

        category = resolve_category(mime)
        transfer_file(f, args.dest, category, args.dry_run, args.copy, stats)

    print_summary(stats, args.dry_run, args.copy)

    if stats.has_issues():
        sys.exit(1)


if __name__ == "__main__":
    main()
