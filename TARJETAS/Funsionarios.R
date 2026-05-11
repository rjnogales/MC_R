library(shiny)
library(tidyverse)#lo tiene todos 
library(DT)
library(rsconnect)
library(dplyr)
library(ggplot2)
library(data.table)


load(file.path(getwd(), "Funsion_ati_final.RData"))  # <<--- Cambia según su necesidad
load(file.path(getwd(), "tarjetas1.RData"))          # <<--- Se mantiene
load(file.path(getwd(), "usos_funsionario.RData"))   # <<--- Cambia según su necesidad


#usos_funsionarioTodos<-read.csv("C:/Users/emosquera/OneDrive - metrocali.gov.co/usos_funsionarioTodos.csv", sep = ";")
#load(str_c(getwd(),"/Activo.RData"))
#write.xlsx(Funsion_ati_final1,"C:/Users/emosquera.METROCALI/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/Tarjetas/Funsionarios.xls",row.names = FALSE)
#write.xlsx(Funsion_ati_final1,"C:/Users/emosquera.METROCALI/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/Tarjetas/Funsionarios.xls",row.names = FALSE)
usos_funsionarioTodos<-as.data.table(usos_funsionarioTodos)
usos_funsionarioTodos[,Año:=(substr(usos_funsionarioTodos$Fecha,1,4))]
#usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Año=="2024"]
usos_funsionarioTodos[,Mes:=substr(usos_funsionarioTodos$Fecha,6,7)]
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "01","Enero")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "02","Febrero")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "03","Marzo")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "04","Abril")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "05","Mayo")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "06","Junio")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "07","Julio")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "08","Agosto")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "09","Septiembre")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "10","Octubre")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "11","Noviembre")
usos_funsionarioTodos$Mes<-replace(usos_funsionarioTodos$Mes,usos_funsionarioTodos$Mes== "12","Diciembre")


Funsion_ati_final1[,Año:=(substr(Funsion_ati_final1$Fecha,1,4))]
#Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Año=="2024"]
Funsion_ati_final1[,Mes:=substr(Funsion_ati_final1$Fecha,6,7)]
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "01","Enero")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "02","Febrero")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "03","Marzo")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "04","Abril")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "05","Mayo")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "06","Junio")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "07","Julio")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "08","Agosto")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "09","Septiembre")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "10","Octubre")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "11","Noviembre")
Funsion_ati_final1$Mes<-replace(Funsion_ati_final1$Mes,Funsion_ati_final1$Mes== "12","Diciembre")

tarjetas2<-tarjetas1[,c(2,7)]

names(tarjetas2)<-c("Nombre","Oficina")

tarjetas2$Oficina<-gsub("CONCESIONARIO ","",tarjetas2$Oficina)

#usos_funsionarioTodos$Nombre<-gsub("[.]","",usos_funsionarioTodos$Nombre)

#usos_funsionarioTodos[,Nombre:=paste("&&",Nombre, sep = "")]
#usos_funsionarioTodos$Nombre<-gsub("&& ","",usos_funsionarioTodos$Nombre)

#usos_funsionarioTodos$Nombre<-gsub(" ","",usos_funsionarioTodos$Nombre)

usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="GONZALES CUELLAR KAREN FERNANDA ","GONZALES CUELLAR KAREN FERNANDA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre==" ALEXANDER VALENCIA","ALEXANDER VALENCIA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="ANDREA VALENTINA RICO LENIS ","ANDREA VALENTINA RICO LENIS")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="LANDAZURI DELGADO YUBI CRISTINA ","LANDAZURI DELGADO YUBI CRISTINA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="ANGIE VANESSA MANTILLA PEÑA ","ANGIE VANESSA MANTILLA PEÑA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="LEONOR AMERICA  LANDAZURY QUIÑONEZ ","LEONOR AMERICA  LANDAZURY QUIÑONEZ")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="DAVALOS TANGARIFE HILDA DANIELA ","DAVALOS TANGARIFE HILDA DANIELA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre==" CARLOS ANDRES ORDOÑEZ MOSQUERA","CARLOS ANDRES ORDOÑEZ MOSQUERA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre==" JORGE ARMANDO BALANTA","JORGE ARMANDO BALANTA")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre==" STEC DAVINSON CASTELLANOS PATIÑO","STEC DAVINSON CASTELLANOS PATIÑO")
usos_funsionarioTodos$Nombre<-replace(usos_funsionarioTodos$Nombre,usos_funsionarioTodos$Nombre=="FRANCISCO JAVIER RIVERA SARRIA.","FRANCISCO JAVIER RIVERA SARRIA")


