# nanobanana-generate

Generate images using Google's nano-banana-2 model on Replicate.

## Usage

```bash
~/dev/replicate-nano-banana/generate.sh "PROMPT" [OPTIONS] -o path/to/output.jpg
```

All output paths are relative to the caller's working directory, so `-o` can point anywhere.

### Examples

Basic generation:
```bash
~/dev/replicate-nano-banana/generate.sh "a cat wearing a hat" -o output/cat.jpg
```

With aspect ratio and resolution:
```bash
~/dev/replicate-nano-banana/generate.sh "mountain landscape" -o output/landscape.jpg --aspect-ratio 16:9 --resolution 4K
```

With reference images (local paths resolved relative to caller's directory):
```bash
~/dev/replicate-nano-banana/generate.sh "similar style painting" -o output/painting.png --image ref1.jpg ref2.jpg --format png
```

With search grounding:
```bash
~/dev/replicate-nano-banana/generate.sh "latest Mars rover photo" -o output/mars.jpg --google-search
```

## Parameters

| Parameter | Flag | Default | Description |
|---|---|---|---|
| prompt | positional | required | Text description of image |
| output | `-o` / `--output` | `output.jpg` | Output file path (relative to caller's cwd) |
| aspect-ratio | `--aspect-ratio` | `1:1` (or `match_input_image` with `--image`) | `1:1`, `16:9`, `9:16`, `3:2`, `2:3`, `4:3`, `3:4`, `4:5`, `5:4`, `21:9`, etc. |
| resolution | `--resolution` | `1K` | `1K`, `2K`, `4K` |
| format | `--format` | `jpg` | `jpg`, `png` |
| image | `--image` | none | Reference image paths/URLs (up to 14) |
| google-search | `--google-search` | off | Enable web search grounding |
| image-search | `--image-search` | off | Enable image search grounding |
