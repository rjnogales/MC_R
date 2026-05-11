import sys
from pathlib import Path

ruta = Path("C:/Users/HP/Dropbox/E_RN/MC/MC_REPORTES_ERIC_R/extractor")

# ---- run_all.py ----
archivo = ruta / "run_all.py"
content = archivo.read_text(encoding="utf-8")
content = content.replace(
    'excel = carpeta_reporte / f"{nombre_reporte}_diccionario.xlsx"',
    'carpeta_output = Path(__file__).parent / "OUTPUT"\n    excel = carpeta_output / f"{nombre_reporte}_diccionario.xlsx"'
)
archivo.write_text(content, encoding="utf-8")
print("run_all.py OK")

# ---- 06_generar_excel.py ----
archivo = ruta / "06_generar_excel.py"
content = archivo.read_text(encoding="utf-8")
content = content.replace(
    'salida = carpeta_reporte / f"{nombre_reporte}_diccionario.xlsx"',
    'carpeta_output = Path(__file__).parent / "OUTPUT"\n    salida = carpeta_output / f"{nombre_reporte}_diccionario.xlsx"'
)
archivo.write_text(content, encoding="utf-8")
print("06_generar_excel.py OK")

print("Ambos archivos actualizados.")