#####personaas de la lista 
#####"LUZ ANGELA MATEUS LEGUINZANO"
#####"LUIS GABRIEL OCHOA MORENO"
#####"DAVIDSON MUÑOZ JESSICA THAIS"
#####"PECHENE VALENCIA FABIOLA
#####"JUAN IGNACIO QUIJANO
#####"RAUL DARIO YEPEZ BOLIVAR


setkey(tarjetas2,Nombre)
setkey(Funsion_ati_final1,Nombre)
setkey(usos_funsionarioTodos,Nombre)


Funsion_ati_final1<-tarjetas2[Funsion_ati_final1, all= TRUE]
usos_funsionarioTodos<-tarjetas2[usos_funsionarioTodos, all= TRUE]

usos_funsionarioTodosisna<-usos_funsionarioTodos[is.na(usos_funsionarioTodos$Oficina)]
usos_funsionarioTodos1<-usos_funsionarioTodos[usos_funsionarioTodos$Oficina!="is.na"]

usos_funsionarioTodosisna<-cbind(usos_funsionarioTodosisna,(str_split_fixed(usos_funsionarioTodosisna$Nombre," ",2)))


usos_funsionarioTodospolcua<-rbind(usos_funsionarioTodosisna[usos_funsionarioTodosisna$V1=="GUARDA"],usos_funsionarioTodosisna[usos_funsionarioTodosisna$V1=="POL"])
usos_funsionarioTodosOtros<-usos_funsionarioTodosisna[usos_funsionarioTodosisna$V1!="POL"]
usos_funsionarioTodosOtros<-usos_funsionarioTodosOtros[usos_funsionarioTodosOtros$V1!="GUARDA"]
rm(usos_funsionarioTodosisna)

usos_funsionarioTodospolcua[,Oficina:=V1]
usos_funsionarioTodosOtros[,Oficina:="No_asociados"]

usos_funsionarioTodospolcua<-usos_funsionarioTodospolcua[,-c(10,11)]
usos_funsionarioTodosOtros<-usos_funsionarioTodosOtros[,-c(10,11)]

usos_funsionarioTodos<-rbind(usos_funsionarioTodos1,usos_funsionarioTodospolcua,usos_funsionarioTodosOtros)


Funsion_ati_finalatipico<-Funsion_ati_final1[,c(1,9)]
Funsion_ati_finalatipico[,Compara:=paste(Nombre,Fecha,sep = "/")]
Funsion_ati_finalatipico[,Atipico:="Atipico"]
Funsion_ati_finalatipico<-Funsion_ati_finalatipico[,c(3,4)]

usos_funsionarioTodos[,Compara:=paste(Nombre,Fecha,sep = "/")]


setkey(Funsion_ati_finalatipico,Compara)
setkey(usos_funsionarioTodos,Compara)

usos_funsionarioTodos<-Funsion_ati_finalatipico[usos_funsionarioTodos, all= TRUE]

