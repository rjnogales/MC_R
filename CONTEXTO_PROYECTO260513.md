# MC_REPORTES_ERIC_R — Documentación de Contexto del Proyecto

**Última actualización:** Mayo 13, 2026  
**Ubicación:** `c:\MC_REPORTES_ERIC_R`

---

## 1. Propósito General del Proyecto

Este proyecto es un **sistema integral de análisis y generación de reportes** para **Metrocali** (Metro de Cali, Colombia). El propósito es:

- **Procesar y consolidar datos** de operaciones de transporte desde bases de datos externas
- **Generar indicadores clave** de desempeño operacional, flota, operadores y usuarios
- **Crear reportes ejecutivos dinámicos** mediante dashboards interactivos (Shiny)
- **Extraer y transformar datos** a través de un pipeline ETL (Python + R)
- **Producir salidas en Excel** para distribución a stakeholders

El proyecto está **en operación activa** con actualizaciones regulares y datos consolidados hasta **2025-2026**.

---

## 2. Estructura del Proyecto

El workspace tiene **4 carpetas principales** + archivos de configuración:

```
MC_REPORTES_ERIC_R/
├── BITACORA/          # Análisis de incidentes, accidentes, vandalismo
├── extractor/         # Pipeline ETL (Python) para extracción de datos y generación de informes
├── OPERADORES/        # Análisis de desempeño de operadores de transporte
├── SALIDAS/           # Análisis de recorridos/salidas
├── TARJETAS/          # Análisis de usuarios y tarjeteros
├── ZDCMTOS/           # Plantillas y acompañantes para informes
├── CONTEXTO_PROYECTO260507.md  # Documentación histórica (Mayo 7, 2026)
├── CONTEXTO_PROYECTO260511.md  # Documentación intermedia (Mayo 11, 2026)
└── CONTEXTO_PROYECTO260513.md  # Esta documentación (Mayo 13, 2026)
```

---

## 3. Descripción por Carpeta

### 3.1 BITACORA/
**Propósito:** Registrar y analizar eventos operacionales (accidentes, incidentes, vandalismo)

**Archivos principales:**
- `Bitacora.R` - Script histórico de análisis
- `Bitacora_2026.R` - Versión actualizada para 2026
- `incidentes_Accidentes_2025.R` - Análisis específico de incidentes y accidentes
- `vandalismo_2025.R` - Análisis de casos de vandalismo
- `indicadores.RData` - Indicadores consolidados

**Datos que procesa:**
- Registro de incidentes/accidentes por mes, línea, operador
- Clasificación de vandalismo
- Indicadores de seguridad operacional
- Tendencias históricas (2022-2026)

**Salidas:** Reportes en Excel con visualizaciones de tendencias, geografía de incidentes

### 3.2 extractor/
**Propósito:** Pipeline automatizado de Extracción, Transformación y Carga (ETL) para generar diccionarios técnicos e informes

**Arquitectura del pipeline (7 pasos):**
```
run_all.py (coordinador)
├── 01_leer_secciones.py      → Lee ficheros de entrada
├── 02_extraer_inputs.py      → Extrae variables de entrada
├── 03_extraer_outputs.py     → Extrae variables de salida
├── 04_extraer_variables_derivadas.py  → Calcula indicadores derivados
├── 05_extraer_relaciones.py  → Establece relaciones entre tablas
├── 06_generar_excel.py       → Genera diccionario en Excel
└── 07_generar_plantilla.py    → Genera informe final con plantilla institucional
```

**Modo de uso:**
```bash
python extractor/run_all.py BITACORA
python extractor/run_all.py OPERADORES
python extractor/run_all.py SALIDAS
python extractor/run_all.py TARJETAS
```

**Salidas generadas:**
- `extractor/OUTPUT/<REPORTE>_diccionario.xlsx` - Diccionario técnico con hojas: Inputs, Outputs, Variables_derivadas, Relaciones, Glosario
- `extractor/OUTPUT/<REPORTE>_docx_acompanante.xlsx` - Metadatos del informe (objetivo, dirigido_a, etc.)
- `extractor/OUTPUT/<REPORTE>_informe.xlsx` - Informe final en formato plantilla institucional

