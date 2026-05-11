library(readxl) #leer archivos en excel y ussas las propiedades de a librerya
library(stringr) #leer utilizar las funciones de los directorios de las carpetas
library(data.table) #Utiliza las funciones para almacenar tablas de datos por medio de "data.table" y "data.frame"
#library(xlsx)
library(lubridate)

load(file.path(getwd(),"FlotaMax_Tipologia22_24.RData"))
FlotaMax_Tipologia22_24<-Fechasmaxima1
FlotaMax_Tipologia22_24[,Fecha:=paste(Año,Mes,Dia,sep = "-")]
load(file.path(getwd(),"FlotaMax_Tipologia25.RData"))
FlotaMax_Tipologia22_24_25<-rbind(FlotaMax_Tipologia22_24,Fechasmaxima1)
rm(FlotaMax_Tipologia22_24,Fechasmaxima1)



kilometros <- "Kilometro"
directoriok <- file.path(getwd(),"/",kilometros,"/")
#directoriok <- "G:/Users/Eric/Desktop/calificacion/02/Kilometro/"
#directoriok <- "C:/Users/emosquera/OneDrive - metrocali.gov.co/02/Kilometro/"
lista_kilom <- dir(directoriok)
# k1 <- data.table(read_excel(str_c(directoriok,lista_kilom[1]),
#                            sheet = "Programacion", col_names =TRUE))
#k1 <- data.table(read.xlsx(str_c(directoriok,lista_kilom[1]),sheetName = "Programacion",header = TRUE))
#k1 <- data.table(read.xlsx2(str_c(directoriok,lista_kilom[1]),sheetName = "Programacion",header = TRUE))
#K1 <- loadWorkbook(str_c(directoriok,lista_kilom[1]))
#k1 <- readWorksheetFromFile(wk1,sheet = "Programacion",header = TRUE)

k1 <- data.table()

