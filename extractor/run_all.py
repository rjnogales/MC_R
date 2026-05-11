"""
run_all.py — Coordinador del pipeline de diccionario Shiny

Uso:
    python extractor/run_all.py TARJETAS
    python extractor/run_all.py SALIDAS
    python extractor/run_all.py BITACORA

El script:
  1. Busca el .R dentro de la carpeta indicada
  2. Crea carpeta temp/<REPORTE>/
  3. Ejecuta los scripts 01 al 06 en orden
  4. Informa si cada paso fue OK o ERROR
  5. Al final dice dónde está el Excel generado
"""

import sys
import subprocess
from pathlib import Path


def encontrar_script_r(carpeta_reporte: Path) -> Path:
    """Busca el .R principal: prefiere el que no sea el nombre 'Funsionarios.R' (versión vieja)"""
    archivos_r = sorted(carpeta_reporte.glob("*.R"))
    if not archivos_r:
        return None
    # Preferir archivos con año en el nombre (versión más reciente)
    con_año = [f for f in archivos_r if any(str(y) in f.name for y in range(2020, 2030))]
    if con_año:
        return con_año[-1]  # el último alfabéticamente (mayor año)
    return archivos_r[0]


def correr_paso(numero: int, nombre: str, args: list) -> bool:
    script = Path(__file__).parent / f"0{numero}_{nombre}.py"
    cmd = [sys.executable, str(script)] + args
    print(f"\n── Paso {numero}: {nombre} ──")
    resultado = subprocess.run(cmd, capture_output=False, text=True)
    if resultado.returncode != 0:
        print(f"[ERROR] Paso {numero} falló con código: {resultado.returncode}")
        return False
    return True


def main():
    if len(sys.argv) < 2:
        print("Uso: python extractor/run_all.py <NOMBRE_REPORTE>")
        print("Ejemplo: python extractor/run_all.py TARJETAS")
        sys.exit(1)

    nombre_reporte = sys.argv[1].upper()

    # Raíz del proyecto = carpeta padre del extractor/
    raiz          = Path(__file__).parent.parent
    carpeta_reporte = raiz / nombre_reporte
    carpeta_temp    = Path(__file__).parent / "temp" / nombre_reporte

    if not carpeta_reporte.exists():
        print(f"[ERROR] No existe la carpeta: {carpeta_reporte}")
        sys.exit(1)

    archivo_r = encontrar_script_r(carpeta_reporte)
    if archivo_r is None:
        print(f"[ERROR] No se encontró ningún archivo .R en: {carpeta_reporte}")
        sys.exit(1)

    print("=" * 60)
    print(f"  PIPELINE DICCIONARIO SHINY")
    print(f"  Reporte   : {nombre_reporte}")
    print(f"  Archivo R : {archivo_r.name}")
    print(f"  Temp      : {carpeta_temp}")
    print("=" * 60)

    pasos = [
        (1, "leer_secciones",             [str(archivo_r), str(carpeta_temp)]),
        (2, "extraer_inputs",             [str(carpeta_temp)]),
        (3, "extraer_outputs",            [str(carpeta_temp)]),
        (4, "extraer_variables_derivadas",[str(carpeta_temp)]),
        (5, "extraer_relaciones",         [str(carpeta_temp)]),
        (6, "generar_excel",              [str(carpeta_temp), str(carpeta_reporte), nombre_reporte]),
    ]

    for numero, nombre, args in pasos:
        ok = correr_paso(numero, nombre, args)
        if not ok:
            print(f"\n[ABORTADO] El pipeline falló en el paso {numero}.")
            sys.exit(1)

    print("\n" + "=" * 60)
    excel = carpeta_reporte / f"{nombre_reporte}_diccionario.xlsx"
    print(f"  PIPELINE COMPLETADO")
    print(f"  Excel generado: {excel}")
    print("=" * 60)


if __name__ == "__main__":
    main()
