#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



if (rstudioapi::isAvailable()) {
  current_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  #current_dir <- file.path(getwd(), "02 - Salidas")
  current_dir <- file.path(getwd())
}
current_dir

source(file.path(current_dir, "incidentes_Accidentes_2025.R"))

#Activamos las librerias necesarias 
library(readxl) #leer archivos en excel y ussas las propiedades de a librerya
library(stringr) #leer utilizar las funciones de los directorios de las carpetas
library(data.table) #Utiliza las funciones para almacenar tablas de datos por medio de "data.table" y "data.frame"
#library(plotrix)
library(openxlsx)
#library(xlsx)
library(lubridate)
library(shiny)
library(TeachingDemos)

#rm(data_frame)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  
    (tabsetPanel (tabPanel("Bitacora e informes ",

    # Application title
   
    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            dateInput("fechas_input",  "DE:", min = today()-730 , max =  today(), value = max(consobita$Fecha)-30, 
                      language = "es", weekstart = 1
            ) ,
            
            dateInput("fechas_input1",  "A:", min = today()-730 , max = today() , value =max(consobita$Fecha), 
                      language = "es", weekstart = 1
            )
            
            
            
            
            
           ,width = 2 ),

        # Show a plot of the generated distribution
        mainPanel(
          
          tabsetPanel(
            
            tabPanel("Bitacora Preliminar", 
          
          plotOutput("distPlot"),
          
          selectInput(inputId = "Tipo_Evento",
                      label = "Tipo de Evento:",
                      
                      choices = list("Desvios","Adicionales","N.A", "Incidente","Salida","Ingreso","Inspección"  )
          ),
          
          plotOutput("distPlot2"),
          
          fluidRow(column(1,checkboxInput("Puntos1",
                                          "Puntos",value = T)),
                   column(1,checkboxInput("Cantidad1",
                                          "Cantidad"))),
          selectInput(inputId = "COT1",
                      label = "COT:",
                      
                      choices = list("Concesionario GIT Masivo"  ,    "Concesionario Blanco y Negro" , "Concesionario Blanco y Negro2", "Concesionario ETM" )
          ),
          
          fluidRow(column(1,checkboxInput("Desvios1",
                                          "Desvios")),
                   column(1,checkboxInput("Adicionales1",
                                          "Adicionales")),
                   column(1,checkboxInput("N.A1",
                                          "N.A")),
                   column(1,checkboxInput("Incidente1",
                                          "Incidente")),
                   column(1,checkboxInput("Salida1",
                                          "Salida",value = T)),
                   column(1,checkboxInput("Ingreso1",
                                          "Ingreso")),
                   column(1,checkboxInput("Inspección1",
                                          "Inspección"))),
          
         plotOutput("distPlot1")
          
          ,
          fluidRow(column(1,checkboxInput("Afectaciones",
                                          
                                          "RUTA")),
                   
                   column(2,checkboxInput("Afectaciones1",
                                          
                                          "NUMERO_VEHICULO")),
                   
                   column(2,checkboxInput("Afectaciones3",
                                          
                                          "CODIGO_OPERADOR")),
                   column(2,checkboxInput("Afectaciones4",
                                          
                                          "Quincena",value = T)),
                   column(1,checkboxInput("Afectaciones5",
                                          
                                          "Dia")),
                   column(1,checkboxInput("Afectaciones6",
                                          
                                          "HORA"))),
         
         selectInput(inputId = "Tipo_Salida2",
                     label = "Tipo:",
                     
                     choices = list("MOTOR","POR INCUMPLIMIENTO AL PROTOCOLO TECNICO" , "CON ABOLLADURAS EN CARROCERIA INTERNA","FALLA DE PUERTA",   	 "PANELES DE CONTROL","CON ABOLLADURAS EN CARROCERIA EXTERNA", "CON FALENCIA DE ASEO EXTERIOR AL INICIO DE LA JORNADA","CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR", "SENALETICA INSTITUCIONAL", "CON FALENCIA DE ASEO INTERIOR AL INICIO DE LA JORNADA","CARENCIA DE ILUMINACION","CON PROBLEMAS DE RUTERO", "CON FALLA DE PUERTAS", "CON ABOLLADURAS EN CARROCERIA EXTERNA ","CON PROTOCOLO TECNOLOGICO FALENTE DURANTE EL ALISTAMIENTO", "CON VENTANA CLARABOYA EXTRACTOR O ESCOTILLA DANADO", "CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO" , "CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD" , "INSTALACIONES ELECTRICAS", "CON PASAMANOS DESPRENDIDO FLOJO ETC",  "CON SILLA ROTA RASGADA ETC", "SUSPENSION",  "CON FALLA DE SISTEMA DE AIRE ACONDICIONADO" , "CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA","CON FALLA PLATAFORMA ELEVADORA", "INFORMACION ERRADA", "CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE EXTINTORES" ,"EMISIONES GASEOSAS","CON FALLA MECANICA","EMISIONES DE RUIDO",	 "TRANSMISION", "RUTERO INEXISTENCIA O DANO FISICO O LOGICO", "CON PROTOCOLO TECNOLOGICO FALENTE", "CON LLANTAS LISAS",  "TRANSITAR DERRAMANDO LIQUIDOS",   "DIRECCION",  "FRENOS", "VALIDADOR", "PANEL INFORMADOR INTERNO",             	 "CON FALLA DE TIMBRES", 	 "FALLA ANGEL GUARDIAN", 	 "TORNIQUETE",        	 "COLOR DE LA CARROCERIA INTERNA O EXTERNA" ,"CON FALTA DE ELEMENTOS DE EXPULSION PARA VENTANAS DE EMERGENCIA" , "IVU BOX::APAGADO",  	 "IVU BOX::DAT DESACTUALIZADO",          	 "IVU BOX",           	 "POR INCUMPLIMIENTO AL PROTOCOLO LEGAL",	 "NO PORTAR EQUIPO DE CARRETERA",        	 "IVU BOX::IBIS",     	 "CON PROBLEMAS EN ELEMENTOS DE FIJACION PARA SILLAS DE RUEDAS" , "MICROFONO AMBIENTE",	 "N.A",               	 "MOTOR",             	 "INICIO DE OPERACION",	 "CAMBIO DE LINEA",   	 "Desvios",           	 "BAJO NIVEL DE COMBUSTIBLE",            	 "RETOMA",            	 "POR DANO MECANICO SOLO BUS",           	 "Adicionales",       	 "AGRESION VERBAL A OPERADOR",           	 "CONGESTION DE USUARIOS EN ESTACIONES O PARADAS" , "POR DANO ELECTRICO VIA MIXTA",         	 "OTROS",             	 "BUS DEL MIO",       	 "NO RELEVO",         	 "POR CASO FORTUITO", 	 "ADICIONAL",         	 "NO USA O USA MAL EL PROTOCOLO DE COMUNICACIÓN" , "AUTOMOVIL PARTICULAR", "POR COMBUSTIBLE SOLO BUS",             	 "POR DANO MECANICO VIA MIXTA",          	 "DANOS AL VEHICULO", 	 "PERSONA SOSPECHOSA EN VEHICULO",       	 "DE ADICIONAL",      	 "ASIGNACION INCORRECTA DE TAREA EN IVU VEHICLE"  , 	 "MOTO MOTOCARRO O MOTOTRICICLO",        	 "INJUSTIFICADO",     	 "PINCHAZO",          	 "CONTAMINACION DE VEHICULO",            	 "ARBOL",             	 "AMENAZA A OPERADOR",	 "POR DANO ELECTRICO SOLO BUS",          	 "ALTERA RECORRIDO DE RUTA",             	 "FIN DE OPERACION",  	 "CAMION O TRACTOCAMION",	 "POR ACCIDENTE DE TERCEROS",            	 "CONGESTION VEHICULAR","NO ACATA O DESCONOCE INSTRUCCION DEL CCO", "LLEVA ACOMPANANTE NO AUTORIZADO EN VIAJE NO COMERCIAL", "NO USA O PORTA MAL EL UNIFORME",       	 "POR MALA APROXIMACION",	 "DESMAYO DE USUARIO EN VEHICULO",       	 "NO USA O USA MAL EL CINTURON DE SEGURIDAD"  ,"INTERRUMPE O BLOQUEA LA OPERACION DEL SISTEMA" ,"ABANDONA VEHICULO SIN AUTORIZACION",   	 "ENFERMEDAD DEL OPERADOR",              	 "TRANSITA CON PUERTAS ABIERTAS",        	 "NO INFORMA ANOMALIAS DEL VEHICULO",    	 "OMITE PARADA",      	 "NO DA INFORMACION", 	 "DA REVERSA SIN AUTORIZACION",          	 "BICICLETA",         	 "TRANSPORTA EVASOR CON CONSENTIMIENTO", 	 "REALIZA PARADA NO AUTORIZADA",         	 "ESTACION DEL MIO",  	 "POR FRENADA BRUSCA",	 "OTRO",              	 "ESTACIONA EN SITIO O ESTACION NO AUTORIZADO EN CANTIDAD O TIEMPO SUPERIOR AL PERMITIDO", "PELEA O RINA EN VEHICULO",    "NO REPORTA EVENTOS DE RIESGO",         	 "CONDUCE DE MANERA INADECUADA",         	 "IVU BOX::DANO FISICO", "USA EQUIPO ELECTRONICO NO AUTORIZADO DURANTE LA CONDUCCION", "TAXI",              	 "ATROPELLO",         	 "ORDEN PUBLICO",     	 "CAMBIO DE VEHICULO PARA ATENCION DE DISCAPACIDAD"	 ,"AGRESION FISICA A OPERADOR",           	 "AGREDE VERBALMENTE",	 "CON VENTANA QUEBRADA O FISURADA",      	 "AMBULANCIA",        	 "BUS O BUSETA DE SERVICIO PUBLICO O ESPECIAL"  ,   	 "POR INCENDIOS",     	 "INGIERE ALIMENTOS DURANTE LA CONDUCCION"  ,"NO INGRESA O INGRESA INCORRECTAMENTE EL CODIGO AL INICIO O FIN DE CADA RECORRIDO"  ,    	 "CHASIS EJES",       	 "HURTO EN VEHICULO", 	 "POR ALTA DEMANDA",  	 "APRISIONAMIENTO",   	 "POR SEMAFORO FUERA DE SERVICIO",       	 "BAJA DEMANDA",      	 "INTERVIENE VEHICULO QUE FALLA",        	 "CRUZA SEMAFORO EN ROJO",               	 "APROXIMA MAL",      	 "VEHICULO POLICIA O EJERCITO",          	 "ADELANTA VEHICULO SIN AUTORIZACION",   	 "ALTERA RECORRIDO DE RUTA REPORTA DIRECCION DE OPERACIONES" , "DESACATA LA AUTORIDAD",	 "ANDEN",             	 "AGREDE FISICAMENTE",	 "POR COMBUSTIBLE VIA MIXTA",            	 "OBRAS CIVILES",     	 "CON ADITAMENTOS DECORATIVOS NO AUTORIZADOS", "JUSTIFICADO",       	 "OPERA CON LUCES APAGADAS DURANTE LA PENUMBRA", "INGRESA DE MANERA IRREGULAR AL SISTEMA" , "BOTON DE PANICO",   	 "CONTINGENCIAS",     	 "SEMAFORO",          	 "POR INSEGURIDAD DE LA ZONA",           	 "VOLQUETA",          	 "MURO",              	 "MAQUINA DE BOMBEROS",	 "EVACUACION",        	 "EXCEDE LA VELOCIDAD ESTABLECIDA",      	 "COBERTIZO PARADERO",	 " CONGESTION VEHICULAR",	 "POSTE", "GRAFITI",    "TRACCION ANIMAL",   	 "MALA FIJACION OBJETOS DEL VEHICULO",   	 "NO INFORMA EVASION EN BUS",            	 "POR INUNDACIONES",  	 "NO ATIENDE LLAMADO DE CCO",   "POR ARBOL CAIDO",   	 "INACTIVIDAD MAYOR A 30 DIAS",    "DESEMPANADOR",      	 "CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO Y/O SENALETICA INSTITUCIONAL", "NO PORTA DOCUMENTOS",	 "INTERRUMPE CRUCE SEMAFORICO",  "POR OPERADOR",   "Incidente",   "OPERA CON CERTIFICADO DE IDONEIDAD SUSPENDIDO", "SISTEMA DE INFORMACION SONORA",  "RETENER PASAJEROS EN EL VEHICULO CONTRA SU VOLUNTAD", "BAJA CONFIABILIDAD", "MEMO", "OPERA VEHICULO PARA ACTIVIDADES AJENAS AL SISTEMA",	 "INSTALAR CUALQUIER EQUIPOS O DISPOSITIVO AL INTERIOR DEL AUTOBUS NO AUTORIZADO"  ,      	 "INTERFAZ AIRE ACONDICIONADO", "VENDE PASAJE O REALIZA MAL USO DE LA TIPSC-F" , "ACCIONAR EXTINTOR", "EXCEPCIONES PLAN",  "CON PROPAGANDA NO AUTORIZADA", "SE PRESENTA ALICORADO O DROGADO",  "POR ATRASO", 	 "CON AUSENCIA O CARENCIA DE ELEMENTOS DE BOTIQUIN", "INVADE LA CEBRA",  "OPERA CON VOLUMEN MEGAFONIA BAJO",     	 "CONTADOR BIDIRECCIONAL",               	 "CON EQUIPOS DE INFORMACION SONORA NO AUTORIZADOS INSTALADOS", "CANCELACION DEL CERTIFICADO DE OPERACION",	 "POR SINIESTRO DE TERCEROS" )
                     
         )
       ),
       
        tabPanel("Datos Informes",
                  
                 fluidRow(column(1,checkboxInput("Afectaciones_2",
                                                 
                                                 "Accidentes")),
                          
                          column(1,checkboxInput("Afectaciones1_2",
                                                 
                                                 "Vandalismo",value = T)),
                          column(1,checkboxInput("Afectaciones2_2",
                                                 
                                                 "IE_IO")),
                          column(2,checkboxInput("Afectaciones3_2",
                                                 
                                                 "IExCOTxTipologia..")),
                          column(1,checkboxInput("Afectaciones4_2",
                                                 
                                                 "Dane o Bitacora")),
                          column(1,checkboxInput("Afectaciones5_2",
                                                 
                                                 "repoci..")),
                          column(1,checkboxInput("Afectaciones6_2",
                                                 
                                                 "Incidentes")),
                          column(1,checkboxInput("Afectaciones7_2",
                                                 
                                                 "Hitos")),
                          
                          column(1,checkboxInput("Afectaciones8_2",
                                                 
                                                 "Km_Salidas")),
                          
                          column(1,checkboxInput("Afectaciones9_2",
                                                 
                                                 "Flota Tablero")),
                          
                          column(1,checkboxInput("Afectaciones10_2",
                                                 
                                                 "Flota tipologia")),
                          
                          ) ,plotOutput("distPlot1_2"),
                 
                 downloadButton("descarga", "Descarga Informes"),
                 
                 downloadButton("descarga2", "Descarga BD"),
                 
                 
                 selectInput(inputId = "Seleccion",
                             label = "Seleccion:",
                             
                             choices = list( "COT","TIPOLOGIA","TIPO","SEVERIDAD")
                 ),
                 
                 
                 plotOutput("distPlot1_3") ,
                 
                 fluidRow(column(1,checkboxInput("Puntos",
                               "Puntos",value = T)),
                          column(1,checkboxInput("Cantidad",
                               "Cantidad"))),
                 
                selectInput(inputId = "COT3",
                             label = "COT:",
                             
                             choices = list("Concesionario GIT Masivo"  ,    "Concesionario Blanco y Negro" , "Concesionario Blanco y Negro2", "Concesionario ETM" )
                 ),
                 
                 #selectInput(inputId = "Tipo_Evento3",
                  #           label = "Tipo de Evento:",
                             
                   #          choices = list("Desvios","Adicionales","N.A", "Incidente","Salida","Ingreso","Inspección"  )
                 #),
                 
                 #selectInput(inputId = "Tipologia3",
                  #           label = "Tipologia:",
                             
                 #            choices = list("ART","PAD","COM","DUAL" )
                             
                # ), 
                fluidRow(column(1,checkboxInput("ART3",
                                                "ART")),
                         column(1,checkboxInput("PAD3",
                                                "PAD",value = T)),
                         column(1,checkboxInput("COM3",
                                                "COM")),
                         column(1,checkboxInput("DUAL3",
                                                "DUAL"))),
                plotOutput("distPlot3"),
                
                selectInput(inputId = "Jerarquias3",
                            label = "Jerarquia:",
                            
                            choices = list("METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE SISTEMA DE AIRE ACONDICIONADO", "METROCALI::CANCELACION::CAMBIO DE LINEA" ,"METROCALI::CANCELACION::DE ADICIONAL"   ,"METROCALI::CANCELACION::OTROS" ,"METROCALI::INCIDENTE::DESPACHO::ASIGNACION INCORRECTA DE TAREA EN IVU VEHICLE","METROCALI::INCIDENTE::FIN DE OPERACION"                                                                          	 ,"METROCALI::INCIDENTE::INICIO DE OPERACION"                                                                       	 ,"METROCALI::INCIDENTE::PERTURBACION DE OPERACION::OTROS"  ,"METROCALI::INCIDENTE::PERTURBACION DE OPERACION::POR ACCIDENTE DE TERCEROS","METROCALI::INCIDENTE::PERTURBACION DE OPERACION::POR SEMAFORO FUERA DE SERVICIO"                                 	 ,"METROCALI::INCIDENTE::POR ALARMA::AGRESION VERBAL A OPERADOR"                                                    	 ,"METROCALI::INCIDENTE::POR ALARMA::DESMAYO DE USUARIO EN VEHICULO"                                                	 ,"METROCALI::INCIDENTE::POR FLOTA::CON ABOLLADURAS EN CARROCERIA EXTERNA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON ABOLLADURAS EN CARROCERIA INTERNA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                	 ,"METROCALI::INCIDENTE::POR FLOTA::CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR"                 	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALENCIA DE ASEO INTERIOR AL INICIO DE LA JORNADA"                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE PUERTAS::FALLA ANGEL GUARDIAN"                                     	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE PUERTAS::FALLA DE PUERTA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA MECANICA::EMISIONES DE RUIDO"                                         	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA MECANICA::PANELES DE CONTROL"                                         	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA PLATAFORMA ELEVADORA"                                                 	 ,"METROCALI::INCIDENTE::POR FLOTA::CON LLANTAS LISAS"                                                              	 ,"METROCALI::INCIDENTE::POR FLOTA::CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO::SENALETICA INSTITUCIONAL"  	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROBLEMAS DE RUTERO::CARENCIA DE ILUMINACION"                               	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROBLEMAS DE RUTERO::INFORMACION ERRADA"                                    	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROPAGANDA NO AUTORIZADA"                                                   	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::APAGADO"                            	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::IBIS"                               	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::PANEL INFORMADOR INTERNO"                    	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::VALIDADOR"                                   	 ,"METROCALI::INCIDENTE::POR FLOTA::INSTALACIONES ELECTRICAS"                                                       	 ,"METROCALI::INCIDENTE::POR OPERADOR::APROXIMA MAL"                                                                	 ,"METROCALI::INCIDENTE::POR OPERADOR::INTERRUMPE O BLOQUEA LA OPERACION DEL SISTEMA"                               	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO ACATA O DESCONOCE INSTRUCCION DEL CCO"                                    	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO DA INFORMACION"                                                           	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO INFORMA ANOMALIAS DEL VEHICULO"                                           	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO USA O USA MAL EL PROTOCOLO DE COMUNICACIÓN"                               	 ,"METROCALI::INCIDENTE::POR OPERADOR::TRANSPORTA EVASOR CON CONSENTIMIENTO"                                        	 ,"METROCALI::INCIDENTE::POR VANDALISMO::DANOS AL VEHICULO"                                                         	 ,"METROCALI::INGRESO::ADICIONAL"                                                                                   	 ,"METROCALI::INGRESO::RETOMA"                                                                                      	 ,"METROCALI::INSPECCION MUESTRAL::CON ABOLLADURAS EN CARROCERIA EXTERNA"                                           	 ,"METROCALI::INSPECCION MUESTRAL::CON ABOLLADURAS EN CARROCERIA INTERNA"                                           	 ,"METROCALI::INSPECCION MUESTRAL::CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE EXTINTORES"                         	 ,"METROCALI::INSPECCION MUESTRAL::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                 	 ,"METROCALI::INSPECCION MUESTRAL::CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR"                  	 ,"METROCALI::INSPECCION MUESTRAL::CON FALLA DE PUERTAS"                                                            	 ,"METROCALI::INSPECCION MUESTRAL::CON FALLA MECANICA::SUSPENSION"                                                  	 ,"METROCALI::INSPECCION MUESTRAL::CON LLANTAS LISAS"                                                               	 ,"METROCALI::INSPECCION MUESTRAL::CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO Y/O SENALETICA INSTITUCIONAL"	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS DE RUTERO"                                                         	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS EN ELEMENTOS DE FIJACION PARA SILLAS DE RUEDAS"                    	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD"                               	 ,"METROCALI::INSPECCION MUESTRAL::CON PROTOCOLO TECNOLOGICO FALENTE DURANTE EL ALISTAMIENTO"                       	 ,"METROCALI::INSPECCION MUESTRAL::CON SILLA ROTA RASGADA ETC"                                                      	 ,"METROCALI::INSPECCION MUESTRAL::CON VENTANA CLARABOYA EXTRACTOR O ESCOTILLA DANADO"                              	 ,"METROCALI::INSPECCION MUESTRAL::INSTALACIONES ELECTRICAS"                                                        	 ,"METROCALI::INSPECCION MUESTRAL::TRANSITAR DERRAMANDO LIQUIDOS"                                                   	 ,"METROCALI::MIO CABLE::FIN DE OPERACION"                                                                          	 ,"METROCALI::MIO CABLE::INICIO DE OPERACION"                                                                       	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::BAJO NIVEL DE COMBUSTIBLE"                                            	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::CAMBIO DE LINEA"                                                      	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::INJUSTIFICADO"                                                        	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::OBJETO FIJO::ANDEN"                                             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::VEHICULO PARTICULAR::AUTOMOVIL PARTICULAR"                      	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::VEHICULO PARTICULAR::MOTO MOTOCARRO O MOTOTRICICLO"             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CON HERIDOS::CAIDA DE OCUPANTE::POR CASO FORTUITO"                             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CON HERIDOS::CAIDA DE OCUPANTE::POR FRENADA BRUSCA"                            	 ,"METROCALI::SALIDAS::POR ALARMA::AGRESION VERBAL A OPERADOR"                                                      	 ,"METROCALI::SALIDAS::POR ALARMA::CONTAMINACION DE VEHICULO"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                  	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE PUERTAS::FALLA DE PUERTA"                                            	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE SISTEMA DE AIRE ACONDICIONADO"                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE TIMBRES"                                                             	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::DIRECCION"                                                    	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::FRENOS"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::MOTOR"                                                        	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::SUSPENSION"                                                   	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::TRANSMISION"                                                  	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA PLATAFORMA ELEVADORA"                                                   	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROBLEMAS DE RUTERO::CARENCIA DE ILUMINACION"                                 	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD"                                	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROPAGANDA NO AUTORIZADA"                                                     	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::APAGADO"                              	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::IBIS"                                 	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::TORNIQUETE"                                    	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::VALIDADOR"                                     	 ,"METROCALI::SALIDAS::POR FLOTA::CON SILLA ROTA RASGADA ETC"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::INSTALACIONES ELECTRICAS"                                                         	 ,"METROCALI::SALIDAS::POR FLOTA::PINCHAZO"                                                                         	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO ELECTRICO SOLO BUS"                                     	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO ELECTRICO VIA MIXTA"                                    	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO MECANICO SOLO BUS"                                      	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO MECANICO VIA MIXTA"                                     	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::ENFERMEDAD DEL OPERADOR"                                    	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::INJUSTIFICADO"                                              	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::NO RELEVO"                                                  	 ,"METROCALI::SALIDAS::POR OPERADOR::ALTERA RECORRIDO DE RUTA"                                                      	 ,"METROCALI::SALIDAS::POR OPERADOR::OMITE PARADA"                                                                  	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::CONGESTION DE USUARIOS EN ESTACIONES O PARADAS"           	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::CONGESTION VEHICULAR"                                     	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::INJUSTIFICADO"                                            	 ,"METROCALI::SALIDAS::POR VANDALISMO::DANOS AL VEHICULO" 
                            )
                )
                
                 
                  
       ), tabPanel("Bitacoras",
                   
                   
                   fluidRow(column(DT::dataTableOutput("Bitacora"), width = 7)
                            
                            
                   ))
       ))
    )
))))

