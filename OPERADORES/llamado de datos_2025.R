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

Corte<-"2026-04-01"


if (rstudioapi::isAvailable()) {
  current_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  #current_dir <- file.path(getwd(), "02 - Salidas")
  current_dir <- file.path(getwd())
}
current_dir




load(str_c(current_dir,"/salidastodaOperadorFAM.RData"))#salida ultimo ok
#load(str_c(getwd(),"/cuartiles751.RData"))#salida ultimo
#load(str_c(getwd(),"/cuartiles75COT.RData"))#salida ultimo



load(str_c(current_dir,"/salidastodaOperadorF.RData"))#salida ultimo ok
load(str_c(current_dir,"/cuartiles751.RData"))#salida ultimo ok
load(str_c(current_dir,"/cuartiles75COT.RData"))#salida ultimo ok

load(str_c(current_dir,"/usostodos.RData"))#scrip operador..POR DIA_MES    IGUAL ok
load(str_c(current_dir,"/Atrasos.RData"))#scrip operador..POR DIA_MES      IGUAL ok
load(str_c(current_dir,"/adelantos.RData"))#scrip operador..POR DIA_MES    IGUAL ok
load(str_c(current_dir,"/salidas.RData"))#salida ultimo POR DIA_MES       IGUAL ok

load(str_c(current_dir,"/Ano_MES_Objet.RData"))#libre inamovible
load(str_c(current_dir,"/BaseDatosReinci.RData"))#historia de conducta del operador 

Maximafehc<-usostodos[,c(18)]
Maximafehc<-max(as.Date(Maximafehc$FECHAD,origin = "1899-12-30"))
Maximafehc1 <- data.table("usos")
Maximafehc1 <- cbind(Maximafehc1,Maximafehc)

Maximafehc<-(salidas_todas_dia1[,c(6)])
Maximafehc<-max(as.Date(Maximafehc$Fecha,origin = "1899-12-30"))
Maximafehc2 <- data.table("salidas")
Maximafehc2 <- cbind(Maximafehc2,Maximafehc)


Maximafehc<-(OperadorAtrazo[,c(1)])
Maximafehc[,"Dia Operativo":=paste(substr(Maximafehc$`Dia Operativo`,7,11),substr(Maximafehc$`Dia Operativo`,4,5),substr(Maximafehc$`Dia Operativo`,1,2),sep = "-")]
Maximafehc<-max(as.Date(Maximafehc$`Dia Operativo`,origin = "1899-12-30"))
Maximafehc3<- data.table("Atraso")
Maximafehc3<- cbind(Maximafehc3,Maximafehc)

Maximafehc<-(OperadorAdelando[,c(1)])
Maximafehc[,"Dia Operativo":=paste(substr(Maximafehc$`Dia Operativo`,7,11),substr(Maximafehc$`Dia Operativo`,4,5),substr(Maximafehc$`Dia Operativo`,1,2),sep = "-")]
Maximafehc<-max(as.Date(Maximafehc$`Dia Operativo`,origin = "1899-12-30"))
Maximafehc4<- data.table("adelanto")
Maximafehc4<- cbind(Maximafehc4,Maximafehc)

Maximafehc<-rbind(Maximafehc1,Maximafehc2,Maximafehc3,Maximafehc4)


names(Maximafehc)=c("Tipo","Corte")
Maximafehc[,Tipo2:=Tipo]
Maximafehcindi<-Maximafehc


Maximafehc$Tipo2<-replace(Maximafehc$Tipo2,Maximafehc$Tipo2== "usos","tasa_usosQ25")
Maximafehc$Tipo2<-replace(Maximafehc$Tipo2,Maximafehc$Tipo2== "salidas","tasa_Salidas")
Maximafehc$Tipo2<-replace(Maximafehc$Tipo2,Maximafehc$Tipo2== "Atraso","Porcentaje Atraso")
Maximafehc$Tipo2<-replace(Maximafehc$Tipo2,Maximafehc$Tipo2== "adelanto","Porcentaje Adelantos")



Maximafehcindi[,Tipo2:="Indicador general"]

Maximafehc<-rbind(Maximafehc,Maximafehcindi)

Maximafehc$Corte<-as.character(Maximafehc$Corte)
#Maximafehc<-as.data.frame(Maximafehc)

BaseDatosReinci$Fecha<-as.Date(BaseDatosReinci$Fecha,origin = "1899-12-30")
BaseDatosReinci<-BaseDatosReinci[BaseDatosReinci$Fecha < Corte]

salidastodaOperadorFAM$COT<-replace(salidastodaOperadorFAM$COT,salidastodaOperadorFAM$COT== "1","GIT")
salidastodaOperadorFAM$COT<-replace(salidastodaOperadorFAM$COT,salidastodaOperadorFAM$COT== "3","ETM")
salidastodaOperadorFAM$COT<-replace(salidastodaOperadorFAM$COT,salidastodaOperadorFAM$COT== "2","BYN")


salidas<-salidastodaOperadorFAM[,c(1:4,5,14,12)]
Adelantos<-salidastodaOperadorFAM[,c(1:4,5,14,25)]
atrasos<-salidastodaOperadorFAM[,c(1:4,5,14,26)]
usos<-salidastodaOperadorFAM[,c(1:4,5,14,21)]


salidas[,Tipo:="tasa_Salidas"]

caja<-boxplot(salidas$tasa_Salidas)
cuartiles<-data.frame(round(caja$stats,0))
cuartilsalida<-data.table(cuartiles)
cuartilsalida<-cuartilsalida[4,1]
cuartilsalida[,Tipo:="Salida"]



salidasclas1<-salidas[salidas$tasa_Salidas>=cuartiles[4,1]]
salidasclas1[,Clasificacion:=1]

