import json
import sys
from pathlib import Path

results = json.loads(Path(__file__).with_name("results.json").read_text())
failed = [item for item in results if not item["passed"]]
for item in failed:
    print(item)
print(f"{len(results) - len(failed)}/{len(results)} verificações satisfeitas")
if len(results) < 403 or failed:
    raise SystemExit(1)

for log in sys.argv[1:]:
    text = Path(log).read_text()
    if "SCRIPT ERROR" in text or any(line.startswith("ERROR:") for line in text.splitlines()):
        raise SystemExit(f"Erros de runtime em {log}")
