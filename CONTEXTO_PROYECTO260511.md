# CONTEXTO_PROYECTO260511.md — Sesión del 11 de mayo de 2026

## Proyecto
**MC_REPORTES_ERIC_R** — Sistema de análisis y generación de reportes para Metrocali.
Ubicación: `C:\MC_REPORTES_ERIC_R`

## Estructura del proyecto
- `BITACORA/` — Incidentes, accidentes, vandalismo
- `extractor/` — Pipeline ETL (Python) para diccionarios Shiny
- `OPERADORES/` — Desempeño de operadores
- `SALIDAS/` — Recorridos/salidas
- `TARJETAS/` — Usuarios y tarjeteros
- `ZDCMTOS/` — Plantillas y acompañantes para informes

## Pipeline extractor (completado)
El pipeline toma scripts `.R` de Shiny y genera un diccionario técnico en Excel.
Flujo: `run_all.py` → 01 a 06 → `OUTPUT/<AREA>_diccionario.xlsx`

### Cambio realizado
Se modificó `extractor/run_all.py` y `06_generar_excel.py` para que la salida
vaya a `extractor/OUTPUT/` en lugar de la carpeta del reporte.
El cambio NO se ha ejecutado aún. Queda pendiente:
  1. Ejecutar `python _edit_output.py` para aplicar los cambios en los scripts.
  2. Ejecutar `python extractor/run_all.py BITACORA` para probar.

## ZDCMTOS (plantillas)
Tres archivos en `ZDCMTOS/`:
1. `_autores.csv` — Iniciales y nombres (LN, JH, MA)
2. `_docx_acompanante_plantilla.xlsx` — Campos: objetivo, dirigido_a, frecuencia, fuentes, etc.
3. `Plantilla Levantamiento de informacion de informes.xlsx` — Plantilla institucional final

## Script pendiente
`extractor/07_generar_plantilla.py` — Creado pero NO ejecutado ni probado.
Objetivo: tomar el diccionario + el acompañante y generar el informe
con formato de la plantilla institucional.
- Recibe: `extractor/OUTPUT/<AREA>_diccionario.xlsx`
- Recibe: `extractor/OUTPUT/<AREA>_docx_acompanante.xlsx` (debe llenarlo el usuario)
- Genera: `extractor/OUTPUT/<AREA>_informe.xlsx`

## Lo que NO se ha hecho
- [] Ejecutar `_edit_output.py` para aplicar cambios de ruta de salida
- [] Ejecutar `run_all.py BITACORA` para probar el pipeline
- [] Ejecutar `07_generar_plantilla.py BITACORA` para probar la generación del informe
- [] Llenar el acompañante (`BITACORA_docx_acompanante.xlsx`) con datos reales

## Observaciones importantes
- La herramienta NO puede editar archivos existentes en rutas de Dropbox.
- El proyecto se movió de Dropbox a `C:\MC_REPORTES_ERIC_R\` para poder trabajar.
- El entorno virtual está en `.venv/` con `openpyxl` instalado.
- No asumir, no adelantarse, no ejecutar sin autorización.
