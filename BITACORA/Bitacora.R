#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
#Activamos las librerias necesarias 
library(readxl) #leer archivos en excel y ussas las propiedades de a librerya
library(stringr) #leer utilizar las funciones de los directorios de las carpetas
library(data.table) #Utiliza las funciones para almacenar tablas de datos por medio de "data.table" y "data.frame"
#library(plotrix)
library(openxlsx)
#library(xlsx)
library(lubridate)
library(shiny)

load("C:/Users/emosquera/OneDrive - metrocali.gov.co/eric_aci_/Calificadas/calificacion2024.RData")
data_frame23<-data_frame
load("C:/Users/emosquera/OneDrive - metrocali.gov.co/eric_aci_/Calificadas/calificacion2025.RData")
data_frame23<-data_frame23[,-53]
data_frame1<-rbind(data_frame23,data_frame)
rm(data_frame23)

carpeta_ano<-"Mes"
Directorios<- "C:/Users/emosquera/OneDrive - metrocali.gov.co/Ajustadas/Todas/" #variable de ubicacion del directorio
subdirectorio1<- str_c(Directorios,"/",carpeta_ano,"/")#variable de ubicacion del sudirectorio
#subdirectorio1<-"G:/Trabajo diario/calificacion/Ajustadas/2017/Todas/Mes/"
lista_archivos<- dir(subdirectorio1)#Nombre de arcivos)

datosen<- as.matrix(read_excel(str_c(subdirectorio1,lista_archivos[length(lista_archivos)]),sheet = 1, col_names = F)) #seleciono el primer archivo para consolidar
nombre_archivo <- lista_archivos[as.numeric(length(lista_archivos))]#Nombre referencia que se va a asignar en el archivo consolidado
nombres_columnas<- datosen[1,1]#Iniciacion fila = 1 columna = 1, para el inicio de los nombres del archivo por columna


for (i in 2:ncol(datosen)){ nombres_columnas <- c(nombres_columnas,datosen[1,i])   }
nombres_columnas<- c(nombres_columnas,"nombre_archivo") #asignacion de nuevo columna nombre del archivo

datosen <- datosen[-1,]

################# PENDIENTE OPERACION IMPORTANTE PARA EL CONSOLIDADO #######
data_frame<-data.frame(datosen)
data_frame<- data.table(data_frame)
#########################################################################
data_frame <- data_frame[,nombre_archivo :=nombre_archivo,]
names(data_frame) <- nombres_columnas

data_frame$NUMERO_VEHICULO<-as.numeric(data_frame$NUMERO_VEHICULO)
data_frame$NUMERO_VEHICULO<-as.character(data_frame$NUMERO_VEHICULO)

data_frame$CODIGO_OPERADOR<-as.numeric(data_frame$CODIGO_OPERADOR)
data_frame$CODIGO_OPERADOR<-as.character(data_frame$CODIGO_OPERADOR)

data_frame<-rbind(data_frame1,data_frame)

data_frame<-unique(data_frame)

rm(data_frame1)

consobita<-data_frame
consobita$JERARQUIA<-as.character(consobita$JERARQUIA)
TABV<-str_split_fixed(consobita$JERARQUIA,"::",4)
TABV<- data.frame(TABV)
consobita<-cbind(consobita,TABV)
consobita[,Fecha:=paste((substr(consobita$nombre_archivo,1,2)),(substr(consobita$nombre_archivo,3,4)),(substr(consobita$nombre_archivo,5,6)),sep = "-")]
consobita[,Fecha:=paste(20,Fecha,sep = "")]
consobita[,Mes:=substr(consobita$nombre_archivo,3,4)]
consobita[,Año:=substr(consobita$nombre_archivo,1,2)]
consobita[,Dia:=substr(consobita$nombre_archivo,5,6)]
consobita[,Tipologia:=substr(consobita$NUMERO_VEHICULO,2,2)]
consobita$Tipologia<-replace(consobita$Tipologia,consobita$Tipologia== "1","ART")
consobita$Tipologia<-replace(consobita$Tipologia,consobita$Tipologia== "3","COM")
consobita$Tipologia<-replace(consobita$Tipologia,consobita$Tipologia== "2","PAD")
consobita$Tipologia<-replace(consobita$Tipologia,consobita$Tipologia== "4","DUAL")


consobitablanco<-consobita[consobita$X3==""]
consobita<-consobita[consobita$X3!=""]

consobita<-rbind(consobita,consobitablanco)

consobita1<-consobita[consobita$X3==""]
consobita1[,X3:=TIPO_EVENTO ]
consobita<-consobita[consobita$X3!=""]

consobita<-rbind(consobita1,consobita)