usos_funsionarioTodos[,Oficina1:=Oficina]

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="JEFE OFICINA CONTROL DE LA OPERACIÓN","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-PATIOS","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-CCO","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-VIA","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-SUPERVISOR","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="COORDINADOR CENTRO DE CONTROL","DIR OPE - OF-CONTROL")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-COORDINADOR PATIOS","DIR OPE - OF-CONTROL")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="OFICINA DE PLANEACION","DIR OPE - OF-PLANEACION")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-PLANEACION - AFORADOR","DIR OPE - OF-PLANEACION")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-PLANEACION","DIR OPE - OF-PLANEACION")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="JEFE OFICINA EVALUACION DE LA OPERACIÓN","DIR OPE - OF-EVALUACION")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="OFICINA DE EVALUACION DE LA OPERACIÓN","DIR OPE - OF-EVALUACION")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPER - OF-EVALUACION - MIO CABLE","DIR OPE - MIO CABLE")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPER - OF-EVALUACION - MIO CABLE - SKYCABLE","DIR OPE - MIO CABLE")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR OPE - OF-CONTROL-MIO CABLE","DIR OPE - MIO CABLE")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="JEFE OFICINA DE SERVCIO AL CLIENTE - VICTOR ( Campaña comercial)","DIR COMER - OF-SERV AL CLIENTE")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIRECTORA COMERCIAL Y DE SERVICIO AL CLIENTE","DIR COMER - OF-SERV AL CLIENTE")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR COMER - OFIC CULTURA Y GES-SOCIAL","DIR COMER - OF-SERV AL CLIENTE")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR COMER - OFIC SERV AL CLIENTE","DIR COMER - OF-SERV AL CLIENTE")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="JEFE OFICINA SISTEMAS","OFICINA DE SISTEMAS")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR INFRAESTRUCTURA - OFICINA DE MANTENIMIENTO","DIR INFRA - OF-MANTENIMIENTO")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR INFRA - OF-CONSTRUCCION","DIR INFRA - OF-CONSTRUCCIONES")
usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="JEFE OFICINA DE CONSTRUCCION","DIR INFRA - OF-CONSTRUCCIONES")

usos_funsionarioTodos$Oficina1<-replace(usos_funsionarioTodos$Oficina1,usos_funsionarioTodos$Oficina1=="DIR INFRA - OF-ESTUDIOS, DISEÑO Y LICITACIONES","DIR INFRA - OF-ESTUDIOS, DISEÑO Y LICITACIONES")


Funsion_ati_final1[,Oficina1:=Oficina]

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="JEFE OFICINA CONTROL DE LA OPERACIÓN","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-PATIOS","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-CCO","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-VIA","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-SUPERVISOR","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="COORDINADOR CENTRO DE CONTROL","DIR OPE - OF-CONTROL")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-COORDINADOR PATIOS","DIR OPE - OF-CONTROL")

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="OFICINA DE PLANEACION","DIR OPE - OF-PLANEACION")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-PLANEACION - AFORADOR","DIR OPE - OF-PLANEACION")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-PLANEACION","DIR OPE - OF-PLANEACION")

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="JEFE OFICINA EVALUACION DE LA OPERACIÓN","DIR OPE - OF-EVALUACION")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="OFICINA DE EVALUACION DE LA OPERACIÓN","DIR OPE - OF-EVALUACION")

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPER - OF-EVALUACION - MIO CABLE","DIR OPE - MIO CABLE")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPER - OF-EVALUACION - MIO CABLE - SKYCABLE","DIR OPE - MIO CABLE")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR OPE - OF-CONTROL-MIO CABLE","DIR OPE - MIO CABLE")

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="JEFE OFICINA DE SERVCIO AL CLIENTE - VICTOR ( Campaña comercial)","DIR COMER - OF-SERV AL CLIENTE")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIRECTORA COMERCIAL Y DE SERVICIO AL CLIENTE","DIR COMER - OF-SERV AL CLIENTE")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR COMER - OFIC CULTURA Y GES-SOCIAL","DIR COMER - OF-SERV AL CLIENTE")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR COMER - OFIC SERV AL CLIENTE","DIR COMER - OF-SERV AL CLIENTE")
 
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="JEFE OFICINA SISTEMAS","OFICINA DE SISTEMAS")

Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR INFRAESTRUCTURA - OFICINA DE MANTENIMIENTO","DIR INFRA - OF-MANTENIMIENTO")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR INFRA - OF-CONSTRUCCION","DIR INFRA - OF-CONSTRUCCIONES")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="JEFE OFICINA DE CONSTRUCCION","DIR INFRA - OF-CONSTRUCCIONES")
Funsion_ati_final1$Oficina1<-replace(Funsion_ati_final1$Oficina1,Funsion_ati_final1$Oficina1=="DIR INFRA - OF-ESTUDIOS, DISEÑO Y LICITACIONES","DIR INFRA - OF-ESTUDIOS, DISEÑO Y LICITACIONES")

