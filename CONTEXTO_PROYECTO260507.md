# MC_REPORTES_ERIC_R — Documentación de Contexto del Proyecto

**Última actualización:** Mayo 7, 2026  
**Ubicación:** `c:\Users\HP\OneDrive - metrocali.gov.co\MC_REPORTES_ERIC_R`

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
├── extractor/         # Pipeline ETL (Python + R) para extracción de datos
├── OPERADORES/        # Análisis de desempeño de operadores de transporte
└── SALIDAS/           # Análisis de salidas/recorridos efectuados
└── TARJETAS/          # Análisis de usuarios y tarjeteros
```

---

## 3. Descripción por Carpeta

### 3.1 BITACORA/
**Propósito:** Registrar y analizar eventos operacionales (accidentes, incidentes, vandalismo)

**Archivos principales:**
- `Bitacora.R` - Script principal para procesar bitácora histórica
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

---

### 3.2 extractor/
**Propósito:** Pipeline automatizado de Extracción, Transformación y Carga (ETL) de datos

**Arquitectura del pipeline:**
```
run_all.py (coordinador)
├── 01_leer_secciones.py      → Lee ficheros de entrada
├── 02_extraer_inputs.py      → Extrae variables de entrada
├── 03_extraer_outputs.py     → Extrae variables de salida
├── 04_extraer_variables_derivadas.py  → Calcula indicadores derivados
├── 05_extraer_relaciones.py  → Establece relaciones entre tablas
└── 06_generar_excel.py       → Genera salida en Excel
```

**Modo de uso:**
```bash
python extractor/run_all.py TARJETAS
python extractor/run_all.py SALIDAS
python extractor/run_all.py BITACORA
```

**Salidas generadas:**
- Reportes en Excel en carpeta `temp/<REPORTE>/`
- Cada paso reporta estado OK/ERROR

**Flujo de datos:**
- Entrada: Bases de datos externas (ERIC, sistemas operacionales)
- Procesamiento: Limpieza, estandarización, cálculo de indicadores
- Salida: Excel con tablas consolidadas, dinámicas y visualizaciones

---

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

---

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

---

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
# ... etc

# Cargar datos históricos
load("path/to/calificacion2024.RData")
load("path/to/calificacion2025.RData")

# Consolidar y procesar
# ...
```

### Rutas de archivos
- **Rutas absolutas** desde OneDrive: `C:/Users/emosquera/OneDrive - metrocali.gov.co/...`
- **Alternativa multispectral:** Algunos scripts tienen versiones con rutas diferentes (sufijo `-DESKTOP-4CN2NBK`)

---

## 7. Estado Actual del Proyecto

### Datos consolidados hasta
- **2024:** Completo (histórico)
- **2025:** En progreso (mayor parte del año)
- **2026:** Inicio de año (enero-mayo aproximadamente)

### Archivos activos (mantienen versiones recientes)
- `Bitacora_2026.R` ✓
- `Operadores_2025.R` ✓
- `Salidas_2025.R` ✓
- `incidentes_Accidentes_2025.R` ✓
- `vandalismo_2025.R` ✓

### Proceso de ejecución típico
1. **Lectura de datos** desde bases externas o archivos crudos
2. **Procesamiento y limpieza** usando R
3. **Consolidación anual** en archivos `.RData`
4. **Generación de indicadores** (salidas, operadores, incidentes)
5. **Creación de reportes** en Excel
6. **Publicación en Shiny** (dashboards interactivos)

---

## 8. Carpetas Secundarias y Archivos Clave

### rsconnect/
- Configuración de publicación de Shiny en servidor (Posit Connect u otro)
- Múltiples carpetas en BITACORA/, OPERADORES/, SALIDAS/

### temp/
- Carpeta en `extractor/` - Almacena salidas intermedias del pipeline

### Archivo destacado
- `TABLERO INDICADORES.V3.0.xlsm` - Dashboard principal en Excel (versión 3.0)
- Posiblemente contiene KPIs consolidados y visualizaciones

---

## 9. Posibles Mejoras / Elementos Pendientes

Según comentarios en código:
- Script Bitacora.R contiene comentario: `"PENDIENTE OPERACION IMPORTANTE PARA EL CONSOLIDADO"`
- Hay múltiples versiones de archivos (indicando iteración activa)
- Rutas hardcodeadas (oportunidad de parametrización)
- Algunos scripts .R más antiguos podrían consolidarse

---

## 10. Cómo Usar Este Documento

**Para nuevos desarrolladores/analistas:**
- Comienza por la **Sección 4** (Flujo de datos)
- Lee la carpeta relevante en **Sección 3**
- Consulta **Sección 6** (Patrones)

**Para entender el flujo de datos:**
- Sección 4 (Diagrama)
- Sección 5 (Tecnologías)

**Para ejecutar procesos:**
- Carpeta `extractor/` (Python)
- Scripts `.R` individuales por carpeta

**Para integrar con sistemas externos:**
- Revisar scripts `*_2025.R` o `*_2026.R`
- Buscar patrones de lectura de datos (usualmente al inicio de scripts)

---

## 11. Contacto / Responsables

**Desarrollador principal:** Eric (usuario: emosquera)  
**Institución:** Metrocali (Metro de Cali, Colombia)  
**Última ejecución exitosa:** Mayo 2026

---

**Fin del documento de contextualización**
