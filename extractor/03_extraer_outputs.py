"""
03_extraer_outputs.py
Lee seccion_server.txt y extrae todos los outputs del Server de Shiny:
  - renderPlot
  - renderDataTable
  - downloadHandler
  - renderText
  - renderUI
  - renderPrint

Genera outputs.csv con columnas: id, tipo

Uso:
    python 03_extraer_outputs.py <carpeta_temp>
"""

import sys
import re
import csv
from pathlib import Path


def extraer_outputs(carpeta_temp: Path):
    archivo = carpeta_temp / "seccion_server.txt"
    if not archivo.exists():
        print(f"[ERROR 03] No se encontró: {archivo}")
        sys.exit(1)

    texto = archivo.read_text(encoding="utf-8")
    lineas_limpias = [l for l in texto.splitlines() if not l.strip().startswith("#")]
    texto_limpio = "\n".join(lineas_limpias)

    tipos_render = [
        "renderPlot",
        "renderDataTable",
        "downloadHandler",
        "renderText",
        "renderUI",
        "renderPrint",
        "renderTable",
    ]

    patron = r'output\$(\w+)\s*<-\s*(' + "|".join(tipos_render) + r')'
    resultados = []
    vistos = set()

    for m in re.finditer(patron, texto_limpio):
        output_id = m.group(1)
        tipo      = m.group(2)
        if output_id not in vistos:
            vistos.add(output_id)
            resultados.append({"id": output_id, "tipo": tipo})

    salida = carpeta_temp / "outputs.csv"
    with open(salida, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id", "tipo"])
        writer.writeheader()
        writer.writerows(resultados)

    print(f"[OK 03] {len(resultados)} outputs encontrados → {salida}")
    for r in resultados:
        print(f"        [{r['tipo']}] {r['id']}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python 03_extraer_outputs.py <carpeta_temp>")
        sys.exit(1)

    extraer_outputs(Path(sys.argv[1]))