for(i in 2:length(lista_kilom))     {
  
  k2 <- data.table(read_excel(str_c(directoriok,lista_kilom[i]),sheet = "Programacion",col_names = T ))
  cat (lista_kilom[i])  #guia de archivos y muestra el error
  cat("\n\n")
  k2 <- k2[,1:39]
  k2<-k2[k2$`Tipo Kilómetros`=="Kms en Servicio"]
  k2<-k2[k2$`Tipo de viaje corto`!="Viaje de posicionamiento"]
  ###########################
  columna<-data.frame(colnames(data.frame(t(k2))))
  names(columna)="nombre"
  k2<-cbind(columna,k2)
  k2<-as.data.table(k2)
  
  
  Adicionales<-k2[is.na(k2$`HORA REAL LLEGADA`)]
  Adicionales[,"HORA REAL SALIDA":=Desde]
  Adicionales[,"HORA REAL LLEGADA":=hasta]
  Adicionales$`HORA REAL SALIDA`<-gsub("1899-12-31 ","",Adicionales$`HORA REAL SALIDA`)
  Adicionales$`HORA REAL LLEGADA`<-gsub("1899-12-31 ","",Adicionales$`HORA REAL LLEGADA`)
  Adicionales$`HORA REAL LLEGADA`<-gsub("1900-01-01 ","",Adicionales$`HORA REAL LLEGADA`)
  Adicionales$`HORA REAL SALIDA`<-gsub("1900-01-01 ","",Adicionales$`HORA REAL SALIDA`)
  
  k20<-k2[k2$`HORA REAL SALIDA`=="0"]
  k20[,"HORA REAL SALIDA":=Desde]
  k20[,"HORA REAL LLEGADA":=hasta]
  k20$`HORA REAL SALIDA`<-gsub("1899-12-31 ","",k20$`HORA REAL SALIDA`)
  k20$`HORA REAL LLEGADA`<-gsub("1899-12-31 ","",k20$`HORA REAL LLEGADA`)
  k20$`HORA REAL LLEGADA`<-gsub("1900-01-01 ","",k20$`HORA REAL LLEGADA`)
  k20$`HORA REAL SALIDA`<-gsub("1900-01-01 ","",k20$`HORA REAL SALIDA`)
  
  k2in<-k2[k2$`HORA REAL SALIDA`!="NA"]
  k2in<-k2[k2$`HORA REAL SALIDA`!="0"]
  
  
  k2<-rbind(k2in,Adicionales,k20)
  
  
  Hora<-substr(k2$`HORA REAL SALIDA`,1,2)
  k2[,Hora:=Hora]  
  Hora2<-substr(k2$`HORA REAL LLEGADA`,1,2)
  k2[,Hora2:=Hora2]  
  Min1<-substr(k2$`HORA REAL SALIDA`,4,5)
  k2[,Min1:=Min1]
  Min2<-substr(k2$`HORA REAL LLEGADA`,4,5)
  k2$Hora<-replace(k2$Hora,k2$Hora==" 00"," 24")
  k2$Hora2<-replace(k2$Hora2,k2$Hora2==" 00"," 24")
  k2$Hora<-replace(k2$Hora,k2$Hora==" 01"," 25")
  k2$Hora2<-replace(k2$Hora2,k2$Hora2==" 01"," 25")
  k2$Hora<-replace(k2$Hora,k2$Hora=="00"," 24")
  k2$Hora2<-replace(k2$Hora2,k2$Hora2=="00"," 24")
  
  
  k2[,Hora3:=(as.numeric(k2$Hora2)-as.numeric(k2$Hora))]
  k2[,Min2:=Min2]
  k2$Min1<-as.numeric(k2$Min1)
  k2$Min2<-as.numeric(k2$Min2)
  
  k2$Min1<-replace(k2$Min1,k2$Min1>29,30)
  k2$Min1<-replace(k2$Min1,k2$Min1<30,0)
  k2$Min2<-replace(k2$Min2,k2$Min2>29,30)
  k2$Min2<-replace(k2$Min2,k2$Min2<30,0)
  k2[,Duracion1:=(Min2-Min1)]
  
  intervalo1<-paste(k2$Hora,k2$Min1,sep =  ":")
  intervalo6<-paste(k2$Hora2,k2$Min2,sep =  ":")
  
  intervalo2_5<-k2[,c("nombre","Min1","Min2","Hora","Hora2")]
  intervalo2_5$Min1<-replace(intervalo2_5$Min1,intervalo2_5$Min1==30,"NA") 
  intervalo2_5$Min1<-replace(intervalo2_5$Min1,intervalo2_5$Min1==0,30)
  intervalo2_5$Min2<-replace(intervalo2_5$Min2,intervalo2_5$Min2==0,"NA") 
  intervalo2_5$Min2<-replace(intervalo2_5$Min2,intervalo2_5$Min2==30,0)
  intervalo2<-paste(intervalo2_5$Hora,intervalo2_5$Min1,sep =  ":")
  intervalo5<-paste(intervalo2_5$Hora2,intervalo2_5$Min2,sep =  ":")
  
  
  intervalo3<-paste((k2$Hora3-1+as.numeric(k2$Hora)),0,sep =  ":")
  intervalo4<-paste((k2$Hora3-1+as.numeric(k2$Hora)),30,sep =  ":")
  
  k2[,intervalo1:=intervalo1]
  k2[,intervalo6:=intervalo6]
  k2[,intervalo2:=intervalo2]
  k2[,intervalo5:=intervalo5]
  k2[,intervalo3:=intervalo3]
  k2[,intervalo4:=intervalo4]
  
  
  k2_intervalo2_5<-k2[k2$Hora3==0]
  k2_intervalo2_5_1<-k2_intervalo2_5[k2_intervalo2_5$Duracion1==0]
  k2_intervalo2_5_2<-k2_intervalo2_5[k2_intervalo2_5$Duracion1!=0]
  k2_intervalo2_5_3<-k2_intervalo2_5[is.na(k2_intervalo2_5$Duracion1)]
  k2_intervalo2_5_1[,intervalo2:="NA"]
  k2_intervalo2_5_1[,intervalo5:="NA"]
  
  k2_intervalo2_5<-rbind(k2_intervalo2_5_1,k2_intervalo2_5_2,k2_intervalo2_5_3)
  k2_1intervalo2_5<-k2[k2$Hora3!=0]
  k2_isna<-k2[is.na(k2$Hora3)]
  
  k2<-rbind(k2_1intervalo2_5,k2_intervalo2_5,k2_isna)
  
  k2_intervalo3_4<-k2[k2$Hora3>1]
  k2_intervalo3_41<-k2[k2$Hora3<2]
  k2_intervalo3_41[,intervalo3:="NA"]
  k2_intervalo3_41[,intervalo4:="NA"]
  k2_isna<-k2[is.na(k2$Hora3)]
  
  k2<-rbind(k2_intervalo3_4,k2_intervalo3_41,k2_isna)
  
  
  
  Tipolog1<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo1,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  Tipolog2<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo2,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  Tipolog3<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo3,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  Tipolog4<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo4,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  Tipolog5<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo5,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  Tipolog6<-paste(k2$Fecha,k2$`Día tipo`,k2$intervalo6,k2$`Número de Vehículo`,
                  k2$`Tipo de vehículo del viaje`,k2$`Concesionario de Transporte`,sep =  "_")
  
  
  
  k2[,Flota1:=Tipolog1]
  k2[,Flota2:=Tipolog2]
  k2[,Flota3:=Tipolog3]
  k2[,Flota4:=Tipolog4]
  k2[,Flota5:=Tipolog5]
  k2[,Flota6:=Tipolog6]
  
  
  
  
  flota1<-as.data.table(unique(k2$Flota1))
  flota2<-as.data.table(unique(k2$Flota2))
  flota3<-as.data.table(unique(k2$Flota3))
  flota4<-as.data.table(unique(k2$Flota4))
  flota5<-as.data.table(unique(k2$Flota5))
  flota6<-as.data.table(unique(k2$Flota6))
 
  
  k2<-rbind(flota1,flota2,flota3,flota4,flota5,flota6)
  k2<-as.data.table(unique(k2$V1))
  
  ##########################
  k1 <- rbind(k1,k2,fill = TRUE)
  rm(k2_intervalo2_5_1,k2,Adicionales,columna,flota1,flota2,flota3,flota4,flota5,flota6,intervalo2_5,k2_1intervalo2_5,k2_intervalo2_5,k2_intervalo2_5_2,k2in,k2_intervalo2_5_3,k2_intervalo3_4,k2_intervalo3_41,k2_isna,k20,Tipolog1,Tipolog2,Tipolog3,Tipolog4,Tipolog5,Tipolog6)
}