salidasclas0<-salidas[salidas$tasa_Salidas<cuartiles[4,1]]
salidasclas0[,Clasificacion:=0]

salidas<-rbind(salidasclas0,salidasclas1)


Adelantos[,Tipo:="Porcentaje Adelantos"]

caja<-boxplot(Adelantos$`Porcentaje Adelantos`)
cuartiles<-data.frame(round(caja$stats,0))
cuartiladelanto<-data.table(cuartiles)
cuartiladelanto<-cuartiladelanto[4,1]
cuartiladelanto[,Tipo:="Adelanto"]


Adelantosclas1<-Adelantos[Adelantos$`Porcentaje Adelantos`>=cuartiles[4,1]]
Adelantosclas1[,Clasificacion:=1]

Adelantosclas0<-Adelantos[Adelantos$`Porcentaje Adelantos`<cuartiles[4,1]]
Adelantosclas0[,Clasificacion:=0]

Adelantos<-rbind(Adelantosclas0,Adelantosclas1)



atrasos[,Tipo:="Porcentaje Atraso"]

caja<-boxplot(atrasos$`Porcentaje Atraso`)
cuartiles<-data.frame(round(caja$stats,0))
cuartilatraso<-data.table(cuartiles)
cuartilatraso<-cuartilatraso[4,1]
cuartilatraso[,Tipo:="Atraso"]

atrasosclas1<-atrasos[atrasos$`Porcentaje Atraso`>=cuartiles[4,1]]
atrasosclas1[,Clasificacion:=1]

atrasosclas0<-atrasos[atrasos$`Porcentaje Atraso`<cuartiles[4,1]]
atrasosclas0[,Clasificacion:=0]

atrasos<-rbind(atrasosclas0,atrasosclas1)




usos[,Tipo:="tasa_usosQ25"]
caja<-boxplot(usos$tasa_usosQ25)
cuartiles<-data.frame(round(caja$stats,0))
cuartilUsos<-data.table(cuartiles)
cuartilUsos<-cuartilUsos[4,1]
cuartilUsos[,Tipo:="Usos"]

usosclas1<-usos[usos$tasa_usosQ25>=cuartiles[4,1]]
usosclas1[,Clasificacion:=1]

usosclas0<-usos[usos$tasa_usosQ25<cuartiles[4,1]]
usosclas0[,Clasificacion:=0]

usos<-rbind(usosclas0,usosclas1)


names(salidas)=c("Año","Mes","Operador","Dia tipo","Comparativos","COT","Total","Tipo","Clasificacion")
names(Adelantos)=c("Año","Mes","Operador","Dia tipo","Comparativos","COT","Total","Tipo","Clasificacion")
names(atrasos)=c("Año","Mes","Operador","Dia tipo","Comparativos","COT","Total","Tipo","Clasificacion")
names(usos)=c("Año","Mes","Operador","Dia tipo","Comparativos","COT","Total","Tipo","Clasificacion")

Tasas<-rbind(salidas,Adelantos,atrasos,usos)

cuartilesUSAA<-rbind(cuartilsalida,cuartiladelanto,cuartilatraso,cuartilUsos)
names(cuartilesUSAA)=c("total","Tipo")
###############
Tasas[,Año_op:=paste(Año,Mes,Operador,Tasas$`Dia tipo`,sep = "_")]

Tasasclasi<-data.frame(tapply(Tasas$Clasificacion,Tasas$Año_op,sum))
Tasasclasi<-cbind(colnames(t(Tasasclasi)),Tasasclasi)
tab<-str_split_fixed(Tasasclasi$`colnames(t(Tasasclasi))`,"_",4)
Tasasclasi<-as.data.table(cbind(tab,Tasasclasi))
names(Tasasclasi)=c("Año","Mes","Operador","Dia tipo","Año_op","Total")


Tasasclasi[,Comparativos:=Año_op]

Tasasclasi[,COT:=substr(Tasasclasi$Operador,1,1)]
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "1","GIT")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "3","ETM")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "2","BYN")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "4","UNM")

Tasasclasi<-Tasasclasi[,c(1:4,7,8,6)]
Tasas<-Tasas[,-c(9,10)]
Tasasclasi[,Tipo:="Indicador general"]

Tasas<-rbind(Tasasclasi,Tasas)

Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "01","Enero")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "02","Febrero")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "03","Marzo")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "04","Abril")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "05","Mayo")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "06","Junio")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "07","Julio")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "08","Agosto")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "09","Septiembre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "10","Octubre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "11","Novimbre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "12","Diciembre")


Tasas[,Año_op:=paste(Año,Operador,Tasas$`Dia tipo`,Tipo,sep = "_")]

TasasAño<-data.frame(tapply(Tasas$Total,Tasas$Año_op,mean))
TasasAño<-cbind(colnames(t(TasasAño)),TasasAño)
tab<-str_split_fixed(TasasAño$`colnames(t(TasasAño))`,"_",4)
TasasAño<-as.data.table(cbind(tab,TasasAño))
names(TasasAño)=c("Año","Operador","Dia tipo","Tipo","Año_op","Total")

TasasAño[,Mes:=paste("Promedio",Año,sep = " ")]
TasasAño[,Comparativos:=paste(Año,Mes,Operador,TasasAño$`Dia tipo`,sep = "_")]

TasasAño[,COT:=substr(TasasAño$Operador,1,1)]
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "1","GIT")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "3","ETM")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "2","BYN")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "4","UNM")

TasasAño<-TasasAño[,c(1,7,2,3,8,9,6,4)]

#TasasAño<-TasasAño[TasasAño$Tipo!="Indicador general"]



Tasas<-Tasas[,-9]



