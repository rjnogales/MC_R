#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

##########

#Leer salidas 
#leer kilometros
#leer vehiculo
#leer Ruta




if (rstudioapi::isAvailable()) {
  current_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  #current_dir <- file.path(getwd(), "02 - Salidas")
  current_dir <- file.path(getwd())
}
current_dir

source(file.path(current_dir, "kmsalidasv1.R"))
#
library(shiny)
library(tidyverse)#lo tiene todos 
library(DT)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(data.table)
require(shiny)
library(readxl) #leer archivos en excel y ussas las propiedades de a librerya
library(stringr) #leer utilizar las funciones de los directorios de las carpetas
library(lubridate)
library(lessR)


ui <- (fluidPage(tabsetPanel((tabPanel("AÑO", 
                                       sidebarLayout(sidebarPanel(
                                         
                                         selectInput(inputId = "COT",
                                                     label = "COT:",
                                                     
                                                     choices = list("SITM-MIO", "GIT","BYN","ETM", "BCPC" )),
                                         
                                         selectInput(inputId = "Mesest",
                                                     label = "Mes:",
                                                     
                                                     choices = list("Año", "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Novimbre", "Diciembre")
                                                     
                                                     
                                         ),
                                        
                                         selectInput(inputId = "año_num_input",
                                                     label = "Año:",
                                                     
                                                     choices = list( "2023","2024","2025","2026")
                                                     #selected = levels(list(accidentesdia))
                                                     
                                         ),
                                         
                                         selectInput(inputId = "año_num_input1",
                                                     label = "Año2:",
                                                     
                                                     choices = list( "2024","2023","2025","2026")
                                                     #selected = levels(list(accidentesdia))
                                                     
                                         ),
                                         actionButton("reload_all", "ActualizarDash"),
                                         
                                         width = 2
                                       ),mainPanel( 
                                         
                                         fluidRow(
                                         
                                                  column(1, checkboxInput("HAB",
                                                       "HAB")),
                                                  column(1,checkboxInput("SAB",
                                                       "SAB")),
                                                  column(1,checkboxInput("FES",
                                                       "FES"))),
                                         
                                     plotOutput("distPlot"),
                                     
                                       
                                       plotOutput("distPlot2"),
                                     
                                     radioButtons("Tipo", "seleccione", c("png","jpeg")),
                                     
                                     downloadButton("dwd","Dowload Grafi"),
                                     
                                     downloadButton("descarga2", "Table de Participacion")
                                       
                                       )))
                              
                              
),tabPanel("COT", 
           sidebarLayout(sidebarPanel(
             
             checkboxInput("TASA",
                           "Tasa"),
             checkboxInput("Total",
                           "Total"),
             selectInput(inputId = "Meses",
                         label = "Mes:",
                         
                         choices = list("Año","Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Novimbre", "Diciembre")
                         #selected = levels(list(accidentesdia))
                         
             ),
             selectInput(inputId = "COTS",
                         label = "COT:",
                         
                         choices = list( "GIT","BYN","ETM", "BCPC" )
                         #selected = levels(list(accidentesdia))
                         
             ),
             
             
             
             
             selectInput(inputId = "TIPOLOGIAS",
                         label = "TIPOLGIA:",
                         
                         choices = list( "ART","PAD","COM","DUAL")
                         #selected = levels(list(accidentesdia))
                         
             ),
             #selectInput(inputId = "TIPO_SER",
             #    label = "TIPO_SEVICIO:",
             
             #           choices = list( "Troncal","Prestoncal","Alimentador","Reserva")
             #selected = levels(list(accidentesdia))
             
             #),
             
             
             selectInput(inputId = "TIPODIA",
                         label = "DIA_TIPO:",
                         
                         choices = list( "HAB","SAB","FES")
                         
             ),
             
             selectInput(inputId = "año_num_input2",
                         label = "Año:",
                         
                         choices = list( "2023","2024","2025")
                         #selected = levels(list(accidentesdia))
                         
             ),
             
             selectInput(inputId = "año_num_input3",
                         label = "Año2:",
                         
                         choices = list( "2024","2023","2025")
                         #selected = levels(list(accidentesdia))
                         
             ),selectInput(inputId = "tiposalida",
                           label = "Tipo de Salida:",
                           
                           choices = list( "UTRYT","FLOTA","ACCIDENTES","OPERADOR","VANDALISMO" )
                           #selected = levels(list(accidentesdia))
                           
             )
             ,
             
             width = 2
             
             #dateInput("fechas_input",  "Fecha:", min = today()-365 , max =  today() , value = today(), 
             #language = "es", weekstart = 1),
             #
             
             
             #submitButton("Reinicie")
             
             
           ),mainPanel(tabsetPanel(tabPanel("TIPOLOGIA",
                                            plotOutput("distPlot4"),
                                            
                                            plotOutput("distPlot11")
                                            
                                            
           ),
           tabPanel("COMBUSTIBLE",
                    
                    selectInput(inputId = "COMBUSTIBLE",
                                label = "TIPO COMBUSTIBLE:",
                                
                                choices = list( "ACPM","Gas","Electricos")
                                #selected = levels(list(accidentesdia))
                                
                    ),
                    plotOutput("distPlot41"),
                    
                    plotOutput("distPlot1")
                    
                    
           )  
           
           
           ))
           
           )),


tabPanel("Rutas",
         sidebarLayout(sidebarPanel(
           
           checkboxInput("TASAr",
                         "Tasa"),
           checkboxInput("Totalr",
                         "Total"),
           selectInput(inputId = "TIPO_SER",
                       label = "TIPO_SEVICIO:",
                       
                       choices = list("Troncal","Pretoncal","Alimentador","Reserva")
                       
           ),
           selectInput(inputId = "TIPODIAr",
                       label = "DIA_TIPO:",
                       
                       choices = list( "HAB","SAB","FES")
                       
           ),
           
           selectInput(inputId = "año_num_inputr",
                       label = "Año:",
                       
                       choices = list( "2024","2023","2025")
                       #selected = levels(list(accidentesdia))
                       
           )
           ,selectInput(inputId = "Mesesr",
                        label = "mes:",
                        
                        choices = list( "Año","Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Novimbre", "Diciembre")
                        
                        
           )
           
           #checkboxInput("Total",
           #  "Total salidas"),
           
           #checkboxGroupInput("TIPO", label =  "Tipo:", choices = list( "UTRYT","FLOTA","ACCIDENTES","OPERADOR","VANDALISMO" ) )
           
           ,width = 2),mainPanel(  selectInput(inputId = "Cuartilesr",
                                               label = "Cuartil:",
                                               
                                               choices = c(0.75,0.50,0.25) ),
                                   
                                   plotOutput("distPlot5"), fluidRow(   column(selectInput(inputId = "Rutas",
                                                                                           label = "Ruta:",
                                                                                           
                                                                                           choices = list( " ","T31","A62","P21A","A12B","A71","P21E","C520","C502","P21C","E27","A17B","P24B","C320","A32","P30B","A13C","P21B",
                                                                                                           "P40B","P27D","P40A","P60B","A76","A06","T40","A41A","E21","A14A","P14A","T57A","A02","A64","P74","A44B",
                                                                                                           "A22","A44A","P47A","P14B","A18","A17E","A12D","C302","A37A","A75","A37B","T42","P62D","A46","A17C",
                                                                                                           "P47C","A36","A17F","A14B","A04","A03","A19A","A73","A12A","A19B","A17D","P61","P42","A47","A13D","A23" ,
                                                                                                           "P52D","C471","A42B","A41C","T50","A11","A24","T47B","P62A","A35A","P82","P24A","C417","T37","A63","A23B",
                                                                                                           "A72A","A12C","A13A","P47B","A33","A21","A70","A17A","A78A","A01A","A61","A05","A11B","A72B","P51C","P51A",
                                                                                                           "A52","A57","T52","P52A","A54","A65","P51B","A55","A83","A81","A01B","A18B","A12E","P83","T51","T53" ,
                                                                                                           "P76","P75","A56","R211","R222","R511","R613","R722","R212","R712","R411","R721","R113","R713","R111","R811")
                                                                                           
                                                                                           #selected = levels(list(accidentesdia))
                                                                                           
                                   ),width = 1),
                                   plotOutput("distPlot6") )
                                   
           )) ),

tabPanel("Vehiculos",
         sidebarLayout(sidebarPanel(
           checkboxInput("TASAf",
                         "Tasa"),
           checkboxInput("Totalf",
                         "Total"),
           
           selectInput(inputId = "COTSf",
                       label = "COT:",
                       
                       choices = list( "GIT","BYN","ETM", "BCPC" )),
           
           selectInput(inputId = "TIPOLOGIAf",
                       label = "TIPOLOGIA:",
                       
                       choices = list("PAD","ART","COM","DUAL")
                       
           ),
           selectInput(inputId = "TIPODIAf",
                       label = "DIA_TIPO:",
                       
                       choices = list( "HAB","SAB","FES")
                       
           ),
           
           selectInput(inputId = "año_num_inputf",
                       label = "Año:",
                       
                       choices = list( "2024","2023","2025")
                       #selected = levels(list(accidentesdia))
                       
           ),
           selectInput(inputId = "Mesesf",
                       label = "mes:",
                       
                       choices = list( "Año","Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Novimbre", "Diciembre")
                       
                       
           )
           ,width = 2),mainPanel(
             
             
            
             fluidRow( column(1,selectInput(inputId = "Cuartilesf",
                                               label = "Cuartil:",
                                               
                                               choices = c(0.75,0.50,0.25) )),
             column(2,numericInput("Numero",
                         "% de dias Operativos:",
                         
                         value = 50,min = 0,max = 100))),
                                   
                                   plotOutput("distPlot7"), fluidRow(  
                                     
                                     
                                     column (selectInput(inputId = "VEHICULOS",
                                                         label = "Vehiculo:",
                                                         
                                                         choices = list(" ","12096","12093","13009","53006","54006","12168","22069","22097","22004","12172","12004","22116","33019","22021"
                                                                        ,"22160","54022","22114","13026","12001","12036","22066","22082","32013","12050","23053","22062","23042","31016"
                                                                        ,"32004","32082","11055","12109","12128","11064","22119","23034","23051","22105","33041","23008","23026","23003"
                                                                        ,"53023","32075","32067","32028","13004","12064","12083","12110","12101","12175","11037","13019","13001","12027"
                                                                        ,"13034","22052","13036","12037","13018","23001","22138","32007","32037","22129","23043","54011","32050","12105"
                                                                        ,"12152","13016","22130","12147","12132","21055","53009","53007","13045","32083","12159","22133","23027","21001"
                                                                        ,"23015","54004","12067","12094","13024","23044","54017","23007","12141","23025","23054","33027","13048","13070"
                                                                        ,"13071","12149","12068","22073","12117","13062","22016","22148","22027","32005","13002","13014","13040","13049"
                                                                        ,"22030","53025","13013","13052","22018","33033","11041","13038","22155","12054","23046","31021","12084","22077"
                                                                        ,"12070","13058","22087","23005","33034","12020","11069","23041","12058","12072","22048","21032","22054","23002"
                                                                        ,"12166","12111","23052","12016","22002","53019","33009","31033","32017","12124","12052","12032","12143","12086"
                                                                        ,"33021","12078","11056","22037","23022","33003","23021","54015","12154","13029","32077","13056","12092","13005"
                                                                        , "12173","23038","31034","32066","12066","12171","13007","12061","22118","23023","53011","32003","11016","13042"
                                                                        ,"22068","21035","21006","22098","23029","22051","21043","21044","32009","12120","32078","54020","32057","22122"
                                                                        ,"13041","11067","11012","53016","22112","13046","12076","23012","23024","23039","21039","33010","33036","32032"
                                                                        , "12069","53008","33018","33024","12053","12011","12079","21010","54023","13022","12150","12113","13021","23010"
                                                                        , "21008","33022","12112","23056","33012","31013","33001","12038","12035","22010","13006","12089","22035","22152"
                                                                        , "22008","23033","33035","33030","12080","12170","13031","13025","33026","23032","21040","22095","22028","22156"
                                                                        , "32063","32062","13066","12026","22039","23030","22147","12153","22059","22099","22014","31015","12157","12148"
                                                                        ,"22032","13059","22076","54008","53015","32047","13065","23011","22067","33007","23004","22047","21022","22121"
                                                                        , "12012","12126","22106","12107","23006","11072","12030","11025","22086","13017","12024","53002","31029","22123"
                                                                        , "12174","23013","31012","11018","23048","12065","12181","21056","54025","13044","12049","12122","12119","22060"
                                                                        ,"32039","12041","12180","12033","22137","32012","32048","11053","32034","22012","22100","12176","12071","53010"
                                                                        , "53026","32074","12042","12019","12167","21003","23055","22026","22134","22058","31011","12163","12023","12025"
                                                                        , "33029","22108","13027","22045","13063","22038","11013","11030","12085","12090","22085","12130","12021","22128"
                                                                        ,"12116","22006","21041","13051","13035","32021","32020","33028","22003","21014","33040","33039","12179","12098"
                                                                        ,"12048","22103","22034","21045","23017","22061","23018","22102","33008","12160","22015","53024","11070","53013"
                                                                        , "33016","22046","31018","32036","22064","23035","23037","53022","32079","32038","33031","12034","33020","13012"
                                                                        ,"21027","12138","22020","21005","22075","33025","31024","12029","22159","22125","22142","13032","33013","21042"
                                                                        , "12031","22023","22132","21037","23036","32065","12017","12114","33037","32072","12039","22107","23049","32015"
                                                                        , "32040","12161","11071","22120","54012","32056","12005","13028","32061","22149","31006","32058","12099","22144"
                                                                        ,"22041","32080","11001","11045","22022","32045","13060","32008","12075","12081","32081","12106","12135","23045"
                                                                        , "22078","11059","12127","21047","33002","12074","22094","22081","32052","12133","32069","32051","33017","32046"
                                                                        ,"22071","32035","22153","32001","11027","32010","11002","22090","32041","32073","12044","33004","32030","22031"
                                                                        ,"13008","22127","11049","12131","22072","32022","11047","13069","22139","13068","22065","22104","32025","12003"
                                                                        ,"13033","11015","21049","22110","22079","32006","12140","13061","21052","11066","22033","23014","13050","12162"
                                                                        ,"33011","11021","11032","54019","32014","22096","13011","12088","23047","22036","53001","11005","11038","32043"
                                                                        , "22115","22101","21059","22074","54024","54018","12125","12129","13030","22025","53004","12014","12047","54002"
                                                                        , "13047","21057","21012","12144","21025","22063","21026","22049","53005","33023","22019","13053","12177","32070"
                                                                        ,"11006","22145","13037","22053","12178","22040","21034","12165","12007","22044","21009","22070","53020","22136"
                                                                        , "11009","23050","32018","31001","12091","22151","33015","12146","22157","22158","12062","33032","12151","21061"
                                                                        , "12040","22117","54003","32027","12118","22113","12156","12045","22042","22089","13039","32059","32053","31017"
                                                                        ,"31004","12121","11063","22143","11034","12123","32060","32024","12013","22055","33038","11050","22011","22088"
                                                                        , "13057","22009","32002","33005","21002","12028","12137","12043","13003","21058","21050","22084","12010","54021"
                                                                        , "54005","32029","12009","22135","22092","32011","53021","22043","22161","31028","13067","12077","33014","11060"
                                                                        ,"53003","53017","11035","11010","32044","23031","22024","31005","21038","32042","22013","54010","22091","11043"
                                                                        , "22131","23016","12087","21023","11031","22017","32054","11051","11036","12073","12102","53012","31036","54013"
                                                                        , "22001","21015","11058","22126","12051","13072","22057","32049","31023","12097","22140","32031","21020","54014"
                                                                        ,"11028","22007","21016","22124","13064","12018","11061","12008","31009","21036","22141","22083","21017","12082"
                                                                        ,"22111","32064","32068","21053","31007","12145","54026","12060","12134","31031","12136","11004","11057","31037"
                                                                        ,"21030","12158","32019","54016","12046","22109","12056","12100","21018","11026","12142","22150","21007","21011"
                                                                        , "13055","11044","12115","22080","21024","12057","22093","31030","12059","21013","11008","32071","11042","11040"
                                                                        , "11065","32016","11073","12155","22029","53014","23009","11068","32033","12015","31019","11054","32055","11048"
                                                                        , "31026","22154","21029","11023","54009","11003","33006","21046","22146","11062","23020","22050","12164","22056"
                                                                        , "32076","21051","21033","54001","11022","21060","54007","11019","21048","21028","11029","21054","31003","23040"
                                                                        , "21031","31022","11017","31008","11046","21019","11024","21021","12104","31032","31025","11020","31035","31027"
                                                                        , "11014","31002","21004","31014","12055","31020","53018","12186","31039","31040"
                                                         )
                                                         
                                                         #selected = levels(list(accidentesdia))
                                                         
                                     ),width = 1),plotOutput("distPlot8"),column(width = 1))
                                   
           )
           
           
           )
         
         
         
),

tabPanel("Vehiculos-Tipo de Salida",
         sidebarLayout(sidebarPanel(
           checkboxInput("TASAf2",
                         "Tasa"),
           checkboxInput("Totalf2",
                         "Total"),
           
           selectInput(inputId = "COTSf2",
                       label = "COT:",
                       
                       choices = list( "GIT","BYN","ETM", "BCPC" )),
           
           selectInput(inputId = "TIPOLOGIAf2",
                       label = "TIPOLOGIA:",
                       
                       choices = list("PAD","ART","COM","DUAL")
                       
           ),
           
           selectInput(inputId = "año_num_inputf2",
                       label = "Año:",
                       
                       choices = list( "2024","2023","2025")
                       #selected = levels(list(accidentesdia))
                       
           ),
           selectInput(inputId = "Mesesf2",
                       label = "mes:",
                       
                       choices = list( "Año","Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Novimbre", "Diciembre")
                       
                       
           ),
           
           selectInput(inputId = "tiposalida2",
                       label = "Tipo de Salida:",
                       
                       choices = list( "salidasflota", "salidasOpe." ,  "salidasUTRYT","vandalismos" , "Accidentes")
                       
                       
           )              
           
           
           ,  width = 2),mainPanel(
             
             
             
             selectInput(inputId = "Cuartilesf2",
                         label = "Cuartil:",
                         
                         choices = c(0.75,0.50,0.25) ),
             
             plotOutput("distPlot72"), fluidRow(  
               
               
               column (
               selectInput(inputId = "Tipo_Salida2",
                           label = "Tipo:",
                           
                           choices = list
                           
                           (	"MOTOR", "SISTEMA DE INFORMACION SONORA",	"PANEL INFORMADOR INTERNO",	"FRENOS",	"SUSPENSIÓN",	"CARENCIA DE ILUMINACION",
                             "POR DANO MECANICO SOLO BUS", "CHASIS EJES",	"DIRECCION",
                             "INSTALACIONES ELECTRICAS",	"CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA","CON FALLA DE SISTEMA DE AIRE ACONDICIONADO",
                             "CON VENTANA CLARABOYA EXTRACTOR O ESCOTILLA DANADO",	"TRANSITAR DERRAMANDO LIQUIDOS",	"CON LLANTAS LISAS",
                             "CON ABOLLADURAS EN CARROCERIA INTERNA",	"CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR",	
                             "CON ADITAMENTOS DECORATIVOS NO AUTORIZADOS",	"RUTERO INEXISTENCIA O DANO FISICO O LOGICO",	"NO PORTAR EQUIPO DE CARRETERA",
                             "ABANDONA VEHICULO SIN AUTORIZACION",	"OMITE PARADA",	"AGREDE VERBALMENTE",	"CONDUCE DE MANERA INADECUADA",	"NO PORTA DOCUMENTOS",
                             "PERSONA SOSPECHOSA EN VEHICULO",	"AGRESION VERBAL A OPERADOR",	"HURTO EN VEHICULO",	"ACCIONAR EXTINTOR",	"APRISIONAMIENTO",
                             "MALA FIJACION OBJETOS DEL VEHICULO",	"IVU BOX::IBIS",	"VALIDADOR",	"IVU BOX::DANO FISICO",	"BOTON DE PANICO",	"MICROFONO AMBIENTE",	
                             "FALLA DE PUERTA","TRANSMISION",	"POR DANO ELECTRICO SOLO BUS",	"POR DANO MECANICO VIA MIXTA",	"POR DANO ELECTRICO VIA MIXTA",	
                             "EMISIONES DE RUIDO",	"INFORMACION ERRADA",	"FALLA ANGEL GUARDIAN",	"POR COMBUSTIBLE SOLO BUS",	"INJUSTIFICADO",	"ENFERMEDAD DEL OPERADOR",
                             "POR CASO FORTUITO",	"AUTOMOVIL PARTICULAR",	"TAXI",	"AMBULANCIA",	"ARBOL",	"BUS O BUSETA DE SERVICIO PUBLICO O ESPECIAL",	"ANDEN",
                             "MURO",	"VOLQUETA",	"VEHICULO POLICIA O EJERCITO",	"CON FALLA PLATAFORMA ELEVADORA",	"CAMBIO DE VEHICULO PARA ATENCION DE DISCAPACIDAD",	
                             "CON SILLA ROTA RASGADA ETC",	"PINCHAZO",	"CON FALLA DE TIMBRES",	"CON VENTANA QUEBRADA O FISURADA",	"CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD",
                             "CON PASAMANOS DESPRENDIDO FLOJO ETC",	"CON ABOLLADURAS EN CARROCERIA EXTERNA",	"CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE EXTINTORES",
                             "CON FALTA DE ELEMENTOS DE EXPULSION PARA VENTANAS DE EMERGENCIA",	"NO ACATA O DESCONOCE INSTRUCCION DEL CCO",	"ALTERA RECORRIDO DE RUTA",
                             "AGREDE FISICAMENTE",	"DESACATA LA AUTORIDAD",	"AMENAZA A OPERADOR",	"DANOS AL VEHICULO",	"AGRESION FISICA A OPERADOR",	"GRAFITI",
                             "PELEA O RINA EN VEHICULO",	"ATROPELLO",	"BUS DEL MIO",	"IVU BOX::APAGADO",	"TORNIQUETE",	"IVU BOX::DAT DESACTUALIZADO","EMISIONES GASEOSAS",	"PANELES DE CONTROL",	"POR COMBUSTIBLE VIA MIXTA",	"SUSPENSION",	"NO RELEVO",
                             "MOTO MOTOCARRO O MOTOTRICICLO",	"POR FRENADA BRUSCA",	"BICICLETA",	"OTRO",	"POR MALA APROXIMACION",	"COBERTIZO PARADERO",	"CAMION O TRACTOCAMION",
                             "POSTE",	"ESTACION DEL MIO",	"TRACCION ANIMAL",	"MAQUINA DE BOMBEROS"
)
                           
               )

               ,width = 3),plotOutput("distPlot7_2"),fluidRow(  
                 
                 
                 column (selectInput(inputId = "VEHICULOS2",
                                     label = "Vehiculo:",
                                     
                                     choices = list(" ","12096","12093","13009","53006","54006","12168","22069","22097","22004","12172","12004","22116","33019","22021"
                                                    ,"22160","54022","22114","13026","12001","12036","22066","22082","32013","12050","23053","22062","23042","31016"
                                                    ,"32004","32082","11055","12109","12128","11064","22119","23034","23051","22105","33041","23008","23026","23003"
                                                    ,"53023","32075","32067","32028","13004","12064","12083","12110","12101","12175","11037","13019","13001","12027"
                                                    ,"13034","22052","13036","12037","13018","23001","22138","32007","32037","22129","23043","54011","32050","12105"
                                                    ,"12152","13016","22130","12147","12132","21055","53009","53007","13045","32083","12159","22133","23027","21001"
                                                    ,"23015","54004","12067","12094","13024","23044","54017","23007","12141","23025","23054","33027","13048","13070"
                                                    ,"13071","12149","12068","22073","12117","13062","22016","22148","22027","32005","13002","13014","13040","13049"
                                                    ,"22030","53025","13013","13052","22018","33033","11041","13038","22155","12054","23046","31021","12084","22077"
                                                    ,"12070","13058","22087","23005","33034","12020","11069","23041","12058","12072","22048","21032","22054","23002"
                                                    ,"12166","12111","23052","12016","22002","53019","33009","31033","32017","12124","12052","12032","12143","12086"
                                                    ,"33021","12078","11056","22037","23022","33003","23021","54015","12154","13029","32077","13056","12092","13005"
                                                    , "12173","23038","31034","32066","12066","12171","13007","12061","22118","23023","53011","32003","11016","13042"
                                                    ,"22068","21035","21006","22098","23029","22051","21043","21044","32009","12120","32078","54020","32057","22122"
                                                    ,"13041","11067","11012","53016","22112","13046","12076","23012","23024","23039","21039","33010","33036","32032"
                                                    , "12069","53008","33018","33024","12053","12011","12079","21010","54023","13022","12150","12113","13021","23010"
                                                    , "21008","33022","12112","23056","33012","31013","33001","12038","12035","22010","13006","12089","22035","22152"
                                                    , "22008","23033","33035","33030","12080","12170","13031","13025","33026","23032","21040","22095","22028","22156"
                                                    , "32063","32062","13066","12026","22039","23030","22147","12153","22059","22099","22014","31015","12157","12148"
                                                    ,"22032","13059","22076","54008","53015","32047","13065","23011","22067","33007","23004","22047","21022","22121"
                                                    , "12012","12126","22106","12107","23006","11072","12030","11025","22086","13017","12024","53002","31029","22123"
                                                    , "12174","23013","31012","11018","23048","12065","12181","21056","54025","13044","12049","12122","12119","22060"
                                                    ,"32039","12041","12180","12033","22137","32012","32048","11053","32034","22012","22100","12176","12071","53010"
                                                    , "53026","32074","12042","12019","12167","21003","23055","22026","22134","22058","31011","12163","12023","12025"
                                                    , "33029","22108","13027","22045","13063","22038","11013","11030","12085","12090","22085","12130","12021","22128"
                                                    ,"12116","22006","21041","13051","13035","32021","32020","33028","22003","21014","33040","33039","12179","12098"
                                                    ,"12048","22103","22034","21045","23017","22061","23018","22102","33008","12160","22015","53024","11070","53013"
                                                    , "33016","22046","31018","32036","22064","23035","23037","53022","32079","32038","33031","12034","33020","13012"
                                                    ,"21027","12138","22020","21005","22075","33025","31024","12029","22159","22125","22142","13032","33013","21042"
                                                    , "12031","22023","22132","21037","23036","32065","12017","12114","33037","32072","12039","22107","23049","32015"
                                                    , "32040","12161","11071","22120","54012","32056","12005","13028","32061","22149","31006","32058","12099","22144"
                                                    ,"22041","32080","11001","11045","22022","32045","13060","32008","12075","12081","32081","12106","12135","23045"
                                                    , "22078","11059","12127","21047","33002","12074","22094","22081","32052","12133","32069","32051","33017","32046"
                                                    ,"22071","32035","22153","32001","11027","32010","11002","22090","32041","32073","12044","33004","32030","22031"
                                                    ,"13008","22127","11049","12131","22072","32022","11047","13069","22139","13068","22065","22104","32025","12003"
                                                    ,"13033","11015","21049","22110","22079","32006","12140","13061","21052","11066","22033","23014","13050","12162"
                                                    ,"33011","11021","11032","54019","32014","22096","13011","12088","23047","22036","53001","11005","11038","32043"
                                                    , "22115","22101","21059","22074","54024","54018","12125","12129","13030","22025","53004","12014","12047","54002"
                                                    , "13047","21057","21012","12144","21025","22063","21026","22049","53005","33023","22019","13053","12177","32070"
                                                    ,"11006","22145","13037","22053","12178","22040","21034","12165","12007","22044","21009","22070","53020","22136"
                                                    , "11009","23050","32018","31001","12091","22151","33015","12146","22157","22158","12062","33032","12151","21061"
                                                    , "12040","22117","54003","32027","12118","22113","12156","12045","22042","22089","13039","32059","32053","31017"
                                                    ,"31004","12121","11063","22143","11034","12123","32060","32024","12013","22055","33038","11050","22011","22088"
                                                    , "13057","22009","32002","33005","21002","12028","12137","12043","13003","21058","21050","22084","12010","54021"
                                                    , "54005","32029","12009","22135","22092","32011","53021","22043","22161","31028","13067","12077","33014","11060"
                                                    ,"53003","53017","11035","11010","32044","23031","22024","31005","21038","32042","22013","54010","22091","11043"
                                                    , "22131","23016","12087","21023","11031","22017","32054","11051","11036","12073","12102","53012","31036","54013"
                                                    , "22001","21015","11058","22126","12051","13072","22057","32049","31023","12097","22140","32031","21020","54014"
                                                    ,"11028","22007","21016","22124","13064","12018","11061","12008","31009","21036","22141","22083","21017","12082"
                                                    ,"22111","32064","32068","21053","31007","12145","54026","12060","12134","31031","12136","11004","11057","31037"
                                                    ,"21030","12158","32019","54016","12046","22109","12056","12100","21018","11026","12142","22150","21007","21011"
                                                    , "13055","11044","12115","22080","21024","12057","22093","31030","12059","21013","11008","32071","11042","11040"
                                                    , "11065","32016","11073","12155","22029","53014","23009","11068","32033","12015","31019","11054","32055","11048"
                                                    , "31026","22154","21029","11023","54009","11003","33006","21046","22146","11062","23020","22050","12164","22056"
                                                    , "32076","21051","21033","54001","11022","21060","54007","11019","21048","21028","11029","21054","31003","23040"
                                                    , "21031","31022","11017","31008","11046","21019","11024","21021","12104","31032","31025","11020","31035","31027"
                                                    , "11014","31002","21004","31014","12055","31020","53018","12186","31039","31040"
                                     )
                                     
                                     #selected = levels(list(accidentesdia))
                                     
                 ),width = 1),plotOutput("distPlot82"),column(width = 1)))
             
           )
           
           
         )
         
         
         
)




)))

