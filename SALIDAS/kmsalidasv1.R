#Activamos las librerias necesarias 
library(readxl) #leer archivos en excel y ussas las propiedades de a librerya
library(stringr) #leer utilizar las funciones de los directorios de las carpetas
library(data.table) #Utiliza las funciones para almacenar tablas de datos por medio de "data.table" y "data.frame"
library(plotrix)
library(openxlsx)
library(lubridate)
library(ggplot2)
library(graphics)
library(plyr)

#correr scrip vehiculo dia
#correr scrip saliadas 
#correr scrip rutas

                                           ######CORTE Diasoperarivos2025 linea 395

#Carga De Datos
if (rstudioapi::isAvailable()) {
  current_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  #current_dir <- file.path(getwd(), "02 - Salidas")
  current_dir <- file.path(getwd())
}



load(file.path(current_dir, "FLOTA_Combustible.RData"))
load(file.path(current_dir, "vehiculodia.RData"))
vehiculodia1 <- vehiculodia
load(file.path(current_dir, "vehiculodia1.RData"))
# Se unen y eliminan duplicados
vehiculodia <- rbind(vehiculodia1, vehiculodia) %>% unique()

filename <- paste0(current_dir, "/vehiculodia.RData")
save(vehiculodia,file = filename)#horas laboradas en los ultimos meses 

#KMSEJECUTADOS_RUTAS<-read_excel("C:/Users/emosquera/OneDrive - metrocali.gov.co/KmsEric/KMSEJECUTADOS_RUTAS_2023 HASTA ABRIL 2024.xlsx", sheet = 1, col_names = T)


#========// Proceso de Carga //====================
load(file.path(current_dir, "Rutadia1.RData"))
Rutadia1<-Rutadia
load(file.path(current_dir, "Rutadia.RData"))
#Rutadia<-Rutadia[,c(3:5,1,6:9)]
Rutadia<-rbind(Rutadia1,Rutadia)
Rutadia<-unique(Rutadia)

#========// Proceso Guardar //====================

filename <- paste0(current_dir, "/Rutadia.RData")
save(vehiculodia,file = filename)#horas laboradas en los ultimos meses 
save(Rutadia,file =filename)#horas laboradas en los ultimos meses 


vehiculodia<-vehiculodia[vehiculodia$Vehiculo!="NA"]
vehiculodia<-vehiculodia[vehiculodia$Vehiculo!="CANCELADA"]
vehiculodia<-vehiculodia[vehiculodia$Vehiculo!="CAMBIO"]

load(file.path(current_dir, "Diatipo.RData"))
tipodia<-Diatipo[,c(1,2)]
#tipodia$FECHA<-as.character(tipodia$FECHA)

names(tipodia)=c("Fecha","TIPODIA")

setkey(tipodia,Fecha)
setkey(vehiculodia,Fecha)

vehiculodia<- tipodia[vehiculodia,all=T]


setkey(tipodia,Fecha)
setkey(Rutadia,Fecha)

Rutadia<- tipodia[Rutadia,all=T]

Rutadia[,Largo:=Rutadia$Largo/1000]

Rutadia$Largo<-round(Rutadia$Largo,0)

KMSEJECUTADOS_RUTAS<-Rutadia[,c(1,2,5,4)]


vehiculodia[,Tipovehiculo:=substr(vehiculodia$Vehiculo,2,2)]
vehiculodia$Tipovehiculo<-replace(vehiculodia$Tipovehiculo,vehiculodia$Tipovehiculo== "1","ART")
vehiculodia$Tipovehiculo<-replace(vehiculodia$Tipovehiculo,vehiculodia$Tipovehiculo== "2","PAD")
vehiculodia$Tipovehiculo<-replace(vehiculodia$Tipovehiculo,vehiculodia$Tipovehiculo== "3","COM")
vehiculodia$Tipovehiculo<-replace(vehiculodia$Tipovehiculo,vehiculodia$Tipovehiculo== "4","DUAL")

