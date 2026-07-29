---
name: mp4-to-gif
description: Converts an MP4 video file to an optimized animated GIF using a two-pass FFmpeg approach (palette generation + encoding). Use this skill whenever the user wants to convert a video to GIF, make an animated GIF from a video, mentions "mp4 to gif", "convert to gif", "make a gif from a video", or asks how to share a short video as an image/gif (e.g. for email, Slack, or web). Even if the user just says "can you gif this" or "turn this into a gif", use this skill.
---

# MP4 to Animated GIF

Convert an MP4 (or other video) to an animated GIF using two-pass FFmpeg for best color quality.

## Steps

### 1. Identify the input file

Get the MP4 path from context (the user likely mentioned it or @-mentioned it). If no file is clear, ask.

### 2. Inspect the file with ffprobe

```bash
ffprobe -v quiet -print_format json -show_streams -show_format <input.mp4>
```

Note the resolution, duration, and framerate. Mention them briefly to the user.

### 3. Run the two-pass conversion

Place the temporary palette file in the **same directory as the input file** (not /tmp or cwd) to avoid path issues.

Set these variables from the input path:
- `INPUT` = full path to the .mp4
- `DIR` = directory containing the input file
- `BASENAME` = filename without extension
- `PALETTE` = `$DIR/$BASENAME_palette.png`
- `OUTPUT` = `$DIR/$BASENAME.gif`

**Pass 1 — generate optimized palette:**
```bash
ffmpeg -i "$INPUT" \
  -vf "fps=8,scale=320:-1:flags=lanczos,palettegen=max_colors=128" \
  -update 1 "$PALETTE" -y
```

**Pass 2 — encode GIF using that palette:**
```bash
ffmpeg -i "$INPUT" -i "$PALETTE" \
  -filter_complex "fps=8,scale=320:-1:flags=lanczos[x];[x][1:v]paletteuse=dither=bayer:bayer_scale=5" \
  "$OUTPUT" -y
```

### 4. Clean up and report

```bash
rm "$PALETTE"
ls -lh "$OUTPUT"
```

Report the output path and file size to the user.

## Why two passes?

GIFs are limited to 256 colors. A single-pass conversion uses a generic palette and looks washed out. The two-pass approach builds a palette tuned to the actual colors in *this* video, resulting in much better quality — especially for skin tones, gradients, and detailed backgrounds.

## Settings rationale

- **320px wide, aspect-ratio preserved** — good balance of quality vs. file size for email/Slack inline display
- **8fps** — smooth enough for most content; lower than 24fps source cuts file size substantially
- **max_colors=128** — half the default 256; GIFs in small sizes rarely benefit from the full palette
- **lanczos scaling** — high-quality downscale filter
- **bayer dithering (bscale=5)** — produces smaller files than the default dithering algorithm with minimal visible difference at this resolution
