"""
05_extraer_relaciones.py
Lee seccion_server.txt y detecta qué inputs usa cada output.

Para cada bloque output$xxx <- render*({...}) extrae todos los
input$yyy mencionados dentro del bloque.

Genera relaciones.csv con columnas:
  output_id, inputs_usados

Uso:
    python 05_extraer_relaciones.py <carpeta_temp>
"""

import sys
import re
import csv
from pathlib import Path


def extraer_relaciones(carpeta_temp: Path):
    archivo = carpeta_temp / "seccion_server.txt"
    if not archivo.exists():
        print(f"[ERROR 05] No se encontró: {archivo}")
        sys.exit(1)

    texto = archivo.read_text(encoding="utf-8")

    # Quitar líneas comentadas
    lineas_limpias = [l for l in texto.splitlines() if not l.strip().startswith("#")]
    texto_limpio = "\n".join(lineas_limpias)

    tipos_render = [
        "renderPlot", "renderDataTable", "downloadHandler",
        "renderText", "renderUI", "renderPrint", "renderTable",
    ]
    patron_inicio = r'output\$(\w+)\s*<-\s*(?:' + "|".join(tipos_render) + r')\s*\({'

    # Encontrar posición de inicio de cada bloque
    bloques = []
    for m in re.finditer(patron_inicio, texto_limpio):
        bloques.append((m.group(1), m.start()))

    resultados = []

    for idx, (output_id, pos_inicio) in enumerate(bloques):
        # El bloque termina donde empieza el siguiente, o al final del texto
        pos_fin = bloques[idx + 1][1] if idx + 1 < len(bloques) else len(texto_limpio)
        bloque = texto_limpio[pos_inicio:pos_fin]

        # Buscar todos los input$xxx dentro del bloque
        inputs_encontrados = re.findall(r'input\$(\w+)', bloque)
        inputs_unicos = list(dict.fromkeys(inputs_encontrados))  # mantiene orden, sin duplicados

        resultados.append({
            "output_id":     output_id,
            "inputs_usados": ", ".join(inputs_unicos) if inputs_unicos else "(ninguno)"
        })

    salida = carpeta_temp / "relaciones.csv"
    with open(salida, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["output_id", "inputs_usados"])
        writer.writeheader()
        writer.writerows(resultados)

    print(f"[OK 05] {len(resultados)} relaciones encontradas → {salida}")
    for r in resultados:
        print(f"        {r['output_id']} ← {r['inputs_usados']}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python 05_extraer_relaciones.py <carpeta_temp>")
        sys.exit(1)

    extraer_relaciones(Path(sys.argv[1]))