Tasas<-rbind(TasasAño,Tasas)


Tasas$Total<-round(Tasas$Total,0)


TasasT<-Tasas


###########################################################################
salidas<-salidastodaOperadorFAM[,c(1:3,5,14,12)]
Adelantos<-salidastodaOperadorFAM[,c(1:3,5,14,25)]
atrasos<-salidastodaOperadorFAM[,c(1:3,5,14,26)]
usos<-salidastodaOperadorFAM[,c(1:3,5,14,21)]


salidas[,Tipo:="tasa_Salidas"]


caja<-boxplot(salidas$tasa_Salidas)
cuartiles<-data.frame(round(caja$stats,0))
cuartilsalida<-data.table(cuartiles)
cuartilsalida<-cuartilsalida[4,1]
cuartilsalida[,Tipo:="Salida"]



salidasclas1<-salidas[salidas$tasa_Salidas>=cuartiles[4,1]]
salidasclas1[,Clasificacion:=1]

salidasclas0<-salidas[salidas$tasa_Salidas<cuartiles[4,1]]
salidasclas0[,Clasificacion:=0]

salidas<-rbind(salidasclas0,salidasclas1)


Adelantos[,Tipo:="Porcentaje Adelantos"]

caja<-boxplot(Adelantos$`Porcentaje Adelantos`)
cuartiles<-data.frame(round(caja$stats,0))
cuartiladelanto<-data.table(cuartiles)
cuartiladelanto<-cuartiladelanto[4,1]
cuartiladelanto[,Tipo:="Adelanto"]


Adelantosclas1<-Adelantos[Adelantos$`Porcentaje Adelantos`>=cuartiles[4,1]]
Adelantosclas1[,Clasificacion:=1]

Adelantosclas0<-Adelantos[Adelantos$`Porcentaje Adelantos`<cuartiles[4,1]]
Adelantosclas0[,Clasificacion:=0]

Adelantos<-rbind(Adelantosclas0,Adelantosclas1)



atrasos[,Tipo:="Porcentaje Atraso"]

caja<-boxplot(atrasos$`Porcentaje Atraso`)
cuartiles<-data.frame(round(caja$stats,0))
cuartilatraso<-data.table(cuartiles)
cuartilatraso<-cuartilatraso[4,1]
cuartilatraso[,Tipo:="Atraso"]

atrasosclas1<-atrasos[atrasos$`Porcentaje Atraso`>=cuartiles[4,1]]
atrasosclas1[,Clasificacion:=1]

atrasosclas0<-atrasos[atrasos$`Porcentaje Atraso`<cuartiles[4,1]]
atrasosclas0[,Clasificacion:=0]

atrasos<-rbind(atrasosclas0,atrasosclas1)




usos[,Tipo:="tasa_usosQ25"]
caja<-boxplot(usos$tasa_usosQ25)
cuartiles<-data.frame(round(caja$stats,0))
cuartilUsos<-data.table(cuartiles)
cuartilUsos<-cuartilUsos[4,1]
cuartilUsos[,Tipo:="Usos"]

usosclas1<-usos[usos$tasa_usosQ25>=cuartiles[4,1]]
usosclas1[,Clasificacion:=1]

usosclas0<-usos[usos$tasa_usosQ25<cuartiles[4,1]]
usosclas0[,Clasificacion:=0]

usos<-rbind(usosclas0,usosclas1)


names(salidas)=c("Año","Mes","Operador","Comparativos","COT","Total","Tipo","Clasificacion")
names(Adelantos)=c("Año","Mes","Operador","Comparativos","COT","Total","Tipo","Clasificacion")
names(atrasos)=c("Año","Mes","Operador","Comparativos","COT","Total","Tipo","Clasificacion")
names(usos)=c("Año","Mes","Operador","Comparativos","COT","Total","Tipo","Clasificacion")

Tasas<-rbind(salidas,Adelantos,atrasos,usos)

cuartilesUSAA<-rbind(cuartilsalida,cuartiladelanto,cuartilatraso,cuartilUsos)
names(cuartilesUSAA)=c("total","Tipo")
###############
Tasas[,Año_op:=paste(Año,Mes,Operador,sep = "_")]

Tasasclasi<-data.frame(tapply(Tasas$Clasificacion,Tasas$Año_op,sum))
Tasasclasi<-cbind(colnames(t(Tasasclasi)),Tasasclasi)
tab<-str_split_fixed(Tasasclasi$`colnames(t(Tasasclasi))`,"_",3)
Tasasclasi<-as.data.table(cbind(tab,Tasasclasi))
names(Tasasclasi)=c("Año","Mes","Operador","Año_op","Total")


Tasasclasi[,Comparativos:=Año_op]

Tasasclasi[,COT:=substr(Tasasclasi$Operador,1,1)]
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "1","GIT")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "3","ETM")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "2","BYN")
Tasasclasi$COT<-replace(Tasasclasi$COT,Tasasclasi$COT== "4","UNM")

Tasasclasi<-Tasasclasi[,c(1:3,6,7,5)]
Tasas<-Tasas[,-c(8,9)]
Tasasclasi[,Tipo:="Indicador general"]

Tasas<-rbind(Tasasclasi,Tasas)

###############
Tasas[,Año_op:=paste(Año,Operador,Tipo,sep = "_")]

TasasAño<-data.frame(tapply(Tasas$Total,Tasas$Año_op,mean))
TasasAño<-cbind(colnames(t(TasasAño)),TasasAño)
tab<-str_split_fixed(TasasAño$`colnames(t(TasasAño))`,"_",3)
TasasAño<-as.data.table(cbind(tab,TasasAño))
names(TasasAño)=c("Año","Operador","Tipo","Año_op","Total")