Flotatab<-str_split_fixed(k1$V1,"_",6)
Flotatab<-data.frame(Flotatab)
k1<-cbind(k1,Flotatab)
names(k1)=c("todo","Fecha","Diatipo","Hora","Vehiculo","Tipologia","COT")

k1$COT<-replace(k1$COT,k1$COT=="GITOE13","GIT")

k1$Vehiculo<-as.character(k1$Vehiculo)
k1$Vehiculo<-as.numeric(k1$Vehiculo)
k1$Hora<-as.character(k1$Hora)

Flota<-k1[k1$Vehiculo>0]
Flotatabhora<-data.frame(str_split_fixed(Flota$Hora,":",2))
names(Flotatabhora)=c("hor","min")
Flota<-cbind(Flota,Flotatabhora)
Flota$hor<-as.character(Flota$hor)
Flota$min<-as.character(Flota$min)
Flota<-as.data.table(Flota)
Flota<-Flota[Flota$min!="NA"]
Flota<-Flota[Flota$min!=""]
Flota$hor<-as.numeric(Flota$hor)
Flota$min<-as.numeric(Flota$min)

Flota[,intervalohora:=paste(Flota$hor,Flota$min,sep = ":")]


Flotahora<-data.frame(t(data.frame(tapply(Flota$Vehiculo,Flota[,c("COT","Fecha","Tipologia","intervalohora")],length))))


Flotahora<-cbind((colnames(t(Flotahora))),Flotahora)          
Flotahora<-as.data.table(Flotahora)
#names(Flotahora)=c("TODO","BYN","BYNPC","ETM","GIT","UNM")
names(Flotahora)=c("TODO","BYN","BYNPC","ETM","GIT")
#names(Flotahora)=c("TODO","BYN","BYNPC","ETM","GIT","NA","UNM")

Flotahora$TODO<-gsub("DUAL","DUA",Flotahora$TODO)
Flotahora$TODO<-gsub("NA","NA1",Flotahora$TODO)
#Flotahora$TODO<-gsub("COM.E","COM",Flotahora$TODO)
Flotahora$TODO<-gsub("COME","COM",Flotahora$TODO)