**Estado actual:** Pipeline completamente funcional. Todos los reportes (BITACORA, OPERADORES, SALIDAS, TARJETAS) tienen sus diccionarios e informes generados y actualizados.

### 3.3 OPERADORES/
**Propósito:** Analizar desempeño de operadores de transporte (COT = Cooperativa u Operador)

**Archivos principales:**
- `Operadores.R` - Script histórico de análisis
- `Operadores_2025.R` - Versión 2025 (script activo)
- `llamado de datos.R` - Lectura y consolidación de datos brutos

**Indicadores analizados:**
- Salidas efectuadas vs. programadas
- Rendimiento operacional por COT
- Uso de flota (disponibilidad, ocupación)
- Clasificación de operadores (cuartiles 75)
- Cuotas de pasaje/tarjeteros

**Datos generados (.RData):**
- `operadores2024.RData`, `operadores2024AM.RData`
- `salidastodaOperadorF.RData` - Consolidado de salidas por operador
- `cuartiles75.RData` - Clasificación de rendimiento
- `Op_ade_atr_uso.RData` - Análisis de atributos y uso

**Dashboard asociado:** Shiny app que filtra por COT y año

### 3.4 SALIDAS/
**Propósito:** Análisis de recorridos/rutas efectuadas (salidas operacionales)

**Archivos principales:**
- `Salidas.R` - Script histórico
- `Salidas_2025.R` - Versión 2025 (activo)
- `kmsalidas.R`, `kmsalidas1.R` - Cálculos de distancia

**Métricas analizadas:**
- Kilómetros recorridos por salida
- Salidas por día, tipo de vehículo, ruta
- Consolidación de recorridos históricos
- Composición de flota activa por salida

**Datos generados (.RData):**
- `salidas.RData`, `salidasBD.RData` - Consolidado de salidas
- `vehiculodia.RData` - Análisis vehículo-día
- `Rutadia.RData` - Consolidado por ruta-día
- `FLOTA_Combustible.RData` - Datos de consumo

### 3.5 TARJETAS/
**Propósito:** Análisis de tarjeteros y usuarios del sistema

**Archivos principales:**
- Diversos scripts de análisis de tarjetería
- `Activos.RData` - Registro de tarjeteros activos
- `activo.csv` - Exportación de datos

**Métricas analizadas:**
- Tarjeteros activos vs. inactivos
- Uso de tarjetas por tipo (estudiante, adulto, etc.)
- Viajes efectuados por período
- Ingresos por tarjetería

### 3.6 ZDCMTOS/
**Propósito:** Plantillas y archivos de acompañamiento para la generación de informes

**Archivos principales:**
- `Plantilla Levantamiento de informacion de informes.xlsx` - Plantilla institucional para informes finales
- `_autores.csv` - Lista de autores con iniciales
- `_docx_acompanante_plantilla.xlsx` - Plantilla para metadatos de informes

---

## 4. Flujo de Datos General

```
┌─────────────────────────────────────────────────────────┐
│         FUENTES EXTERNAS DE DATOS                       │
│  (Bases de datos operacionales, ERIC, sistemas BRT)     │
└──────────────────────┬──────────────────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │   extractor/ (Python/ETL)    │
        │  - Lectura de secciones      │
        │  - Extracción de variables   │
        │  - Cálculo de indicadores    │
        │  - Generación de Excel       │
        │  - Creación de informes      │
        └──────────────────────────────┘
                       │
         ┌─────────────┼─────────────┐
         │             │             │
         ▼             ▼             ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │BITACORA/│  │OPERADORES│ │SALIDAS/ │
    │  .R     │  │   .R    │  │  .R     │
    │ scripts │  │ scripts │  │scripts  │
    └────┬────┘  └────┬────┘  └────┬────┘
         │             │            │
         ▼             ▼            ▼
    ┌─────────┐  ┌─────────┐  ┌─────────┐
    │.RData   │  │.RData   │  │.RData   │
    │(datos)  │  │(datos)  │  │(datos)  │
    └────┬────┘  └────┬────┘  └────┬────┘
         │             │            │
         └─────────────┼────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │   Shiny Apps (Dashboards)    │
        │  - Interactivos              │
        │  - Filtrable por período     │
        │  - Visualizaciones           │
        └──────────────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │   Reportes en Excel/PDF      │
        │   (Para distribución)        │
        └──────────────────────────────┘
```