TasasAño[,Mes:=paste("Promedio",Año,sep = " ")]
TasasAño[,Comparativos:=paste(Año,Mes,Operador,sep = "_")]

TasasAño[,COT:=substr(TasasAño$Operador,1,1)]
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "1","GIT")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "3","ETM")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "2","BYN")
TasasAño$COT<-replace(TasasAño$COT,TasasAño$COT== "4","UNM")

TasasAño<-TasasAño[,c(1,6,2,7,8,5,3)]
Tasas<-Tasas[,-8]
Tasas<-rbind(TasasAño,Tasas)

Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "01","Enero")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "02","Febrero")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "03","Marzo")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "04","Abril")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "05","Mayo")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "06","Junio")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "07","Julio")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "08","Agosto")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "09","Septiembre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "10","Octubre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "11","Novimbre")
Tasas$Mes<-replace(Tasas$Mes,Tasas$Mes== "12","Diciembre")

Tasas$Total<-round(Tasas$Total,0)

salidasT<-salidastodaOperadorFAM[,c(1:5,14,11)]
AdelantosT<-salidastodaOperadorFAM[,c(1:5,14,20)]
atrasosT<-salidastodaOperadorFAM[,c(1:5,14,19)]
usosT<-salidastodaOperadorFAM[,c(1:5,14,18)]

salidasT[,Tipo:="Total_Salidas"]
AdelantosT[,Tipo:="Total Adelantos"]
atrasosT[,Tipo:="Total Atrasos"]
usosT[,Tipo:="Total_usosQ25"]

names(salidasT)=c("Año","Mes","Operador","Dia_tipo","Comparativos","COT","Total","Tipo")
names(AdelantosT)=c("Año","Mes","Operador","Dia_tipo","Comparativos","COT","Total","Tipo")
names(atrasosT)=c("Año","Mes","Operador","Dia_tipo","Comparativos","COT","Total","Tipo")
names(usosT)=c("Año","Mes","Operador","Dia_tipo","Comparativos","COT","Total","Tipo")

Total<-rbind(salidasT,AdelantosT,atrasosT,usosT)

#Total[,Año_op:=paste(Año,Operador,Dia_tipo,Tipo,sep = "_")]
Total[,Año_op:=paste(Año,Operador,Tipo,sep = "_")]

Totalaño<-data.frame(tapply(Total$Total,Total$Año_op,sum))
Totalaño<-cbind(colnames(t(Totalaño)),Totalaño)
tab<-str_split_fixed(Totalaño$`colnames(t(Totalaño))`,"_",3)
Totalaño<-as.data.table(cbind(tab,Totalaño))
names(Totalaño)=c("Año","Operador","Tipo","Comparativos","Total")

#TasasAño1<-TasasAño[,c(1,3,4,8,5,7)]
#names(TasasAño1)=c("Año","Operador","Dia tipo","Tipo","Comparativos","Total")

#Totalaño<-rbind(Totalaño,TasasAño1)

TasasAño<-TasasAño[TasasAño$Tipo!="Indicador general"]

TasasAño$Total<-round(TasasAño$Total,0)

#determinan los niveles de reincidencia alto, medio, bajo y seis novedades en los ultimos seis meses 
load(str_c(current_dir,"/BDM_A_B.RData"))#base de datos para los novedades de todos los niveles de reincidencia ok
load(str_c(current_dir,"/seisBDM_A_B.RData"))#novedades de los seis meses-debe hacer un filtro para determinar 6 novedades en los ultimos seis meses 
load(str_c(current_dir,"/altomediobajo.RData"))#los pocicionados en esos niveles ok

BaseDatosReinci<-BaseDatosReinci[as.numeric(BaseDatosReinci$Año)>2023]


#BaseDatosReinci<-BaseDatosReinci[,c(3,4,1,5:12,2)]

BaseDatosReinci[,COT:=substr(BaseDatosReinci$Operador,1,1)]
BaseDatosReinci$COT<-replace(BaseDatosReinci$COT,BaseDatosReinci$COT== "1","GIT")
BaseDatosReinci$COT<-replace(BaseDatosReinci$COT,BaseDatosReinci$COT== "3","ETM")
BaseDatosReinci$COT<-replace(BaseDatosReinci$COT,BaseDatosReinci$COT== "2","BYN")
BaseDatosReinci$COT<-replace(BaseDatosReinci$COT,BaseDatosReinci$COT== "4","UNM")
BaseDatosReinci<-BaseDatosReinci[BaseDatosReinci$COT!="N"]
BaseDatosReinci<-BaseDatosReinci[BaseDatosReinci$COT!="UNM"]

BaseDatosReinci[,ceros:=substr(BaseDatosReinci$Operador,2,6)]
BaseDatosReinci<-BaseDatosReinci[BaseDatosReinci$ceros!="000"]
BaseDatosReinci<-BaseDatosReinci[,-13]

bitacora<-BaseDatosReinci[BaseDatosReinci$Fuente=="Bitaco"]
Quejas<-BaseDatosReinci[BaseDatosReinci$Fuente=="Quejas"]
Acci_de_bitaco<-BaseDatosReinci[BaseDatosReinci$Fuente=="Acci_de_bitaco"]


Transito<-BaseDatosReinci[BaseDatosReinci$Fuente=="Transito"]
TABV<-str_split_fixed(bitacora$jerarquias,"::",4)

bitacora<-cbind(bitacora,TABV)
file_path <- file.path(current_dir, "Accidentalidad Consolidada.xlsx")
Niveles<-as.data.table(read_excel(file_path, sheet = "Tabla Detallada", col_names = F))