Flotahora[,Hora:= substr(Flotahora$TODO,17,22)]
Flotahora[,tipologia:= substr(Flotahora$TODO,13,15)]
Flotahora[,fecha:= substr(Flotahora$TODO,2,11)]

#hay dos problemas, que son los dos puntos

Flotahora<-replace(Flotahora,is.na(Flotahora),0)
floBNM<-data.frame(tapply(Flotahora$BYN,Flotahora[,c("fecha","tipologia")],max))
floGIT<-data.frame(tapply(Flotahora$GIT,Flotahora[,c("fecha","tipologia")],max))
floETM<-data.frame(tapply(Flotahora$ETM,Flotahora[,c("fecha","tipologia")],max))
#floUNM<-data.frame(tapply(Flotahora$UNM,Flotahora[,c("fecha","tipologia")],max))
floBNM2<-data.frame(tapply(Flotahora$BYNPC,Flotahora[,c("fecha","tipologia")],max))

#MaxBNM<-data.frame(tapply(Flotahora$BYN,Flotahora[,c("fecha","Hora","tipologia")],max))
#MaxGIT<-data.frame(tapply(Flotahora$GIT,Flotahora[,c("fecha","Hora","tipologia")],max))
#MaxETM<-data.frame(tapply(Flotahora$ETM,Flotahora[,c("fecha","Hora","tipologia")],max))
#MaxUNM<-data.frame(tapply(Flotahora$UNM,Flotahora[,c("fecha","Hora","tipologia")],max))
#MaxBNM2<-data.frame(tapply(Flotahora$BYNPC,Flotahora[,c("fecha","Hora","tipologia")],max))

MaxBNM<-data.frame(t(data.frame(tapply(Flotahora$BYN,Flotahora[,c("tipologia","fecha","Hora")],max))))
nombre<-colnames(data.frame(t(MaxBNM)))
MaxBNM<-as.data.table(cbind(nombre,MaxBNM))
#COT<-as.data.table(t(data.frame(c("nombre","BNM","BNM"))))
#names(COT)=c("nombre","NA1","PAD")


COT<-as.data.table(t(data.frame(c("nombre","BNM","BNM","BNM","BNM","BNM"))))
names(COT)=c("nombre","ART","COM","DUA","NA1","PAD")

#COT<-as.data.table(t(data.frame(c("nombre","BNM","BNM","BNM","BNM"))))
#names(COT)=c("nombre","ART","COM","NA1","PAD")

#names(COT)=c("nombre","COM","DUA","NA1","PAD")
COT<-COT[,-5]

MaxBNM<-rbind(COT,MaxBNM)

MaxGIT<-data.frame(t(data.frame(tapply(Flotahora$GIT,Flotahora[,c("tipologia","fecha","Hora")],max))))
nombre<-colnames(data.frame(t(MaxGIT)))
MaxGIT<-as.data.table(cbind(nombre,MaxGIT))

#COT<-as.data.table(t(data.frame(c("nombre","GIT","GIT"))))
#names(COT)=c("nombre","NA1","PAD")


COT<-as.data.table(t(data.frame(c("nombre","GIT","GIT","GIT","GIT","GIT"))))
names(COT)=c("nombre","ART","COM","DUA","NA1","PAD")
COT<-COT[,-5]
#COT<-as.data.table(t(data.frame(c("nombre","GIT","GIT","GIT","GIT"))))
#names(COT)=c("nombre","COM","DUA","NA1","PAD")
#names(COT)=c("nombre","ART","COM","NA1","PAD")

MaxGIT<-rbind(COT,MaxGIT)


MaxETM<-data.frame(t(data.frame(tapply(Flotahora$ETM,Flotahora[,c("tipologia","fecha","Hora")],max))))
nombre<-colnames(data.frame(t(MaxETM)))
MaxETM<-as.data.table(cbind(nombre,MaxETM))

COT<-as.data.table(t(data.frame(c("nombre","ETM","ETM","ETM","ETM","ETM"))))
names(COT)=c("nombre","ART","COM","DUA","NA1","PAD")
COT<-COT[,-5]
#COT<-as.data.table(t(data.frame(c("nombre","ETM","ETM","ETM","ETM"))))
#names(COT)=c("nombre","COM","DUA","NA1","PAD")
#names(COT)=c("nombre","ART","COM","NA1","PAD")