# ══════════════════════════════ SERVER ════════════════════════════════════════

server <- function(input, output, session) {  
  
  
  
  # ── 1) ObserveEvent para recargar datos al presionar el botón ───────────────
  observeEvent(input$reload_all, {
    
    # 1) Relee/actualiza tus datos
    source(file.path(current_dir, "kmsalidasv1.R"), local = TRUE)
    
    # 2) Muestra un mensaje de éxito
    showNotification("¡Datos actualizados!", type = "message")
    
    # 3) Reinicia la app (el usuario verá la app recargada desde cero)
    session$reload()
  })
  
  output$distPlot2 <- renderPlot({
    Maximafehc<-salidas_todas_dia1[,6]
    Maximafehc<-max(as.Date(Maximafehc$Fecha,origin = "1899-12-30"))
    Maximafehc1 <- data.table("SALIDAS")
    Maximafehc1 <- cbind(Maximafehc1,Maximafehc)
    Maximafehc1$Maximafehc<-as.character(Maximafehc1$Maximafehc)
    
    indicadores$Dia<-as.numeric(indicadores$Dia)
    #indicadores<-indicadores[indicadores$TOTAL>0 ]
    Maximafehc<-indicadores[,3]
    Maximafehc<-max(as.Date(Maximafehc$Dia,origin = "1899-12-30"))
    Maximafehc2 <- data.table("KILOMETROS")
    Maximafehc2 <- cbind(Maximafehc2,Maximafehc)
    Maximafehc2$Maximafehc<-as.character(Maximafehc2$Maximafehc)
    
    
    
    Maximafehc<-as.data.frame(rbind(Maximafehc1,Maximafehc2))
    
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    indicadores<-rbind(indicadores,indicadorestodo)
    
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAt]
    #indicadores<-indicadores[indicadores$Diatipo==input$TIPODIAt]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesest]
    indicadores<-indicadores[indicadores$Mes==input$Mesest]
    
  
    if(input$HAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="HAB"]
      indicadores<-indicadores[indicadores$Diatipo=="HAB"]
    }
    
    if(input$SAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="SAB"]
      indicadores<-indicadores[indicadores$Diatipo=="SAB"]
      
    }
    
    
    if(input$FES){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="FES"]
      indicadores<-indicadores[indicadores$Diatipo=="FES"]
      
    }
    
    
    BCPCKMaño<-data.frame(t(tapply(as.numeric(indicadores$BYNCPC),indicadores$Año,sum)))
    BYNMaño<-data.frame(t(tapply(as.numeric(indicadores$BNM),indicadores$Año,sum)))
    GITKMaño<-data.frame(t(tapply(as.numeric(indicadores$GIT),indicadores$Año,sum)))
    ETMKMaño<-data.frame(t(tapply(as.numeric(indicadores$ETM),indicadores$Año,sum)))
    
    
    
    salidas_todas_dia12<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año")],length))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    Kilometroaño<-data.table(data.frame(t(tapply(as.numeric(indicadores$TOTAL),indicadores$Año,sum))))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    
    k1 <-data.table( X2023= 0,X2024=0,X2025=0,X2026=0 )
    
    salidas_todas_diatotales<-rbind(k1,salidas_todas_diatotales,fill = TRUE)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[-1,c(5,1:4)]
    salidas_todas_diatotales<-replace(salidas_todas_diatotales,is.na(salidas_todas_diatotales),0)
    
    
    salidas_todas_diatotales[,kilometros23:=Kilometroaño$X2023]
    salidas_todas_diatotales[,kilometros24:=Kilometroaño$X2024]
    salidas_todas_diatotales[,kilometros25:=Kilometroaño$X2025]
    salidas_todas_diatotales[,kilometros26:=Kilometroaño$X2026]
    
    salidas_todas_diatotales[,"salidas/mill_23":=round((X2023/kilometros23)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_24":=round((X2024/kilometros24)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_25":=round((X2025/kilometros25)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_26":=round((X2026/kilometros26)*1000000,0)]
    
    salidas_todas_diatotales[,COT:="SITM-MIO"]
    
    salidas_todas_diatotales<- salidas_todas_diatotales[order(salidas_todas_diatotales$`salidas/mill_25`,decreasing = T), ]
    names(salidas_todas_diatotales)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    #####################
    
    salidas_todas_dia13<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Codificacion Concesionario")],length))
    salidas_todas_dia13<-as.data.table(cbind(row.names(salidas_todas_dia13),salidas_todas_dia13))
    
    k1 <-data.table( "X2023.BCPC"=0, "X2024.BCPC"=0,"X2025.BCPC"=0,"X2026.BCPC"=0, "X2023.BYN"=0,  "X2024.BYN"=0 ,"X2025.BYN"=0 ,"X2026.BYN"=0 , "X2023.ETM"=0,  "X2024.ETM"=0,"X2025.ETM"=0,"X2026.ETM"=0,  "X2023.GIT"=0,  "X2024.GIT"=0, "X2025.GIT"=0,"X2026.GIT"=0 )
    
    salidas_todas_dia13<-rbind(k1,salidas_todas_dia13,fill = TRUE)
    
    salidas_todas_dia13<-salidas_todas_dia13[-1,c(17,1:16)]
    salidas_todas_dia13<-replace(salidas_todas_dia13,is.na(salidas_todas_dia13),0)
    
    
    GIT<-as.data.table(salidas_todas_dia13[,c(1,14:17)])
    GIT[,kilometros23:=GITKMaño$X2023]
    GIT[,kilometros24:=GITKMaño$X2024]
    GIT[,kilometros25:=GITKMaño$X2025]
    GIT[,kilometros26:=GITKMaño$X2026]
    GIT[,"salidas/mill_23":=round((X2023.GIT/kilometros23)*1000000,0)]
    GIT[,"salidas/mill_24":=round((X2024.GIT/kilometros24)*1000000,0)]
    GIT[,"salidas/mill_25":=round((X2025.GIT/kilometros25)*1000000,0)]
    GIT[,"salidas/mill_26":=round((X2026.GIT/kilometros26)*1000000,0)]
    GIT[,COT:="GIT"]
    
    GIT<- GIT[order(GIT$`salidas/mill_25`,decreasing = T), ]
    names(GIT)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    
    
    BYN<-as.data.table(salidas_todas_dia13[,c(1,6:9)])
    BYN[,kilometros23:=BYNMaño$X2023]
    BYN[,kilometros24:=BYNMaño$X2024]
    BYN[,kilometros25:=BYNMaño$X2025]
    BYN[,kilometros26:=BYNMaño$X2026]
    
    BYN[,"salidas/mill_23":=round((X2023.BYN/kilometros23)*1000000,0)]
    BYN[,"salidas/mill_24":=round((X2024.BYN/kilometros24)*1000000,0)]
    BYN[,"salidas/mill_25":=round((X2025.BYN/kilometros25)*1000000,0)]
    BYN[,"salidas/mill_26":=round((X2026.BYN/kilometros26)*1000000,0)]
    BYN[,COT:="BYN"]
    
    BYN<- BYN[order(BYN$`salidas/mill_24`,decreasing = T), ]
    names(BYN)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    ETM<-as.data.table(salidas_todas_dia13[,c(1,10:13)])
    ETM[,kilometros23:=ETMKMaño$X2023]
    ETM[,kilometros24:=ETMKMaño$X2024]
    ETM[,kilometros25:=ETMKMaño$X2025]
    ETM[,kilometros26:=ETMKMaño$X2026]
    
    ETM[,"salidas/mill_23":=round((X2023.ETM/kilometros23)*1000000,0)]
    ETM[,"salidas/mill_24":=round((X2024.ETM/kilometros24)*1000000,0)]
    ETM[,"salidas/mill_25":=round((X2025.ETM/kilometros25)*1000000,0)]
    ETM[,"salidas/mill_26":=round((X2026.ETM/kilometros26)*1000000,0)]
    
    ETM[,COT:="ETM"]
    
    
    ETM<- ETM[order(ETM$`salidas/mill_24`,decreasing = T), ]
    names(ETM)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    BCPC<-as.data.table(salidas_todas_dia13[,c(1:5)])
    BCPC[,kilometros23:=BCPCKMaño$X2023]
    BCPC[,kilometros24:=BCPCKMaño$X2024]
    BCPC[,kilometros25:=BCPCKMaño$X2025]
    BCPC[,kilometros26:=BCPCKMaño$X2026]
    
    BCPC[,"salidas/mill_23":=round((X2023.BCPC/kilometros23)*1000000,0)]
    BCPC[,"salidas/mill_24":=round((X2024.BCPC/kilometros24)*1000000,0)]
    BCPC[,"salidas/mill_25":=round((X2025.BCPC/kilometros25)*1000000,0)]
    BCPC[,"salidas/mill_26":=round((X2026.BCPC/kilometros26)*1000000,0)]
    
    BCPC[,COT:="BCPC"]
    BCPC<- BCPC[order(BCPC$`salidas/mill_24`,decreasing = T), ]
    
    names(BCPC)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    salidas_todas_diatotales<-rbind(salidas_todas_diatotales,GIT,ETM,BYN,BCPC)
    
    salidas_todas_diatotales<-replace(salidas_todas_diatotales,salidas_todas_diatotales=="Inf",0)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[salidas_todas_diatotales$COT==input$COT]
    ############################  
    
    mtc<-salidas_todas_diatotales[,c(1,2,3,4,5)]
    mtc<-data.frame(mtc)
    #mtc<-data.frame(colnames(t(mtc)),mtc)
    names(mtc)=c("Tipo","2023","2024","2025","2026")
    mtc2<-mtc
    mtc1<-data.frame(t(mtc[,-1]))
    mtc<-mtc[,-1]
    mtc <- mtc[,c(input$año_num_input,input$año_num_input1)]
    mtctitulo<-salidas_todas_diatotales[1,14]
    
    

    saltoda<-barplot(t(mtc[,c(1,2)]), main = paste( "Total Salidas",mtctitulo,input$Mesest, sep = " "), ylab = "Total",  names.arg = mtc2$Tipo ,cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("Gray", "lightblue"),beside = TRUE,ylim =c(0,(max(mtc[,1]+2000))))
    #text(saltoda, mtc[,1] +1000 ,labels = mtc[,1])
    text(saltoda, (t(mtc[,c(1,2)]))+100 ,labels = t(mtc[,c(1,2)]))
    legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend = c(input$año_num_input,input$año_num_input1), fill = c("Gray","lightblue"),cex = 1.2)
    #legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste( mtc2[,1],mtc[,2], sep = " ") ,cex = 0.9,xpd = TRUE,col = "blue")
    
    #legend(x = "topright",bty = "n",horiz = F,inset = c(0.1,-0.01), legend = paste(mtcpor$Tipo,mtcpor$"2023"), fill = ,cex = 1.1)
    #legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.3), legend = c(paste( "kM",kilo23, sep = "-"),paste( "kM",kilo24, sep = "-")) , fill = c("Gray","lightblue"),cex = 1.2)
    
    
  })
  
  
  output$dwd<-downloadHandler(filename = function()
    
  {paste("Salidas",input$COT,input$Tipo,sep = ".")},
  
  content = function(file){
    
    if(input$Tipo=="png") {png(file,width = 700)} 
    if(input$Tipo=="jpeg"){jpeg(file)}
    
    
    Maximafehc<-salidas_todas_dia1[,6]
    Maximafehc<-max(as.Date(Maximafehc$Fecha,origin = "1899-12-30"))
    Maximafehc1 <- data.table("SALIDAS")
    Maximafehc1 <- cbind(Maximafehc1,Maximafehc)
    Maximafehc1$Maximafehc<-as.character(Maximafehc1$Maximafehc)
    
    indicadores$Dia<-as.numeric(indicadores$Dia)
    indicadores<-indicadores[indicadores$TOTAL>0 ]
    Maximafehc<-indicadores[,3]
    Maximafehc<-max(as.Date(Maximafehc$Dia,origin = "1899-12-30"))
    Maximafehc2 <- data.table("KILOMETROS")
    Maximafehc2 <- cbind(Maximafehc2,Maximafehc)
    Maximafehc2$Maximafehc<-as.character(Maximafehc2$Maximafehc)
    
    
    
    Maximafehc<-as.data.frame(rbind(Maximafehc1,Maximafehc2))
    
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    indicadores<-rbind(indicadores,indicadorestodo)
    
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAt]
    #indicadores<-indicadores[indicadores$Diatipo==input$TIPODIAt]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesest]
    indicadores<-indicadores[indicadores$Mes==input$Mesest]
    
    
    if(input$HAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="HAB"]
      indicadores<-indicadores[indicadores$Diatipo=="HAB"]
    }
    
    if(input$SAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="SAB"]
      indicadores<-indicadores[indicadores$Diatipo=="SAB"]
      
    }
    
    
    if(input$FES){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="FES"]
      indicadores<-indicadores[indicadores$Diatipo=="FES"]
      
    }
    
    
    BCPCKMaño<-data.frame(t(tapply(as.numeric(indicadores$BYNCPC),indicadores$Año,sum)))
    BYNMaño<-data.frame(t(tapply(as.numeric(indicadores$BNM),indicadores$Año,sum)))
    GITKMaño<-data.frame(t(tapply(as.numeric(indicadores$GIT),indicadores$Año,sum)))
    ETMKMaño<-data.frame(t(tapply(as.numeric(indicadores$ETM),indicadores$Año,sum)))
    
    
    
    salidas_todas_dia12<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año")],length))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    Kilometroaño<-data.table(data.frame(t(tapply(as.numeric(indicadores$TOTAL),indicadores$Año,sum))))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    
    k1 <-data.table( X2023= 0,X2024=0,X2025=0,X2026=0 )
    
    salidas_todas_diatotales<-rbind(k1,salidas_todas_diatotales,fill = TRUE)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[-1,c(5,1:4)]
    salidas_todas_diatotales<-replace(salidas_todas_diatotales,is.na(salidas_todas_diatotales),0)
    
    
    salidas_todas_diatotales[,kilometros23:=Kilometroaño$X2023]
    salidas_todas_diatotales[,kilometros24:=Kilometroaño$X2024]
    salidas_todas_diatotales[,kilometros25:=Kilometroaño$X2025]
    salidas_todas_diatotales[,kilometros26:=Kilometroaño$X2026]
    
    salidas_todas_diatotales[,"salidas/mill_23":=round((X2023/kilometros23)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_24":=round((X2024/kilometros24)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_25":=round((X2025/kilometros25)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_26":=round((X2026/kilometros26)*1000000,0)]
    
    salidas_todas_diatotales[,COT:="SITM-MIO"]
    
    salidas_todas_diatotales<- salidas_todas_diatotales[order(salidas_todas_diatotales$`salidas/mill_25`,decreasing = T), ]
    names(salidas_todas_diatotales)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    #####################
    
    salidas_todas_dia13<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Codificacion Concesionario")],length))
    salidas_todas_dia13<-as.data.table(cbind(row.names(salidas_todas_dia13),salidas_todas_dia13))
    
    k1 <-data.table( "X2023.BCPC"=0, "X2024.BCPC"=0,"X2025.BCPC"=0,"X2026.BCPC"=0, "X2023.BYN"=0,  "X2024.BYN"=0 ,"X2025.BYN"=0 ,"X2026.BYN"=0 , "X2023.ETM"=0,  "X2024.ETM"=0,"X2025.ETM"=0,"X2026.ETM"=0,  "X2023.GIT"=0,  "X2024.GIT"=0, "X2025.GIT"=0,"X2026.GIT"=0 )
    
    salidas_todas_dia13<-rbind(k1,salidas_todas_dia13,fill = TRUE)
    
    salidas_todas_dia13<-salidas_todas_dia13[-1,c(17,1:16)]
    salidas_todas_dia13<-replace(salidas_todas_dia13,is.na(salidas_todas_dia13),0)
    
    
    GIT<-as.data.table(salidas_todas_dia13[,c(1,14:17)])
    GIT[,kilometros23:=GITKMaño$X2023]
    GIT[,kilometros24:=GITKMaño$X2024]
    GIT[,kilometros25:=GITKMaño$X2025]
    GIT[,kilometros26:=GITKMaño$X2026]
    GIT[,"salidas/mill_23":=round((X2023.GIT/kilometros23)*1000000,0)]
    GIT[,"salidas/mill_24":=round((X2024.GIT/kilometros24)*1000000,0)]
    GIT[,"salidas/mill_25":=round((X2025.GIT/kilometros25)*1000000,0)]
    GIT[,"salidas/mill_26":=round((X2026.GIT/kilometros26)*1000000,0)]
    GIT[,COT:="GIT"]
    
    GIT<- GIT[order(GIT$`salidas/mill_25`,decreasing = T), ]
    names(GIT)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    
    
    BYN<-as.data.table(salidas_todas_dia13[,c(1,6:9)])
    BYN[,kilometros23:=BYNMaño$X2023]
    BYN[,kilometros24:=BYNMaño$X2024]
    BYN[,kilometros25:=BYNMaño$X2025]
    BYN[,kilometros26:=BYNMaño$X2026]
    
    BYN[,"salidas/mill_23":=round((X2023.BYN/kilometros23)*1000000,0)]
    BYN[,"salidas/mill_24":=round((X2024.BYN/kilometros24)*1000000,0)]
    BYN[,"salidas/mill_25":=round((X2025.BYN/kilometros25)*1000000,0)]
    BYN[,"salidas/mill_26":=round((X2026.BYN/kilometros26)*1000000,0)]
    BYN[,COT:="BYN"]
    
    BYN<- BYN[order(BYN$`salidas/mill_24`,decreasing = T), ]
    names(BYN)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    ETM<-as.data.table(salidas_todas_dia13[,c(1,10:13)])
    ETM[,kilometros23:=ETMKMaño$X2023]
    ETM[,kilometros24:=ETMKMaño$X2024]
    ETM[,kilometros25:=ETMKMaño$X2025]
    ETM[,kilometros26:=ETMKMaño$X2026]
    
    ETM[,"salidas/mill_23":=round((X2023.ETM/kilometros23)*1000000,0)]
    ETM[,"salidas/mill_24":=round((X2024.ETM/kilometros24)*1000000,0)]
    ETM[,"salidas/mill_25":=round((X2025.ETM/kilometros25)*1000000,0)]
    ETM[,"salidas/mill_26":=round((X2026.ETM/kilometros26)*1000000,0)]
    
    ETM[,COT:="ETM"]
    
    
    ETM<- ETM[order(ETM$`salidas/mill_24`,decreasing = T), ]
    names(ETM)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    BCPC<-as.data.table(salidas_todas_dia13[,c(1:5)])
    BCPC[,kilometros23:=BCPCKMaño$X2023]
    BCPC[,kilometros24:=BCPCKMaño$X2024]
    BCPC[,kilometros25:=BCPCKMaño$X2025]
    BCPC[,kilometros26:=BCPCKMaño$X2026]
    
    BCPC[,"salidas/mill_23":=round((X2023.BCPC/kilometros23)*1000000,0)]
    BCPC[,"salidas/mill_24":=round((X2024.BCPC/kilometros24)*1000000,0)]
    BCPC[,"salidas/mill_25":=round((X2025.BCPC/kilometros25)*1000000,0)]
    BCPC[,"salidas/mill_26":=round((X2026.BCPC/kilometros26)*1000000,0)]
    
    BCPC[,COT:="BCPC"]
    BCPC<- BCPC[order(BCPC$`salidas/mill_24`,decreasing = T), ]
    
    names(BCPC)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    salidas_todas_diatotales<-rbind(salidas_todas_diatotales,GIT,ETM,BYN,BCPC)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[salidas_todas_diatotales$COT==input$COT]
    ############################  
    
    mtc<-salidas_todas_diatotales[,c(1,2,3,4,5)]
    mtc<-data.frame(mtc)
    #mtc<-data.frame(colnames(t(mtc)),mtc)
    names(mtc)=c("Tipo","2023","2024","2025","2026")
    mtc2<-mtc
    mtc1<-data.frame(t(mtc[,-1]))
    mtc<-mtc[,-1]
    mtc <- mtc[,c(input$año_num_input,input$año_num_input1)]
    mtctitulo<-salidas_todas_diatotales[1,14]
    
    
    
    saltoda<-barplot(t(mtc[,c(1,2)]), main = paste( "Total Salidas",mtctitulo,input$Mesest, sep = " "), ylab = "Total",  names.arg = mtc2$Tipo ,cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("Gray", "lightblue"),beside = TRUE,ylim =c(0,(max(mtc[,1]+2000))))
    #text(saltoda, mtc[,1] +1000 ,labels = mtc[,1])
    text(saltoda, (t(mtc[,c(1,2)]))+100 ,labels = t(mtc[,c(1,2)]))
    legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend = c(input$año_num_input,input$año_num_input1), fill = c("Gray","lightblue"),cex = 1.2)
    #legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste( mtc2[,1],mtc[,2], sep = " ") ,cex = 0.9,xpd = TRUE,col = "blue")
    
    #legend(x = "topright",bty = "n",horiz = F,inset = c(0.1,-0.01), legend = paste(mtcpor$Tipo,mtcpor$"2023"), fill = ,cex = 1.1)
    #legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.3), legend = c(paste( "kM",kilo23, sep = "-"),paste( "kM",kilo24, sep = "-")) , fill = c("Gray","lightblue"),cex = 1.2)
    
    dev.off()
  }) 
  
  
  output$distPlot <- renderPlot({
    
    Maximafehc<-salidas_todas_dia1[,6]
    Maximafehc<-max(as.Date(Maximafehc$Fecha,origin = "1899-12-30"))
    Maximafehc1 <- data.table("SALIDAS")
    Maximafehc1 <- cbind(Maximafehc1,Maximafehc)
    Maximafehc1$Maximafehc<-as.character(Maximafehc1$Maximafehc)
    
    indicadores$Dia<-as.numeric(indicadores$Dia)
    #indicadores<-indicadores[indicadores$TOTAL>0 ]
    Maximafehc<-indicadores[,3]
    Maximafehc<-max(as.Date(Maximafehc$Dia,origin = "1899-12-30"))
    Maximafehc2 <- data.table("KILOMETROS")
    Maximafehc2 <- cbind(Maximafehc2,Maximafehc)
    Maximafehc2$Maximafehc<-as.character(Maximafehc2$Maximafehc)
    
    
    
    Maximafehc<-as.data.frame(rbind(Maximafehc1,Maximafehc2))
    
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    indicadores<-rbind(indicadores,indicadorestodo)
    
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAt]
    #indicadores<-indicadores[indicadores$Diatipo==input$TIPODIAt]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesest]
    indicadores<-indicadores[indicadores$Mes==input$Mesest]
    
    
    if(input$HAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="HAB"]
      indicadores<-indicadores[indicadores$Diatipo=="HAB"]
    }
    
    if(input$SAB){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="SAB"]
      indicadores<-indicadores[indicadores$Diatipo=="SAB"]
      
    }
    
    
    if(input$FES){  
      
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="FES"]
      indicadores<-indicadores[indicadores$Diatipo=="FES"]
      
    }
    
    
    BCPCKMaño<-data.frame(t(tapply(as.numeric(indicadores$BYNCPC),indicadores$Año,sum)))
    BYNMaño<-data.frame(t(tapply(as.numeric(indicadores$BNM),indicadores$Año,sum)))
    GITKMaño<-data.frame(t(tapply(as.numeric(indicadores$GIT),indicadores$Año,sum)))
    ETMKMaño<-data.frame(t(tapply(as.numeric(indicadores$ETM),indicadores$Año,sum)))
    
    
    
    salidas_todas_dia12<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año")],length))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    Kilometroaño<-data.table(data.frame(t(tapply(as.numeric(indicadores$TOTAL),indicadores$Año,sum))))
    salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
    
    k1 <-data.table( X2023= 0,X2024=0,X2025=0,X2026=0 )
    
    salidas_todas_diatotales<-rbind(k1,salidas_todas_diatotales,fill = TRUE)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[-1,c(5,1:4)]
    salidas_todas_diatotales<-replace(salidas_todas_diatotales,is.na(salidas_todas_diatotales),0)
    
    
    salidas_todas_diatotales[,kilometros23:=Kilometroaño$X2023]
    salidas_todas_diatotales[,kilometros24:=Kilometroaño$X2024]
    salidas_todas_diatotales[,kilometros25:=Kilometroaño$X2025]
    salidas_todas_diatotales[,kilometros26:=Kilometroaño$X2026]
    
    salidas_todas_diatotales[,"salidas/mill_23":=round((X2023/kilometros23)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_24":=round((X2024/kilometros24)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_25":=round((X2025/kilometros25)*1000000,0)]
    salidas_todas_diatotales[,"salidas/mill_26":=round((X2026/kilometros26)*1000000,0)]
    
    salidas_todas_diatotales[,COT:="SITM-MIO"]
    
    salidas_todas_diatotales<- salidas_todas_diatotales[order(salidas_todas_diatotales$`salidas/mill_25`,decreasing = T), ]
    names(salidas_todas_diatotales)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    #####################
    
    salidas_todas_dia13<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Codificacion Concesionario")],length))
    salidas_todas_dia13<-as.data.table(cbind(row.names(salidas_todas_dia13),salidas_todas_dia13))
    
    k1 <-data.table( "X2023.BCPC"=0, "X2024.BCPC"=0,"X2025.BCPC"=0,"X2026.BCPC"=0, "X2023.BYN"=0,  "X2024.BYN"=0 ,"X2025.BYN"=0 ,"X2026.BYN"=0 , "X2023.ETM"=0,  "X2024.ETM"=0,"X2025.ETM"=0,"X2026.ETM"=0,  "X2023.GIT"=0,  "X2024.GIT"=0, "X2025.GIT"=0,"X2026.GIT"=0 )
    
    salidas_todas_dia13<-rbind(k1,salidas_todas_dia13,fill = TRUE)
    
    salidas_todas_dia13<-salidas_todas_dia13[-1,c(17,1:16)]
    salidas_todas_dia13<-replace(salidas_todas_dia13,is.na(salidas_todas_dia13),0)
    
    
    GIT<-as.data.table(salidas_todas_dia13[,c(1,14:17)])
    GIT[,kilometros23:=GITKMaño$X2023]
    GIT[,kilometros24:=GITKMaño$X2024]
    GIT[,kilometros25:=GITKMaño$X2025]
    GIT[,kilometros26:=GITKMaño$X2026]
    GIT[,"salidas/mill_23":=round((X2023.GIT/kilometros23)*1000000,0)]
    GIT[,"salidas/mill_24":=round((X2024.GIT/kilometros24)*1000000,0)]
    GIT[,"salidas/mill_25":=round((X2025.GIT/kilometros25)*1000000,0)]
    GIT[,"salidas/mill_26":=round((X2026.GIT/kilometros26)*1000000,0)]
    GIT[,COT:="GIT"]
    
    GIT<- GIT[order(GIT$`salidas/mill_25`,decreasing = T), ]
    names(GIT)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    
    
    BYN<-as.data.table(salidas_todas_dia13[,c(1,6:9)])
    BYN[,kilometros23:=BYNMaño$X2023]
    BYN[,kilometros24:=BYNMaño$X2024]
    BYN[,kilometros25:=BYNMaño$X2025]
    BYN[,kilometros26:=BYNMaño$X2026]
    
    BYN[,"salidas/mill_23":=round((X2023.BYN/kilometros23)*1000000,0)]
    BYN[,"salidas/mill_24":=round((X2024.BYN/kilometros24)*1000000,0)]
    BYN[,"salidas/mill_25":=round((X2025.BYN/kilometros25)*1000000,0)]
    BYN[,"salidas/mill_26":=round((X2026.BYN/kilometros26)*1000000,0)]
    BYN[,COT:="BYN"]
    
    BYN<- BYN[order(BYN$`salidas/mill_24`,decreasing = T), ]
    names(BYN)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    ETM<-as.data.table(salidas_todas_dia13[,c(1,10:13)])
    ETM[,kilometros23:=ETMKMaño$X2023]
    ETM[,kilometros24:=ETMKMaño$X2024]
    ETM[,kilometros25:=ETMKMaño$X2025]
    ETM[,kilometros26:=ETMKMaño$X2026]
    
    ETM[,"salidas/mill_23":=round((X2023.ETM/kilometros23)*1000000,0)]
    ETM[,"salidas/mill_24":=round((X2024.ETM/kilometros24)*1000000,0)]
    ETM[,"salidas/mill_25":=round((X2025.ETM/kilometros25)*1000000,0)]
    ETM[,"salidas/mill_26":=round((X2026.ETM/kilometros26)*1000000,0)]
    
    ETM[,COT:="ETM"]
    
    
    ETM<- ETM[order(ETM$`salidas/mill_24`,decreasing = T), ]
    names(ETM)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    
    BCPC<-as.data.table(salidas_todas_dia13[,c(1:5)])
    BCPC[,kilometros23:=BCPCKMaño$X2023]
    BCPC[,kilometros24:=BCPCKMaño$X2024]
    BCPC[,kilometros25:=BCPCKMaño$X2025]
    BCPC[,kilometros26:=BCPCKMaño$X2026]
    
    BCPC[,"salidas/mill_23":=round((X2023.BCPC/kilometros23)*1000000,0)]
    BCPC[,"salidas/mill_24":=round((X2024.BCPC/kilometros24)*1000000,0)]
    BCPC[,"salidas/mill_25":=round((X2025.BCPC/kilometros25)*1000000,0)]
    BCPC[,"salidas/mill_26":=round((X2026.BCPC/kilometros26)*1000000,0)]
    
    BCPC[,COT:="BCPC"]
    BCPC<- BCPC[order(BCPC$`salidas/mill_24`,decreasing = T), ]
    
    names(BCPC)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
    salidas_todas_diatotales<-rbind(salidas_todas_diatotales,GIT,ETM,BYN,BCPC)
    
    salidas_todas_diatotales<-replace(salidas_todas_diatotales,salidas_todas_diatotales=="Inf",0)
    
    salidas_todas_diatotales<-salidas_todas_diatotales[salidas_todas_diatotales$COT==input$COT]
    ############################  
    
    mtc<-salidas_todas_diatotales[,c(1,10:13)]
    mtc<-data.frame(mtc)
    #mtc<-data.frame(colnames(t(mtc)),mtc)
    names(mtc)=c("Tipo","2023","2024","2025","2026")
    mtc2<-mtc
    mtc1<-data.frame(t(mtc[,-1]))
    mtc<-mtc[,-1]
    mtc <- mtc[,c(input$año_num_input,input$año_num_input1)]
    mtctitulo<-salidas_todas_diatotales[1,14]
    
    
    # saltoda<-barplot(t(mtc[,c(1,2)]), main = paste( "Total Salidas",mtctitulo,input$Mesest, sep = " "), ylab = "Total",  names.arg = mtc2$Tipo ,cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("Gray", "lightblue"),beside = TRUE,ylim =c(0,(max(mtc[,1]+2000))))
    # text(saltoda, mtc[,1] +1000 ,labels = mtc[,1])
    #text(saltoda, (t(mtc[,c(1,2)]))+100 ,labels = t(mtc[,c(1,2)]))
    #legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend = c(input$año_num_input,input$año_num_input1), fill = c("Gray","lightblue"),cex = 1.2)
    #legend(x = "topright",bty = "n",horiz = F,inset = c(0.1,-0.01), legend = paste(mtcpor$Tipo,mtcpor$"2023"), fill = ,cex = 1.1)
    #legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.3), legend = c(paste( "kM",kilo23, sep = "-"),paste( "kM",kilo24, sep = "-")) , fill = c("Gray","lightblue"),cex = 1.2)
    
    Corte1<-salidas_todas_dia1[salidas_todas_dia1$Año==input$año_num_input1]
    Corte2<-salidas_todas_dia1[salidas_todas_dia1$Año==input$año_num_input]
    Corte2<-max(Corte2$Fecha)
    Corte1<-max(Corte1$Fecha)
    
    
    saltodamill<-barplot(t(mtc[,c(1,2)]), main =paste( "Tasa de Salidas",mtctitulo,input$Mesest, sep = " ") ,col.main = "blue", ylab = "total/millon de kilometros",  names.arg = mtc2$Tipo ,cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("black", "blue"),beside = TRUE,ylim =c(0,(max(mtc[,1]+1500))))
    #text(saltoda, mtc[,1] +1000 ,labels = mtc[,1])
    text(saltodamill, (t(mtc[,c(1,2)]))+100 ,labels = t(mtc[,c(1,2)]))
    legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.1), legend = c(input$año_num_input,input$año_num_input1), fill = c("black", "blue"),cex = 1.2)
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = "(Salidas/Kilometros)*millon", col = "lightblue",cex = 0.9)
    legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste( Maximafehc[,1],Maximafehc[,2], sep = " corte al ") ,cex = 0.9,xpd = TRUE,col = "blue")
    
  })
  
  
  
  
  
  
  output$descarga2<- downloadHandler(
    
    filename =  "Asignenombre.xlsx",
    content =  function(file){
    
      Maximafehc<-salidas_todas_dia1[,6]
      Maximafehc<-max(as.Date(Maximafehc$Fecha,origin = "1899-12-30"))
      Maximafehc1 <- data.table("SALIDAS")
      Maximafehc1 <- cbind(Maximafehc1,Maximafehc)
      Maximafehc1$Maximafehc<-as.character(Maximafehc1$Maximafehc)
      
      indicadores$Dia<-as.numeric(indicadores$Dia)
      indicadores<-indicadores[indicadores$TOTAL>0 ]
      Maximafehc<-indicadores[,3]
      Maximafehc<-max(as.Date(Maximafehc$Dia,origin = "1899-12-30"))
      Maximafehc2 <- data.table("KILOMETROS")
      Maximafehc2 <- cbind(Maximafehc2,Maximafehc)
      Maximafehc2$Maximafehc<-as.character(Maximafehc2$Maximafehc)
      
      
      
      Maximafehc<-as.data.frame(rbind(Maximafehc1,Maximafehc2))
      
      
      
      salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
      indicadores<-rbind(indicadores,indicadorestodo)
      
      #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAt]
      #indicadores<-indicadores[indicadores$Diatipo==input$TIPODIAt]
      salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesest]
      indicadores<-indicadores[indicadores$Mes==input$Mesest]
      
      
      if(input$HAB){  
        
        salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="HAB"]
        indicadores<-indicadores[indicadores$Diatipo=="HAB"]
      }
      
      if(input$SAB){  
        
        salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="SAB"]
        indicadores<-indicadores[indicadores$Diatipo=="SAB"]
        
      }
      
      
      if(input$FES){  
        
        salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo=="FES"]
        indicadores<-indicadores[indicadores$Diatipo=="FES"]
        
      }
      
      
      BCPCKMaño<-data.frame(t(tapply(as.numeric(indicadores$BYNCPC),indicadores$Año,sum)))
      BYNMaño<-data.frame(t(tapply(as.numeric(indicadores$BNM),indicadores$Año,sum)))
      GITKMaño<-data.frame(t(tapply(as.numeric(indicadores$GIT),indicadores$Año,sum)))
      ETMKMaño<-data.frame(t(tapply(as.numeric(indicadores$ETM),indicadores$Año,sum)))
      
      
      
      salidas_todas_dia12<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año")],length))
      salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
      Kilometroaño<-data.table(data.frame(t(tapply(as.numeric(indicadores$TOTAL),indicadores$Año,sum))))
      salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
      
      k1 <-data.table( X2023= 0,X2024=0,X2025=0,X2026=0 )
      
      salidas_todas_diatotales<-rbind(k1,salidas_todas_diatotales,fill = TRUE)
      
      salidas_todas_diatotales<-salidas_todas_diatotales[-1,c(5,1:4)]
      salidas_todas_diatotales<-replace(salidas_todas_diatotales,is.na(salidas_todas_diatotales),0)
      
      
      salidas_todas_diatotales[,kilometros23:=Kilometroaño$X2023]
      salidas_todas_diatotales[,kilometros24:=Kilometroaño$X2024]
      salidas_todas_diatotales[,kilometros25:=Kilometroaño$X2025]
      salidas_todas_diatotales[,kilometros26:=Kilometroaño$X2026]
      
      salidas_todas_diatotales[,"salidas/mill_23":=round((X2023/kilometros23)*1000000,0)]
      salidas_todas_diatotales[,"salidas/mill_24":=round((X2024/kilometros24)*1000000,0)]
      salidas_todas_diatotales[,"salidas/mill_25":=round((X2025/kilometros25)*1000000,0)]
      salidas_todas_diatotales[,"salidas/mill_26":=round((X2026/kilometros26)*1000000,0)]
      
      salidas_todas_diatotales[,COT:="SITM-MIO"]
      
      salidas_todas_diatotales<- salidas_todas_diatotales[order(salidas_todas_diatotales$`salidas/mill_25`,decreasing = T), ]
      names(salidas_todas_diatotales)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
      
      #####################
      
      salidas_todas_dia13<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Codificacion Concesionario")],length))
      salidas_todas_dia13<-as.data.table(cbind(row.names(salidas_todas_dia13),salidas_todas_dia13))
      
      k1 <-data.table( "X2023.BCPC"=0, "X2024.BCPC"=0,"X2025.BCPC"=0,"X2026.BCPC"=0, "X2023.BYN"=0,  "X2024.BYN"=0 ,"X2025.BYN"=0 ,"X2026.BYN"=0 , "X2023.ETM"=0,  "X2024.ETM"=0,"X2025.ETM"=0,"X2026.ETM"=0,  "X2023.GIT"=0,  "X2024.GIT"=0, "X2025.GIT"=0,"X2026.GIT"=0 )
      
      salidas_todas_dia13<-rbind(k1,salidas_todas_dia13,fill = TRUE)
      
      salidas_todas_dia13<-salidas_todas_dia13[-1,c(17,1:16)]
      salidas_todas_dia13<-replace(salidas_todas_dia13,is.na(salidas_todas_dia13),0)
      
      
      GIT<-as.data.table(salidas_todas_dia13[,c(1,14:17)])
      GIT[,kilometros23:=GITKMaño$X2023]
      GIT[,kilometros24:=GITKMaño$X2024]
      GIT[,kilometros25:=GITKMaño$X2025]
      GIT[,kilometros26:=GITKMaño$X2026]
      GIT[,"salidas/mill_23":=round((X2023.GIT/kilometros23)*1000000,0)]
      GIT[,"salidas/mill_24":=round((X2024.GIT/kilometros24)*1000000,0)]
      GIT[,"salidas/mill_25":=round((X2025.GIT/kilometros25)*1000000,0)]
      GIT[,"salidas/mill_26":=round((X2026.GIT/kilometros26)*1000000,0)]
      GIT[,COT:="GIT"]
      
      GIT<- GIT[order(GIT$`salidas/mill_25`,decreasing = T), ]
      names(GIT)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
      
      
      
      BYN<-as.data.table(salidas_todas_dia13[,c(1,6:9)])
      BYN[,kilometros23:=BYNMaño$X2023]
      BYN[,kilometros24:=BYNMaño$X2024]
      BYN[,kilometros25:=BYNMaño$X2025]
      BYN[,kilometros26:=BYNMaño$X2026]
      
      BYN[,"salidas/mill_23":=round((X2023.BYN/kilometros23)*1000000,0)]
      BYN[,"salidas/mill_24":=round((X2024.BYN/kilometros24)*1000000,0)]
      BYN[,"salidas/mill_25":=round((X2025.BYN/kilometros25)*1000000,0)]
      BYN[,"salidas/mill_26":=round((X2026.BYN/kilometros26)*1000000,0)]
      BYN[,COT:="BYN"]
      
      BYN<- BYN[order(BYN$`salidas/mill_24`,decreasing = T), ]
      names(BYN)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
      
      ETM<-as.data.table(salidas_todas_dia13[,c(1,10:13)])
      ETM[,kilometros23:=ETMKMaño$X2023]
      ETM[,kilometros24:=ETMKMaño$X2024]
      ETM[,kilometros25:=ETMKMaño$X2025]
      ETM[,kilometros26:=ETMKMaño$X2026]
      
      ETM[,"salidas/mill_23":=round((X2023.ETM/kilometros23)*1000000,0)]
      ETM[,"salidas/mill_24":=round((X2024.ETM/kilometros24)*1000000,0)]
      ETM[,"salidas/mill_25":=round((X2025.ETM/kilometros25)*1000000,0)]
      ETM[,"salidas/mill_26":=round((X2026.ETM/kilometros26)*1000000,0)]
      
      ETM[,COT:="ETM"]
      
      
      ETM<- ETM[order(ETM$`salidas/mill_24`,decreasing = T), ]
      names(ETM)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
      
      BCPC<-as.data.table(salidas_todas_dia13[,c(1:5)])
      BCPC[,kilometros23:=BCPCKMaño$X2023]
      BCPC[,kilometros24:=BCPCKMaño$X2024]
      BCPC[,kilometros25:=BCPCKMaño$X2025]
      BCPC[,kilometros26:=BCPCKMaño$X2026]
      
      BCPC[,"salidas/mill_23":=round((X2023.BCPC/kilometros23)*1000000,0)]
      BCPC[,"salidas/mill_24":=round((X2024.BCPC/kilometros24)*1000000,0)]
      BCPC[,"salidas/mill_25":=round((X2025.BCPC/kilometros25)*1000000,0)]
      BCPC[,"salidas/mill_26":=round((X2026.BCPC/kilometros26)*1000000,0)]
      
      BCPC[,COT:="BCPC"]
      BCPC<- BCPC[order(BCPC$`salidas/mill_24`,decreasing = T), ]
      
      names(BCPC)<-c("Salidas","2023","2024","2025","2026","kilometros23","kilometros24","kilometros25","kilometros26","salidas/mill_23","salidas/mill_24" ,"salidas/mill_25","salidas/mill_26","COT")
      salidas_todas_diatotales<-rbind(salidas_todas_diatotales,GIT,ETM,BYN,BCPC)
      
      salidas_todas_diatotales<-salidas_todas_diatotales[salidas_todas_diatotales$COT==input$COT]
      ############################  
      
      mtc<-salidas_todas_diatotales[,c(1,2,3,4,5)]
      mtc<-data.frame(mtc)
      #mtc<-data.frame(colnames(t(mtc)),mtc)
      names(mtc)=c("Tipo","2023","2024","2025","2026")
      mtc2<-mtc
      mtc1<-data.frame(t(mtc[,-1]))
      mtc<-mtc[,-1]
      mtc <- mtc[,c(input$año_num_input,input$año_num_input1)]
      mtctitulo<-salidas_todas_diatotales[1,14]
      mtcfinal<-cbind(mtc2[,1],mtc)
    
    write.xlsx(mtcfinal, file)
  })
  
  output$distPlot4 <- renderPlot({
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAS]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTS]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIA]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Meses]
    
    
    
    ###########################
    
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Meses]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAS]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIA]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTS]
    
    vehiculodia$Largo<-replace(vehiculodia$Largo,is.na(vehiculodia$Largo),0)
    
    
    Kilometroaño<-data.frame(t(tapply(vehiculodia$Largo,vehiculodia$Año,sum)))
 
    k1 <-data.table( X2023= 0,X2024=0,X2025=0 )
    
    Kilometroaño<-rbind(k1,Kilometroaño,fill = TRUE)
    
    Kilometroaño<-Kilometroaño[-1,]
    Kilometroaño<-replace(Kilometroaño,is.na(Kilometroaño),0)
    
    
    
    UTRYT<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasUTRYT"]
    FLOTA<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasflota"]
    OPERADOR<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasOpe."]
    VANDA<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="vandalismos"]
    ACCI<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="Accidentes"]
    salidasUTRYT2<-data.frame(tapply(UTRYT$sal_veh,UTRYT[,c("X5","Año")],length))
    salidasUTRYT2<-data.table(colnames(t(salidasUTRYT2)),salidasUTRYT2)
    salidasUTRYT2[,tipo:="UTRYT"]
    salidasflota2<-data.frame(tapply(FLOTA$sal_veh,FLOTA[,c("X4","Año")],length))
    salidasflota2<-data.table(colnames(t(salidasflota2)),salidasflota2)
    salidasflota2[,tipo:="FLOTA"]
    salidasOpe2<-data.frame(tapply(OPERADOR$sal_veh,OPERADOR[,c("X4","Año")],length))
    salidasOpe2<-data.table(colnames(t(salidasOpe2)),salidasOpe2)
    salidasOpe2[,tipo:="OPERADOR"]
    vandalismos2<-data.frame(tapply(VANDA$sal_veh,VANDA[,c("X4","Año")],length))
    vandalismos2<-data.table(colnames(t(vandalismos2)),vandalismos2)
    vandalismos2[,tipo:="VANDALISMO"]
    Accidentes2<-data.frame(tapply(ACCI$sal_veh,ACCI[,c("X4","Año")],length))
    Accidentes2<-data.table(colnames(t(Accidentes2)),Accidentes2)
    Accidentes2[,tipo:="ACCIDENTES"]
    todos<-rbind(Accidentes2,vandalismos2,salidasflota2,salidasUTRYT2,salidasOpe2)
    todos<-replace(todos,is.na(todos),0)
    
    
    todos$V1<-gsub("CON FALLA DE ","",todos$V1)
    todos$V1<-gsub("INSTALACIONES ","",todos$V1)
    todos$V1<-gsub("IVU BOX::","",todos$V1)
    todos$V1<-gsub("CON PROBLEMAS DE ","",todos$V1)
    todos$V1<-gsub("CON FALLA ","",todos$V1)
    todos$V1<-gsub("CON ","",todos$V1)
    todos$V1<-gsub("TRANSITAR ","",todos$V1)
    todos$V1<-gsub("CAMBIO DE VEHICULO PARA ATENCION DE ","",todos$V1)
    todos$V1<-gsub("VEHICULO ","",todos$V1)
    todos$V1<-gsub("CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE","",todos$V1)
    todos$V1<-gsub("CON FALLA DE SISTEMA DE AIRE ","",todos$V1)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0, "tipo"=0 )
    
    todos<-rbind(k1,todos,fill = TRUE)
    
    todos<-todos[-1,]
    todos<-replace(todos,is.na(todos),0)
    
    todos<-todos[todos$tipo==input$tiposalida]
    
    
    todos<-todos[todos$X2024>=quantile(todos$X2024,probs = 0.50)]
    todos<- todos[order(todos$X2024,decreasing = T), ]
    todos2<-todos
    todos2[,kilo2023:=(Kilometroaño[1,1])]
    todos2[,kilo2024:=(Kilometroaño[1,2])]
    todos2[,kilo2025:=(Kilometroaño[1,3])]
    todos2[,tasa23:=round(((X2023/kilo2023)*1000000),0)]
    todos2[,tasa24:=round(((X2024/kilo2024)*1000000),0)]
    todos2[,tasa25:=round(((X2025/kilo2025)*1000000),0)]
    todos2<- todos2[order(todos2$X2024,decreasing = T), ]
    todos2<-data.frame(todos2)
    
    #todos<-todos[c(1:5),]
    todos<-data.frame(todos)
    
    #mtc<-data.frame(colnames(t(mtc)),mtc)
    
    
    
    if(input$TASA){
      
      
      #todos<- todos[order(todos$X2024,decreasing = T), ]
      
      
      mtctodos<-todos2[,c(1,9:11)]
      #mtctodos<- mtctodos[order(mtctodos$X2024,decreasing = T), ]
      
      names(mtctodos)=c("Tipo","2023","2024","2025")
      
      mtc2todos<-mtctodos
      mtc1todos<-data.frame(t(mtctodos[,-1]))
      mtctodos<-mtc2todos[,-1]
      mtctodos <- mtctodos[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo<-todos2[1,4]
      mtctitulo1<-"(Salidas/Kilometros)*millon"
      titulo1<-"Tasa"
      
    }
    
    if(input$Total){
      
      #todos<- todos[order(todos$X2024,decreasing = T), ]
      mtctodos<-todos[,-5]
      #mtctodos<- mtctodos[order(mtctodos$X2024,decreasing = T), ]
      
      names(mtctodos)=c("Tipo","2023","2024","2025")
      
      
      mtc2todos<-mtctodos
      mtc1todos<-data.frame(t(mtctodos[,-1]))
      mtctodos<-mtc2todos[,-1]
      mtctodos <- mtctodos[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo<-todos[1,4]
      titulo1<-"Total"
      mtctitulo1<-""
    }
    
    #par(mfrow=c(2,1))
    
    saltodatodo<-barplot(t(mtctodos[,c(1,2)]) ,main=paste(titulo1,"Salidas por",input$tiposalida,input$TIPODIA,input$COTS,input$Meses,">Q.50",sep = " ") ,ylab = "cantidad", names.arg = mtc2todos$Tipo, cex.names=0.7,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("Gray","lightblue"),beside = TRUE,ylim =c(0,(max(mtctodos[,1]+100))))
    text(saltodatodo, (t(mtctodos[,c(1,2)]))+10 ,labels = t(mtctodos[,c(1,2)]))
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.1), legend = c(input$año_num_input2,input$año_num_input3), fill = c("Gray", "lightblue"),cex = 1.2)
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulo1, col = "lightblue",cex = 0.9)
    
    
  })
  
  
  
  output$distPlot11 <- renderPlot({
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    names(FLOTA_Combustible)=c("NUMERO_VEHICULO","Combustible")
    FLOTA_Combustible$NUMERO_VEHICULO<-as.character(FLOTA_Combustible$NUMERO_VEHICULO)
    FLOTA_Combustible<-as.data.table(FLOTA_Combustible)
    
    
    setkey(salidas_todas_dia1,NUMERO_VEHICULO)
    setkey(FLOTA_Combustible,NUMERO_VEHICULO)
    
    salidas_todas_dia1<- FLOTA_Combustible[salidas_todas_dia1,all=T]
    
    salidas_todas_dia1$Combustible<-replace(salidas_todas_dia1$Combustible,is.na(salidas_todas_dia1$Combustible),"ACPM")
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Meses]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAS]
    
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Combustible==input$COMBUSTIBLE]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIA]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTS]
    
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "vandalismos","VANDALISMO")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasflota","FLOTA")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasUTRYT","UTRYT")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasOpe.","OPERADOR")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "Accidentes","ACCIDENTES")
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$salidastipo==input$tiposalida]
    
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Meses]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAS]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIA]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTS]
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("NUMERO_VEHICULO","Año")],length))
    vehic<-data.table(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0)
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,]
    
    vehic<-replace(vehic,is.na(vehic),0)
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0)
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    
    vehickm<-data.table(vehickm)
    
    setkey(vehickm,V1)
    setkey(vehic,V1)
    
    vehic<- vehickm[vehic,all=T]
    
    
    
    vehic[,Tasa23:=(X2023/k2023)*4800]
    vehic[,Tasa24:=(X2024/k2024)*4800]
    vehic[,Tasa25:=(X2025/k2025)*4800]
    vehic$Tasa23<-round((vehic$Tasa23),0)
    vehic$Tasa24<-round((vehic$Tasa24),0)
    vehic$Tasa25<-round((vehic$Tasa25),0)
    
    vehic<-replace(vehic,vehic== "Inf",0)
    vehic<-replace(vehic,vehic== "NaN",0)
    vehic<-replace(vehic,vehic== "NA",0)
    
    vehic<-vehic[vehic$Tasa24>0]
    
    
    
    vehic<- vehic[order(vehic$Tasa24,decreasing = T), ]
    vehic<-vehic[vehic$Tasa24>=quantile(vehic$Tasa24,probs = as.numeric(0.75))]
    
    
    vehictodo<-vehic
    
    if(input$TASA){
      
      
      vehic<-data.frame(vehic[,c(1,8:10)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo1<-"(Salidas/Kilometros)*cuatromil ochocientos"
      titulo1<-"Tasa"
    }
    
    if(input$Total){
      
      vehic<-data.frame(vehic[,c(1,5:7)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_input2,input$año_num_input3)]
      titulo1<-"Total"
      mtctitulo1<-""
    }
    
    
    salidavehiclo<-barplot(t(vehic2[,c(1,2)]),main=paste( titulo1,"Salidas por",input$tiposalida,input$COTS,input$Meses,input$TIPODIA,"vehiculos","> Q.75",sep = " "),beside = T,names.arg = vehic1$vehiculo, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=2,col = c("Gray","lightblue"),ylim =c(0,(max(vehic2[,2])+35)))
    text(salidavehiclo, (t(vehic2[,c(1,2)]))+1 ,labels = t(vehic2[,c(1,2)]))
    legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.1), legend = c(input$año_num_input2,input$año_num_input3), fill = c("Gray", "lightblue"),cex = 1.2)
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulo1, col = "lightblue",cex = 0.9)
    
    
  })
  
  
  output$distPlot1 <- renderPlot({
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    

    names(FLOTA_Combustible)=c("NUMERO_VEHICULO","Combustible")
    FLOTA_Combustible$NUMERO_VEHICULO<-as.character(FLOTA_Combustible$NUMERO_VEHICULO)
    FLOTA_Combustible<-as.data.table(FLOTA_Combustible)
    
    setkey(salidas_todas_dia1,NUMERO_VEHICULO)
    setkey(FLOTA_Combustible,NUMERO_VEHICULO)
    
    salidas_todas_dia1<- FLOTA_Combustible[salidas_todas_dia1,all=T]
    
    salidas_todas_dia1$Combustible<-replace(salidas_todas_dia1$Combustible,is.na(salidas_todas_dia1$Combustible),"ACPM")
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Meses]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAS]
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Combustible==input$COMBUSTIBLE]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIA]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTS]
    
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "vandalismos","VANDALISMO")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasflota","FLOTA")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasUTRYT","UTRYT")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "salidasOpe.","OPERADOR")
    salidas_todas_dia1$salidastipo<-replace(salidas_todas_dia1$salidastipo,salidas_todas_dia1$salidastipo== "Accidentes","ACCIDENTES")
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$salidastipo==input$tiposalida]
    
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Meses]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAS]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIA]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTS]
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("NUMERO_VEHICULO","Año")],length))
    vehic<-data.table(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0)
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,]
    
    vehic<-replace(vehic,is.na(vehic),0)
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0)
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    
    vehickm<-data.table(vehickm)
    
    setkey(vehickm,V1)
    setkey(vehic,V1)
    
    vehic<- vehickm[vehic,all=T]
    
    
    
    vehic[,Tasa23:=(X2023/k2023)*4800]
    vehic[,Tasa24:=(X2024/k2024)*4800]
    vehic[,Tasa25:=(X2024/k2025)*4800]
    vehic$Tasa23<-round((vehic$Tasa23),0)
    vehic$Tasa24<-round((vehic$Tasa24),0)
    vehic$Tasa25<-round((vehic$Tasa25),0)
    
    vehic<-replace(vehic,vehic== "Inf",0)
    vehic<-replace(vehic,vehic== "NaN",0)
    vehic<-replace(vehic,vehic== "NA",0)
    
    vehic<-vehic[vehic$Tasa24>0]
    
    
    
    vehic<- vehic[order(vehic$Tasa24,decreasing = T), ]
    vehic<-vehic[vehic$Tasa24>=quantile(vehic$Tasa24,probs = as.numeric(0.75))]
    
    
    vehictodo<-vehic
    
    if(input$TASA){
      
      
      vehic<-data.frame(vehic[,c(1,8:10)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo1<-"(Salidas/Kilometros)*cuatromil ochocientos"
      titulo1<-"Tasa"
    }
    
    if(input$Total){
      
      vehic<-data.frame(vehic[,c(1,5:7)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_input2,input$año_num_input3)]
      titulo1<-"Total"
      mtctitulo1<-""
    }
    
    
    salidavehiclo<-barplot(t(vehic2[,c(1,2)]),main=paste( titulo1,"Salidas por",input$tiposalida,input$COTS,input$Meses,input$TIPODIA,"vehiculos",input$COMBUSTIBLE,"> Q.75",sep = " "),beside = T,names.arg = vehic1$vehiculo, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=2,col = c("Gray","lightblue"),ylim =c(0,(max(vehic2[,2])+35)))
    text(salidavehiclo, (t(vehic2[,c(1,2)]))+1 ,labels = t(vehic2[,c(1,2)]))
    legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.1), legend = c(input$año_num_input2,input$año_num_input3), fill = c("Gray", "lightblue"),cex = 1.2)
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulo1, col = "lightblue",cex = 0.9)
    
    
  })
  
  output$distPlot41 <- renderPlot({
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
   
    FLOTA_Combustible1<-FLOTA_Combustible
    
    names(FLOTA_Combustible1)=c("NUMERO_VEHICULO","Combustible")
    FLOTA_Combustible1$NUMERO_VEHICULO<-as.character(FLOTA_Combustible1$NUMERO_VEHICULO)
    FLOTA_Combustible1<-as.data.table(FLOTA_Combustible1)
    
    setkey(salidas_todas_dia1,NUMERO_VEHICULO)
    setkey(FLOTA_Combustible1,NUMERO_VEHICULO)
    
    salidas_todas_dia1<-FLOTA_Combustible1[salidas_todas_dia1,all=T]
    
    salidas_todas_dia1$Combustible<-replace(salidas_todas_dia1$Combustible,is.na(salidas_todas_dia1$Combustible),"ACPM")
    
    
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Combustible==input$COMBUSTIBLE]
    
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAS]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTS]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIA]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Meses]
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
 
    
    names(FLOTA_Combustible)=c("Vehiculo","Combustible")
    FLOTA_Combustible<-as.data.table(FLOTA_Combustible)
    FLOTA_Combustible$Vehiculo<-as.character(FLOTA_Combustible$Vehiculo)
    setkey(vehiculodia,Vehiculo)
    setkey(FLOTA_Combustible,Vehiculo)
    
    vehiculodia<- FLOTA_Combustible[vehiculodia,all=T]
    vehiculodia$Combustible<-replace(vehiculodia$Combustible,is.na(vehiculodia$Combustible),"ACPM")
    
    vehiculodia<-vehiculodia[vehiculodia$Combustible==input$COMBUSTIBLE]
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Meses]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAS]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIA]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTS]
    
    vehiculodia$Largo<-replace(vehiculodia$Largo,is.na(vehiculodia$Largo),0)
    
    
    Kilometroaño<-data.frame(t(tapply(vehiculodia$Largo,vehiculodia$Año,sum)))
    
    k1 <-data.table( X2023= 0,X2024=0,X2025=0 )
    
    Kilometroaño<-rbind(k1,Kilometroaño,fill = TRUE)
    
    Kilometroaño<-Kilometroaño[-1,]
    Kilometroaño<-replace(Kilometroaño,is.na(Kilometroaño),0)
    
    UTRYT<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasUTRYT"]
    FLOTA<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasflota"]
    OPERADOR<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasOpe."]
    VANDA<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="vandalismos"]
    ACCI<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="Accidentes"]
    salidasUTRYT2<-data.frame(tapply(UTRYT$sal_veh,UTRYT[,c("X5","Año")],length))
    salidasUTRYT2<-data.table(colnames(t(salidasUTRYT2)),salidasUTRYT2)
    salidasUTRYT2[,tipo:="UTRYT"]
    salidasflota2<-data.frame(tapply(FLOTA$sal_veh,FLOTA[,c("X4","Año")],length))
    salidasflota2<-data.table(colnames(t(salidasflota2)),salidasflota2)
    salidasflota2[,tipo:="FLOTA"]
    salidasOpe2<-data.frame(tapply(OPERADOR$sal_veh,OPERADOR[,c("X4","Año")],length))
    salidasOpe2<-data.table(colnames(t(salidasOpe2)),salidasOpe2)
    salidasOpe2[,tipo:="OPERADOR"]
    vandalismos2<-data.frame(tapply(VANDA$sal_veh,VANDA[,c("X4","Año")],length))
    vandalismos2<-data.table(colnames(t(vandalismos2)),vandalismos2)
    vandalismos2[,tipo:="VANDALISMO"]
    Accidentes2<-data.frame(tapply(ACCI$sal_veh,ACCI[,c("X4","Año")],length))
    Accidentes2<-data.table(colnames(t(Accidentes2)),Accidentes2)
    Accidentes2[,tipo:="ACCIDENTES"]
    todos<-rbind(Accidentes2,vandalismos2,salidasflota2,salidasUTRYT2,salidasOpe2)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0, "tipo"=0 )
    
    todos<-rbind(k1,todos,fill = TRUE)
    
    todos<-todos[-1,]
    
    todos<-replace(todos,is.na(todos),0)
    
    
    todos$V1<-gsub("CON FALLA DE ","",todos$V1)
    todos$V1<-gsub("INSTALACIONES ","",todos$V1)
    todos$V1<-gsub("IVU BOX::","",todos$V1)
    todos$V1<-gsub("CON PROBLEMAS DE ","",todos$V1)
    todos$V1<-gsub("CON FALLA ","",todos$V1)
    todos$V1<-gsub("CON ","",todos$V1)
    todos$V1<-gsub("TRANSITAR ","",todos$V1)
    todos$V1<-gsub("CAMBIO DE VEHICULO PARA ATENCION DE ","",todos$V1)
    todos$V1<-gsub("VEHICULO ","",todos$V1)
    todos$V1<-gsub("CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE","",todos$V1)
    todos$V1<-gsub("CON FALLA DE SISTEMA DE AIRE ","",todos$V1)
    
    
    todos<-todos[todos$tipo==input$tiposalida]
    
    
    todos<-todos[todos$X2024>=quantile(todos$X2024,probs = 0.50)]
    todos<- todos[order(todos$X2024,decreasing = T), ]
    todos2<-todos
    todos2[,kilo2023:=(Kilometroaño[1,1])]
    todos2[,kilo2024:=(Kilometroaño[1,2])]
    todos2[,kilo2025:=(Kilometroaño[1,3])]
    todos2[,tasa23:=round(((X2023/kilo2023)*1000000),0)]
    todos2[,tasa24:=round(((X2024/kilo2024)*1000000),0)]
    todos2[,tasa25:=round(((X2025/kilo2025)*1000000),0)]
    todos2<- todos2[order(todos2$X2024,decreasing = T), ]
    todos2<-data.frame(todos2)
    
    #todos<-todos[c(1:5),]
    todos<-data.frame(todos)
    
    #mtc<-data.frame(colnames(t(mtc)),mtc)
    
    
    
    if(input$TASA){
      
      
      #todos<- todos[order(todos$X2024,decreasing = T), ]
      
      
      mtctodos<-todos2[,c(1,9:11)]
      #mtctodos<- mtctodos[order(mtctodos$X2024,decreasing = T), ]
      
      names(mtctodos)=c("Tipo","2023","2024","2025")
      
      mtc2todos<-mtctodos
      mtc1todos<-data.frame(t(mtctodos[,-1]))
      mtctodos<-mtc2todos[,-1]
      mtctodos <- mtctodos[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo<-todos2[1,4]
      mtctitulo1<-"(Salidas/Kilometros)*millon"
      titulo1<-"Tasa"
      
    }
    
    if(input$Total){
      
      #todos<- todos[order(todos$X2024,decreasing = T), ]
      mtctodos<-todos[,-5]
      #mtctodos<- mtctodos[order(mtctodos$X2024,decreasing = T), ]
      
      names(mtctodos)=c("Tipo","2023","2024","2025")
      
      
      mtc2todos<-mtctodos
      mtc1todos<-data.frame(t(mtctodos[,-1]))
      mtctodos<-mtc2todos[,-1]
      mtctodos <- mtctodos[,c(input$año_num_input2,input$año_num_input3)]
      mtctitulo<-todos[1,4]
      titulo1<-"Total"
      mtctitulo1<-""
    }
    
    #par(mfrow=c(2,1))
    
    saltodatodo<-barplot(t(mtctodos[,c(1,2)]) ,main=paste(titulo1,"Salidas por",input$tiposalida,input$TIPODIA,input$COTS,input$Meses,input$COMBUSTIBLE,">Q.50",sep = " ") ,ylab = "cantidad", names.arg = mtc2todos$Tipo, cex.names=0.7,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("Gray","lightblue"),beside = TRUE,ylim =c(0,(max(mtctodos[,1]+100))))
    #legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.005), legend = input$COMBUSTIBLE,cex = 1.4)
    text(saltodatodo, (t(mtctodos[,c(1,2)]))+10 ,labels = t(mtctodos[,c(1,2)]))
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    legend(x = "top",bty = "n",horiz = TRUE,inset =  c(0,0.2), legend = c(input$año_num_input2,input$año_num_input3), fill = c("Gray", "lightblue"),cex = 1.2)
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulo1, col = "lightblue",cex = 0.9)
    
  })
  
  output$distPlot5 <- renderPlot({
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
   
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`tipo ruta`==input$TIPO_SER]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAr]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesr]
    
    KMSEJECUTADOS_RUTAS<-rbind(KMSEJECUTADOS_RUTAS,KMSEJECUTADOS_RUTAStodo)
    
  
    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$`tipo ruta`==input$TIPO_SER]
    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$TIPODIA==input$TIPODIAr]
    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$Mes==input$Mesesr]
    
    KMSEJECUTADOS_RUTAS[,KMPro:=`tipo ruta`]
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Troncal","976000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Alimentador","1400000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Pretoncal","1150000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Reserva","1150000")
    KMSEJECUTADOS_RUTAS$KMPro<-as.numeric(KMSEJECUTADOS_RUTAS$KMPro)
    KMSEJECUTADOS_RUTAS<-replace(KMSEJECUTADOS_RUTAS,is.na(KMSEJECUTADOS_RUTAS),0)
    
    RUTASkm<-data.frame((tapply(KMSEJECUTADOS_RUTAS$Largo,KMSEJECUTADOS_RUTAS[,c("Ruta","Año")],sum)))
    RUTASkm<-data.table(colnames(t(RUTASkm)),RUTASkm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    RUTASkm<-rbind(k1,RUTASkm,fill = TRUE)
    
    RUTASkm<-RUTASkm[-1,]
    
    RUTASkm<-data.frame(replace(RUTASkm,is.na(RUTASkm),0))
    names(RUTASkm)=c("V1","k2023","k2024","k2025")
  
    RUTAS<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("RUTA","Año")],length))
    RUTAS<-data.table(colnames(t(RUTAS)),RUTAS)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    RUTAS<-rbind(k1,RUTAS,fill = TRUE)
    
    RUTAS<-RUTAS[-1,]
    
    RUTAS<-replace(RUTAS,is.na(RUTAS),0)
    
    
    RUTASkm<-data.table(RUTASkm)
    RUTAS<-data.table(RUTAS)
    
    setkey(RUTASkm,V1)
    setkey(RUTAS,V1)
    
    RUTAS<- RUTASkm[RUTAS,all=T]
    
    
    RUTAS<-RUTAS[RUTAS$X2024>=quantile(RUTAS$X2024,probs = as.numeric(input$Cuartilesr))]
    
    RUTAS[,Tasa23:=(X2023/k2023)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAS[,Tasa24:=(X2024/k2024)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAS[,Tasa25:=(X2025/k2025)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAS$Tasa23<-round((RUTAS$Tasa23),0)
    RUTAS$Tasa24<-round((RUTAS$Tasa24),0)
    RUTAS$Tasa25<-round((RUTAS$Tasa25),0)
    
    RUTAS<-replace(RUTAS,RUTAS== "Inf",0)
    RUTAS<-replace(RUTAS,RUTAS== "NaN",0)
    RUTAS<-replace(RUTAS,RUTAS== "NA",0)
    
    #RUTAStasa<-RUTAStasa[,-1]
    
    
    
    
    if(input$TASAr){
      RUTAStasa<-RUTAS[,c(1,8:10)]
      RUTAStasa<- RUTAStasa[order(RUTAStasa$Tasa24,decreasing = T), ]
      
      RUTAStasa<-data.frame(RUTAStasa)
      names(RUTAStasa)=c("Ruta","2023","2024","2025")
      
      RUTAS1<-RUTAStasa
      RUTAS2<-RUTAStasa[,-1]
      #RUTAStasa<-data.frame(t(RUTAStasa[,-1]))
      RUTAS2<-RUTAS2[,c(input$año_num_inputr,input$año_num_inputr)]
      #RUTAStasa<-RUTAStasa[,c(input$año_num_inputr,input$año_num_inputr)]
      titulo<-"Tasa de Salidas"
      mtctitulo1<-paste( "(Salidas/Kilometros)*",max(KMSEJECUTADOS_RUTAS$KMPro),sep = " ")
    }
    
    if(input$Totalr){
      
      RUTAS<-RUTAS[,c(1,5:7)]
      
      RUTAS<- RUTAS[order(RUTAS$X2024,decreasing = T), ]
      
      RUTAS<-data.frame(RUTAS)
      names(RUTAS)=c("Ruta","2023","2024","2025")
      RUTAS1<-RUTAS
      RUTAS2<-RUTAS[,-1]
      #RUTAS<-data.frame(t(RUTAS[,-1]))
      RUTAS2<-RUTAS2[,c(input$año_num_inputr,input$año_num_inputr)]
      titulo<-"Cantidad de Salidas"
      #RUTAStasa<-RUTAStasa[,c(input$año_num_inputr,input$año_num_inputr)]
      mtctitulo1<-""
    }
    
    salidaruta<-barplot(t(RUTAS2[,1]),main=paste( titulo,input$TIPO_SER,input$Mesesr,"de",input$año_num_inputr,sep = " "),beside = T,names.arg = RUTAS1$Ruta, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=1,col = "blue",ylim =c(0,(max(RUTAS2[,1])+500)))
    text(salidaruta, (t(RUTAS2[,c(1)]))+100 ,labels = t(RUTAS2[,c(1)]))
    #text(salidaruta, (t(RUTAS2[,c(1)]))+500 ,labels = t(RUTAStasa[,c(1)]),col = "red"  )
    legend(x = "top",bty = "n",horiz = T, legend = mtctitulo1, col = "lightblue",cex = 0.9)
    
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    
    
  })
  output$distPlot6 <- renderPlot({
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`tipo ruta`==input$TIPO_SER]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAr]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesr]
    
    KMSEJECUTADOS_RUTAS<-rbind(KMSEJECUTADOS_RUTAS,KMSEJECUTADOS_RUTAStodo)

    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$`tipo ruta`==input$TIPO_SER]
    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$TIPODIA==input$TIPODIAr]
    KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$Mes==input$Mesesr]
    
    KMSEJECUTADOS_RUTAS[,KMPro:=`tipo ruta`]
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Troncal","976000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Alimentador","1400000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Pretoncal","1150000")
    KMSEJECUTADOS_RUTAS$KMPro<-replace(KMSEJECUTADOS_RUTAS$KMPro,KMSEJECUTADOS_RUTAS$KMPro== "Reserva","1150000")
    KMSEJECUTADOS_RUTAS$KMPro<-as.numeric(KMSEJECUTADOS_RUTAS$KMPro)
    KMSEJECUTADOS_RUTAS<-replace(KMSEJECUTADOS_RUTAS,is.na(KMSEJECUTADOS_RUTAS),0)
    
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Meses]
    RUTASkm<-data.frame((tapply(KMSEJECUTADOS_RUTAS$Largo,KMSEJECUTADOS_RUTAS[,c("Ruta","Año")],sum)))
    RUTASkm<-data.table(colnames(t(RUTASkm)),RUTASkm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    RUTASkm<-rbind(k1,RUTASkm,fill = TRUE)
    
    RUTASkm<-RUTASkm[-1,]
    
    RUTASkm<-data.frame(replace(RUTASkm,is.na(RUTASkm),0))
    names(RUTASkm)=c("V1","k2023","k2024","k2025")
    RUTASkm$k2023<-round((RUTASkm$k2023),0)
    RUTASkm$k2024<-round((RUTASkm$k2024),0)
    RUTASkm$k2025<-round((RUTASkm$k2025),0)
    
    RUTASkm<-as.data.table(RUTASkm)
    RUTASkm<-RUTASkm[RUTASkm$V1==input$Rutas]
    
    RUTASkm23<-max(RUTASkm$k2023)
    RUTASkm24<-max(RUTASkm$k2024)
    RUTASkm25<-max(RUTASkm$k2025)
    
    RUTA<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("salidastipo","RUTA","Año")],length))
    RUTA<-data.frame(t(RUTA))
    nomru<-data.frame(colnames(t(RUTA)))
    nomru<-cbind(data.table(str_split_fixed(nomru$colnames.t.RUTA..,"[.]",2)),nomru)
    names(nomru)=c("Rutas","Año","Todas")
    RUTA<-data.frame(nomru,RUTA)
    
    RUTA<-data.table(RUTA)
    RUTA<-replace(RUTA,is.na(RUTA),0)
    
    RUTA<-RUTA[RUTA$Rutas==input$Rutas]
    
    
    RUTA<-RUTA[,-c(1,3)]
    
    RUTA<-data.frame(t(RUTA))
    RUTA<-RUTA[-1,]
    RUTA<-cbind(colnames(t(RUTA)),RUTA)
    
    k1 <-data.table( "X1"=0, "X2"=0,"X3"=0 )
    
    RUTA<-rbind(k1,RUTA,fill = TRUE)
    
    RUTA<-RUTA[-1,c(4,1:3)]
    
    RUTA<-data.frame(replace(RUTA,is.na(RUTA),0))
    
    RUTA<- RUTA[order(RUTA$X2,decreasing = T), ]
    
    names(RUTA)=c("Tipo","2023","2024","2025")
    RUTA$"2024"<-as.numeric(RUTA$"2024")
    RUTA$"2023"<-as.numeric(RUTA$"2023")
    RUTA$"2025"<-as.numeric(RUTA$"2025")
    
    RUTAtasa<-as.data.table(RUTA)
    
    RUTAtasa[,km24:= max(RUTASkm$k2024)]
    RUTAtasa[,km23:= max(RUTASkm$k2023)]
    RUTAtasa[,km25:= max(RUTASkm$k2025)]
    
    RUTAtasa[,Tasa23:=(RUTAtasa$"2023"/RUTAtasa$km23)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAtasa[,Tasa24:=(RUTAtasa$"2024"/RUTAtasa$km24)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAtasa[,Tasa25:=(RUTAtasa$"2025"/RUTAtasa$km25)*max(KMSEJECUTADOS_RUTAS$KMPro)]
    RUTAtasa$Tasa23<-round((RUTAtasa$Tasa23),2)
    RUTAtasa$Tasa24<-round((RUTAtasa$Tasa24),2)
    RUTAtasa$Tasa25<-round((RUTAtasa$Tasa25),2)
    
    RUTAtasa<-RUTAtasa[,c("Tipo","Tasa23","Tasa24","Tasa25")]
    
    names(RUTAtasa)=c("Tipo","2023","2024","2025")
    
    RUTAtasa<-as.data.frame(RUTAtasa)
    
    
    
    RUTApor<-as.data.table(RUTA)
    RUTApor[,a2023:=(RUTApor$"2023"/(sum(RUTApor$"2023")))*100]
    RUTApor[,a2024:=(RUTApor$"2024"/(sum(RUTApor$"2024")))*100]
    RUTApor[,a2025:=(RUTApor$"2025"/(sum(RUTApor$"2025")))*100]
    
    RUTApor<-RUTApor[,-c(2,3,4)]
    names(RUTApor)=c("Tipo","2023","2024","2025")
    RUTApor$"2023"<-round(RUTApor$"2023",digits = 0)
    RUTApor$"2024"<-round(RUTApor$"2024",digits = 0)
    RUTApor$"2025"<-round(RUTApor$"2025",digits = 0)
    
    RUTApor<-as.data.frame(RUTApor)
    RUTApor<-RUTApor[,c(input$año_num_inputr,input$año_num_inputr)]
    
    RUTA2<-RUTA
    RUTA1<-RUTA
    
    
    RUTA<-data.frame(t(RUTA[,-1]))
    RUTA2<-RUTA2[,c(input$año_num_inputr,input$año_num_inputr)]
    
    RUTA3<-RUTAtasa
    RUTA4<-RUTAtasa
    
    
    RUTA3<-RUTA3[,c(input$año_num_inputr,input$año_num_inputr)]
    
    
    RUTASkm1<-data.frame(RUTASkm[,-1])
    
    names(RUTASkm1)=c("2023","2024","2025")
    
    RUTASkm1<-RUTASkm1[,c(input$año_num_inputr,input$año_num_inputr)]
    
    
    if(input$Totalr){
      
      par(mfrow=c(1,2))
      
      salidaruta1<-barplot(t(RUTA2[,1]) ,main=paste( "Total de Salidas por Tipo",input$Mesesr,"de" ,input$año_num_inputr,input$Rutas,sep = " "),ylab = "cantidad", names.arg = RUTA1$Tipo, cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(RUTA2[,1])+1000)))
      text(salidaruta1, (t(RUTA2[,1]))+100 ,labels = t(RUTA2[,1]))
      legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.2), legend = paste( "kM",RUTASkm1[,1], sep = "-") , fill = c("Gray","lightblue"),cex = 1.2)
      
      torta<-pie3D(t(RUTApor[,1]),main=paste( "Porcentaje(%) de Tipo de Salidas",input$Mesesr,"de" ,input$año_num_inputr,input$Rutas,sep = " "),labels= paste(RUTA1$Tipo,RUTApor[,1],"%",sep = " "), pty="s", col = rainbow(5),explode = 0.2)
      
    }
    
    if(input$TASAr){
      
      salidaruta1<-barplot(t(RUTA3[,1]) ,main=paste( "Tasa de Salidas por Tipo",input$Mesesr,"de" ,input$año_num_inputr,input$Rutas,sep = " "),ylab = "cantidad", names.arg = RUTA4$Tipo, cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(RUTA3[,1])+1000)))
      text(salidaruta1, (t(RUTA3[,1]))+100 ,labels = t(RUTA3[,1]))
      legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.2), legend = paste( "(Salidas/Kilometros)*",max(KMSEJECUTADOS_RUTAS$KMPro),sep = " ") , fill = c("Gray","lightblue"),cex = 1.2)
      
      
      
    }
    
    
  })
  
  output$distPlot7 <- renderPlot({
    
 
    salidas_todas_dia1[,Desepeflota:=paste(NUMERO_VEHICULO,Año,Mes,sep = "_")]
    salidas_todas_dia1toda[,Desepeflota:=paste(NUMERO_VEHICULO,Año,Mes,sep = "_")]
    
    DeseFlotaMes<-DeseFlotaMes[,c(5,4)]
    DeseFlotaAño<-DeseFlotaAño[,c(5,3)]
    
    setkey(salidas_todas_dia1,Desepeflota)
    setkey(DeseFlotaMes,Desepeflota)
    
    salidas_todas_dia1<- DeseFlotaMes[salidas_todas_dia1,all=T]
    
    
    setkey(salidas_todas_dia1toda,Desepeflota)
    setkey(DeseFlotaAño,Desepeflota)
    
    salidas_todas_dia1toda<- DeseFlotaAño[salidas_todas_dia1toda,all=T]
    
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesf]
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTSf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diaoperativo>=input$Numero]
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
  
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Mesesf]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAf]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIAf]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTSf]
    vehiculodia<-vehiculodia[vehiculodia$Diaoperativo>=input$Numero]
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("NUMERO_VEHICULO","Año")],length))
    vehic<-data.table(colnames(t(vehic)),vehic)
    
    vehic$V1<-as.numeric(vehic$V1)
    vehic$V1<-as.character(vehic$V1)
    
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,]
    
    vehic<-replace(vehic,is.na(vehic),0)
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    
    vehickm<-data.table(vehickm)
    
    setkey(vehickm,V1)
    setkey(vehic,V1)
    
    vehic<- vehickm[vehic,all=T]
    
    
    
    vehic[,Tasa23:=(X2023/k2023)*4800]
    vehic[,Tasa24:=(X2024/k2024)*4800]
    vehic[,Tasa25:=(X2025/k2025)*4800]
    vehic$Tasa23<-round((vehic$Tasa23),0)
    vehic$Tasa24<-round((vehic$Tasa24),0)
    vehic$Tasa25<-round((vehic$Tasa25),0)
    
    vehic<-replace(vehic,vehic== "Inf",0)
    vehic<-replace(vehic,vehic== "NaN",0)
    vehic<-replace(vehic,vehic== "NA",0)
    
    vehic<-vehic[vehic$X2024>=quantile(vehic$X2024,probs = as.numeric(input$Cuartilesf))]
    
    
    #RUTAS<-RUTAS[RUTAS==input$Rutas]
    vehic<- vehic[order(vehic$Tasa24,decreasing = T), ]
    xxxx<-as.numeric(substr(input$año_num_inputf,4,4))-1
    
    vehictodo<-vehic
    
    if(input$TASAf){
      
      vehic<-data.frame(vehic[,c(1,8:10)])
      names(vehic)=c("vehiculo","2023","2024","2025")
     vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf,input$año_num_inputf)]
      titulof<-"Tasa de Salidas"
      mtctitulof<-"(Salidas/Kilometros)*cuatromil_ochocientos"
    }
    if(input$Totalf){
      
      vehic<-data.frame(vehic[,c(1,5:7)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf,input$año_num_inputf)]
      titulof<-"Cantidad de Salidas"
      mtctitulof<-" "
    }
    
    
    salidavehiclo<-barplot(t(vehic2[,1]),main=paste( titulof,input$COTS,input$TIPOLOGIAf,input$Mesesf,"de",input$año_num_inputf,sep = " "),beside = T,names.arg = vehic1$vehiculo, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=2,col = "yellow",ylim =c(0,(max(vehic2[,1])+15)))
    text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]))
    #text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]),srt = 90)
    
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulof, col = "lightblue",cex = 0.9)
    
    
  })
  
  output$distPlot8 <- renderPlot({
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Diatipo==input$TIPODIAf]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTSf]
    
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
 
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Mesesf]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAf]
    vehiculodia<-vehiculodia[vehiculodia$TIPODIA==input$TIPODIAf]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTSf]
    
    
    
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    vehickm<-as.data.table(vehickm)
    vehickm<-vehickm[vehickm$V1==input$VEHICULOS]
    
    vehickm23<-max(vehickm$k2023)
    vehickm24<-max(vehickm$k2024)
    vehickm25<-max(vehickm$k2025)
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("salidastipo","NUMERO_VEHICULO","Año")],length))
    vehic<-data.frame(t(vehic))
    
    nomru<-data.frame(colnames(t(vehic)))
    nomru<-cbind(data.table(str_split_fixed(nomru$colnames.t.vehic..,"[.]",2)),nomru)
    names(nomru)=c("Vehiculo","Año","Todas")
    vehic<-data.frame(nomru,vehic)
    
    vehic<-data.table(vehic)
    vehic<-replace(vehic,is.na(vehic),0)
    vehic$Vehiculo<-gsub("X","",vehic$Vehiculo)
    vehic<-vehic[vehic$Vehiculo==input$VEHICULOS]
    
    
    vehic<-vehic[,-c(1,3)]
    
    vehic<-data.frame(t(vehic))
    vehic<-vehic[-1,]
    vehic<-cbind(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "X1"=0, "X2"=0,"X3"=0 )
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,c(4,1:3)]
    
    vehic<-data.frame(replace(vehic,is.na(vehic),0))
    
    #vehic<- vehic[order(vehic$X2,decreasing = T), ]
    
    xxxx<-as.numeric(substr(input$año_num_inputf,4,4))-1
    vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
    
    
    names(vehic)=c("Tipo","2023","2024","2025")
    vehic$"2024"<-as.numeric(vehic$"2024")
    vehic$"2023"<-as.numeric(vehic$"2023")
    vehic$"2025"<-as.numeric(vehic$"2025")
    
    vehictasa<-as.data.table(vehic)
    
    vehictasa[,km24:= max(vehickm$k2024)]
    vehictasa[,km23:= max(vehickm$k2023)]
    vehictasa[,km25:= max(vehickm$k2025)]
    
    vehictasa[,Tasa23:=(vehictasa$"2023"/vehictasa$km23)*4800]
    vehictasa[,Tasa24:=(vehictasa$"2024"/vehictasa$km24)*4800]
    vehictasa[,Tasa25:=(vehictasa$"2025"/vehictasa$km25)*4800]
    vehictasa$Tasa23<-round((vehictasa$Tasa23),0)
    vehictasa$Tasa24<-round((vehictasa$Tasa24),0)
    vehictasa$Tasa25<-round((vehictasa$Tasa25),0)
    
    vehictasa<-vehictasa[,c("Tipo","Tasa23","Tasa24","Tasa25")]
    
    names(vehictasa)=c("Tipo","2023","2024","2025")
    
    vehictasa<-as.data.frame(vehictasa)
    
    
    vehicpor<-as.data.table(vehic)
    
    
    vehicpor[,a2023:=(vehicpor$"2023"/(sum(vehicpor$"2023")))*100]
    vehicpor[,a2024:=(vehicpor$"2024"/(sum(vehicpor$"2024")))*100]
    vehicpor[,a2025:=(vehicpor$"2025"/(sum(vehicpor$"2025")))*100]
    vehicpor<-vehicpor[,-c(2,3,4)]
    names(vehicpor)=c("Tipo","2023","2024","2025")
    vehicpor$"2023"<-round(vehicpor$"2023",digits = 0)
    vehicpor$"2024"<-round(vehicpor$"2024",digits = 0)
    vehicpor$"2025"<-round(vehicpor$"2025",digits = 0)
    
    
    vehicpor<-as.data.frame(vehicpor)
    vehicpor<-vehicpor[,c(input$año_num_inputf,input$año_num_inputf)]
    
    vehic2<-vehic
    vehic1<-vehic
    
    vehic3<-vehictasa
    vehic4<-vehictasa
    
    vehic<-data.frame(t(vehic[,-1]))
    vehic2<-vehic2[,c(input$año_num_inputf,input$año_num_inputf)]
    
    
    vehic3<-vehic3[,c(input$año_num_inputf,input$año_num_inputf)]
    
    vehickm1<-data.frame(vehickm[,-1])
    
    names(vehickm1)=c("2023","2024","2025")
    
    vehickm1<-vehickm1[,c(input$año_num_inputf,input$año_num_inputf)]
    
    if(input$Totalf){
      
      par(mfrow=c(1,2))
      
      
      salidavehic1<-barplot(t(vehic2[,1]) ,main=paste( "Total Salidas por Tipo",input$Mesesf,"de" ,input$año_num_inputf,"vehiculo",input$VEHICULOS,sep = " "),ylab = "cantidad", names.arg = vehic1$Tipo, cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(vehic2[,1])+50)))
      text(salidavehic1, (t(vehic2[,1]))+2 ,labels = t(vehic2[,1]))
      legend(x = "top",bty = "n",horiz = T,inset =  c(-0.1,0.2), legend = paste( "kM",vehickm1[,1], sep = "-") , fill = c("Gray","lightblue"),cex = 1.2)
      
      tortavehic<-pie3D(t(vehicpor[,1]),main=paste( "Tipo de Salidas %",input$Mesesf,"de" ,input$año_num_inputf,"vehiculo",input$VEHICULOS,sep = " "),labels= paste(vehic1$Tipo,vehicpor[,1],"%",sep = " "), pty="s", col = rainbow(5),explode = 0.2)
      
      
    }
    
    if(input$TASAf){
      
      salidavehic1<-barplot(t(vehic3[,1]) ,main=paste( "Tasa de Salidas por Tipo",input$Mesesf,"de" ,input$año_num_inputf,"vehiculo",input$VEHICULOS,sep = " "),ylab = "cantidad", names.arg = vehic4$Tipo, cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(vehic3[,1])+50)))
      text(salidavehic1, (t(vehic3[,1]))+2 ,labels = t(vehic3[,1]))
      legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = "(Salidas/Kilometros)*cuatromil_ochocientos", col = "lightblue",cex = 0.9)
    }
    
    
    
  })
  
  output$distPlot72 <- renderPlot({
    
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesf2]
    
    salidas_todas_dia1$Fecha<-as.Date(salidas_todas_dia1$Fecha,origin = "1899-12-30")
    salidas_todas_dia1<- salidas_todas_dia1[order(salidas_todas_dia1$Fecha,decreasing = F), ]
    salidas_todas_dia1$Fecha<-as.character(salidas_todas_dia1$Fecha)
    maximo<-salidas_todas_dia1[salidas_todas_dia1$Año==input$año_num_inputf2]
    maximo<-maximo[length(maximo$JERARQUIA),]
    maximo<-maximo[,6]
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAf2]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$salidastipo==input$tiposalida2]
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTSf2]
    
    salidas_todas_dia1blanco<-salidas_todas_dia1[salidas_todas_dia1$X5==""]
    salidas_todas_dia1blanco[,X5:=X4]
    salidas_todas_dia1x<-salidas_todas_dia1[salidas_todas_dia1$X5!=""]
    salidas_todas_dia1<-rbind(salidas_todas_dia1blanco,salidas_todas_dia1x)
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Mesesf2]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAf2]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTSf2]
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("NUMERO_VEHICULO","Año")],length))
    vehic<-data.table(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,]
    
    vehic<-replace(vehic,is.na(vehic),0)
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    
    vehickm<-data.table(vehickm)
    
    setkey(vehickm,V1)
    setkey(vehic,V1)
    
    vehic<- vehickm[vehic,all=T]
    
    
    
    vehic[,Tasa23:=(X2023/k2023)*4800]
    vehic[,Tasa24:=(X2024/k2024)*4800]
    vehic[,Tasa25:=(X2025/k2025)*4800]
    vehic$Tasa23<-round((vehic$Tasa23),0)
    vehic$Tasa24<-round((vehic$Tasa24),0)
    vehic$Tasa25<-round((vehic$Tasa25),0)
    
    vehic<-replace(vehic,vehic== "Inf",0)
    vehic<-replace(vehic,vehic== "NaN",0)
    vehic<-replace(vehic,vehic== "NA",0)
    
    vehic<-vehic[vehic$X2024>=quantile(vehic$X2024,probs = as.numeric(input$Cuartilesf2))]
    
    
    #RUTAS<-RUTAS[RUTAS==input$Rutas]
    vehic<- vehic[order(vehic$Tasa24,decreasing = T), ]
    
    
    xxxx<-as.numeric(substr(input$año_num_inputf2,4,4))-1
    
    
    
    vehictodo<-vehic
    
    if(input$TASAf2){
      
      vehic<-data.frame(vehic[,c(1,8:10)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf2,input$año_num_inputf2)]
      titulof<-"Tasa de Salidas"
      mtctitulof<-"(Salidas/Kilometros)*cuatromil_ochocientos"
    }
    if(input$Totalf2){
      
      vehic<-data.frame(vehic[,c(1,5:7)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf2,input$año_num_inputf2)]
      titulof<-"Cantidad de Salidas"
      mtctitulof<-" "
    }
    
    
    salidavehiclo<-barplot(t(vehic2[,1]),main=paste( titulof,input$COTS2,input$TIPOLOGIAf2,input$Mesesf2,input$año_num_inputf2,input$tiposalida2,"a", maximo,sep = " "),beside = T,names.arg = vehic1$vehiculo, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=2,col ="blue",ylim =c(0,(max(vehic2[,1])+15)))
    text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]))
    #text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]),srt = 90)
    
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulof, col = "lightblue",cex = 0.9)
    
    
  })
  
  output$distPlot82 <- renderPlot({
    
   
    
    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesf2]
    
    salidas_todas_dia1$Fecha<-as.Date(salidas_todas_dia1$Fecha,origin = "1899-12-30")
    salidas_todas_dia1<- salidas_todas_dia1[order(salidas_todas_dia1$Fecha,decreasing = F), ]
    salidas_todas_dia1$Fecha<-as.character(salidas_todas_dia1$Fecha)
    maximo<-salidas_todas_dia1[salidas_todas_dia1$Año==input$año_num_inputf2]
    maximo<-maximo[length(maximo$JERARQUIA),]
    maximo<-maximo[,6]
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAf2]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$salidastipo==input$tiposalida2]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTSf2]
    #salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$X4==input$Tipo_Salida2]
    
    
    salidas_todas_dia1blanco<-salidas_todas_dia1[salidas_todas_dia1$X5==""]
    salidas_todas_dia1blanco[,X5:=X4]
    salidas_todas_dia1x<-salidas_todas_dia1[salidas_todas_dia1$X5!=""]
    salidas_todas_dia1<-rbind(salidas_todas_dia1blanco,salidas_todas_dia1x)
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Mesesf2]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAf2]
    
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTSf2]
    
    
    
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    vehickm<-as.data.table(vehickm)
    vehickm<-vehickm[vehickm$V1==input$VEHICULOS2]
    
    vehickm23<-max(vehickm$k2023)
    vehickm24<-max(vehickm$k2024)
    vehickm25<-max(vehickm$k2025)
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("X5","NUMERO_VEHICULO","Año")],length))
    vehic<-data.frame(t(vehic))
    
    nomru<-data.frame(colnames(t(vehic)))
    nomru<-cbind(data.table(str_split_fixed(nomru$colnames.t.vehic..,"[.]",2)),nomru)
    names(nomru)=c("Vehiculo","Año","Todas")
    vehic<-data.frame(nomru,vehic)
    
    vehic<-data.table(vehic)
    vehic<-replace(vehic,is.na(vehic),0)
    vehic$Vehiculo<-gsub("X","",vehic$Vehiculo)
    vehic<-vehic[vehic$Vehiculo==input$VEHICULOS2]
    
    
    vehic<-vehic[,-c(1,3)]
    
    vehic<-data.frame(t(vehic))
    vehic<-vehic[-1,]
    vehic<-cbind(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "X1"=0, "X2"=0,"X3"=0 )
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,c(4,1:3)]
    
    vehic<-data.frame(replace(vehic,is.na(vehic),0))
    #vehic<- vehic[order(vehic$X2,decreasing = T), ]
    xxxx<-as.numeric(substr(input$año_num_inputf2,4,4))-1
    vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
    
    
    vehic<-vehic[1:round(((length(vehic$X3))/3),0),]
 
    
    names(vehic)=c("Tipo","2023","2024","2025")
    vehic$"2024"<-as.numeric(vehic$"2024")
    vehic$"2023"<-as.numeric(vehic$"2023")
    vehic$"2025"<-as.numeric(vehic$"2025")
    
    vehictasa<-as.data.table(vehic)
    
    vehictasa[,km24:= max(vehickm$k2024)]
    vehictasa[,km23:= max(vehickm$k2023)]
    vehictasa[,km25:= max(vehickm$k2025)]
    
    vehictasa[,Tasa23:=(vehictasa$"2023"/vehictasa$km23)*4800]
    vehictasa[,Tasa24:=(vehictasa$"2024"/vehictasa$km24)*4800]
    vehictasa[,Tasa25:=(vehictasa$"2025"/vehictasa$km25)*4800]
    vehictasa$Tasa23<-round((vehictasa$Tasa23),0)
    vehictasa$Tasa24<-round((vehictasa$Tasa24),0)
    vehictasa$Tasa25<-round((vehictasa$Tasa25),0)
    
    vehictasa<-vehictasa[,c("Tipo","Tasa23","Tasa24","Tasa25")]
    
    names(vehictasa)=c("Tipo","2023","2024","2025")
    
    vehictasa<-as.data.frame(vehictasa)
    
    
    vehicpor<-as.data.table(vehic)
    
    
    vehicpor[,a2023:=(vehicpor$"2023"/(sum(vehicpor$"2023")))*100]
    vehicpor[,a2024:=(vehicpor$"2024"/(sum(vehicpor$"2024")))*100]
    vehicpor[,a2025:=(vehicpor$"2025"/(sum(vehicpor$"2025")))*100]
    vehicpor<-vehicpor[,-c(2,3,4)]
    names(vehicpor)=c("Tipo","2023","2024","2025")
    vehicpor$"2023"<-round(vehicpor$"2023",digits = 0)
    vehicpor$"2024"<-round(vehicpor$"2024",digits = 0)
    vehicpor$"2025"<-round(vehicpor$"2025",digits = 0)
    
    
    vehicpor<-as.data.frame(vehicpor)
    vehicpor<-vehicpor[,c(input$año_num_inputf2,input$año_num_inputf2)]
    
    vehic2<-vehic
    vehic1<-vehic
    
    vehic3<-vehictasa
    vehic4<-vehictasa
    
    vehic<-data.frame(t(vehic[,-1]))
    vehic2<-vehic2[,c(input$año_num_inputf2,input$año_num_inputf2)]
    
    
    vehic3<-vehic3[,c(input$año_num_inputf2,input$año_num_inputf2)]
    
    vehickm1<-data.frame(vehickm[,-1])
    
    names(vehickm1)=c("2023","2024","2025")
    
    vehickm1<-vehickm1[,c(input$año_num_inputf2,input$año_num_inputf2)]
    
    
    if(input$Totalf2){
      
      par(mfrow=c(1,2))
      
      
      salidavehic1<-barplot(t(vehic2[,1]) ,main=paste( "Tipo de Salidas por Flota",input$Mesesf2,input$año_num_inputf2,"vehiculo",input$VEHICULOS2,input$tiposalida2,"a", maximo,sep = " "),ylab = "cantidad",  cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(vehic2[,1])+50)))
      text(salidavehic1, (t(vehic2[,1]))+2 ,labels = t(vehic2[,1]))
      legend(x = "left",inset = c(0.15,9),bty = "n",horiz = T, legend = paste( "kM",vehickm1[,1], sep = "-") , fill = c("Gray","lightblue"),cex = 1.2)
      
      
      tortavehic<-pie3D(t(vehicpor[,1]),main=paste( "Tipo de Salidas por Flota %",input$Mesesf2,input$año_num_inputf2,"vehiculo",input$VEHICULOS2,"asta", maximo,sep = " "),labels= paste(vehicpor[,1],"%",sep = " "), pty="s", col = rainbow(11),explode = 0.2)
      legend(x = "left",bty = "n",lty = 1,horiz = F, legend = paste(vehicpor[,1],"%","-",vehic4$Tipo,"-",vehic2[,1], sep = ""),cex = 0.9,xpd = TRUE,col = rainbow(11))
      
      
    }
    
    if(input$TASAf2){
      
      salidavehic1<-barplot(t(vehic3[,1]) ,main=paste( "Tasa de Salidas por Flota",input$Mesesf2,input$año_num_inputf2,"vehiculo",input$VEHICULOS2,input$tiposalida2,"a", maximo,sep = " "),ylab = "cantidad", cex.names=1.1,cex.axis = 1.2,cex.lab = 1.1, las=1,ylim =c(0,(max(vehic3[,1])+50)))
      text(salidavehic1, (t(vehic3[,1]))+2 ,labels = t(vehic3[,1]))
      legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = "(Salidas/Kilometros)*cuatromil_ochocientos", col = "lightblue",cex = 0.9)
      legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(vehic4$Tipo,"-",vehic3[,1], sep = ""),cex = 0.7,xpd = TRUE)
      
       }
    
    
    
  })
  
  output$distPlot7_2 <- renderPlot({
    

    salidas_todas_dia1<-rbind(salidas_todas_dia1,salidas_todas_dia1toda)
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Mes==input$Mesesf2]
    
    salidas_todas_dia1$Fecha<-as.Date(salidas_todas_dia1$Fecha,origin = "1899-12-30")
    salidas_todas_dia1<- salidas_todas_dia1[order(salidas_todas_dia1$Fecha,decreasing = F), ]
    salidas_todas_dia1$Fecha<-as.character(salidas_todas_dia1$Fecha)
    maximo<-salidas_todas_dia1[salidas_todas_dia1$Año==input$año_num_inputf2]
    maximo<-maximo[length(maximo$JERARQUIA),]
    maximo<-maximo[,6]
    
    
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$Tipovehiculo==input$TIPOLOGIAf2]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$salidastipo==input$tiposalida2]
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$`Codificacion Concesionario`==input$COTSf2]
    
    salidas_todas_dia1blanco<-salidas_todas_dia1[salidas_todas_dia1$X5==""]
    salidas_todas_dia1blanco[,X5:=X4]
    salidas_todas_dia1x<-salidas_todas_dia1[salidas_todas_dia1$X5!=""]
    salidas_todas_dia1<-rbind(salidas_todas_dia1blanco,salidas_todas_dia1x)
    salidas_todas_dia1<-salidas_todas_dia1[salidas_todas_dia1$X5==input$Tipo_Salida2]
    
    vehiculodia<-rbind(vehiculodia,vehiculodiatoda)
    
    
    vehiculodia<-vehiculodia[vehiculodia$Mes==input$Mesesf2]
    vehiculodia<-vehiculodia[vehiculodia$Tipovehiculo==input$TIPOLOGIAf2]
    vehiculodia<-vehiculodia[vehiculodia$COT==input$COTSf2]
    
    
    vehic<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("NUMERO_VEHICULO","Año")],length))
    vehic<-data.table(colnames(t(vehic)),vehic)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehic<-rbind(k1,vehic,fill = TRUE)
    
    vehic<-vehic[-1,]
    
    vehic<-replace(vehic,is.na(vehic),0)
    
    vehickm<-data.frame(tapply(vehiculodia$Largo,vehiculodia[,c("Vehiculo","Año")],sum))
    vehickm<-data.table(colnames(t(vehickm)),vehickm)
    
    k1 <-data.table( "V1"=0,"X2023"=0, "X2024"=0,"X2025"=0 )
    
    vehickm<-rbind(k1,vehickm,fill = TRUE)
    
    vehickm<-vehickm[-1,]
    
    vehickm<-replace(vehickm,is.na(vehickm),0)
    vehickm<-data.frame(replace(vehickm,is.na(vehickm),0))
    names(vehickm)=c("V1","k2023","k2024","k2025")
    
    
    vehickm<-data.table(vehickm)
    
    setkey(vehickm,V1)
    setkey(vehic,V1)
    
    vehic<- vehickm[vehic,all=T]
    
    
    
    vehic[,Tasa23:=(X2023/k2023)*4800]
    vehic[,Tasa24:=(X2024/k2024)*4800]
    vehic[,Tasa25:=(X2025/k2025)*4800]
    vehic$Tasa23<-round((vehic$Tasa23),0)
    vehic$Tasa24<-round((vehic$Tasa24),0)
    vehic$Tasa25<-round((vehic$Tasa25),0)
    
    vehic<-replace(vehic,vehic== "Inf",0)
    vehic<-replace(vehic,vehic== "NaN",0)
    vehic<-replace(vehic,vehic== "NA",0)
    
    vehic<-vehic[vehic$X2024>=quantile(vehic$X2024,probs = as.numeric(input$Cuartilesf2))]
    
    
    
    vehic<- vehic[order(vehic$Tasa24,decreasing = T), ]
  
    xxxx<-as.numeric(substr(input$año_num_inputf2,4,4))-1
   
    
    
    vehictodo<-vehic
    
    if(input$TASAf2){
      
      vehic<-data.frame(vehic[,c(1,8:10)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf2,input$año_num_inputf2)]
      titulof<-"Tasa de Salidas"
      mtctitulof<-"(Salidas/Kilometros)*cuatromil_ochocientos"
    }
    if(input$Totalf2){
      
      vehic<-data.frame(vehic[,c(1,5:7)])
      names(vehic)=c("vehiculo","2023","2024","2025")
      vehic<- vehic[order(vehic[,xxxx],decreasing = T), ]
      
      vehic1<-vehic
      vehic2<-vehic[,-1]
      #vehic<-data.frame(t(vehic[,-1]))
      vehic2<-vehic2[,c(input$año_num_inputf2,input$año_num_inputf2)]
      
      titulof<-"Cantidad de Salidas"
      mtctitulof<-" "
    }
    
    
    salidavehiclo<-barplot(t(vehic2[,1]),main=paste( titulof,input$COTS2,input$TIPOLOGIAf2,input$Mesesf2,input$año_num_inputf2,input$tiposalida2,"-",input$Tipo_Salida2,"a", maximo,sep = " "),beside = T,names.arg = vehic1$vehiculo, cex.names=0.8,cex.axis = 1.2,cex.lab = 1.1, las=2,col = "yellow",ylim =c(0,(max(vehic2[,1])+15)))
    text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]))
    #text(salidavehiclo, (t(vehic2[,c(1)]))+1 ,labels = t(vehic2[,c(1)]),srt = 90)
    
    #saltodaoper<-barplot(t(mtcmes[,c(1,2)]) , ylab = "total/millon de kilometros",  cex.names=1.2,cex.axis = 1.2,cex.lab = 1.1, las=1,col = c("blue", "yellow"),beside = TRUE,ylim =c(0,(max(mtcmes[,1]+2000))))
    legend(x = "top",bty = "n",horiz = T,inset = c(-0.10,0.3), legend = mtctitulof, col = "lightblue",cex = 0.9)
    
    
  })
 
}





# Activa modo autoreload con la opción global
options(shiny.autoreload = TRUE)
options(shiny.autoreload.interval = 2000)
# Run the application 
shinyApp(ui = ui, server = server, options = list(host = "0.0.0.0",port=9002))