Funsion_ati_final1<-cbind(Funsion_ati_final1,(str_split_fixed(Funsion_ati_final1$Nombre," ",2)))


Funsion_ati_final1napol<-Funsion_ati_final1[Funsion_ati_final1$Oficina!="is.na"]
Funsion_ati_final1na<-Funsion_ati_final1[is.na(Funsion_ati_final1$Oficina)]
Funsion_ati_final1na<-Funsion_ati_final1na[Funsion_ati_final1na$V1!="POL"]
Funsion_ati_final1pol<-Funsion_ati_final1[Funsion_ati_final1$V1=="POL"]

Funsion_ati_final1pol[,Oficina1:=V1]
Funsion_ati_final1na[,Oficina1:="No_asociados"]
Funsion_ati_final1pol[,Oficina:=V1]
Funsion_ati_final1na[,Oficina:="No_asociados"]


Funsion_ati_final1<-rbind(Funsion_ati_final1napol,Funsion_ati_final1pol,Funsion_ati_final1na)


isnavacios<-usos_funsionarioTodos[is.na(usos_funsionarioTodos$Oficina)]
isnavacios1<-data.frame(tapply(isnavacios$Nombre,isnavacios[,c("Nombre","Producto")],length))
isnavacios2<-data.frame(tapply(isnavacios$Nombre,isnavacios$Nombre,length))
isnavacios1<-cbind(row.names(isnavacios1),isnavacios1)

