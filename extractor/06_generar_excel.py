"""
06_generar_excel.py
Lee los 4 CSV del temp y genera el Excel final con 4 hojas:
  - Inputs
  - Outputs
  - Variables_derivadas
  - Relaciones

Genera: <carpeta_reporte>/<nombre_reporte>_diccionario.xlsx

Uso:
    python 06_generar_excel.py <carpeta_temp> <carpeta_reporte> <nombre_reporte>
"""

import sys
import csv
from pathlib import Path

try:
    import openpyxl
    from openpyxl.styles import Font, PatternFill, Alignment
    from openpyxl.utils import get_column_letter
except ImportError:
    print("[ERROR 06] Falta openpyxl. Instalar con: pip install openpyxl")
    sys.exit(1)


COLORES_HOJA = {
    "Inputs":              "4472C4",   # azul
    "Outputs":             "ED7D31",   # naranja
    "Variables_derivadas": "70AD47",   # verde
    "Relaciones":          "9E480E",   # marrón
}


def leer_csv(ruta: Path) -> tuple:
    """Devuelve (cabeceras, filas) de un CSV"""
    if not ruta.exists():
        return [], []
    with open(ruta, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        filas = list(reader)
        cabeceras = reader.fieldnames or []
    return cabeceras, filas


def escribir_hoja(ws, cabeceras: list, filas: list, color_hex: str):
    """Escribe cabeceras con formato y filas de datos"""
    fill_header = PatternFill("solid", fgColor=color_hex)
    font_header = Font(bold=True, color="FFFFFF")
    font_datos  = Font(name="Calibri", size=10)

    # Cabeceras
    for col_idx, nombre in enumerate(cabeceras, start=1):
        celda = ws.cell(row=1, column=col_idx, value=nombre)
        celda.fill = fill_header
        celda.font = font_header
        celda.alignment = Alignment(horizontal="center")

    # Datos
    for row_idx, fila in enumerate(filas, start=2):
        for col_idx, nombre_col in enumerate(cabeceras, start=1):
            celda = ws.cell(row=row_idx, column=col_idx, value=fila.get(nombre_col, ""))
            celda.font = font_datos
            celda.alignment = Alignment(wrap_text=True, vertical="top")

    # Ancho automático por columna
    for col_idx, nombre in enumerate(cabeceras, start=1):
        max_ancho = len(nombre)
        for fila in filas:
            valor = str(fila.get(nombre, ""))
            # Para celdas largas limitar el ancho visual
            max_ancho = max(max_ancho, min(len(valor), 60))
        ws.column_dimensions[get_column_letter(col_idx)].width = max_ancho + 4

    # Congelar primera fila
    ws.freeze_panes = "A2"


def generar_excel(carpeta_temp: Path, carpeta_reporte: Path, nombre_reporte: str):
    hojas = {
        "Inputs":              carpeta_temp / "inputs.csv",
        "Outputs":             carpeta_temp / "outputs.csv",
        "Variables_derivadas": carpeta_temp / "variables_derivadas.csv",
        "Relaciones":          carpeta_temp / "relaciones.csv",
    }

    wb = openpyxl.Workbook()
    wb.remove(wb.active)  # quitar hoja vacía por defecto

    for nombre_hoja, ruta_csv in hojas.items():
        cabeceras, filas = leer_csv(ruta_csv)
        if not cabeceras:
            print(f"        [AVISO] Sin datos para hoja: {nombre_hoja}")
            cabeceras, filas = [nombre_hoja], [{}]

        ws = wb.create_sheet(title=nombre_hoja)
        escribir_hoja(ws, cabeceras, filas, COLORES_HOJA[nombre_hoja])
        print(f"        Hoja '{nombre_hoja}': {len(filas)} filas")

    salida = carpeta_reporte / f"{nombre_reporte}_diccionario.xlsx"
    wb.save(salida)
    print(f"[OK 06] Excel generado → {salida}")


if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Uso: python 06_generar_excel.py <carpeta_temp> <carpeta_reporte> <nombre_reporte>")
        sys.exit(1)

    generar_excel(
        carpeta_temp    = Path(sys.argv[1]),
        carpeta_reporte = Path(sys.argv[2]),
        nombre_reporte  = sys.argv[3]
    )