vehiculodia[,COT:=substr(vehiculodia$Vehiculo,1,1)]
vehiculodia$COT<-replace(vehiculodia$COT,vehiculodia$COT== "1","GIT")
vehiculodia$COT<-replace(vehiculodia$COT,vehiculodia$COT== "2","BYN")
vehiculodia$COT<-replace(vehiculodia$COT,vehiculodia$COT== "3","ETM")
vehiculodia$COT<-replace(vehiculodia$COT,vehiculodia$COT== "5","BCPC")

vehiculodia$Mes<-as.numeric(vehiculodia$Mes)
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 1,"Enero")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 2,"Febrero")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 3,"Marzo")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 4,"Abril")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 5,"Mayo")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 6,"Junio")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 7,"Julio")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 8,"Agosto")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 9,"Septiembre")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 10,"Octubre")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 11,"Novimbre")
vehiculodia$Mes<-replace(vehiculodia$Mes,vehiculodia$Mes== 12,"Diciembre")
vehiculodia[,largokm:=(Largo/1000)]
vehiculodia[,Largo:=round(largokm,0)]
vehiculodia<-vehiculodia[,-12]

vehiculodia$TIPODIA<-replace(vehiculodia$TIPODIA,vehiculodia$TIPODIA== "DOM","FES")
vehiculodia$TIPODIA<-replace(vehiculodia$TIPODIA,vehiculodia$TIPODIA== "DHABIL","HAB")
vehiculodia$TIPODIA<-replace(vehiculodia$TIPODIA,vehiculodia$TIPODIA== "DOMFEST","FES")

diasMeses<-data.table(unique(vehiculodia$Mes))
names(diasMeses)="Mes"
diasMeses[,Dias:=30]
Febrero<-diasMeses[2,]
Febrero[,Dias:=29]
otros<-diasMeses[c(1,3,5,7,8,10,12),]
otros[,Dias:=31]
diasMeses<-diasMeses[-c(1,2,3,5,7,8,10,12),]

diasMeses<-rbind(otros,Febrero,diasMeses)

vehiculodia[,Diaoperativo:=paste(Vehiculo,Año,Mes,sep ="-" )]

vehidiaop<-data.frame(tapply(vehiculodia$Dia,vehiculodia$Diaoperativo,length))
vehidiaop<-cbind((row.names(vehidiaop)),vehidiaop)
names(vehidiaop)=c("Diaoperativo","diaoperat")

vehidiaop<-as.data.table(vehidiaop)

setkey(vehidiaop,Diaoperativo)
setkey(vehiculodia,Diaoperativo)

vehiculodia<- vehidiaop[vehiculodia,all=T]

setkey(diasMeses,Mes)
setkey(vehiculodia,Mes)

vehiculodia<- diasMeses[vehiculodia,all=T]

vehiculodia[,Diaoperativo:=round(100*(diaoperat/Dias),0)]

load(file.path(current_dir, "salidas.RData"))
#salidas_todas_dia1__ <- salidas_todas_dia1
#load(file.path(current_dir, "salidas1.RData"))
#salidas_todas_dia1__<-salidas_todas_dia1__[,-c("tipo")]
#salidas_todas_dia1 <- rbind(salidas_todas_dia1__, salidas_todas_dia1) %>% unique()

filename <- paste0(current_dir, "/salidas.RData")
save(salidas_todas_dia1,file = filename)

salidas_todas_dia1<-replace(salidas_todas_dia1,is.na(salidas_todas_dia1),0)
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

salidas_todas_dia1$`Codificacion Concesionario`<-replace(salidas_todas_dia1$`Codificacion Concesionario`,salidas_todas_dia1$`Codificacion Concesionario`== "1","GIT")
salidas_todas_dia1$`Codificacion Concesionario`<-replace(salidas_todas_dia1$`Codificacion Concesionario`,salidas_todas_dia1$`Codificacion Concesionario`== "2","BYN")
salidas_todas_dia1$`Codificacion Concesionario`<-replace(salidas_todas_dia1$`Codificacion Concesionario`,salidas_todas_dia1$`Codificacion Concesionario`== "3","ETM")
salidas_todas_dia1$`Codificacion Concesionario`<-replace(salidas_todas_dia1$`Codificacion Concesionario`,salidas_todas_dia1$`Codificacion Concesionario`== "5","BCPC")