MaxETM<-rbind(COT,MaxETM)


#MaxUNM<-data.frame(t(data.frame(tapply(Flotahora$UNM,Flotahora[,c("tipologia","fecha","Hora")],max))))
#nombre<-colnames(data.frame(t(MaxUNM)))
#MaxUNM<-as.data.table(cbind(nombre,MaxUNM))

#COT<-as.data.table(t(data.frame(c("nombre","UNM","UNM","UNM","UNM","UNM"))))
#names(COT)=c("nombre","ART","COM","DUA","NA1","PAD")
#COT<-COT[,-5]
#COT<-as.data.table(t(data.frame(c("nombre","UNM","UNM","UNM","UNM"))))
#names(COT)=c("nombre","ART","COM","NA1","PAD")

#names(COT)=c("nombre","COM","DUA","NA1","PAD")


#MaxUNM<-rbind(COT,MaxUNM)


MaxBNM2<-data.frame(t(data.frame(tapply(Flotahora$BYNPC,Flotahora[,c("tipologia","fecha","Hora")],max))))
nombre<-colnames(data.frame(t(MaxBNM2)))
MaxBNM2<-as.data.table(cbind(nombre,MaxBNM2))

COT<-as.data.table(t(data.frame(c("nombre","BNM2","BNM2","BNM2","BNM2","BNM2"))))
names(COT)=c("nombre","ART","COM","DUA","NA1","PAD")
COT<-COT[,-5]
#COT<-as.data.table(t(data.frame(c("nombre","BNM2","BNM2","BNM2","BNM2"))))
#names(COT)=c("nombre","COM","DUA","NA1","PAD")
#names(COT)=c("nombre","ART","COM","NA1","PAD")


MaxBNM2<-rbind(COT,MaxBNM2)

MaxBNM<-MaxBNM[,c(1,2,5,3)]
MaxGIT<-MaxGIT[,c(1,2,5,3)]
MaxETM<-MaxETM[,c(1,2,5,3)]
#MaxUNM<-MaxUNM[,c(1,2,5,3)]
MaxBNM2<-MaxBNM2[,c(1,3,4)]

#MaxBNM<-MaxBNM[,c(1,2,5,3)]
#MaxGIT<-MaxGIT[,c(1,2,5,3)]
#MaxETM<-MaxETM[,c(1,2,5,3)]
#MaxUNM<-MaxUNM[,c(1,2,5,3)]
#MaxBNM2<-MaxBNM2[,c(1,3)]


#setkey(MaxUNM,nombre)
#setkey(MaxBNM2,nombre)
#Flotacomite<- MaxUNM[MaxBNM2,all=T]


setkey(MaxBNM2,nombre)
setkey(MaxETM,nombre)

#Flotacomite<- MaxETM[MaxBNM2,all=T]

Flotacomite<- MaxETM[MaxBNM2,all=T]

setkey(Flotacomite,nombre)
setkey(MaxBNM,nombre)
Flotacomite<- MaxBNM[Flotacomite,all=T]

setkey(Flotacomite,nombre)
setkey(MaxGIT,nombre)
Flotacomite<- MaxGIT[Flotacomite,all=T]
total<-length(Flotacomite$nombre)

FlotacomiteCOT<-Flotacomite[,1:4]
FlotacomiteCOT$ART<-as.integer(FlotacomiteCOT$ART)
FlotacomiteCOT$PAD<-as.integer(FlotacomiteCOT$PAD)
FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)
#FlotacomiteCOT[,totalGIT:=c(PAD+COM)]
FlotacomiteCOT[,totalGIT:=c(ART+PAD+COM)]
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

FlotacomiteCOT<-Flotacomite[,c(1,5:7)]
names(FlotacomiteCOT)=c("nombre","ART","PAD","COM")
#names(FlotacomiteCOT)=c("nombre","PAD","COM","DUA")
FlotacomiteCOT$ART<-as.integer(FlotacomiteCOT$ART)
FlotacomiteCOT$PAD<-as.integer(FlotacomiteCOT$PAD)
FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)
#FlotacomiteCOT[,totalBNM:=c(PAD+COM)]
FlotacomiteCOT[,totalBNM:=c(ART+PAD+COM)]
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