# Define UI for application that draws a histogram
ui <- fluidPage(tabsetPanel((tabPanel("ATIPICOS POR PRODUCTO", 
                                     
                                     titlePanel("Tipo de Perfil"),                          sidebarLayout(sidebarPanel(
                                      
                                       
                                       selectInput(inputId = "Años",
                                                   label = "Años:",
                                                   
                                                   choices = list( "2024", "2025")),
                                                   
                                                   
                                       selectInput(inputId = "Mest",
                                                   label = "mes:",
                                                   
                                                   choices = list( "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
                                                   
                                                   
                                       ),
                                       
                                       selectInput(inputId = "TIPODIA",
                                                   label = "DIA_TIPO:",
                                                   
                                                   choices = list( "HAB","SAB","FES")
                                                   
                                       ),
                                       
                                       checkboxInput("FM_ADMINISTRA",
                                                     "FM_ADMINISTRA"),
                                       checkboxInput("FM_OPER.CONTR",
                                                     "FM_OPER.CONTR"),
                                       checkboxInput("FM_TEC.PAT",
                                                     "FM_TEC.PAT"),
                                       checkboxInput("FM_OPER.SUPERV",
                                                     "FM_OPER.SUPERV"),
                                       checkboxInput("FM_OPERA.INSPE",
                                                     "FM_OPERA.INSPE"),
                                       checkboxInput("FM_FACILITADOR",
                                                     "FM_FACILITADOR"),
                                       
                                       checkboxInput("FM...POLICIA",
                                                     "FM_POLICIA"),
                                     )
                                     ,mainPanel(plotOutput("distPlot"))
                                     
),tabPanel("Datos",
           
           titlePanel("Funcionarios"),
           fluidRow(column(DT::dataTableOutput("Funsionario"), width = 12)
                    
                    
           ) 
           
           
           
)

)), tabPanel("USOS Y ATIPICOS POR OFICINA", 
             
             titlePanel("Oficina"),                          sidebarLayout(sidebarPanel(
               
               
               selectInput(inputId = "Añost",
                           label = "Años:",
                           
                           choices = list( "2024", "2025")),
                           
                           
               selectInput(inputId = "Meses",
                           label = "mes:",
                           
                           choices = list( "Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre")
                           
                           
               ),
               
               selectInput(inputId = "Oficinast",
                           label = "Oficina:",
                           
                           choices = list( "DIR OPE - OF-CONTROL","DIR OPE - OF-PLANEACION","DIR OPE - OF-EVALUACION","DIR OPE - MIO CABLE","DIR INFRA - OF-MANTENIMIENTO","DIR INFRA - OF-CONSTRUCCIONES","DIR COMER - OF-CULTURA Y GESTION SOCIAL","DIR COMER - OF-SERV AL CLIENTE","DIR COMER - OF-ATENCION AL CIUDADANO","OFICINA DE SISTEMAS","DIR INFRA - OF-ESTUDIOS, DISEÑO Y LICITACIONES","POL","GUARDA","No_asociados","GIT","BNM","ETM")
                           
                           #choices = list( "DIR COMER - OFIC SERV AL CLIENTE" ,"GIT","BNM","ETM", "DIR INFRAESTRUCTURA - OFICINA DE MANTENIMIENTO" ,"DIR OPE - OF-CONTROL-VIA" ,"DIR OPE - OF-CONTROL-PATIOS", "DIR OPE - OF-CONTROL-CCO" ,"DIR COMER - OFIC CULTURA Y GESTION", "DIR OPER - OF-EVALUACION - MIO CABLE - SKYCABLE" ,"DIR OPE - OF-PLANEACION","OFICINA PLANEACION DE LA OPERACIÓN","JEFE OFICINA EVALUACION DE LA OPERACIÓN" ,"DIR OPER - OF-EVALUACION - MIO CABLE" ,"OFICINA DE SISTEMAS" , "OFICINA DE EVALUACION DE LA OPERACIÓN" ,"DIR OPE - OF-PLANEACION - AFORADOR" , "DIR OPE - OF-CONTROL-SUPERVISOR", "JEFE OFICNA DE SERVCIO AL CLIENTE - VICTOR" ,"DIR COMER - OFIC CULTURA Y GES-SOCIAL","DIRECTORA COMERCIAL Y DE SERVICIO AL CLIENTE" ,"OFICINA EVALUACION DE LA OPERACIÓN","JEFE OFICINA SISTEMAS" ,"DIR OPE - OF-CONTROL-COORDINADOR PATIOS","DIR OPE - OF-CONTROL-MIO CABLE" ,"JEFE OFICINA CONTROL DE LA OPERACIÓN","COORDINADOR CENTRO DE CONTROL")
                           #selected = levels(list(accidentesdia))
                           
               ),
              
               selectInput(inputId = "TIPODIAt",
                           label = "DIA_TIPO:",
                           
                           choices = list( "HAB","SAB","FES")
                           
               ),
               
               selectInput(inputId = "Oficinaszom",
                           label = "Curva  Comparativa:",
                           
                           choices = list( "BNM"                                    ,         "COORDINADOR.CENTRO.DE.CONTROL" ,                 
                                           "DIR.COMER...OFIC.CULTURA.Y.GES.SOCIAL" ,          "DIR.COMER...OFIC.CULTURA.Y.GESTION",             
                                           "DIR.COMER...OFIC.SERV.AL.CLIENTE"       ,         "DIR.INFRA...OF.CONSTRUCCION"        ,            
                                           "DIR.INFRA...OF.ESTUDIOS..DISEÑO.Y.LICITACIONES" , "DIR.INFRAESTRUCTURA...OFICINA.DE.MANTENIMIENTO", 
                                           "DIR.OPE...OF.CONTROL.CCO"            ,            "DIR.OPE...OF.CONTROL.MIO.CABLE"                 ,
                                           "DIR.OPE...OF.CONTROL.PATIOS"  ,                   "DIR.OPE...OF.CONTROL.SUPERVISOR"                ,
                                           "DIR.OPE...OF.CONTROL.VIA"    ,                    "DIR.OPE...OF.PLANEACION"                        ,
                                           "DIR.OPE...OF.PLANEACION...AFORADOR" ,             
                                           "DIRECTORA.COMERCIAL.Y.DE.SERVICIO.AL.CLIENTE"   ,
                                           "ETM"      ,                                       "GIT"                                            ,
                                           "GUARDA"             ,                             "JEFE.OFICINA.CONTROL.DE.LA.OPERACIÓN"           ,
                                           "JEFE.OFICINA.DE.CONSTRUCCION"         ,           "JEFE.OFICINA.EVALUACION.DE.LA.OPERACIÓN"        ,
                                           "JEFE.OFICINA.SISTEMAS"      ,                     "No_asociados"                                   ,
                                           "OFICINA.DE.EVALUACION.DE.LA.OPERACIÓN" ,          "OFICINA.DE.PLANEACION"                          ,
                                           "OFICINA.DE.SISTEMAS"                      ,       "POL" 
                                           
                                           
                           )), 
               
               
               width = 2
               
             )
             ,mainPanel(plotOutput("distPlot2"),
                        plotOutput("distPlot3"),width = 10)
             
       
             
             
             ),tabPanel("Datos1",
                        
                        titlePanel("funcionario1"),
                        fluidRow(column(DT::dataTableOutput("funsionario1"), width = 12)
                                 
                                 
                        ) 
                        
                        
                        
             )
  
  
  
))
        
)




server <- function(input, output) {  output$distPlot <- renderPlot({
  
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Año==input$Años]
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Diatipo==input$TIPODIA]
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Mes==input$Mest]
 
  
  
  d_2<-Funsion_ati_final1[,11]
  Tipo_fun<-data.frame(tapply(Funsion_ati_final1$Qpax,Funsion_ati_final1[,c("Nombre","Producto")],sum))
  nombres_funs<-data.table(colnames(t(Tipo_fun)))
  names(nombres_funs)="Funsionario"
  Tipo_fun<-cbind(nombres_funs,Tipo_fun)
  Tipo_fun<-replace(Tipo_fun,is.na(Tipo_fun),0)
  
  Tipo_fun1<-Tipo_fun[,Total:=sum(Tipo_fun[,c(2:7)])]
  Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$Total,decreasing = T), ]
  
  Tipo_fun2<-Tipo_fun1[Tipo_fun1$Total>0]
  d_1<-t(Tipo_fun1$Total)
  d_3<-"Todos"
  
  if(input$FM_FACILITADOR){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM.FACILITADOR>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM.FACILITADOR,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM.FACILITADOR
    d_2<-"FM-FACILITADOR"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM-FACILITADOR"
    
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM.FACILITADOR,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
    
  }
  
 
  if(input$FM_ADMINISTRA){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM...ADMINISTRA>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM...ADMINISTRA,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM...ADMINISTRA
    d_2<-"FM-ADMINISTRATI"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM-ADMINISTRATI"
    
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM...ADMINISTRA,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
  }
  if(input$FM_OPER.CONTR){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM...OPER.CONTR>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM...OPER.CONTR,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM...OPER.CONTR
    d_2<-"FM-OPERA.CONTR"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM-OPERA.CONTR"
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM...OPER.CONTR,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
    
  }
  if(input$FM_TEC.PAT){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM...TEC.PAT>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM...TEC.PAT,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM...TEC.PAT
    d_2<-"FM-TEC.PATIO"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM-TEC.PATIO"
    
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM...TEC.PAT,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
  }
  
  if(input$FM_OPER.SUPERV){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM..OPER.SUPERV>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM..OPER.SUPERV,decreasing = T), ]
    
   d_1<-Tipo_fun1$FM..OPER.SUPERV
   d_2<-"FM-OPERA.SUPER"
   d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
   d_3<-"FM-OPERA.SUPER"
   
   Tipo_fun3<-Tipo_fun1
   Tipo_fun3[,Funsionario:=paste(Funsionario,FM..OPER.SUPERV,sep = "-")]
   Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
   Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
   Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
  }
  if(input$FM_OPERA.INSPE){
  
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM..OPERA.INSPE>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM..OPERA.INSPE,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM..OPERA.INSPE
    d_2<-"FM-OPERA.INSPE"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM-OPERA.INSPE"
    
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM..OPERA.INSPE,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
  }
  
  if(input$FM...POLICIA){
    
    Tipo_fun1<-Tipo_fun[Tipo_fun$FM...POLICIA>0]
    Tipo_fun1<- Tipo_fun1[order(Tipo_fun1$FM...POLICIA,decreasing = T), ]
    
    d_1<-Tipo_fun1$FM...POLICIA
    d_2<-"FM-FM...POLICIA"
    d_2<-Funsion_ati_final1[Funsion_ati_final1$CD_DESC == d_2]
    d_3<-"FM...POLICIA"
    
    Tipo_fun3<-Tipo_fun1
    Tipo_fun3[,Funsionario:=paste(Funsionario,FM...POLICIA,sep = "-")]
    Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
    Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
    Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<10]
  }
  
  #filter(Tipo %in% input$checktipo) %>%
  
  
  Graf2<-barplot.default(d_1, main = paste("Usos Atipicos de ",input$Mest,"de",input$Años,d_3,sep = " "),ylab = "Usos atipicos" ,names.arg = Tipo_fun1$Funsionario,cex.names=0.8, las=2,col ="red", ylim = c(0,(max(d_1 +50))))
  text(Graf2, (d_1+10) ,labels = d_1)
  legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(Tipo_fun3$Funsionario, sep = " "), col= "red",cex = 0.8,xpd = TRUE)
  
  
})