# Define server logic required to draw a histogram
server <- function(input, output) {

  output$distPlot <- renderPlot({
    
    consobita<-consobita[consobita$Fecha>=input$fechas_input]
    consobita<-consobita[consobita$Fecha<=input$fechas_input1]

    TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$TIPO_EVENTO,length))
    TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
    names(TotalNovedades)=c("Rutas","Total")
    TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
    
    Graf1<-barplot(TotalNovedades$Total,main =paste( "Tipo de Novedad","De ",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Rutas,cex.names=0.8,col = "blue",cex.axis = 1.2,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$Total)+100))))
    text(Graf1, (as.numeric(TotalNovedades$Total)+20),labels = as.numeric(as.numeric(TotalNovedades$Total)))
    
  })
  
  output$distPlot2 <- renderPlot({
    
    consobita<-consobita[consobita$Fecha>=input$fechas_input]
    consobita<-consobita[consobita$Fecha<=input$fechas_input1]
    consobita<-consobita[consobita$TIPO_EVENTO==input$Tipo_Evento]
    Novedad<-consobita[2,3]
    
    TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$JERARQUIA,length))
    TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
    names(TotalNovedades)=c("Rutas","Total")
    
    TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
    cuartiles<-as.data.table(TotalNovedades)
    cuartiles<-cuartiles[cuartiles$Total>=quantile(cuartiles$Total,probs = 0.75)]
    
    
    Graf1<-barplot(TotalNovedades$Total,main =paste( Novedad,"De ",input$fechas_input,"A ",input$fechas_input1, sep = " "),cex.names=0.8,col = "blue",cex.axis = 1.2,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$Total)+100))))
    text(Graf1, (as.numeric(TotalNovedades$Total)+20),labels = as.numeric(as.numeric(TotalNovedades$Total)))
    legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(cuartiles$Rutas,"-",cuartiles$Total, sep = ""),cex = 0.7,xpd = TRUE)
  })
    output$distPlot1 <- renderPlot({
      
      
      consobita<-consobita[consobita$Fecha>=input$fechas_input]
      consobita<-consobita[consobita$Fecha<=input$fechas_input1]
      consobita<-consobita[consobita$X5==input$Tipo_Salida2]
      consobita<-consobita[consobita$Concesionario==input$COT1]
      
      
      if(input$Cantidad1){
      if(input$Afectaciones){
        
      TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("RUTA","TIPO_EVENTO")],length))
      Nombres<-(row.names(TotalNovedades))
      TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
      TotalNovedades[,Cero:=0]
      titulo<-"RUTA"
      }
      if(input$Afectaciones1){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("NUMERO_VEHICULO","TIPO_EVENTO")],length))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"NUMERO DE VEHICULO"
      }
      if(input$Afectaciones3){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("CODIGO_OPERADOR","TIPO_EVENTO")],length))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"CODIGO DE OPERADOR"
      }
      if(input$Afectaciones4){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("Quincena","TIPO_EVENTO")],length))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"PERSONA QUE REGISTRA"
      }
      if(input$Afectaciones5){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("Fecha","TIPO_EVENTO")],length))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"Dia"
      } }
      
      if(input$Puntos1){
        
        if(input$Afectaciones){
          
          TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("RUTA","TIPO_EVENTO")],sum))
          Nombres<-(row.names(TotalNovedades))
          TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
          TotalNovedades[,Cero:=0]
          titulo<-"RUTA"
        }
        if(input$Afectaciones1){
          TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("NUMERO_VEHICULO","TIPO_EVENTO")],sum))
          Nombres<-(row.names(TotalNovedades))
          TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
          TotalNovedades[,Cero:=0]
          titulo<-"NUMERO DE VEHICULO"
        }
        if(input$Afectaciones3){
          TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("CODIGO_OPERADOR","TIPO_EVENTO")],sum))
          Nombres<-(row.names(TotalNovedades))
          TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
          TotalNovedades[,Cero:=0]
          titulo<-"CODIGO DE OPERADOR"
        }
        if(input$Afectaciones4){
          TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("Quincena","TIPO_EVENTO")],sum))
          Nombres<-(row.names(TotalNovedades))
          TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
          TotalNovedades[,Cero:=0]
          titulo<-"Quincena"
        }
        if(input$Afectaciones5){
          TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("Fecha","TIPO_EVENTO")],sum))
          Nombres<-(row.names(TotalNovedades))
          TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
          TotalNovedades[,Cero:=0]
          titulo<-"Dia"
        } 
        
      }
    
      
      Graf1<- barplot(TotalNovedades$Cero,main =paste( "por",titulo,"De",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Nombres,cex.names=0.8,col = "lightblue",cex.axis = 1.2,las=2,cex.lab = 1.5,ylim = c(0,(max(TotalNovedades$Salida)+min(TotalNovedades$Salida))))
      
      if(input$Ingreso1){
        lines(as.numeric(TotalNovedades$Ingreso),col = "blue", type = "l",lwd= 4) 
        legend(x = "topright",col = "blue",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.3), legend =paste("Ingreso") , cex = 1.2)
        }
      
      if(input$Salida1){
        lines(as.numeric(TotalNovedades$Salida),col = "orange", type = "l",lwd= 4)
        legend(x = "topright",col = "orange",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.2), legend =paste("Salida") , cex = 1.2)
        }
      
      if(input$Incidente1){  
        lines(as.numeric(TotalNovedades$Incidente),col = "red", type = "l", lwd= 4) 
        legend(x = "topright",col =  "red",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.1), legend =paste("Incidente") , cex = 1.2)
        }
      
      if(input$Inspección1){
        lines(as.numeric(TotalNovedades$Inspección),col = "green", type = "l",lwd= 4) 
        legend(x = "topright",col = "green",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.4), legend =paste("Inspección") , cex = 1.2)
        }
      
      
      if(input$Desvios1){
        lines(as.numeric(TotalNovedades$Desvios),col = "yellow", type = "l" ,lwd= 4)
        legend(x = "topright",col = "yellow",bty = "n",horiz = T,lwd= 4,inset =  c(0,-0.05), legend =paste("Desvios") , cex = 1.2)
        }
      
      if(input$Adicionales1){  
        lines(as.numeric(TotalNovedades$Adicionales),col = "black", type = "l",lwd= 4) 
        legend(x = "topright",col = "black",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.0), legend =paste("Adicionales") , cex = 1.2)
      }
  

    })
    output$Bitacora <- DT::renderDataTable(
      
      
      DT::datatable({data_frame}, options = list(lenghtMenu= list(c(7,8,-1), c(5,8, "All")), pagelenght= 15), filter = "top")
      
    )
    
    output$distPlot1_2 <- renderPlot({
      
      
      #Fechasmaxima1<-Fechasmaxima1[,-4]
      FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[,-4]
      
      #FlotaMax_Tipologia22_24_25<-rbind(FlotaMax_Tipologia22_24_25,Fechasmaxima1)
      
      FlotaMax_Tipologia22_24_25<-unique(FlotaMax_Tipologia22_24_25)
      
      FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha!="nombre"]
      FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha>=input$fechas_input]
      FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha<=input$fechas_input1]
      
      TotalNovedadesf<-as.data.frame(tapply(FlotaMax_Tipologia22_24_25$total,FlotaMax_Tipologia22_24_25$Fecha,mean))
      TotalNovedadesf<-cbind(row.names(TotalNovedadesf),TotalNovedadesf)
      names(TotalNovedadesf)=c("Rutas","Flota")
      
      TotalNovedadesf<-as.data.table(TotalNovedadesf)
   
      if(input$Afectaciones_2){
        
        accidentesdia<-accidentesdia[accidentesdia$nomb>=input$fechas_input]
        accidentesdia<-accidentesdia[accidentesdia$nomb<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(accidentesdia[,c("nomb","total")])
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Accidentes"
      }
      if(input$Afectaciones1_2){
        
        vandalismodia<-vandalismodia[vandalismodia$V1>=input$fechas_input]
        vandalismodia<-vandalismodia[vandalismodia$V1<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(vandalismodia[,c("V1","total")])
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Vandalismo"
      }
      if(input$Afectaciones2_2){
        PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha>=input$fechas_input]
        PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(PuntosIE_IO[,c("Fecha","Total")])
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        titulo<-"Puntos IE _IO"
      }
      if(input$Afectaciones3_2){
       
        P_TotalesIE
        
        P_IE<-P_IE[P_IE$Fecha>=input$fechas_input]
        P_IE<-P_IE[P_IE$Fecha<=input$fechas_input1]
        
        TotalNovedades<-data.frame(tapply(P_IE$Puntos,P_IE$Fecha,sum))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        titulo<-"Puntos IE"
       
      }
      if(input$Afectaciones4_2){
        
        consobita<-consobita[consobita$Fecha>=input$fechas_input]
        consobita<-consobita[consobita$Fecha<=input$fechas_input1]
        
        
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$Fecha,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        
        titulo<-"Cantidad de novedades"
      }
      
      if(input$Afectaciones5_2){
        
        reposicidia<-as.data.table(reposicidia)
        reposicidia<-reposicidia[reposicidia$Fecha>=input$fechas_input]
        reposicidia<-reposicidia[reposicidia$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(reposicidia)
        names(TotalNovedades)=c("Rutas","Total")
        
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Repocicionamientos" 
      }
      
      if(input$Afectaciones6_2){
        
        Incidentes.IA3<-as.data.table(Incidentes.IA3)
        Incidentes.IA3<-Incidentes.IA3[Incidentes.IA3$Fecha>=input$fechas_input]
        Incidentes.IA3<-Incidentes.IA3[Incidentes.IA3$Fecha<=input$fechas_input1]
 
        TotalNovedades<-as.data.frame(Incidentes.IA3)
        names(TotalNovedades)=c("Rutas","Total")
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Incidentes" 
      }
      
      if(input$Afectaciones7_2){
        
        Hitos<-Hitos[Hitos$Fecha>=input$fechas_input]
        Hitos<-Hitos[Hitos$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(Hitos$JERARQUIA,Hitos$Fecha,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        names(TotalNovedades)=c("Rutas","Total")
        
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Incidentes" 
      }
      
      if(input$Afectaciones8_2){
        
        salidas<-salidas[salidas$Fecha>=input$fechas_input]
        salidas<-salidas[salidas$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(salidas$Kilometros_peridos,salidas$Fecha,sum))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        names(TotalNovedades)=c("Rutas","Total")
        
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Kilometros perdidos x salidas" 
      }
      
      if(input$Afectaciones9_2){
        
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha>=input$fechas_input]
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(Tablero2024_25$Total,Tablero2024_25$Fecha,mean))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        names(TotalNovedades)=c("Rutas","Total")
        
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Flota promedio" 
      }
      
      if(input$Afectaciones10_2){
        
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha>=input$fechas_input]
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(Tablero2024_25$Total,Tablero2024_25$Fecha,mean))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        names(TotalNovedades)=c("Rutas","Total")
        
        
        TotalNovedades<-as.data.table(TotalNovedades)
        
        setkey(TotalNovedades,Rutas)
        setkey(TotalNovedadesf,Rutas)
        TotalNovedades<-TotalNovedadesf[TotalNovedades, all= TRUE]
        
        TotalNovedades<-as.data.frame(TotalNovedades)
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Flota promedio" 
      }
      
      
      Graf1<- barplot(TotalNovedades$Total,main =paste( titulo,"De",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Rutas,cex.names=0.8,col = "lightblue",cex.axis = 1.2,las=2,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$Total)+mean(TotalNovedades$Total)))))
      #lines(Graf1,(t(TotalNovedades[,3])+mean(TotalNovedades$Total)) , type = "p", lwd = 3,col = "yellow")
      text(Graf1, (as.numeric(TotalNovedades$Total)+3),labels = as.numeric(as.numeric(TotalNovedades$Total)))
      #text(Graf1,(t(TotalNovedades[,3])+mean(TotalNovedades$Total)-1) , labels = as.numeric(as.numeric(TotalNovedades[,2]))) 
      
      #legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend =unique(reposici$JERARQUIA) , cex = 1.2)
      
      
      
    })
    
    
    
    output$descarga<- downloadHandler(
      
        filename =  "Asignenombre.csv",
        content =  function(file){ 
          
          if(input$Afectaciones_2){
            
            accidentesdia<-accidentesdia[accidentesdia$nomb>=input$fechas_input]
            accidentesdia<-accidentesdia[accidentesdia$nomb<=input$fechas_input1]
            accidentesdia<-accidentesdia[,c(1,2,5,8:20)]
            TotalNovedades<-as.data.frame(accidentesdia)
            
          }
          if(input$Afectaciones1_2){
            
            vandalismodia<-vandalismodia[vandalismodia$V1>=input$fechas_input]
            vandalismodia<-vandalismodia[vandalismodia$V1<=input$fechas_input1]
            
            vandalismodia<-vandalismodia[,-c("R","N","C")]
            vandalismodia[,TRO:=as.numeric(vandalismodia$T)+as.numeric(vandalismodia$E)]
            vandalismodia[,Daño:=as.numeric(vandalismodia$`DANOS AL VEHICULO`)+as.numeric(vandalismodia$GRAFITI)]
            vandalismodia[,AgrsionVerbal:=as.numeric(vandalismodia$`AGRESION VERBAL A OPERADOR`)+as.numeric(vandalismodia$`AMENAZA A OPERADOR`)]
            
            vandalismodia<-vandalismodia[,c(1:6,8,25,10:13,16,21,22,23,26,27,24)]
            
            TotalNovedades<-as.data.frame(vandalismodia)
            
          }
          
          
          if(input$Afectaciones2_2){
            PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha>=input$fechas_input]
            PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(PuntosIE_IO[,c(1,6:9,2:5,10)])
          }
          if(input$Afectaciones3_2){
            
            P_TotalesIE<-as.data.table(P_TotalesIE)
            P_TotalesIE<-P_TotalesIE[P_TotalesIE$Fecha>=input$fechas_input]
            P_TotalesIE<-P_TotalesIE[P_TotalesIE$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(P_TotalesIE)
            
            
          }
          if(input$Afectaciones4_2){
            
            consobita<-consobita[consobita$Fecha>=input$fechas_input]
            consobita<-consobita[consobita$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("X4","Mes")],length))
            TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
            
            
            TotalNovedades<-TotalNovedades
            
          }
          
          if(input$Afectaciones5_2){
            
            reposicidia<-as.data.table(reposicidia)
            reposicidia<-reposicidia[reposicidia$Fecha>=input$fechas_input]
            reposicidia<-reposicidia[reposicidia$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(reposicidia)
            
          }
          
          if(input$Afectaciones6_2){
            Incidentes.IA3<-Incidentes.IA4
            
            Incidentes.IA3<-as.data.table(Incidentes.IA3)
            Incidentes.IA3<-Incidentes.IA3[Incidentes.IA3$Fecha>=input$fechas_input]
            Incidentes.IA3<-Incidentes.IA3[Incidentes.IA3$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(Incidentes.IA3)
            
          }
          
          if(input$Afectaciones7_2){
            
            Hitos<-Hitos[Hitos$Fecha>=input$fechas_input]
            Hitos<-Hitos[Hitos$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(tapply(Hitos$JERARQUIA,Hitos$Fecha,length))
            TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
            
            TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
            names(TotalNovedades)=c("Fecha","Total")
            
            
            TotalNovedades<-as.data.frame(TotalNovedades)
            
          }
          
          if(input$Afectaciones8_2){
            
            salidas<-salidas[salidas$Fecha>=input$fechas_input]
            salidas<-salidas[salidas$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(tapply(salidas$Kilometros_peridos,salidas$Fecha,sum))
            TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
            
            TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
            names(TotalNovedades)=c("Fecha","TotalKM")
            
            TotalNovedades<-as.data.table(TotalNovedades)
            
            setkey(salidas_todas_dia,Fecha)
            setkey(TotalNovedades,Fecha)
            
            
            TotalNovedades1<-salidas_todas_dia[TotalNovedades, all= TRUE]
            
            
            
            TotalNovedades<-as.data.frame(TotalNovedades1)
            
            
            
          }
          
          
          if(input$Afectaciones9_2){
            
            Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha>=input$fechas_input]
            Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(Tablero2024_25)
            
            
            TotalNovedades<-as.data.frame(TotalNovedades)
            #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
           
          }
          
          
          if(input$Afectaciones10_2){
            
            FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha>=input$fechas_input]
            FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha<=input$fechas_input1]
            
            TotalNovedades<-as.data.frame(FlotaMax_Tipologia22_24_25)
            
            
            TotalNovedades<-as.data.frame(TotalNovedades)
            #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
            
          }  
          
          
        write.csv(TotalNovedades, file)
        
      })
    
    output$descarga2<- downloadHandler(
      
      filename =  "Asignenombre.xlsx",
      content =  function(file){ 
        
        if(input$Afectaciones_2){
          
          Accidentes<-Accidentes[Accidentes$Fecha>=input$fechas_input]
          Accidentes<-Accidentes[Accidentes$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(Accidentes[,-c(53:65)])
          
        }
        if(input$Afectaciones1_2){
          
          vandalismos<-vandalismos[vandalismos$Fecha>=input$fechas_input]
          vandalismos<-vandalismos[vandalismos$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(vandalismos[,-c(58:60)])
          
        }
        
        
        if(input$Afectaciones2_2){
          PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha>=input$fechas_input]
          PuntosIE_IO<-PuntosIE_IO[PuntosIE_IO$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(PuntosIE_IO[,c(1,6:9,2:5,10)])
        }
        
        if(input$Afectaciones3_2){
          
          P_TotalesIE<-as.data.table(P_TotalesIE)
          P_TotalesIE<-P_TotalesIE[P_TotalesIE$Fecha>=input$fechas_input]
          P_TotalesIE<-P_TotalesIE[P_TotalesIE$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(P_TotalesIE)
          
        }
        
        if(input$Afectaciones4_2){
          
          consobita<-as.data.table(consobita)
          consobita$Fecha<-as.character(consobita$Fecha)
          consobita<-consobita[consobita$Fecha>=input$fechas_input]
          consobita<-consobita[consobita$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(consobita[,-c(53:65)])
          
          
          
        }
        
        if(input$Afectaciones5_2){
          
          reposici<-as.data.table(reposici)
          reposici$Fecha<-as.character(reposici$Fecha)
          reposici<-reposici[reposici$Fecha>=input$fechas_input]
          reposici<-reposici[reposici$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(reposici)
          
        }
        
        if(input$Afectaciones6_2){
          
         
          BDincidentes<-BDincidentes[BDincidentes$Fecha>=input$fechas_input]
          BDincidentes<-BDincidentes[BDincidentes$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(BDincidentes[,-c(53:65)])
          
        }
        
        if(input$Afectaciones7_2){
          
          
          Hitos<-Hitos[Hitos$Fecha>=input$fechas_input]
          Hitos<-Hitos[Hitos$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(Hitos[,-c(53:65)])
          
        }
        if(input$Afectaciones8_2){
          
          
          salidas<-salidas[salidas$Fecha>=input$fechas_input]
          salidas<-salidas[salidas$Fecha<=input$fechas_input1]
          
          TotalNovedades<-as.data.frame(salidas[,-c(54:64,66,67)])
          
        }
        
        write.xlsx(TotalNovedades, file)
        
      })
    
    output$distPlot1_3 <- renderPlot({
      
 
      
     
      if(input$Afectaciones_2){
        
        accidentesdia<-accidentesdia[accidentesdia$nomb>=input$fechas_input]
        accidentesdia<-accidentesdia[accidentesdia$nomb<=input$fechas_input1]
        Accidentes<-Accidentes[Accidentes$Fecha>=input$fechas_input]
        Accidentes<-Accidentes[Accidentes$Fecha<=input$fechas_input1]
        
        
        
        TotalNovedades<-cbind(data.table(sum(accidentesdia$`Concesionario GIT Masivo`)),data.table(sum(accidentesdia$`Concesionario Blanco y Negro`)),data.table(sum(accidentesdia$`Concesionario ETM`)),data.table(sum(accidentesdia$`Concesionario Blanco y Negro2`)))
        names(TotalNovedades)=c("GIT","BYN","ETM","BCPC")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadesC<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadesC[,Seleccion:="COT"]
        names(TotalNovedadesC)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-cbind(data.table(sum(accidentesdia$"1")),data.table(sum(accidentesdia$"2")),data.table(sum(accidentesdia$"3")),data.table(sum(accidentesdia$"4")))
        names(TotalNovedades)=c("ART","PAD","COM","DUAL")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadest<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadest[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedadest)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-cbind(data.table(sum(accidentesdia$AD3)),data.table(sum(accidentesdia$AF)),data.table(sum(accidentesdia$AH)))
        names(TotalNovedades)=c("Daños","Fatales","Heridos")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadesS<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadesS[,Seleccion:="SEVERIDAD"]
        names(TotalNovedadesS)=c("Rutas","Total","Seleccion")
        
        TotalNovedades<-as.data.frame(tapply(Accidentes$JERARQUIA,Accidentes$X4,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedadesC,TotalNovedadest,TotalNovedadesS)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Accidentes"
      }
     
      if(input$Afectaciones1_2){
        
        vandalismodia<-vandalismodia[vandalismodia$V1>=input$fechas_input]
        vandalismodia<-vandalismodia[vandalismodia$V1<=input$fechas_input1]
        vandalismos<-vandalismos[vandalismos$Fecha>=input$fechas_input]
        vandalismos<-vandalismos[vandalismos$Fecha<=input$fechas_input1]
        
        
        TotalNovedades<-cbind(data.table(sum(as.numeric(vandalismodia$`Concesionario GIT Masivo`))),data.table(sum(as.numeric(vandalismodia$`Concesionario Blanco y Negro`))),data.table(sum(as.numeric(vandalismodia$`Concesionario ETM`)),data.table(sum(as.numeric(vandalismodia$`Concesionario Blanco y Negro2`)))))
        names(TotalNovedades)=c("GIT","BYN","ETM","BCPC")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadesC<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadesC[,Seleccion:="COT"]
        names(TotalNovedadesC)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-cbind(data.table(sum(as.numeric(vandalismodia$"1"))),data.table(sum(as.numeric(vandalismodia$"2"))),data.table(sum(as.numeric(vandalismodia$"3"))),data.table(sum(as.numeric(vandalismodia$"4"))))
        names(TotalNovedades)=c("ART","PAD","COM","DUAL")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadest<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadest[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedadest)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos$X4,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedadesC,TotalNovedadest)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Vandalismo"
      }
      if(input$Afectaciones2_2){
        P_Totales<-P_Totales[P_Totales$Fecha>=input$fechas_input]
        P_Totales<-P_Totales[P_Totales$Fecha<=input$fechas_input1]
        
      
        TotalNovedades1<-as.data.frame(tapply(P_Totales$Puntos,P_Totales$Concesionario,sum))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(P_Totales$Puntos,P_Totales$Tipologia,sum))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        
        titulo<-"Puntos IE _IO"
      }
      if(input$Afectaciones3_2){
        
        P_TotalesIE
        
        P_IE<-P_IE[P_IE$Fecha>=input$fechas_input]
        P_IE<-P_IE[P_IE$Fecha<=input$fechas_input1]
        
        
        TotalNovedades1<-as.data.frame(tapply(P_IE$Puntos,P_IE$Concesionario,sum))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(P_IE$Puntos,P_IE$Tipologia,sum))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Puntos IE"
        
      }
      if(input$Afectaciones4_2){
        
        consobita<-consobita[consobita$Fecha>=input$fechas_input]
        consobita<-consobita[consobita$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$X2,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        TotalNovedades1<-as.data.frame(tapply(consobita$JERARQUIA,consobita$Concesionario,length))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(consobita$JERARQUIA,consobita$Tipologia,length))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        
        titulo<-"Cantidad de novedades"
      }
      
      if(input$Afectaciones5_2){
        
        reposici<-as.data.table(reposici)
        reposici<-reposici[reposici$Fecha>=input$fechas_input]
        reposici<-reposici[reposici$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(reposici$JERARQUIA,reposici$V5,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        TotalNovedades1<-as.data.frame(tapply(reposici$JERARQUIA,reposici$Concesionario,length))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(reposici$JERARQUIA,reposici$Tipologia,length))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Repocicionamientos" 
      }
      
      if(input$Afectaciones6_2){
        
        BDincidentes<-as.data.table(BDincidentes)
        BDincidentes<-BDincidentes[BDincidentes$Fecha>=input$fechas_input]
        BDincidentes<-BDincidentes[BDincidentes$Fecha<=input$fechas_input1]
        
        TotalNovedades<-as.data.frame(tapply(BDincidentes$JERARQUIA,BDincidentes$X3,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        TotalNovedades1<-as.data.frame(tapply(BDincidentes$JERARQUIA,BDincidentes$Concesionario,length))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(BDincidentes$JERARQUIA,BDincidentes$Tipologia,length))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Incidentes" 
      }
      
      if(input$Afectaciones7_2){
        
        Hitos<-Hitos[Hitos$Fecha>=input$fechas_input]
        Hitos<-Hitos[Hitos$Fecha<=input$fechas_input1]
        Hitos$Concesionario<-replace(Hitos$Concesionario,is.na(Hitos$Concesionario),"N_A")
        Hitos$Tipologia<-replace(Hitos$Tipologia,is.na(Hitos$Tipologia),"N_A")
        
        TotalNovedades<-as.data.frame(tapply(Hitos$JERARQUIA,Hitos$X3,length))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        TotalNovedades1<-as.data.frame(tapply(Hitos$JERARQUIA,Hitos$Concesionario,length))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(Hitos$JERARQUIA,Hitos$Tipologia,length))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Hitos" 
      }
      
      if(input$Afectaciones8_2){
        
        salidas<-salidas[salidas$Fecha>=input$fechas_input]
        salidas<-salidas[salidas$Fecha<=input$fechas_input1]
        salidas$Concesionario<-replace(salidas$Concesionario,is.na(salidas$Concesionario),"N_A")
        salidas$Tipologia<-replace(salidas$Tipologia,is.na(salidas$Tipologia),"N_A")
        
        TotalNovedades<-as.data.frame(tapply(salidas$Kilometros_peridos,salidas$X3,sum))
        TotalNovedades<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedades[,Seleccion:="TIPO"]
        names(TotalNovedades)=c("Rutas","Total","Seleccion")
        TotalNovedades1<-as.data.frame(tapply(salidas$Kilometros_peridos,salidas$Concesionario,sum))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades2<-as.data.frame(tapply(salidas$Kilometros_peridos,salidas$Tipologia,sum))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        
        
        
        TotalNovedades<-rbind(TotalNovedades,TotalNovedades1,TotalNovedades2)
        TotalNovedades<-replace(TotalNovedades,is.na(TotalNovedades),0)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Kilometros perdidos x salidas" 
      }
      
      
      if(input$Afectaciones9_2){
        
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha>=input$fechas_input]
        Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha<=input$fechas_input1]
        
        
        TotalNovedades<-cbind(data.table(mean(as.numeric(Tablero2024_25$GIT))),data.table(mean(as.numeric(Tablero2024_25$BNM))),data.table(mean(as.numeric(Tablero2024_25$ETM))),data.table(mean(as.numeric(Tablero2024_25$BNM2))))
        names(TotalNovedades)=c("GIT","BYN","ETM","BCPC")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadesC<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadesC[,Seleccion:="COT"]
        names(TotalNovedadesC)=c("Rutas","Total","Seleccion")
        
        
        TotalNovedades<-cbind(data.table(mean(as.numeric(Tablero2024_25$ART))),data.table(mean(as.numeric(Tablero2024_25$PAD))),data.table(mean(as.numeric(Tablero2024_25$COM))),data.table(mean(as.numeric(Tablero2024_25$DUAL))))
        names(TotalNovedades)=c("ART","PAD","COM","DUAL")
        TotalNovedades<-as.data.frame(t(TotalNovedades))
        TotalNovedadest<-as.data.table(cbind(row.names(TotalNovedades),TotalNovedades))
        TotalNovedadest[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedadest)=c("Rutas","Total","Seleccion")
        
       
        
        
        TotalNovedades<-rbind(TotalNovedadesC,TotalNovedadest)
        TotalNovedades$Total<-round(TotalNovedades$Total,0)
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Flota Promedio"
      }
      
      
      if(input$Afectaciones10_2){
        
        FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha>=input$fechas_input]
        FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Fecha<=input$fechas_input1]
        FlotaMax_Tipologia22_24_25[,variable:=paste(COT,Tipologia,sep = "_")]
        
        TotalNovedades1<-as.data.frame(tapply(FlotaMax_Tipologia22_24_25$Total,FlotaMax_Tipologia22_24_25$variable,mean))
        TotalNovedades1<-as.data.table(cbind(row.names(TotalNovedades1),TotalNovedades1))
        TotalNovedades1[,Seleccion:="COT"]
        names(TotalNovedades1)=c("Rutas","Total","Seleccion")
        TotalNovedades1$Total<-round(TotalNovedades1$Total,0)
        
        FlotaMax_Tipologia22_24_25[,variable:=paste(Tipologia,COT,sep = "_")]
        TotalNovedades2<-as.data.frame(tapply(FlotaMax_Tipologia22_24_25$Total,FlotaMax_Tipologia22_24_25$variable,mean))
        TotalNovedades2<-as.data.table(cbind(row.names(TotalNovedades2),TotalNovedades2))
        TotalNovedades2[,Seleccion:="TIPOLOGIA"]
        names(TotalNovedades2)=c("Rutas","Total","Seleccion")
        TotalNovedades2$Total<-round(TotalNovedades2$Total,0)
        
        
        
        
        TotalNovedades<-rbind(TotalNovedades1,TotalNovedades2)
        TotalNovedades<-TotalNovedades[TotalNovedades$Total>0]
        
        
        TotalNovedades<-TotalNovedades[TotalNovedades$Seleccion==input$Seleccion]
        TotalNovedades<-as.data.frame(TotalNovedades)
        
        
        #TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Flota Promedio"
      }
      #par(mfrow=c(1,2))
      
      Graf1<- barplot(TotalNovedades$Total,main =paste( titulo,"De",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Rutas,cex.names=0.8,col = "lightblue",cex.axis = 1.2,las=1,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$Total)+mean(TotalNovedades$Total)))))
      #lines(Graf1,(t(TotalNovedades[,3])+mean(TotalNovedades$Total)) , type = "p", lwd = 3,col = "yellow")
      text(Graf1, (as.numeric(TotalNovedades$Total)+3),labels = as.numeric(as.numeric(TotalNovedades$Total)))
      #text(Graf1,(t(TotalNovedades[,3])+mean(TotalNovedades$Total)-1) , labels = as.numeric(as.numeric(TotalNovedades[,2]))) 
      legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend =paste("Total",sum(TotalNovedades$Total)) , cex = 1.2)
      legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(TotalNovedades$Rutas,TotalNovedades$Total, sep = "-"),cex = 0.7,xpd = TRUE)
      
      
    })
    
    output$distPlot3 <- renderPlot({
      
      
      consobita<-consobita[consobita$Fecha>=input$fechas_input]
      consobita<-consobita[consobita$Fecha<=input$fechas_input1]
      consobita<-consobita[consobita$JERARQUIA==input$Jerarquias3]
      consobita<-consobita[consobita$Concesionario==input$COT3]
      #consobita<-consobita[consobita$TIPO_EVENTO==input$Tipo_Evento3]
      
      Novedad<-"Quincena"
      
      
      if(input$Puntos){
        
        TotalNovedades<-as.data.frame(tapply(consobita$Puntos,consobita[,c("Quincena","Tipologia")],sum))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"Suma Puntos"
      }
      if(input$Cantidad){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("Quincena","Tipologia")],length))
        Nombres<-(row.names(TotalNovedades))
        TotalNovedades<-as.data.table(cbind(Nombres,TotalNovedades))
        TotalNovedades[,Cero:=0]
        titulo<-"Cantidad"
      }
      
      
      
      
      Graf1<- barplot(TotalNovedades$Cero,main =paste( titulo,"por",Novedad,"De",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Nombres,cex.names=0.8,col = "lightblue",cex.axis = 1.2,las=1,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$PAD)+mean(TotalNovedades$ART)))))
      if(input$ART3){
      lines(as.numeric(TotalNovedades$ART),col = "blue", type = "l",lwd= 4) 
        legend(x = "topright",col = "blue",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.1), legend =paste("ART") , cex = 1.2)  }
     
        if(input$PAD3){  
      lines(as.numeric(TotalNovedades$PAD),col = "red", type = "l", lwd= 4) 
      legend(x = "topright",col =  "red",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.2), legend =paste("PAD") , cex = 1.2)    }
      
     
        if(input$DUAL3){
        lines(as.numeric(TotalNovedades$DUAL),col = "yellow", type = "l" ,lwd= 4) 
        legend(x = "topright",col = "yellow",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.4), legend =paste("DUAL") , cex = 1.2)  }
     
      
      
      if(input$COM3){  
        lines(as.numeric(TotalNovedades$COM),col = "black", type = "l",lwd= 4)   
        legend(x = "topright",col = "black",bty = "n",horiz = T,lwd= 4,inset =  c(0,0.3), legend =paste("COM") , cex = 1.2)
        }
      #text(Graf1, (as.numeric(TotalNovedades$Total)+3),labels = as.numeric(as.numeric(TotalNovedades$Total)))
      #legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend =input$Jerarquias , cex = 1.2)
      
      
      
    })
    
    
}

# Run the application 
# Activa modo autoreload con la opción global
options(shiny.autoreload = TRUE)
options(shiny.autoreload.interval = 2000)
# Run the application 
shinyApp(ui = ui, server = server, options = list(host = "0.0.0.0",port=9004))

#+(10^(length(digits((mean(TotalNovedades$Salida))))))