---

## 5. Tecnologías y Dependencias

### Lenguajes
- **R** (~80% del código) - Procesamiento de datos, análisis, visualización
- **Python** (~20% del código) - Pipeline ETL, coordinación de procesos

### Librerías R principales
- `data.table` - Manipulación eficiente de tablas
- `tidyverse`, `dplyr` - Transformación de datos
- `ggplot2` - Visualización estática
- `shiny` - Dashboards web interactivos
- `openxlsx`, `readxl` - Lectura/escritura Excel
- `stringr` - Manipulación de strings
- `lubridate` - Manejo de fechas
- `rsconnect` - Publicación de Shiny apps

### Librerías Python
- `pathlib`, `subprocess` - Orquestación de procesos
- `openpyxl` - Manipulación de archivos Excel
- Posiblemente pandas, numpy (en scripts 01-06)

### Formatos de datos
- `.RData` - Archivos binarios de R (datos persistentes)
- `.R` - Scripts fuente
- `.csv` - Datos tabulares
- `.xlsx`, `.xlsm` - Reportes Excel (TABLERO INDICADORES.V3.0.xlsm)

---

## 6. Patrones y Convenciones

### Nomenclatura de scripts
- **Por año:** `Bitacora_2026.R`, `Operadores_2025.R`, `Salidas_2025.R`
- **Histórico:** `Bitacora.R`, `Operadores.R`, `Salidas.R` (versiones antiguas)
- **Específicos:** `incidentes_Accidentes_2025.R`, `vandalismo_2025.R`

### Almacenamiento de datos
- **Datos consolidados:** Se guardan en `.RData` para reutilización rápida
- **Datos crudos:** Se leen de fuentes externas en cada ejecución
- **Reportes:** Se generan en Excel (`.xlsx`)

### Estructura de carga de datos
La mayoría de scripts R comienza con:
```r
# Cargar librerías necesarias
library(readxl)
library(data.table)
```

### Pipeline extractor
- Scripts numerados del 01 al 07
- `run_all.py` coordina la ejecución
- Salidas en `extractor/OUTPUT/`
- Requiere archivos de acompañante (`_docx_acompanante.xlsx`) para generar informes

---

## 7. Estado Actual del Proyecto

### Pipeline extractor completado
- **7 pasos funcionales:** Del 01 (lectura) al 07 (generación de informe final)
- **Reportes generados:** BITACORA, OPERADORES, SALIDAS, TARJETAS
- **Archivos en OUTPUT:**
  - `<REPORTE>_diccionario.xlsx` - Diccionario técnico
  - `<REPORTE>_docx_acompanante.xlsx` - Metadatos del informe
  - `<REPORTE>_informe.xlsx` - Informe en formato institucional

### Próximos pasos sugeridos
- Validar contenido de los informes generados
- Ajustar metadatos en archivos acompañantes si es necesario
- Integrar pipeline en procesos automatizados
- Documentar cambios en este archivo de contexto

### Notas importantes
- El proyecto se movió de Dropbox a `C:\MC_REPORTES_ERIC_R\` para compatibilidad con herramientas de edición
- Entorno virtual Python en `.venv/` con `openpyxl` instalado
- Scripts R requieren acceso a bases de datos operacionales para ejecución completa

---

**Fin del documento de contexto**</content>
<parameter name="filePath">c:\MC_REPORTES_ERIC_R\CONTEXTO_PROYECTO260513.md