output$distPlot2 <- renderPlot({
  
  
  #usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Oficina==input$Oficinast]
 
  usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Diatipo==input$TIPODIAt]
  usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Año==input$Añost]
  
  
  usos_funsionarioTodos[,nombremes:=paste(Nombre,Mes)]
  Tipo_fun<-data.frame(tapply(usos_funsionarioTodos$Qpax,usos_funsionarioTodos[,c("nombremes","Oficina")],sum))
  nombres_funs<-data.frame(colnames(t(Tipo_fun)))
  
  Tipo_fun<-cbind(nombres_funs,Tipo_fun)
  Tipo_fun<-replace(Tipo_fun,is.na(Tipo_fun),0)
  
  Tipo_fundef<-Tipo_fun[,-1]
  
  nombres_funs<-data.frame(colnames((Tipo_fundef)))
  names(nombres_funs)="Funsionario"
  Tipo_fundef<-data.table(cbind(nombres_funs,(t(Tipo_fundef))))
  Tipo_fundef<-Tipo_fundef[Tipo_fundef$Funsionario==input$Oficinaszom]
  Tipo_fundef<-data.frame(t(Tipo_fundef))
  
  Tipo_fundef<-data.table(Tipo_fundef[-1,])
  names(Tipo_fundef)="Funsionario"
  Tipo_fundef$Funsionario<-as.numeric(Tipo_fundef$Funsionario)
  Tipo_fundef<-Tipo_fundef[Tipo_fundef$Funsionario>0]
  
  #Tipo_fundef<-Tipo_fundef[,c(input$Oficinaszom,input$Oficinaszom)]
  #Tipo_fundef<-Tipo_fundef[,1]

  
  
  indenti<-boxplot(Tipo_fundef$Funsionario,boxwex=0.8,las=2)
  
  
  grafi2<-data.frame(indenti$stats)
  
  
  usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Oficina1==input$Oficinast]
  usos_funsionarioTodos<-usos_funsionarioTodos[usos_funsionarioTodos$Mes==input$Meses]
  
  
 Tipo_fun<-data.frame(tapply(usos_funsionarioTodos$Qpax,usos_funsionarioTodos[,c("Nombre","Oficina1")],sum))
  nombres_funs<-data.table(colnames(t(Tipo_fun)))
  names(nombres_funs)="Funsionario"
  Tipo_fun<-cbind(nombres_funs,Tipo_fun)
  Tipo_fun<-replace(Tipo_fun,is.na(Tipo_fun),0)
 
  
  Tipo_fun<- Tipo_fun[order(Tipo_fun[,2],decreasing = T), ]
  
  Tipo_fun1<-Tipo_fun
  Tipo_fun1<-Tipo_fun1[,-1]
  
  Tipo_fun3<-Tipo_fun
  names(Tipo_fun3)=c("Funsionario","Total")
  Tipo_fun3[,Funsionario:=paste(Tipo_fun3$Funsionario,Tipo_fun3$Total,sep = "-")]
  
  Tipo_fun3[,maximo:=grafi2[3,1]]
  Tipo_fun4<-Tipo_fun3[,3]
  Tipo_fun3<-Tipo_fun3[,-3]
  Tipo_fun3<-as.data.table(cbind(row.names(Tipo_fun3),Tipo_fun3))
  Tipo_fun3$V1<-as.numeric(Tipo_fun3$V1)
  Tipo_fun3<-Tipo_fun3[Tipo_fun3$V1<15]
 
  #Funsionariox<-barplot(t(Tipo_fun[,2]))


  #Funsionariox<-barplot(t(Tipo_fun[,2]))
  

  Funsionariox<-barplot(t(Tipo_fun1[,1]) ,main = paste((input$Oficinast),"Usos de",input$Meses,"de",input$Añost,input$TIPODIAt,sep = " "),ylab = "cantidad", col = "lightblue" , cex.names=0.8,cex.axis = 1.2,names.arg = Tipo_fun$Funsionario,cex.lab = 1.1, las=2,ylim = c(0,(max(Tipo_fun1 +10))))
  text(Funsionariox, (t(Tipo_fun1[,1]))+2 ,labels = t(Tipo_fun1[,1]))
  lines(Funsionariox,(t(Tipo_fun4[,1])) , type = "o", lwd = 3,col = "yellow")
  legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(Tipo_fun3$Funsionario, sep = " "), col= "lightblue",cex = 0.8,xpd = TRUE)
  legend(x = "top",bty = "n",lty = 1,horiz = F, legend = paste("Ofi. comparativa-media de ",input$Oficinaszom ), col= "yellow",cex = 1.1,xpd = TRUE)
  
  
})