salidas_todas_dia1$Año<-replace( salidas_todas_dia1$Año, salidas_todas_dia1$Año== "23","2023")
salidas_todas_dia1$Año<-replace( salidas_todas_dia1$Año, salidas_todas_dia1$Año== "24","2024")
salidas_todas_dia1$Año<-replace( salidas_todas_dia1$Año, salidas_todas_dia1$Año== "25","2025")
salidas_todas_dia1$Año<-replace( salidas_todas_dia1$Año, salidas_todas_dia1$Año== "26","2026")

salidas_todas_dia12<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año")],length))
salidas_todas_dia13<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Codificacion Concesionario")],length))
salidas_todas_dia14<-data.frame(tapply(salidas_todas_dia1$NUMERO_DE_CASO,salidas_todas_dia1[,c("salidastipo","Año","Mes")],length))

salidasUTRYT<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasUTRYT"]
salidasflota<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasflota"]
salidasOpe.<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="salidasOpe."]
vandalismos<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="vandalismos"]
Accidentes<-salidas_todas_dia1[salidas_todas_dia1$salidastipo=="Accidentes"]

salidasUTRYT1<-data.frame(tapply(salidasUTRYT$sal_veh,salidasUTRYT[,c("X5","Año","Codificacion Concesionario")],length))
salidasUTRYT1<-data.table(colnames(t(salidasUTRYT1)),salidasUTRYT1)

salidasflota1<-data.frame(tapply(salidasflota$sal_veh,salidasflota[,c("X4","Año","Codificacion Concesionario")],length))
salidasflota1<-data.table(colnames(t(salidasflota1)),salidasflota1)

salidasOpe1<-data.frame(tapply(salidasOpe.$sal_veh,salidasOpe.[,c("X4","Año","Codificacion Concesionario")],length))
salidasOpe1<-data.table(colnames(t(salidasOpe1)),salidasOpe1)

vandalismos1<-data.frame(tapply(vandalismos$sal_veh,vandalismos[,c("X4","Año","Codificacion Concesionario")],length))
vandalismos1<-data.table(colnames(t(vandalismos1)),vandalismos1)

Accidentes1<-data.frame(tapply(Accidentes$sal_veh,Accidentes[,c("X4","Año","Codificacion Concesionario")],length))
Accidentes1<-data.table(colnames(t(Accidentes1)),Accidentes1)


load(file.path(current_dir, "TABLERO_indicadores.RData"))#salidas ultimo

consecutivo<-TABLERO_indicadores

indicadores<-TABLERO_indicadores[-c(1,2),c(1,4,5,108:120,3)]
rm(TABLERO_indicadores)
names(indicadores)=c("Dia","Año","Mes","TOTAL","T","P","A","ART","PAD","COM","DUAL","GIT","BNM","ETM","UNM","BYNCPC","Diatipo")
indicadores<-as.data.table(indicadores)
indicadores$Año<-as.numeric(indicadores$Año)
indicadores<-replace(indicadores,is.na(indicadores),0)
#indicadores<-indicadores[indicadores$Año>2011]
indicadores$TOTAL<-as.integer(indicadores$TOTAL)


consecutivo<-consecutivo[-c(1,2),c(1,4)]
consecutivo1<-data.frame(t(consecutivo))
consecutivo1<-data.frame(colnames(consecutivo1))
consecutivo<-data.table(cbind(consecutivo1,consecutivo))
colnames(consecutivo)=c("consecutivo","Año","Mes")
consecutivo[,añomes:=paste(Año,Mes, sep = "_")]
consecutivo<-consecutivo[,c(1,4)]

indicadores[,añomes:=paste(Dia,Año,sep = "_")]

setkey(consecutivo,añomes)
setkey(indicadores,añomes)

indicadores<- consecutivo[indicadores,all=T]
indicadoresx<- indicadores[consecutivo,all=T]

indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 1,"Enero")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 2,"Febrero")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 3,"Marzo")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 4,"Abril")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 5,"Mayo")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 6,"Junio")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 7,"Julio")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 8,"Agosto")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 9,"Septiembre")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 10,"Octubre")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 11,"Novimbre")
indicadores$Mes<-replace(indicadores$Mes,indicadores$Mes== 12,"Diciembre")