FlotacomiteCOT<-Flotacomite[,c(1,8:10)]
names(FlotacomiteCOT)=c("nombre","ART","PAD","COM")
#names(FlotacomiteCOT)=c("nombre","PAD","COM","DUA")
FlotacomiteCOT$ART<-as.integer(FlotacomiteCOT$ART)
FlotacomiteCOT$PAD<-as.integer(FlotacomiteCOT$PAD)
FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)
FlotacomiteCOT[,totalETM:=c(ART+PAD+COM)]
#FlotacomiteCOT[,totalETM:=c(PAD+COM)]
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

#FlotacomiteCOT<-Flotacomite[,c(1,11:13)]
#names(FlotacomiteCOT)=c("nombre","ART","PAD","COM")
#names(FlotacomiteCOT)=c("nombre","PAD","COM","DUA")
#FlotacomiteCOT$ART<-as.integer(FlotacomiteCOT$ART)
#FlotacomiteCOT$PAD<-as.integer(FlotacomiteCOT$PAD)
#FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)
#FlotacomiteCOT[,totalUNM:=c(PAD+COM)]
#FlotacomiteCOT[,totalUNM:=c(ART+PAD+COM)]
#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

FlotacomiteCOT<-Flotacomite[,c(1,11,12)]
#FlotacomiteCOT<-Flotacomite[,c(1,11,12)]

names(FlotacomiteCOT)=c("nombre","COM","DUA")
FlotacomiteCOT$DUA<-as.integer(FlotacomiteCOT$DUA)
FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)

FlotacomiteCOT[,totalBNM2:=c(DUA+COM)]
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,4])
#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,3])

#FlotacomiteCOT<-Flotacomite[,c(1,14:15)]
#names(FlotacomiteCOT)=c("nombre","COM","DUA")
#FlotacomiteCOT$DUA<-as.integer(FlotacomiteCOT$DUA)
#FlotacomiteCOT$COM<-as.integer(FlotacomiteCOT$COM)
#FlotacomiteCOT[,totalBNM2:=c(COM+DUA)]
#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,4])

#FlotacomiteCOT<-Flotacomite[,c(1,2,5,8,11)]
FlotacomiteCOT<-Flotacomite[,c(1,2,5,8)]

#names(FlotacomiteCOT)=c("nombre","ART1","ART2","ART3","ART4")
names(FlotacomiteCOT)=c("nombre","ART1","ART2","ART3")

FlotacomiteCOT$ART1<-as.integer(FlotacomiteCOT$ART1)
FlotacomiteCOT$ART2<-as.integer(FlotacomiteCOT$ART2)
FlotacomiteCOT$ART3<-as.integer(FlotacomiteCOT$ART3)
#FlotacomiteCOT$ART4<-as.integer(FlotacomiteCOT$ART4)

#FlotacomiteCOT[,totalART:=c(ART1+ART2+ART3+ART4)]
FlotacomiteCOT[,totalART:=c(ART1+ART2+ART3)]

#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,6])
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

#FlotacomiteCOT<-Flotacomite[,c(1,3,6,9,12)]
FlotacomiteCOT<-Flotacomite[,c(1,3,6,9)]

#names(FlotacomiteCOT)=c("nombre","PAD1","PAD2","PAD3","PAD4")
names(FlotacomiteCOT)=c("nombre","PAD1","PAD2","PAD3")

FlotacomiteCOT$PAD1<-as.integer(FlotacomiteCOT$PAD1)
FlotacomiteCOT$PAD2<-as.integer(FlotacomiteCOT$PAD2)
FlotacomiteCOT$PAD3<-as.integer(FlotacomiteCOT$PAD3)
#FlotacomiteCOT$PAD4<-as.integer(FlotacomiteCOT$PAD4)

#FlotacomiteCOT[,totalPAD:=c(PAD1+PAD2+PAD3+PAD4)]
FlotacomiteCOT[,totalPAD:=c(PAD1+PAD2+PAD3)]
#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,6])
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,5])

#FlotacomiteCOT<-Flotacomite[,c(1,4,7,10,13,14)]
FlotacomiteCOT<-Flotacomite[,c(1,4,7,10,11)]

#names(FlotacomiteCOT)=c("nombre","COM1","COM2","COM3","COM4","COM5")
names(FlotacomiteCOT)=c("nombre","COM1","COM2","COM3","COM4")