output$distPlot3 <- renderPlot({
  
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Oficina1==input$Oficinast]
  
  #Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Oficina==input$Oficinast]
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Diatipo==input$TIPODIAt]
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Mes==input$Meses]
  Funsion_ati_final1<-Funsion_ati_final1[Funsion_ati_final1$Año==input$Añost]
 
  Tipo_fun<-data.frame(tapply(Funsion_ati_final1$Qpax,Funsion_ati_final1[,c("Nombre","Oficina1")],sum))
  nombres_funs<-data.table(colnames(t(Tipo_fun)))
  names(nombres_funs)="Funsionario"
  Tipo_fun<-cbind(nombres_funs,Tipo_fun)
  Tipo_fun<-replace(Tipo_fun,is.na(Tipo_fun),0)
  Tipo_fun<- Tipo_fun[order(Tipo_fun[,2],decreasing = T), ]
  
  Tipo_fun1<-Tipo_fun
  Tipo_fun1<-Tipo_fun1[,-1]
  
  Tipo_fun3<-Tipo_fun
  names(Tipo_fun3)=c("Funsionario","Total")
  Tipo_fun3[,Funsionario:=paste(Tipo_fun3$Funsionario,Tipo_fun3$Total,sep = "-")]
  
  #Funsionariox<-barplot(t(Tipo_fun[,2]))
  Funsionariox<-barplot(t(Tipo_fun1[,1]) ,main = paste((input$Oficinast),"Atipicos de",input$Meses,"de",input$Añost,input$TIPODIAt,sep = " "),ylab = "cantidad", col = "red" , cex.names=0.8,cex.axis = 1.2,names.arg = Tipo_fun$Funsionario,cex.lab = 1.1, las=2,ylim = c(0,(max(Tipo_fun1 +10))))
  text(Funsionariox, (t(Tipo_fun1[,1]))+2 ,labels = t(Tipo_fun1[,1]))
  legend(x = "topright",bty = "n",lty = 1,horiz = F, legend = paste(Tipo_fun3$Funsionario, sep = " "), col= "red",cex = 0.8,xpd = TRUE)
  
  
})
output$Funsionario <- DT::renderDataTable(
  #DT::datatable({diamonds}, options = list(lenghtMenu= list(c(7,15,-1), c(5,15, "All")), pagelenght= 15), filter = "top")
  DT::datatable({Funsion_ati_final1}, options = list(lenghtMenu= list(c(7,15,-1), c(5,15, "All")), pagelenght= 15), filter = "top")
  
)
 
output$funsionario1 <- DT::renderDataTable(
   
   DT::datatable({usos_funsionarioTodos}, options = list(lenghtMenu= list(c(7,15,-1), c(5,15, "All")), pagelenght= 15), filter = "top")
)
  
  
  
}
  
  
  



# Run the applicatio
shinyApp(ui = ui, server = server, options = list(host = "0.0.0.0",port=9001))
#shinyApp(ui = ui, server = server)