indicadores[,añomes:=paste(Año,Mes,sep = "_")]




KilometroTotal<-data.frame(tapply(indicadores$TOTAL,indicadores$añomes,sum))
KilometroTotal<-cbind(colnames(t(KilometroTotal)),KilometroTotal)
names(KilometroTotal)=c("añomes","Kilometros")

salidas_todas_dia14<-data.frame(cbind(colnames(salidas_todas_dia14),t(salidas_todas_dia14)))
names(salidas_todas_dia14)=c("añomes","Accidentes","salidasflota","salidasOpe.","salidasUTRYT","vandalismos")
salidas_todas_dia14$añomes<-gsub("[.]","_",salidas_todas_dia14$añomes)
salidas_todas_dia14$añomes<-gsub("X","",salidas_todas_dia14$añomes)

salidas_todas_dia14<-as.data.table(salidas_todas_dia14)
KilometroTotal<-as.data.table(KilometroTotal)

setkey(salidas_todas_dia14,añomes)
setkey(KilometroTotal,añomes)

salidas_todas_dia14<- KilometroTotal[salidas_todas_dia14,all=T]

salidas_todas_dia14<-replace(salidas_todas_dia14,is.na(salidas_todas_dia14),0)

salidas_todas_dia14[,"accidentes/millon":= round(((as.numeric(Accidentes)/Kilometros)*1000000),0)]
salidas_todas_dia14[,"vandalismo/millon":= round(((as.numeric(vandalismos)/Kilometros)*1000000),0)]
salidas_todas_dia14[,"Utryt/millon":= round(((as.numeric(salidasUTRYT)/Kilometros)*1000000),0)]
salidas_todas_dia14[,"operador/millon":= round(((as.numeric(salidasOpe.)/Kilometros)*1000000),0)]
salidas_todas_dia14[,"flota/millon":= round(((as.numeric(salidasflota)/Kilometros)*1000000),0)]

TABV<-data.table(str_split_fixed(salidas_todas_dia14$añomes,"_",2))
colnames(TABV)=c("Año","Mes")

salidas_todas_dia14<-cbind(TABV,salidas_todas_dia14)

salidas_todas_dia14$añomes<-gsub("X","",salidas_todas_dia14$añomes)

consecutivo1<-indicadores[,c(1,2)]
consecutivo1[,concec:=paste(consecutivo,añomes,sep = "&")]
consecutivo1<-data.table(unique(consecutivo1))

setkey(salidas_todas_dia14,añomes)
setkey(consecutivo1,añomes)


salidas_todas_dia14<- consecutivo1[salidas_todas_dia14,all=T]
salidas_todas_dia14$consecutivo<-gsub("X","",salidas_todas_dia14$consecutivo)
salidas_todas_dia14$consecutivo<-as.numeric(salidas_todas_dia14$consecutivo)
salidas_todas_dia14<- salidas_todas_dia14[order(salidas_todas_dia14$consecutivo), ]
salidas_todas_dia14<- salidas_todas_dia14[salidas_todas_dia14$Kilometros>0 ]

salidas_todas_dia14[,"Total salidas":= as.numeric(Accidentes)+as.numeric(salidasflota)+as.numeric(vandalismos)+as.numeric(salidasUTRYT)+as.numeric(salidasOpe.)]
salidas_todas_dia14[,"salidas/millon":= round(((as.numeric(`Total salidas`)/Kilometros)*1000000),0)]

BCPCKMaño<-data.frame(t(tapply(as.numeric(indicadores$BYNCPC),indicadores$Año,sum)))
BYNMaño<-data.frame(t(tapply(as.numeric(indicadores$BNM),indicadores$Año,sum)))
GITKMaño<-data.frame(t(tapply(as.numeric(indicadores$GIT),indicadores$Año,sum)))
ETMKMaño<-data.frame(t(tapply(as.numeric(indicadores$ETM),indicadores$Año,sum)))



salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))

