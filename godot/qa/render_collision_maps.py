"""Render the runtime collision report over each original background for review."""
import argparse
import json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

parser = argparse.ArgumentParser()
parser.add_argument("output", type=Path)
parser.add_argument("--routes", action="store_true")
args = parser.parse_args()
project = Path(__file__).resolve().parents[1]
report = json.loads((project / "qa/collision_maps.json").read_text())
args.output.mkdir(parents=True, exist_ok=True)
font = ImageFont.truetype("DejaVuSans.ttf", 22)
for area, data in report.items():
    scene = Image.open(project / data["background"].removeprefix("res://")).convert("RGBA")
    mask = Image.new("L", scene.size)
    draw = ImageDraw.Draw(mask)
    for polygon in data["floor"]:
        draw.polygon([tuple(p) for p in polygon], fill=55)
    for polygon in data["obstacles"]:
        draw.polygon([tuple(p) for p in polygon], fill=0)
    fill = Image.new("RGBA", scene.size, (20, 230, 70, 0))
    fill.putalpha(mask)
    scene = Image.alpha_composite(scene, fill)
    draw = ImageDraw.Draw(scene)
    for polygon in data["floor"]:
        draw.line([tuple(p) for p in polygon + [polygon[0]]], fill="#30ff60", width=3)
    for polygon in data["obstacles"]:
        draw.line([tuple(p) for p in polygon + [polygon[0]]], fill="#ff4949", width=3)
    if args.routes:
        for route in data["routes"]:
            points = [tuple(p) for p in route["points"]]
            if len(points) > 1:
                draw.line(points, fill="#fff349", width=2)
            x, y = route["target"]
            draw.ellipse((x-6,y-6,x+6,y+6),fill="#fff349")
    x, y = data["spawn"]
    draw.ellipse((x-12,y-12,x+12,y+12),fill="#22caff",outline="white",width=2)
    for x,y in data["unreachable"]:
        draw.ellipse((x-8,y-8,x+8,y+8),fill="#ff00df")
    title = Image.new("RGBA",(1672,35),(10,15,20,220))
    ImageDraw.Draw(title).text((12,4),area + " | verde: piso livre | vermelho: sólidos | azul: início",font=font,fill="white")
    scene.alpha_composite(title)
    scene.convert("RGB").save(args.output / f"{area}.png")
print(f"{len(report)} mapas renderizados em {args.output}")
