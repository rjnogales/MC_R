"""
02_extraer_inputs.py
Lee seccion_ui.txt y extrae todos los inputs del UI de Shiny:
  - selectInput
  - checkboxInput
  - radioButtons
  - sliderInput
  - textInput
  - dateInput

Genera inputs.csv con columnas: id, tipo, etiqueta, opciones

Uso:
    python 02_extraer_inputs.py <carpeta_temp>
"""

import sys
import re
import csv
from pathlib import Path


def extraer_choices(bloque: str) -> str:
    """Extrae los valores dentro de choices = list(...) o choices = c(...)"""
    m = re.search(r'choices\s*=\s*(?:list|c)\s*\(([^)]+)\)', bloque, re.DOTALL)
    if not m:
        return ""
    contenido = m.group(1)
    # Extraer solo los valores entre comillas
    valores = re.findall(r'"([^"]+)"', contenido)
    return " | ".join(valores)


def extraer_inputs(carpeta_temp: Path):
    archivo = carpeta_temp / "seccion_ui.txt"
    if not archivo.exists():
        print(f"[ERROR 02] No se encontró: {archivo}")
        sys.exit(1)

    texto = archivo.read_text(encoding="utf-8")
    # Quitar líneas comentadas
    lineas_limpias = [l for l in texto.splitlines() if not l.strip().startswith("#")]
    texto_limpio = "\n".join(lineas_limpias)

    resultados = []

    # ── selectInput ──────────────────────────────────────────────────────────
    for m in re.finditer(
        r'selectInput\s*\(\s*inputId\s*=\s*"([^"]+)"\s*,\s*label\s*=\s*"([^"]*)"([^)]*(?:\([^)]*\)[^)]*)*)',
        texto_limpio, re.DOTALL
    ):
        input_id  = m.group(1)
        etiqueta  = m.group(2)
        resto     = m.group(0)
        opciones  = extraer_choices(resto)
        resultados.append({"id": input_id, "tipo": "selectInput", "etiqueta": etiqueta, "opciones": opciones})

    # ── checkboxInput ─────────────────────────────────────────────────────────
    for m in re.finditer(
        r'checkboxInput\s*\(\s*"([^"]+)"\s*,\s*"([^"]*)"',
        texto_limpio
    ):
        resultados.append({"id": m.group(1), "tipo": "checkboxInput", "etiqueta": m.group(2), "opciones": "TRUE / FALSE"})

    # ── radioButtons ──────────────────────────────────────────────────────────
    for m in re.finditer(
        r'radioButtons\s*\(\s*"([^"]+)"\s*,\s*"([^"]*)"([^)]*(?:\([^)]*\)[^)]*)*)',
        texto_limpio, re.DOTALL
    ):
        input_id = m.group(1)
        etiqueta = m.group(2)
        opciones = extraer_choices(m.group(0))
        resultados.append({"id": input_id, "tipo": "radioButtons", "etiqueta": etiqueta, "opciones": opciones})

    # ── sliderInput ───────────────────────────────────────────────────────────
    for m in re.finditer(
        r'sliderInput\s*\(\s*inputId\s*=\s*"([^"]+)"\s*,\s*label\s*=\s*"([^"]*)"',
        texto_limpio
    ):
        resultados.append({"id": m.group(1), "tipo": "sliderInput", "etiqueta": m.group(2), "opciones": "rango numérico"})

    # ── textInput ─────────────────────────────────────────────────────────────
    for m in re.finditer(
        r'textInput\s*\(\s*inputId\s*=\s*"([^"]+)"\s*,\s*label\s*=\s*"([^"]*)"',
        texto_limpio
    ):
        resultados.append({"id": m.group(1), "tipo": "textInput", "etiqueta": m.group(2), "opciones": "texto libre"})

    # ── dateInput ─────────────────────────────────────────────────────────────
    for m in re.finditer(
        r'dateInput\s*\(\s*inputId\s*=\s*"([^"]+)"\s*,\s*label\s*=\s*"([^"]*)"',
        texto_limpio
    ):
        resultados.append({"id": m.group(1), "tipo": "dateInput", "etiqueta": m.group(2), "opciones": "fecha"})

    # ── downloadButton ────────────────────────────────────────────────────────
    for m in re.finditer(
        r'downloadButton\s*\(\s*"([^"]+)"\s*,\s*"([^"]*)"',
        texto_limpio
    ):
        resultados.append({"id": m.group(1), "tipo": "downloadButton", "etiqueta": m.group(2), "opciones": ""})

    # Eliminar duplicados por id
    vistos = set()
    unicos = []
    for r in resultados:
        if r["id"] not in vistos:
            vistos.add(r["id"])
            unicos.append(r)

    salida = carpeta_temp / "inputs.csv"
    with open(salida, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["id", "tipo", "etiqueta", "opciones"])
        writer.writeheader()
        writer.writerows(unicos)

    print(f"[OK 02] {len(unicos)} inputs encontrados → {salida}")
    for r in unicos:
        print(f"        [{r['tipo']}] {r['id']} : {r['etiqueta']}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python 02_extraer_inputs.py <carpeta_temp>")
        sys.exit(1)

    extraer_inputs(Path(sys.argv[1]))