Kilometroaño<-data.table(data.frame(t(tapply(as.numeric(indicadores$TOTAL),indicadores$Año,sum))))
salidas_todas_diatotales<-as.data.table(cbind(row.names(salidas_todas_dia12),salidas_todas_dia12))
salidas_todas_diatotales[,kilometros23:=Kilometroaño$X2023]
salidas_todas_diatotales[,kilometros24:=Kilometroaño$X2024]
salidas_todas_diatotales[,kilometros25:=Kilometroaño$X2025]
salidas_todas_diatotales[,kilometros26:=Kilometroaño$X2026]

salidas_todas_diatotales[,"salidas/mill_23":=round((X2023/kilometros23)*1000000,0)]
salidas_todas_diatotales[,"salidas/mill_24":=round((X2024/kilometros24)*1000000,0)]
salidas_todas_diatotales[,"salidas/mill_25":=round((X2025/kilometros25)*1000000,0)]
salidas_todas_diatotales[,"salidas/mill_26":=round((X2025/kilometros26)*1000000,0)]

salidas_todas_dia1[,"tipo ruta":=substr(salidas_todas_dia1$RUTA,1,1)]
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "E","Troncal")
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "T","Troncal")
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "A","Alimentador")
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "P","Pretoncal")
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "C","Pretoncal")
salidas_todas_dia1$`tipo ruta`<-replace(salidas_todas_dia1$`tipo ruta`,salidas_todas_dia1$`tipo ruta`== "R","Reserva")

salidas_todas_dia1[,Tipovehiculo:=substr(salidas_todas_dia1$NUMERO_VEHICULO,2,2)]

salidas_todas_dia1$Tipovehiculo<-replace(salidas_todas_dia1$Tipovehiculo,salidas_todas_dia1$Tipovehiculo== "1","ART")
salidas_todas_dia1$Tipovehiculo<-replace(salidas_todas_dia1$Tipovehiculo,salidas_todas_dia1$Tipovehiculo== "2","PAD")
salidas_todas_dia1$Tipovehiculo<-replace(salidas_todas_dia1$Tipovehiculo,salidas_todas_dia1$Tipovehiculo== "3","COM")
salidas_todas_dia1$Tipovehiculo<-replace(salidas_todas_dia1$Tipovehiculo,salidas_todas_dia1$Tipovehiculo== "4","DUAL")


tabruas<-data.table(str_split_fixed(KMSEJECUTADOS_RUTAS$Fecha,"-",3))
names(tabruas)=c("Año","Mes","dia")
KMSEJECUTADOS_RUTAS<-data.table(cbind(KMSEJECUTADOS_RUTAS,tabruas))
KMSEJECUTADOS_RUTAS[,"tipo ruta":=substr(KMSEJECUTADOS_RUTAS$Ruta,1,1)]
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "E","Troncal")
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "T","Troncal")
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "A","Alimentador")
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "P","Pretoncal")
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "C","Pretoncal")
KMSEJECUTADOS_RUTAS$`tipo ruta`<-replace(KMSEJECUTADOS_RUTAS$`tipo ruta`,KMSEJECUTADOS_RUTAS$`tipo ruta`== "R","Reserva")

#KMSEJECUTADOS_RUTAS$`TIPO DIA`<-replace(KMSEJECUTADOS_RUTAS$`TIPO DIA`,KMSEJECUTADOS_RUTAS$`TIPO DIA`== "DOM","FES")
#KMSEJECUTADOS_RUTAS$`TIPO DIA`<-replace(KMSEJECUTADOS_RUTAS$`TIPO DIA`,KMSEJECUTADOS_RUTAS$`TIPO DIA`== "DHABIL","HAB")
#KMSEJECUTADOS_RUTAS$`TIPO DIA`<-replace(KMSEJECUTADOS_RUTAS$`TIPO DIA`,KMSEJECUTADOS_RUTAS$`TIPO DIA`== "DOMFEST","FES")

KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "01","Enero")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "02","Febrero")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "03","Marzo")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "04","Abril")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "05","Mayo")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "06","Junio")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "07","Julio")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "08","Agosto")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "09","Septiembre")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "10","Octubre")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "11","Novimbre")
KMSEJECUTADOS_RUTAS$Mes<-replace(KMSEJECUTADOS_RUTAS$Mes,KMSEJECUTADOS_RUTAS$Mes== "12","Diciembre")

