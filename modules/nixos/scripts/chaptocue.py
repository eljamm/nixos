#!/usr/bin/env python

import json
import os
import re
import sys
import textwrap

import yt_dlp as youtube_dl
from yt_dlp.utils import sanitize_filename

input = sys.argv[1]

ydl = youtube_dl.YoutubeDL(
    {
        "outtmpl": "%(id)s.%(ext)s",
        "writeinfojson": True,
        "skip_download": True,
        "quiet": True,
    }
)
try:
    with ydl:
        result = ydl.download(str(input))
except:
    exit()

regex = re.compile(
    r"^(?:http|ftp)s?://"  # http:// or https://
    r"(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|"  # domain...
    r"localhost|"  # localhost...
    r"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})"  # ...or ip
    r"(?::\d+)?"  # optional port
    r"(?:/?|[/?]\S+)$",
    re.IGNORECASE,
)

if re.match(regex, input):
    file_info = str(input)[-11:]
else:
    file_info = str(input)

if re.search(".*(soundcloud|instagram)", input):
    os._exit(0)


def convert(seconds):
    minutes = seconds // 60
    seconds %= 60

    return "%02d:%02d:00" % (minutes, seconds)


input_file = f"{file_info}.info.json"

if os.path.isfile(input_file):
    with open(input_file, "r") as json_file:
        json_data = json.load(json_file)
        try:
            channel = json_data["channel"]
            id = json_data["id"]
            upload_date = json_data["upload_date"]
            title = sanitize_filename(json_data["title"])
            chapters = json_data["chapters"]

            with open(f"{title}-{id}.cue", "w") as cue_file:
                cue_format = textwrap.dedent(f"""\
					REM DATE {upload_date}
					REM COMMENT "{id}"
					PERFORMER "{channel}"
					TITLE "{title}"
					FILE "{title}-{id}.mkv" WAVE
				""")

                i = 1
                for song in chapters:
                    song_start_time = convert(song["start_time"])
                    song_title = song["title"]

                    cue_format += textwrap.indent(
                        textwrap.dedent(f"""\
					TRACK {i:02d} AUDIO
				  	TITLE "{song_title}"
				  	INDEX 01 {song_start_time}
					"""),
                        "  ",
                    )
                    i += 1

                cue_file.write(cue_format)
        except Exception as e:
            # print(e)
            print("\nChapters are currently unavailable for this video.")

    os.remove(input_file)
