"""
01_leer_secciones.py
Lee un archivo .R de Shiny y lo divide en 3 secciones:
  - seccion_pre.txt    : preprocesamiento (antes del UI)
  - seccion_ui.txt     : bloque UI
  - seccion_server.txt : bloque Server

Uso:
    python 01_leer_secciones.py <ruta_al_R> <carpeta_temp>
"""

import sys
import re
from pathlib import Path


def leer_secciones(ruta_r: Path, carpeta_temp: Path):
    texto = ruta_r.read_text(encoding="utf-8", errors="ignore")
    lineas = texto.splitlines()

    idx_ui = None
    idx_server = None

    for i, linea in enumerate(lineas):
        # Ignorar líneas comentadas
        if linea.strip().startswith("#"):
            continue
        if idx_ui is None and re.match(r"^\s*ui\s*<-", linea):
            idx_ui = i
        if idx_server is None and re.match(r"^\s*server\s*<-\s*function", linea):
            idx_server = i

    if idx_ui is None:
        print("[ERROR 01] No se encontró la definición de ui <- en el archivo.")
        sys.exit(1)
    if idx_server is None:
        print("[ERROR 01] No se encontró la definición de server <- function en el archivo.")
        sys.exit(1)

    seccion_pre    = "\n".join(lineas[:idx_ui])
    seccion_ui     = "\n".join(lineas[idx_ui:idx_server])
    seccion_server = "\n".join(lineas[idx_server:])

    carpeta_temp.mkdir(parents=True, exist_ok=True)
    (carpeta_temp / "seccion_pre.txt").write_text(seccion_pre, encoding="utf-8")
    (carpeta_temp / "seccion_ui.txt").write_text(seccion_ui, encoding="utf-8")
    (carpeta_temp / "seccion_server.txt").write_text(seccion_server, encoding="utf-8")

    print(f"[OK 01] Secciones guardadas en: {carpeta_temp}")
    print(f"        Preprocesamiento : líneas 1 - {idx_ui}")
    print(f"        UI               : líneas {idx_ui+1} - {idx_server}")
    print(f"        Server           : líneas {idx_server+1} - {len(lineas)}")


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python 01_leer_secciones.py <ruta_R> <carpeta_temp>")
        sys.exit(1)

    ruta_r       = Path(sys.argv[1])
    carpeta_temp = Path(sys.argv[2])

    if not ruta_r.exists():
        print(f"[ERROR 01] No se encontró el archivo: {ruta_r}")
        sys.exit(1)

    leer_secciones(ruta_r, carpeta_temp)