salidas_todas_dia1$NUMERO_VEHICULO<-as.numeric(salidas_todas_dia1$NUMERO_VEHICULO)
salidas_todas_dia1$NUMERO_VEHICULO<-as.character(salidas_todas_dia1$NUMERO_VEHICULO)


salidas_todas_dia1toda<-as.data.frame(salidas_todas_dia1)
salidas_todas_dia1toda<-as.data.table(salidas_todas_dia1toda)

salidas_todas_dia1toda[,Mes:="Año"]

vehiculodiatoda<-as.data.frame(vehiculodia)
vehiculodiatoda<-as.data.table(vehiculodiatoda)

vehiculodiatoda[,Mes:="Año"]

vehiculodiatoda[,Diaoperativo:=paste(Vehiculo,Año,sep ="-" )]

vehidiaop<-data.frame(tapply(vehiculodiatoda$Dia,vehiculodiatoda$Diaoperativo,length))
vehidiaop<-cbind((row.names(vehidiaop)),vehidiaop)
names(vehidiaop)=c("Diaoperativo","diaoperat")

vehidiaop<-as.data.table(vehidiaop)

vehiculodiatoda<-vehiculodiatoda[,-4]
vehiculodiatoda[,Dias:=360]

vehiculodiatoda2025<-vehiculodiatoda[vehiculodiatoda$Año=="2025"]
vehiculodiatoda<-vehiculodiatoda[vehiculodiatoda$Año!="2025"]

Meses2025<-vehiculodia[vehiculodia$Año=="2025"]
Diasoperarivos2025<-(as.numeric(length(unique(Meses2025$Mes))))*30


vehiculodiatoda2025[,Dias:=Diasoperarivos2025]

vehiculodiatoda<-rbind(vehiculodiatoda,vehiculodiatoda2025)

setkey(vehidiaop,Diaoperativo)
setkey(vehiculodiatoda,Diaoperativo)

vehiculodiatoda<- vehidiaop[vehiculodiatoda,all=T]

vehiculodiatoda[,Diaoperativo:=round(100*(diaoperat/Dias),0)]


DeseFlotaAño<-unique(vehiculodiatoda[,c(9,10,1)])
DeseFlotaMes<-unique(vehiculodia[,c(9,10,1,3)])

DeseFlotaAño[,Mes:="Año"]

DeseFlotaAño[,Desepeflota:=paste(Vehiculo,Año,Mes,sep = "_")]
DeseFlotaMes[,Desepeflota:=paste(Vehiculo,Año,Mes,sep = "_")]

DeseFlotaAño<-as.data.table(DeseFlotaAño)
DeseFlotaMes<-as.data.table(DeseFlotaMes)

salidas_todas_dia1$NUMERO_VEHICULO<-as.numeric(salidas_todas_dia1$NUMERO_VEHICULO)

KMSEJECUTADOS_RUTAS<-KMSEJECUTADOS_RUTAS[KMSEJECUTADOS_RUTAS$Año!="2022"]

KMSEJECUTADOS_RUTAStodo<-as.data.frame(KMSEJECUTADOS_RUTAS)
KMSEJECUTADOS_RUTAStodo<-as.data.table(KMSEJECUTADOS_RUTAStodo)

KMSEJECUTADOS_RUTAStodo[,Mes:="Año"]

indicadorestodo<-as.data.frame(indicadores)
indicadorestodo<-as.data.table(indicadorestodo)

indicadorestodo[,Mes:="Año"]


#FLOTA_Combustible<-read_excel("C:/Users/emosquera/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/Salidas/FLOTA Combustible.xlsx", sheet = 1, col_names = T)
#save(salidas_todas_dia1,file = "C:/Users/emosquera/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/salidas vehiculos/salidas_todas_dia1.RData")#horas laboradas en los ultimos meses 
#save(salidas_todas_dia1toda,file = "C:/Users/emosquera/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/salidas vehiculos/salidas_todas_dia1toda.RData")#horas laboradas en los ultimos meses 
#save(vehiculodiatoda,file = "C:/Users/emosquera/OneDrive - metrocali.gov.co/Bk Eric/R.09.Buses/salidas vehiculos/vehiculodiatoda.RData")#horas laboradas en los ultimos meses 