consobita$Fecha<-as.Date(consobita$Fecha,origin = "1899-12-30")
consobita<-consobita[consobita$TIPO_EVENTO!="TIPO_EVENTO"]


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Bitacora Preliminar"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            dateInput("fechas_input",  "DE:", min = today()-730 , max =  today(), value =  today()-30 , 
                      language = "es", weekstart = 1
            ) ,
            
            dateInput("fechas_input1",  "A:", min = today()-730 , max = today() , value =today()-30, 
                      language = "es", weekstart = 1
            )
            
            
            
            
            
           ,width = 2 ),

        # Show a plot of the generated distribution
        mainPanel(
          
          plotOutput("distPlot"),
          
          selectInput(inputId = "Tipo_Evento",
                      label = "Tipo de Evento:",
                      
                      choices = list("Desvios","Adicionales","N.A", "Incidente","Salida","Ingreso","Inspección"  )
          ),
          
          plotOutput("distPlot2"),
          
          selectInput(inputId = "Jerarquias",
                      label = "Jerarquia:",
                      
                      choices = list( "METROCALI::CANCELACION::CAMBIO DE LINEA" ,"METROCALI::CANCELACION::DE ADICIONAL"   ,"METROCALI::CANCELACION::OTROS" ,"METROCALI::INCIDENTE::DESPACHO::ASIGNACION INCORRECTA DE TAREA EN IVU VEHICLE"                                   	 ,"METROCALI::INCIDENTE::FIN DE OPERACION"                                                                          	 ,"METROCALI::INCIDENTE::INICIO DE OPERACION"                                                                       	 ,"METROCALI::INCIDENTE::PERTURBACION DE OPERACION::OTROS"                                                          	 ,"METROCALI::INCIDENTE::PERTURBACION DE OPERACION::POR ACCIDENTE DE TERCEROS"                                      	 ,"METROCALI::INCIDENTE::PERTURBACION DE OPERACION::POR SEMAFORO FUERA DE SERVICIO"                                 	 ,"METROCALI::INCIDENTE::POR ALARMA::AGRESION VERBAL A OPERADOR"                                                    	 ,"METROCALI::INCIDENTE::POR ALARMA::DESMAYO DE USUARIO EN VEHICULO"                                                	 ,"METROCALI::INCIDENTE::POR FLOTA::CON ABOLLADURAS EN CARROCERIA EXTERNA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON ABOLLADURAS EN CARROCERIA INTERNA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                	 ,"METROCALI::INCIDENTE::POR FLOTA::CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR"                 	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALENCIA DE ASEO INTERIOR AL INICIO DE LA JORNADA"                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE PUERTAS::FALLA ANGEL GUARDIAN"                                     	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE PUERTAS::FALLA DE PUERTA"                                          	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA DE SISTEMA DE AIRE ACONDICIONADO"                                     	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA MECANICA::EMISIONES DE RUIDO"                                         	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA MECANICA::PANELES DE CONTROL"                                         	 ,"METROCALI::INCIDENTE::POR FLOTA::CON FALLA PLATAFORMA ELEVADORA"                                                 	 ,"METROCALI::INCIDENTE::POR FLOTA::CON LLANTAS LISAS"                                                              	 ,"METROCALI::INCIDENTE::POR FLOTA::CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO::SENALETICA INSTITUCIONAL"  	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROBLEMAS DE RUTERO::CARENCIA DE ILUMINACION"                               	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROBLEMAS DE RUTERO::INFORMACION ERRADA"                                    	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROPAGANDA NO AUTORIZADA"                                                   	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::APAGADO"                            	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::IBIS"                               	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::PANEL INFORMADOR INTERNO"                    	 ,"METROCALI::INCIDENTE::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::VALIDADOR"                                   	 ,"METROCALI::INCIDENTE::POR FLOTA::INSTALACIONES ELECTRICAS"                                                       	 ,"METROCALI::INCIDENTE::POR OPERADOR::APROXIMA MAL"                                                                	 ,"METROCALI::INCIDENTE::POR OPERADOR::INTERRUMPE O BLOQUEA LA OPERACION DEL SISTEMA"                               	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO ACATA O DESCONOCE INSTRUCCION DEL CCO"                                    	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO DA INFORMACION"                                                           	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO INFORMA ANOMALIAS DEL VEHICULO"                                           	 ,"METROCALI::INCIDENTE::POR OPERADOR::NO USA O USA MAL EL PROTOCOLO DE COMUNICACIÓN"                               	 ,"METROCALI::INCIDENTE::POR OPERADOR::TRANSPORTA EVASOR CON CONSENTIMIENTO"                                        	 ,"METROCALI::INCIDENTE::POR VANDALISMO::DANOS AL VEHICULO"                                                         	 ,"METROCALI::INGRESO::ADICIONAL"                                                                                   	 ,"METROCALI::INGRESO::RETOMA"                                                                                      	 ,"METROCALI::INSPECCION MUESTRAL::CON ABOLLADURAS EN CARROCERIA EXTERNA"                                           	 ,"METROCALI::INSPECCION MUESTRAL::CON ABOLLADURAS EN CARROCERIA INTERNA"                                           	 ,"METROCALI::INSPECCION MUESTRAL::CON AUSENCIA FALTA DE CARGA O VENCIMIENTO DE EXTINTORES"                         	 ,"METROCALI::INSPECCION MUESTRAL::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                 	 ,"METROCALI::INSPECCION MUESTRAL::CON DESPERFECTOS EN SISTEMA DE ILUMINACION ARTIFICIAL EXTERIOR"                  	 ,"METROCALI::INSPECCION MUESTRAL::CON FALLA DE PUERTAS"                                                            	 ,"METROCALI::INSPECCION MUESTRAL::CON FALLA MECANICA::SUSPENSION"                                                  	 ,"METROCALI::INSPECCION MUESTRAL::CON LLANTAS LISAS"                                                               	 ,"METROCALI::INSPECCION MUESTRAL::CON MODIFICACION DE ESQUEMA DE COLORES DEL VEHICULO Y/O SENALETICA INSTITUCIONAL"	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS DE RUTERO"                                                         	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS EN ELEMENTOS DE FIJACION PARA SILLAS DE RUEDAS"                    	 ,"METROCALI::INSPECCION MUESTRAL::CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD"                               	 ,"METROCALI::INSPECCION MUESTRAL::CON PROTOCOLO TECNOLOGICO FALENTE DURANTE EL ALISTAMIENTO"                       	 ,"METROCALI::INSPECCION MUESTRAL::CON SILLA ROTA RASGADA ETC"                                                      	 ,"METROCALI::INSPECCION MUESTRAL::CON VENTANA CLARABOYA EXTRACTOR O ESCOTILLA DANADO"                              	 ,"METROCALI::INSPECCION MUESTRAL::INSTALACIONES ELECTRICAS"                                                        	 ,"METROCALI::INSPECCION MUESTRAL::TRANSITAR DERRAMANDO LIQUIDOS"                                                   	 ,"METROCALI::MIO CABLE::FIN DE OPERACION"                                                                          	 ,"METROCALI::MIO CABLE::INICIO DE OPERACION"                                                                       	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::BAJO NIVEL DE COMBUSTIBLE"                                            	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::CAMBIO DE LINEA"                                                      	 ,"METROCALI::SALIDAS::POR ABANDONO DE TAREA::INJUSTIFICADO"                                                        	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::OBJETO FIJO::ANDEN"                                             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::VEHICULO PARTICULAR::AUTOMOVIL PARTICULAR"                      	 ,"METROCALI::SALIDAS::POR ACCIDENTE CHOQUE SIMPLE::VEHICULO PARTICULAR::MOTO MOTOCARRO O MOTOTRICICLO"             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CON HERIDOS::CAIDA DE OCUPANTE::POR CASO FORTUITO"                             	 ,"METROCALI::SALIDAS::POR ACCIDENTE CON HERIDOS::CAIDA DE OCUPANTE::POR FRENADA BRUSCA"                            	 ,"METROCALI::SALIDAS::POR ALARMA::AGRESION VERBAL A OPERADOR"                                                      	 ,"METROCALI::SALIDAS::POR ALARMA::CONTAMINACION DE VEHICULO"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON CAIDA O FALTANTE DE ELEMENTOS DE CARROCERIA"                                  	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE PUERTAS::FALLA DE PUERTA"                                            	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE SISTEMA DE AIRE ACONDICIONADO"                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA DE TIMBRES"                                                             	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::DIRECCION"                                                    	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::FRENOS"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::MOTOR"                                                        	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::SUSPENSION"                                                   	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA MECANICA::TRANSMISION"                                                  	 ,"METROCALI::SALIDAS::POR FLOTA::CON FALLA PLATAFORMA ELEVADORA"                                                   	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROBLEMAS DE RUTERO::CARENCIA DE ILUMINACION"                                 	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROBLEMAS O AUSENCIA DE CINTURON DE SEGURIDAD"                                	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROPAGANDA NO AUTORIZADA"                                                     	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::APAGADO"                              	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::IVU BOX::IBIS"                                 	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::TORNIQUETE"                                    	 ,"METROCALI::SALIDAS::POR FLOTA::CON PROTOCOLO TECNOLOGICO FALENTE::VALIDADOR"                                     	 ,"METROCALI::SALIDAS::POR FLOTA::CON SILLA ROTA RASGADA ETC"                                                       	 ,"METROCALI::SALIDAS::POR FLOTA::INSTALACIONES ELECTRICAS"                                                         	 ,"METROCALI::SALIDAS::POR FLOTA::PINCHAZO"                                                                         	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO ELECTRICO SOLO BUS"                                     	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO ELECTRICO VIA MIXTA"                                    	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO MECANICO SOLO BUS"                                      	 ,"METROCALI::SALIDAS::POR FLOTA::VEHICULO VARADO::POR DANO MECANICO VIA MIXTA"                                     	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::ENFERMEDAD DEL OPERADOR"                                    	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::INJUSTIFICADO"                                              	 ,"METROCALI::SALIDAS::POR OPERADOR::ABANDONO DE TAREA::NO RELEVO"                                                  	 ,"METROCALI::SALIDAS::POR OPERADOR::ALTERA RECORRIDO DE RUTA"                                                      	 ,"METROCALI::SALIDAS::POR OPERADOR::OMITE PARADA"                                                                  	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::CONGESTION DE USUARIOS EN ESTACIONES O PARADAS"           	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::CONGESTION VEHICULAR"                                     	 ,"METROCALI::SALIDAS::POR REPOSICIONAMIENTO::POR ATRASO::INJUSTIFICADO"                                            	 ,"METROCALI::SALIDAS::POR VANDALISMO::DANOS AL VEHICULO" 
                      )
          ),
         fluidRow(column(1,checkboxInput("Afectaciones",
                       
                       "RUTA")),
         
         column(2,checkboxInput("Afectaciones1",
                       
                       "NUMERO_VEHICULO")),
         column(1,checkboxInput("Afectaciones2",
                       
                       "COT")),
         column(2,checkboxInput("Afectaciones3",
                       
                       "CODIGO_OPERADOR")),
         column(2,checkboxInput("Afectaciones4",
                       
                       "AGENTE_REGISTRA")),
         column(1,checkboxInput("Afectaciones5",
                       
                       "Dia")),
         column(1,checkboxInput("Afectaciones6",
                       
                       "HORA")))
         
          
           ,plotOutput("distPlot1")
        )
    ), tabPanel("Datos",
                
                titlePanel("Bitacoras"),
                fluidRow(column(DT::dataTableOutput("Bitacora"), width = 12)
                         
                         
                ) 
                
                
                
    )
)

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
      consobita<-consobita[consobita$JERARQUIA==input$Jerarquias]
      Novedad<-consobita[2,3]
      
      
      if(input$Afectaciones){
      TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$RUTA,length))
      TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
      names(TotalNovedades)=c("Rutas","Total")
      TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
      titulo<-"RUTA"
      }
      if(input$Afectaciones1){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$NUMERO_VEHICULO,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"NUMERO DE VEHICULO"
      }
      if(input$Afectaciones2){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$COLA,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"COT"
      }
      if(input$Afectaciones3){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$CODIGO_OPERADOR,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"CODIGO DE OPERADOR"
      }
      if(input$Afectaciones4){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$AGENTE_REGISTRA,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"PERSONA QUE REGISTRA"
      }
      if(input$Afectaciones5){
        TotalNovedades<-as.data.frame(tapply(consobita$JERARQUIA,consobita$Dia,length))
        TotalNovedades<-cbind(row.names(TotalNovedades),TotalNovedades)
        names(TotalNovedades)=c("Rutas","Total")
        TotalNovedades<- TotalNovedades[order(TotalNovedades$Total,decreasing = T), ]
        titulo<-"Dia"
      }
      
    
      
      Graf1<- barplot(TotalNovedades$Total,main =paste( Novedad,"por",titulo,"De",input$fechas_input,"A ",input$fechas_input1, sep = " "),names.arg = TotalNovedades$Rutas,cex.names=0.8,col = "lightblue",cex.axis = 1.2,las=2,cex.lab = 1.5,ylim = c(0,(max(t(TotalNovedades$Total)+10))))
      text(Graf1, (as.numeric(TotalNovedades$Total)+3),labels = as.numeric(as.numeric(TotalNovedades$Total)))
      legend(x = "top",bty = "n",horiz = T,inset =  c(0,0.1), legend =input$Jerarquias , cex = 1.2)
      
      
      
    })
    output$Bitacora <- DT::renderDataTable(
      
      
      DT::datatable({data_frame}, options = list(lenghtMenu= list(c(7,8,-1), c(5,8, "All")), pagelenght= 15), filter = "top")
      
    )
}

# Run the application 
shinyApp(ui = ui, server = server)