colnames(Niveles)=c("Fuente","jerarquias","Conducta","Nivel","reincidenc")
Niveles<-Niveles[-c(1,2),-c(1,3,5)]

setkey(Niveles,jerarquias)
setkey(bitacora,jerarquias)

bitacora<- Niveles[bitacora,all=T]
bitacora<-bitacora[,c(3,4,1,5:17,2)]
bitacora$Nivel<-replace(bitacora$Nivel,is.na(bitacora$Nivel),"Informativa")
bitacora$Fuente<-replace(bitacora$Fuente,bitacora$Fuente=="Bitaco","Novedades")

bitacora[,Fuente:=paste(Fuente,Nivel)]

#bitacora<-bitacora[,-17]

TABV<-str_split_fixed(Quejas$jerarquias,"::",5)
Quejas<-cbind(Quejas,TABV)

TABV<-str_split_fixed(Acci_de_bitaco$jerarquias,"::",5)
Acci_de_bitaco<-cbind(Acci_de_bitaco,TABV)
Acci_de_bitacoIN<-Acci_de_bitaco[Acci_de_bitaco$V2=="SALIDAS"]
Acci_de_bitacoSA<-Acci_de_bitaco[Acci_de_bitaco$V2!="SALIDAS"]


TABV<-str_split_fixed(Transito$jerarquias,":",2)
Transito<-cbind(Transito,TABV)

Acci_de_bitacoIN[,Novedad:=V3]

Acci_de_bitacoSA[,Novedad:=V2]

Acci_de_bitaco<-rbind(Acci_de_bitacoIN,Acci_de_bitacoSA)
Acci_de_bitaco<-Acci_de_bitaco[Acci_de_bitaco$Novedad!="POR VANDALISMO"]
Acci_de_bitaco$Novedad<-replace(Acci_de_bitaco$Novedad,Acci_de_bitaco$Novedad== "INCIDENTE","POR ACCIDENTE CHOQUE SIMPLE")


bitacora[,Novedad:=V4]
Transito[,Novedad:=V1]
Quejas[,Novedad:=V4]

Acci_de_bitaco<-Acci_de_bitaco[,-c(13:17)]
bitacora<-bitacora[,-c(13:17)]



Transito<-Transito[,-c(13:14)]
Transito<-Transito[Transito$vehiculo>0]

Quejas<-Quejas[,-c(13:17)]

Acci_de_bitaco[,Fuente:="Accidentalidad"]
#bitacora[,Fuente:="Bitacora"]
Transito[,Fuente:="Transito"]
Quejas[,Fuente:="Quejas"]

BaseDatosReinci<-rbind(Acci_de_bitaco,bitacora,Quejas,Transito)
BaseDatosReinci$Fuente<-gsub(" ","",BaseDatosReinci$Fuente)

seisBDM_A_B[,COT:=substr(seisBDM_A_B$Operador,1,1)]
seisBDM_A_B$COT<-replace(seisBDM_A_B$COT,seisBDM_A_B$COT== "1","GIT")
seisBDM_A_B$COT<-replace(seisBDM_A_B$COT,seisBDM_A_B$COT== "3","ETM")
seisBDM_A_B$COT<-replace(seisBDM_A_B$COT,seisBDM_A_B$COT== "2","BYN")

altomediobajo[,COT:=substr(altomediobajo$conductor,1,1)]
altomediobajo$COT<-replace(altomediobajo$COT,altomediobajo$COT== "1","GIT")
altomediobajo$COT<-replace(altomediobajo$COT,altomediobajo$COT== "3","ETM")
altomediobajo$COT<-replace(altomediobajo$COT,altomediobajo$COT== "2","BYN")


#load(str_c(getwd(),"/totalparadas1.RData"))#scrip operador..
salidas_todas_dia1$CODIGO_OPERADOR<-as.numeric(salidas_todas_dia1$CODIGO_OPERADOR)
salidas_todas_dia1$CODIGO_OPERADOR<-as.character(salidas_todas_dia1$CODIGO_OPERADOR)

cuartiles75<-cuartiles751[,c(1,2,5,6)]
names(cuartiles75)=c("Tasa_salidas"  , "tasa_usosQ25" ,  "tasa_Adelantos", "tasa_Atrazos" )
cuartiles75COT1<-cuartiles75COT[,-4]



Operadoresfinales<-data.table(unique(salidas_todas_dia1[,c(33)]))

Operadoresfinales[,Operador:=Operadoresfinales$CODIGO_OPERADOR]

OperadorAdelando$Operador<-as.character(OperadorAdelando$Operador)
OperadorAtrazo$Operador<-as.character(OperadorAtrazo$Operador)


#usostodos<-as.data.table(usostodos)

OperadorAdelando<-as.data.table(OperadorAdelando)
OperadorAtrazo<-as.data.table(OperadorAtrazo)

#usostodos[,Operador:=usostodos$CONDUCTOR]

setkey(OperadorAtrazo,Operador)
setkey(OperadorAdelando,Operador)
#setkey(usostodos,Operador)
setkey(Operadoresfinales,Operador)

#usostodos<-usostodos[Operadoresfinales, all= TRUE]
OperadorAdelando<-OperadorAdelando[Operadoresfinales, all= TRUE]
OperadorAtrazo<-OperadorAtrazo[Operadoresfinales, all= TRUE]

OperadorAdelando<-OperadorAdelando[,-26]
OperadorAtrazo<-OperadorAtrazo[,-26]

Operadoresfinales<-data.table(unique(salidas_todas_dia1[,c(33)]))

Operadoresfinales[,CONDUCTOR:=Operadoresfinales$CODIGO_OPERADOR]

usostodos<-as.data.table(usostodos)

setkey(usostodos,CONDUCTOR)
setkey(Operadoresfinales,CONDUCTOR)