#names(FlotacomiteCOT)=c("nombre","COM1","COM2","COM3","COM4")

FlotacomiteCOT$COM1<-as.integer(FlotacomiteCOT$COM1)
FlotacomiteCOT$COM2<-as.integer(FlotacomiteCOT$COM2)
FlotacomiteCOT$COM3<-as.integer(FlotacomiteCOT$COM3)
FlotacomiteCOT$COM4<-as.integer(FlotacomiteCOT$COM4)
#FlotacomiteCOT$COM5<-as.integer(FlotacomiteCOT$COM5)

#FlotacomiteCOT[,totalCOM:=c(COM1+COM2+COM3+COM4+COM5)]
FlotacomiteCOT[,totalCOM:=c(COM1+COM2+COM3+COM4)]

#Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,7])
Flotacomite<-cbind(Flotacomite,FlotacomiteCOT[,6])

#Flotacomite[,total:=c(totalGIT+totalBNM+totalUNM+totalETM+totalBNM2)]
Flotacomite[,total:=c(totalGIT+totalBNM+totalETM+totalBNM2)]

fecha<-substr(Flotacomite$nombre,1,12)
Hora<-data.table(substr(Flotacomite$nombre,13,18))
hor_min<-data.table(str_split_fixed(Hora$V1,"[.]",2))
Hora<-cbind(Hora,hor_min)
names(Hora)=c("Hora","hora1","Media")
Flotacomite[,Fecha:=fecha]
Flotacomite<-cbind(Flotacomite,Hora)

#Flotacomite<-Flotacomite[,c(1,26,2:20,24,25,28,27,21:23)]

tableroflota1<-Flotacomite[-1,]
tableroflota<-Flotacomite[-1,]

tableroflota<-data.frame(tapply(tableroflota$total,tableroflota$Fecha,max))
tableroflota<-cbind(colnames(t(tableroflota)),tableroflota)
names(tableroflota)=c("Fecha","maximo")
tableroflota<-as.data.table(tableroflota)
tableroflota1<-as.data.table(tableroflota1)

tableroflota1[,Max:= paste(tableroflota1$Fecha,tableroflota1$total)]
tableroflota[,Max:= paste(tableroflota$Fecha,tableroflota$maximo)]

setkey(tableroflota1,Max)
setkey(tableroflota,Max)
tableroflota<- tableroflota1[tableroflota,all=T]



Flota[,maximo:="maximo"]

Flotahora11<-data.frame(t(data.frame(tapply(Flota$Vehiculo,Flota[,c("maximo","COT","Fecha","Tipologia","intervalohora")],length))))

Flotahora11<-cbind((colnames(t(Flotahora11))),Flotahora11)          
Flotahora11<-as.data.table(Flotahora11)
names(Flotahora11)=c("TODO","Total")
tabular<-str_split_fixed(Flotahora11$TODO,"[.]",6)
Flotahora11<-cbind(Flotahora11,tabular)
names(Flotahora11)=c("TODO","Total","COT","Año","Mes","Dia","Tipologia","Hora")

#hay dos problemas, que son los dos puntos

Flotahora11<-replace(Flotahora11,is.na(Flotahora11),0)

Fechasmaxima<-tableroflota[,c(1,20)]

Fechasmaxima[,unicos:=substr(nombre,1,10)]



Flotahora11[,nombre:=paste(Año,Mes,Dia,Hora,sep = ".")]
Fechasmaxima$nombre<-gsub("X","",Fechasmaxima$nombre)

setkey(Fechasmaxima,nombre)
setkey(Flotahora11,nombre)
Fechasmaxima1<- Flotahora11[Fechasmaxima,all=T]

Fechasmaxima1<-Fechasmaxima1[,-11]

Fechasmaxima1[,Fecha:=substr(nombre,1,10)]

Fechasmaxima1$Fecha<-gsub("[.]","-",Fechasmaxima1$Fecha)

rm(Flota,k1,Flotatab,Flotatabhora)

#FlotaMax_Tipologia22_24_25<-rbind(FlotaMax_Tipologia22_24_25,Fechasmaxima1)

#FlotaMax_Tipologia22_24_25<-unique(FlotaMax_Tipologia22_24_25)
