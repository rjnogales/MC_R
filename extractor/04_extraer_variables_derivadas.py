"""
04_extraer_variables_derivadas.py
Lee seccion_pre.txt y extrae variables derivadas que se crean
sobre los datasets principales (los cargados con load()).

Regla:
  - SÍ: asignaciones sobre datasets principales FUERA de bloques render*({})
  - NO: variables temporales locales (Tipo_fun, grafi2, etc.)

Detecta dos patrones:
  1. data.table:  dataset[, col := formula]
  2. base R:      dataset$col <- formula

Genera variables_derivadas.csv con columnas:
  dataset, columna_nueva, formula, linea

Uso:
    python 04_extraer_variables_derivadas.py <carpeta_temp>
"""

import sys
import re
import csv
from pathlib import Path


def extraer_datasets_principales(texto: str) -> list:
    """Extrae nombres de objetos cargados con load()"""
    # Los .RData cargan objetos; el nombre del objeto generalmente
    # corresponde al nombre del archivo sin extensión o se infiere del código.
    # También buscamos variables que aparecen en setkey() o como targets de join.
    datasets = set()

    # Objetos en setkey(nombre, ...)
    for m in re.finditer(r'setkey\s*\(\s*(\w+)\s*,', texto):
        datasets.add(m.group(1))

    # Objetos que tienen :=  → son data.tables → son datasets principales
    for m in re.finditer(r'(\w+)\s*\[,\s*\w+\s*:=', texto):
        datasets.add(m.group(1))

    # Objetos que tienen $col <- → asignación base R sobre data.frame
    for m in re.finditer(r'^(\w+)\$\w+\s*<-', texto, re.MULTILINE):
        datasets.add(m.group(1))

    # Excluir nombres claramente temporales o de control
    excluir = {
        "Tipo_fun", "Tipo_fun1", "Tipo_fun2", "Tipo_fun3", "Tipo_fun4",
        "Tipo_fundef", "nombres_funs", "grafi2", "Graf2", "indenti",
        "Funsionariox", "isnavacios", "isnavacios1", "isnavacios2",
        "Mes_valor", "d_1", "d_2", "d_3"
    }
    return [d for d in datasets if d not in excluir]


def extraer_variables_derivadas(carpeta_temp: Path):
    archivo = carpeta_temp / "seccion_pre.txt"
    if not archivo.exists():
        print(f"[ERROR 04] No se encontró: {archivo}")
        sys.exit(1)

    texto = archivo.read_text(encoding="utf-8")

    datasets = extraer_datasets_principales(texto)
    print(f"        Datasets principales detectados: {datasets}")

    resultados = []

    for i, linea_orig in enumerate(texto.splitlines(), start=1):
        linea = linea_orig.strip()

        # Ignorar comentarios
        if linea.startswith("#"):
            continue

        # Patrón 1 data.table: dataset[, col := formula]
        m = re.match(r'^(\w+)\s*\[,\s*(\w+)\s*:=\s*(.+)\]?\s*$', linea)
        if m:
            ds  = m.group(1)
            col = m.group(2)
            formula = m.group(3).rstrip("]").strip()
            if ds in datasets:
                resultados.append({
                    "dataset":      ds,
                    "columna_nueva": col,
                    "formula":      formula,
                    "linea":        i
                })
            continue

        # Patrón 2 base R: dataset$col <- formula
        m = re.match(r'^(\w+)\$(\w+)\s*<-\s*(.+)$', linea)
        if m:
            ds      = m.group(1)
            col     = m.group(2)
            formula = m.group(3).strip()
            if ds in datasets:
                resultados.append({
                    "dataset":      ds,
                    "columna_nueva": col,
                    "formula":      formula,
                    "linea":        i
                })

    # Eliminar duplicados exactos (mismo dataset + columna + formula)
    vistos = set()
    unicos = []
    for r in resultados:
        clave = (r["dataset"], r["columna_nueva"], r["formula"])
        if clave not in vistos:
            vistos.add(clave)
            unicos.append(r)

    salida = carpeta_temp / "variables_derivadas.csv"
    with open(salida, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=["dataset", "columna_nueva", "formula", "linea"])
        writer.writeheader()
        writer.writerows(unicos)

    print(f"[OK 04] {len(unicos)} variables derivadas encontradas → {salida}")
    for r in unicos:
        print(f"        {r['dataset']}${r['columna_nueva']} = {r['formula']}  (línea {r['linea']})")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python 04_extraer_variables_derivadas.py <carpeta_temp>")
        sys.exit(1)

    extraer_variables_derivadas(Path(sys.argv[1]))