usostodos<-usostodos[Operadoresfinales, all= TRUE]

usostodos<-usostodos[,-20]


salidastodaOperadorFAM$horas<-round(salidastodaOperadorFAM$horas,0)
salidastodaOperadorFAM$tasa_Atrazos<-round(salidastodaOperadorFAM$tasa_Atrazos,0)
salidastodaOperadorFAM$tasa_Adelantos<-round(salidastodaOperadorFAM$tasa_Adelantos,0)
salidastodaOperadorFAM$tasa_usosQ25<-round(salidastodaOperadorFAM$tasa_usosQ25,0)
salidastodaOperadorFAM$`Porcentaje Adelantos`<-round(salidastodaOperadorFAM$`Porcentaje Adelantos`,0)
salidastodaOperadorFAM$`Porcentaje Atraso`<-round(salidastodaOperadorFAM$`Porcentaje Atraso`,0)

salidastodaOperadorFAM[,tasa_Adelantos:=`Porcentaje Adelantos`]
salidastodaOperadorFAM[,tasa_Atrazos:=`Porcentaje Atraso`]

salidastodaOperadorOP<-salidastodaOperadorFAM[,c(1:4,14,6,7:13,15:26)]
salidastodaOperadorFAM<-salidastodaOperadorFAM[,-14]

##########Pendiente



#salidastodaOperador$indicadores<-replace(salidastodaOperador$indicadores,salidastodaOperador$indicadores=="veces_usos_Q25","N° de viajes con usos bajos")





#salidastodaOperadorF$horas<-round(salidastodaOperadorF$horas,0)
#salidastodaOperadorF$tasa_Atrazos<-round(salidastodaOperadorF$tasa_Atrazos,0)
#salidastodaOperadorF$tasa_Adelantos<-round(salidastodaOperadorF$tasa_Adelantos,0)
#salidastodaOperadorF$tasa_usosQ25<-round(salidastodaOperadorF$tasa_usosQ25,0)
#salidastodaOperadorF$`Porcentaje Adelantos`<-round(salidastodaOperadorF$`Porcentaje Adelantos`,0)
#salidastodaOperadorF$`Porcentaje Atraso`<-round(salidastodaOperadorF$`Porcentaje Atraso`,0)

#salidastodaOperadorF[,tasa_Adelantos:=`Porcentaje Adelantos`]
#salidastodaOperadorF[,tasa_Atrazos:=`Porcentaje Atraso`]

#salidastodaOperadorOP<-salidastodaOperadorF[,c(1,11,2:10,13:19)]



#salidastodaOperadorF<-salidastodaOperadorF[,-c(11,12)]

#salidastodaOperador<-data.frame(t(salidastodaOperadorFAM))

#colnames(salidastodaOperador)<-salidastodaOperador[1,]
#salidastodaOperador<-salidastodaOperador[-1,]
#indicadores<-row.names(salidastodaOperador)
#names(indicadores)="indicadores"
#salidastodaOperador<-cbind(indicadores,salidastodaOperador)

usostodos<-replace(usostodos,is.na(usostodos),0)
usostodos<-usostodos[usostodos$CONDUCTOR != 0]


#salidastodaOperador$indicadores<-replace(salidastodaOperador$indicadores,salidastodaOperador$indicadores=="veces_usos_Q25","N° de viajes con usos bajos")



#usostodos$CONDUCTOR<-as.character(usostodos$CONDUCTOR)
#usoshabil$CONDUCTOR<-as.character(usoshabil$CONDUCTOR)

salidas_todas_dia1[,Año:=substr(salidas_todas_dia1$Fecha,1,4)]
OperadorAtrazo[,Año:=substr(OperadorAtrazo$`Dia Operativo`,7,11)]
OperadorAdelando[,Año:=substr(OperadorAdelando$`Dia Operativo`,7,11)]

usosOpemes<-usostodos
usosOpemes[,Mes:= substr(usosOpemes$FECHA,4,5)]
usosOpemes[,Año:= substr(usosOpemes$FECHA,7,11)]
OperadorAdelando[,Mes:=substr(OperadorAdelando$`Dia Operativo`,4,5)]
OperadorAtrazo[,Mes:=substr(OperadorAtrazo$`Dia Operativo`,4,5)]

#OperadorAdelando<-OperadorAdelando[OperadorAdelando$Operador]
#OperadorAtrazo<-OperadorAtrazo[OperadorAtrazo$Operador]

OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "01","Enero")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "02","Febrero")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "03","Marzo")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "04","Abril")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "05","Mayo")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "06","Junio")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "07","Julio")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "08","Agosto")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "09","Septiembre")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "10","Octubre")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "11","Novimbre")
OperadorAtrazo$Mes<-replace(OperadorAtrazo$Mes,OperadorAtrazo$Mes== "12","Diciembre")

OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "01","Enero")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "02","Febrero")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "03","Marzo")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "04","Abril")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "05","Mayo")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "06","Junio")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "07","Julio")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "08","Agosto")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "09","Septiembre")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "10","Octubre")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "11","Novimbre")
OperadorAdelando$Mes<-replace(OperadorAdelando$Mes,OperadorAdelando$Mes== "12","Diciembre")

salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 1,"Enero")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 2,"Febrero")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 3,"Marzo")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 4,"Abril")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 5,"Mayo")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 6,"Junio")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 7,"Julio")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 8,"Agosto")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 9,"Septiembre")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 10,"Octubre")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 11,"Novimbre")
salidas_todas_dia1$Mes<-replace(salidas_todas_dia1$Mes,salidas_todas_dia1$Mes== 12,"Diciembre")

usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "01","Enero")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "02","Febrero")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "03","Marzo")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "04","Abril")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "05","Mayo")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "06","Junio")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "07","Julio")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "08","Agosto")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "09","Septiembre")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "10","Octubre")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "11","Novimbre")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "12","Diciembre")
usosOpemes$Mes<-replace(usosOpemes$Mes,usosOpemes$Mes== "","Abril")

usosOpemes$CONDUCTOR<-as.integer(usosOpemes$CONDUCTOR)


Tasa_atrasos<- (round(mean(as.numeric(salidastodaOperadorOP$tasa_Atrazos)),0))
Tasa_Salidas<- (round(mean(as.numeric(salidastodaOperadorOP$tasa_Salidas)),0))
Tasa_Adelantos<- (round(mean(as.numeric(salidastodaOperadorOP$tasa_Adelantos)),0))
Tasa_Usos<- (round(mean(as.numeric(salidastodaOperadorOP$tasa_usosQ25)),0))


#TsalidasCOT<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("CODIGO_OPERADOR","Mes")],length))
#TadelantosCOT<-data.frame(tapply(OperadorAdelando$PuntualidadID,OperadorAdelando[,c("Operador","Mes")],length))
#TatrasosCOT<-data.frame(tapply(OperadorAtrazo$PuntualidadID,OperadorAtrazo[,c("Operador","Mes")],length))

TusosCOT<-data.frame(tapply(usosOpemes$UsoQ25,usosOpemes[,c("CONDUCTOR","Mes")],length))
TsalidasCOT<-data.frame(tapply(salidas_todas_dia1$JERARQUIA,salidas_todas_dia1[,c("CODIGO_OPERADOR","Mes")],length))
TadelantosCOT<-data.frame(tapply(OperadorAdelando$PuntualidadID,OperadorAdelando[,c("Operador","Mes")],length))
TatrasosCOT<-data.frame(tapply(OperadorAtrazo$PuntualidadID,OperadorAtrazo[,c("Operador","Mes")],length))


diatipo<-usostodos[,c(10,15)]
diatipo<<-unique(diatipo)
OperadorAtrazo[,FECHA:=OperadorAtrazo$`Dia Operativo`]
OperadorAdelando[,FECHA:=OperadorAdelando$`Dia Operativo`]

OperadorAdelando<-OperadorAdelando[OperadorAdelando$`Dia Operativo`!="is.na"]
OperadorAtrazo<-OperadorAtrazo[OperadorAtrazo$`Dia Operativo`!="is.na"]

setkey(diatipo,FECHA)
setkey(OperadorAtrazo,FECHA)
setkey(OperadorAdelando,FECHA)

OperadorAtrazo<-diatipo[OperadorAtrazo, all= TRUE]
OperadorAdelando<-diatipo[OperadorAdelando, all= TRUE]



usosOpemes<-usosOpemes[usosOpemes$Q25<=0]


Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 1,"Enero")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 2,"Febrero")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 3,"Marzo")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 4,"Abril")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 5,"Mayo")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 6,"Junio")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 7,"Julio")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 8,"Agosto")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 9,"Septiembre")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 10,"Octubre")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 11,"Novimbre")
Ano_MES_Objet$mes<-replace(Ano_MES_Objet$mes,Ano_MES_Objet$mes== 12,"Diciembre")

Ano_MES_Objet[,MES:=mes]
Ano_MES_Objet<-Ano_MES_Objet[,-2]


#salidastodaOperadorTasa<-salidastodaOperador[c(8,14,15,16),]
#salidastodaOperador1<-salidastodaOperadorTasa[,-1]
#salidastodaOperadortotal<-salidastodaOperador[c(7,11,13,12),]#pendiente usos menoresQ25 fila 11
#salidastodaOperador2<-salidastodaOperadortotal[,-1]
#salidastodaOperadortotal$indicadores<-replace(salidastodaOperadortotal$indicadores,salidastodaOperadortotal$indicadores== "paradas atrazadas","paradas atrasadas")

#salidastodaOperadorOPMos<-salidastodaOperadorOP
#names(salidastodaOperadorOPMos)=c("Operador","COT","horas","vandalismo","Accidentes","Utryt","inc_operador","Flota","Totalsalidas","tasa_Salidas","tasa_Operador","USOS","veces_usos_Q25","paradas atrasadas","paradas adelantadas","tasa_usosQ25","tasa_Adelantos","tasa_Atrasos")

######################################################
reincita<-BaseDatosReinci
reincita[,Novedad_Año:=paste(reincita$Novedad,reincita$Año,sep = "_")]

reincita<-data.frame(tapply(reincita$jerarquias,reincita[,c("COT","Operador","Fuente","Novedad_Año")],length))
reincita<-as.data.frame(t(reincita))
reincita<-replace(reincita,is.na(reincita),0)
reincita<-data.table(cbind(row.names(reincita),reincita))
names(reincita)=c("NOVEDADES","BYN","ETM","GIT")

TABV<-str_split_fixed(reincita$NOVEDADES,"[.]",3)
reincita<-cbind(TABV,reincita)
#reincita[,V3:=paste(V2,V3,sep = "")]

reincita<-reincita[,-3]
names(reincita)=c("Operador","Fuente","NOVEDADES","BYN","ETM","GIT")
reincita$Operador<-gsub("X","",reincita$Operador)

reincitaG<-reincita[,-c(4,5)]
reincitaB<-reincita[,-c(5,6)]
reincitaE<-reincita[,-c(4,6)]

reincitaG<-reincitaG[reincitaG$GIT>0]
reincitaB<-reincitaB[reincitaB$BYN>0]
reincitaE<-reincitaE[reincitaE$ETM>0]

reincitaG<-reincitaG[reincitaG$Operador!=10000]
reincitaB<-reincitaB[reincitaB$Operador!=20000]
reincitaE<-reincitaE[reincitaE$Operador!=30000]

reincitaB[,COT:="BYN"]
reincitaG[,COT:="GIT"]
reincitaE[,COT:="ETM"]

reincitaB[,Total:=BYN]
reincitaG[,Total:=GIT]
reincitaE[,Total:=ETM]

reincitaG<-reincitaG[,-4]
reincitaE<-reincitaE[,-4]
reincitaB<-reincitaB[,-4]

reincita<-rbind(reincitaG,reincitaB,reincitaE)

TABV<-str_split_fixed(reincita$NOVEDADES,"_",2)
reincita<-cbind(reincita,TABV[,2])


horasop<-data.table(t(tapply(as.numeric(salidastodaOperadorOP$horas),salidastodaOperadorOP$COT,sum)))
names(horasop)=c("HGIT","HBYN","HETM")
horasop[,TotalH:=(HGIT+HETM+HBYN)]


Reincishi1<-altomediobajo[,c(3,11)]
names(Reincishi1)=c("Operador","total")
Reincishi1[,Tipo:="Medio"]
Reincishi2<-altomediobajo[,c(3,10)]
names(Reincishi2)=c("Operador","total")
Reincishi2[,Tipo:="Bajo"]
Reincishi3<-altomediobajo[,c(3,9)]
names(Reincishi3)=c("Operador","total")
Reincishi3[,Tipo:="Alto"]
Reincishi4<-seisBDM_A_B[,c(1,8)]
Reincishi4<-Reincishi4[Reincishi4$total>6]
Reincishi4[,Tipo:="Seis"]

Reincishi<-rbind(Reincishi1,Reincishi2,Reincishi3,Reincishi4)

Reincishi<-Reincishi[Reincishi$total>0]
Reincishi[,COT:=substr(Reincishi$Operador,1,1)]
Reincishi$COT<-replace(Reincishi$COT,Reincishi$COT== "1","GIT")
Reincishi$COT<-replace(Reincishi$COT,Reincishi$COT== "3","ETM")
Reincishi$COT<-replace(Reincishi$COT,Reincishi$COT== "2","BYN")

BaseDatosReinci[,Mes1:=Mes]
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1== "01","Enero")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1== "02","Febrero")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="03","Marzo")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="04","Abril")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="05","Mayo")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="06","Junio")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="07","Julio")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="08","Agosto")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="09","Septiembre")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="10","Octubre")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="11","Novimbre")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="12","Diciembre")
BaseDatosReinci$Mes1<-replace(BaseDatosReinci$Mes1,BaseDatosReinci$Mes1=="","Abril")

TasasT[,Todo:=paste(Año,Mes,Operador,sep = "_")]

horasOPmes<-salidastodaOperadorOP[,c(1,2,3,6)]
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "01","Enero")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "02","Febrero")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "03","Marzo")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "04","Abril")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "05","Mayo")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "06","Junio")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "07","Julio")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "08","Agosto")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "09","Septiembre")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "10","Octubre")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "11","Novimbre")
horasOPmes$V2<-replace(horasOPmes$V2,horasOPmes$V2== "12","Diciembre")
horasOPmes[,horasf:=paste(V1,V2,V3,sep = "_")]
#horasOPmes[,totalmesaño:=paste(V1,V2,sep = "_")]
horasOPmes[,horasaño:=paste(V1,paste("Promedio",V1,sep = " "),V3,sep = "_")]

horasOPAño<-data.frame(tapply(horasOPmes$horas,horasOPmes$horasaño,sum))

horasOPmes<-data.frame(tapply(horasOPmes$horas,horasOPmes$horasf,sum))
horasOPmes<-data.table(cbind(row.names(horasOPmes),horasOPmes))


horasOPAño<-data.table(cbind(row.names(horasOPAño),horasOPAño))
names(horasOPmes)=c("Todo","horas")
names(horasOPAño)=c("Todo","horas")
horasOPAño<-rbind(horasOPmes,horasOPAño)

#horasOPAño[,PorcenOperaMes:=substr(horasOPAño$Todo,1,4)]
#horasOPAño$PorcenOperaMes<-replace(horasOPAño$PorcenOperaMes,horasOPAño$PorcenOperaMes== "2024","216")
#horasOPAño$PorcenOperaMes<-replace(horasOPAño$PorcenOperaMes,horasOPAño$PorcenOperaMes== "2025","216")
#horasOPAño$PorcenOperaMes<-as.numeric(horasOPAño$PorcenOperaMes)
#horasOPAño[,PorcenOperaMes:=round(((horas/PorcenOperaMes)*100),0)]


setkey(horasOPAño,Todo)
setkey(TasasT,Todo)

TasasT<- horasOPAño[TasasT,all=T]
#TasasT<- TasasT[,c(4:11,3)]

#todsOpemes1<-rbind(as.data.table(usosOpemes1),as.data.table(salidasOpemes1),as.data.table(atrasosOpemes1),as.data.table(adelantosOpemes1),fill=TRUE)

#todsOpemes1<-replace(todsOpemes1,is.na(todsOpemes1),0)

#usosOpemes1<-todsOpemes1[1:4,]
#salidasOpemes1<-todsOpemes1[5:8,]
#atrasosOpemes1<-todsOpemes1[9:12,]
#adelantosOpemes1<-todsOpemes1[13:16,]

#usosOpemes1<-as.data.frame(usosOpemes1)
#salidasOpemes1<-as.data.frame(todsOpemes1)
#atrasosOpemes1<-as.data.frame(todsOpemes1)
#adelantosOpemes1<-as.data.frame(todsOpemes1)



###### parte uno 


