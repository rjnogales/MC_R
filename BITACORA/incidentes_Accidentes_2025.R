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

if (rstudioapi::isAvailable()) {
  current_dir <- dirname(rstudioapi::getActiveDocumentContext()$path)
} else {
  #current_dir <- file.path(getwd(), "02 - Salidas")
  current_dir <- file.path(getwd())
}
current_dir

load(file.path(getwd(),"calificacion2024.RData"))
data_frame23<-data_frame
load(file.path(getwd(),"calificacion2025.RData"))
data_frame23<-data_frame23[,-53]
data_frame25<-data_frame
load(file.path(getwd(),"calificacion2026.RData"))
#data_frame<-data_frame[,-53]

#data_ultimo<-load(file.path(getwd(),"datafre2025.RData"))

data_frame1<-rbind(data_frame23,data_frame25,data_frame)
rm(data_frame23)

load(file.path(getwd(),"Kmnoretomadas.RData"))
load(file.path(getwd(),"Kmsalidas.RData"))


kmsalidas<-rbind(k1[,c(1,4,10)],salidasnoretomadas2[,c(1,7,13)])

data_frame$NUMERO_VEHICULO<-as.numeric(data_frame$NUMERO_VEHICULO)
data_frame$NUMERO_VEHICULO<-as.character(data_frame$NUMERO_VEHICULO)

data_frame$CODIGO_OPERADOR<-as.numeric(data_frame$CODIGO_OPERADOR)
data_frame$CODIGO_OPERADOR<-as.character(data_frame$CODIGO_OPERADOR)

data_frame<-rbind(data_frame1,data_frame)

data_frame<-unique(data_frame)

rm(data_frame1)


#save(data_frame,file =(file.path(getwd(),"calificacion2025.RData")))

consobita<-data_frame
consobita$JERARQUIA<-as.character(consobita$JERARQUIA)
TABV<-str_split_fixed(consobita$JERARQUIA,"::",5)
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


consobitaNA<-consobita[consobita$X4=="NA"]
consobita<-consobita[consobita$X4!="NA"]
consobitablanco<-consobita[consobita$X3==""]
consobita<-consobita[consobita$X3!=""]

consobita<-rbind(consobita,consobitablanco)

consobita1<-consobita[consobita$X3==""]
consobita1[,X3:=TIPO_EVENTO ]
consobita<-consobita[consobita$X3!=""]

consobita<-rbind(consobita1,consobita)

consobita1<-consobita[consobita$X4==""]
consobita1[,X4:=X3 ]
consobita<-consobita[consobita$X4!=""]

consobita<-rbind(consobita1,consobita)

consobita1<-consobita[consobita$X5==""]
consobita1[,X5:=X4 ]
consobita<-consobita[consobita$X5!=""]

consobita<-rbind(consobita1,consobita)

consobita$Fecha<-as.Date(consobita$Fecha,origin = "1899-12-30")
consobita<-consobita[consobita$TIPO_EVENTO!="TIPO_EVENTO"]

consobita$Puntos<-as.integer(consobita$Puntos)

consobita$Puntos<-replace(consobita$Puntos,is.na(consobita$Puntos),0)

consobita[,FCTP:=paste(Fecha,Concesionario,Tipologia,sep = "_")]

kmsalidas[,kmsal:=paste(NUMERO_DE_CASO,Fecha,sep = "_")]
consobita[,kmsal:=paste(NUMERO_DE_CASO,Fecha,sep = "_")]

kmsalidas<-kmsalidas[,c(1,4)]

setkey(kmsalidas,kmsal)
setkey(consobita,kmsal)
consobita<-kmsalidas[consobita, all= TRUE]
consobita<-consobita[,c(3:63,64,65,1,2)]
consobita$Kilometros_peridos<-replace(consobita$Kilometros_peridos,is.na(consobita$Kilometros_peridos),0)
consobita[,Kilometros_peridos:=Kilometros_peridos*-1]
consobita[,Kilometros_peridos:=round((Kilometros_peridos/1000),1)]


consobita<-consobita[,Quincena:=Dia]
##consobita$Quincena<-as.numeric(consobita$Quincena)
consobita$Quincena<-replace(consobita$Quincena,consobita$Quincena>15,"2Q")
consobita$Quincena<-replace(consobita$Quincena,consobita$Quincena<16,"1Q")
consobita<-consobita[,Quincena:=paste(Año,Mes,Quincena,sep = "-")]
#salidas<-consobita[consobita$X2=="SALIDAS"]
salidas<-consobita[consobita$TIPO_EVENTO=="Salida"]
#salidas[,TIPO_sali:=paste(X2,X3,sep = "_")]

abandono<-salidas[salidas$X3=="POR ABANDONO DE TAREA"]
abandono[,X3:=X4]
ALARMA<-salidas[salidas$X3=="POR ALARMA"]
ALARMA[,X3:=X4]

salidas<-salidas[salidas$X3!="POR ABANDONO DE TAREA"]
salidas<-salidas[salidas$X3!="POR ALARMA"]


salidas<-rbind(salidas,abandono,ALARMA)

Hitos<-consobita[consobita$Calificacion=="H"]



P_IE<-consobita[consobita$Indice=="IE"]
P_IO<-consobita[consobita$Indice=="IO"]
P_Totales<-rbind(P_IE,P_IO)

PuntosIE<-data.frame(tapply(P_IE$Puntos,P_IE$FCTP,sum))
PuntosIO<-data.frame(tapply(P_IO$Puntos,P_IO$FCTP,sum))

PuntosIE<-cbind(colnames(t(PuntosIE)),PuntosIE)
PuntosIO<-cbind(colnames(t(PuntosIO)),PuntosIO)

names(PuntosIE)=c("Fecha","Puntos")

TABV<-str_split_fixed(PuntosIE$Fecha,"[_]",3)
PuntosIE<-cbind(TABV,PuntosIE)
PuntosIE<-PuntosIE[,c(1,2,3,5)]
names(PuntosIE)=c("Fecha","COT","Tipologia","Puntos")

P_TotalesIE<-PuntosIE



TotalNovedadesDane<-as.data.frame(tapply(consobita$JERARQUIA,consobita[,c("X3","Mes")],length))
TotalNovedadesDane<-cbind(row.names(TotalNovedadesDane),TotalNovedadesDane)


Incidentes<-consobita[consobita$Calificacion=="1y3"]
Incidentes.IA<-consobita
Tipo.IA<-str_split_fixed(Incidentes.IA$JERARQUIA,"::",5)
Tipo.IA<-data.frame(Tipo.IA)
Incidentes.IA<-cbind(Incidentes.IA,Tipo.IA)
Incidentes.IA<-Incidentes.IA[Incidentes.IA$X3=="POR CHOQUE SIMPLE"]
jerinci<-unique(Incidentes$JERARQUIA)
jerinci<-data.frame(unique(Incidentes$JERARQUIA))
Incidentes$JERARQUIA<-as.character(Incidentes$JERARQUIA)
Tipo_inci<-str_split_fixed(Incidentes$JERARQUIA,"::",5)
Tipo_inci<-data.frame(Tipo_inci)
Incidentes<-cbind(Incidentes,Tipo_inci)
Incidentes<-rbind(Incidentes,Incidentes.IA)
Incidentes1<-data.frame(tapply(Incidentes$JERARQUIA,Incidentes$X4,length))
nombreincidente<-colnames(t(Incidentes1))
Incidentes1<-cbind(nombreincidente,Incidentes1)
ab<-Incidentes1[Incidentes1$nombreincidente=="ABANDONA VEHICULO SIN AUTORIZACION",]
ue<-Incidentes1[Incidentes1$nombreincidente=="USA EQUIPO ELECTRONICO NO AUTORIZADO",]
ad<-Incidentes1[Incidentes1$nombreincidente=="ALTERA RECORRIDO DE RUTA REPORTA DIRECCION DE OPERACIONES",]
ra<-Incidentes1[Incidentes1$nombreincidente=="REALIZA PARADA NO AUTORIZADA",]
tp<-Incidentes1[Incidentes1$nombreincidente=="TRANSITA CON PUERTAS ABIERTAS",]
da<-Incidentes1[Incidentes1$nombreincidente=="DESACATA LA AUTORIDAD",]
ns<-Incidentes1[Incidentes1$nombreincidente=="NO USA O USA MAL EL CINTURON DE SEGURIDAD",]
ea<-Incidentes1[Incidentes1$nombreincidente=="ESTACIONA EN PARADERO NO AUTORIZADO",]
ar<-Incidentes1[Incidentes1$nombreincidente=="ALTERA RECORRIDO DE RUTA",]
cr<-Incidentes1[Incidentes1$nombreincidente=="CRUZA SEMAFORO EN ROJO",]
ia<-Incidentes1[Incidentes1$nombreincidente=="INGIERE ALIMENTOS DURANTE LA CONDUCCION",]
ci<-Incidentes1[Incidentes1$nombreincidente=="CONDUCE DE MANERA INADECUADA",]
dr<-Incidentes1[Incidentes1$nombreincidente=="DA REVERSA SIN AUTORIZACION",]
en<-Incidentes1[Incidentes1$nombreincidente=="ESTACIONA EN SITIO O ESTACION NO AUTORIZADO EN CANTIDAD O TIEMPO SUPERIOR AL PERMITIDO",]
aa<-Incidentes1[Incidentes1$nombreincidente=="OPERA CON LUCES APAGADAS DURANTE LA PENUMBRA",]
am<-Incidentes1[Incidentes1$nombreincidente=="APROXIMA MAL",]
is<-Incidentes1[Incidentes1$nombreincidente=="INTERRUMPE CRUCE SEMAFORICO",]
bm<-Incidentes1[Incidentes1$nombreincidente=="BUS DEL MIO",]
of<-Incidentes1[Incidentes1$nombreincidente=="OBJETO FIJO",]
av<-Incidentes1[Incidentes1$nombreincidente=="ABANDONA VEHICULO SIN AUTORIZACION",]
vp<-Incidentes1[Incidentes1$nombreincidente=="VEHICULO PARTICULAR",]
ua<-Incidentes1[Incidentes1$nombreincidente=="USA EQUIPO ELECTRONICO NO AUTORIZADO DURANTE LA CONDUCCION",]
Incidentes$NUMERO_VEHICULO<-as.character(Incidentes$NUMERO_VEHICULO)
Incidentes.IA$X4<-as.character(Incidentes.IA$X4)
tip.IA<-tapply(Incidentes.IA$JERARQUIA,Incidentes.IA[,c("X4","Concesionario")],length)
Incidentes.IA$Concesionario<-as.character(Incidentes.IA$Concesionario)
Incidentes1.1<-rbind(ua,vp,av,of,bm,is,am,aa,en,da,ci,ia,ar,ea,ns,dr,tp,ra,ad,ue,ab)
rm(ua,vp,av,of,bm,is,am,aa,en,da,ci,ia,ar,ea,ns,dr,tp,ra,ad,ue,ab)
Incidentes1.1<-data.frame(sum(Incidentes1.1$tapply.Incidentes.JERARQUIA..Incidentes.X4..length.))

Incidentes.IA1<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA[,c("nombre_archivo","Concesionario")],length))
Incidentes.IA1<-cbind(colnames(t(Incidentes.IA1)),Incidentes.IA1)
names(Incidentes.IA1)=c("Fecha" ,  "Concesionario.Blanco.y.Negro" , "Concesionario.Blanco.y.Negro2", "Concesionario.ETM" ,"Concesionario.GIT.Masivo") 
Incidentes.IA2<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA[,c("nombre_archivo","X4")],length))
Incidentes.IA2<-cbind(colnames(t(Incidentes.IA2)),Incidentes.IA2)
names(Incidentes.IA2)=c("Fecha" , "BUS.DEL.MIO" ,"OBJETO.FIJO" , "VEHICULO.PARTICULAR") 
Incidentes.IA1<-as.data.table(Incidentes.IA1)
Incidentes.IA2<-as.data.table(Incidentes.IA2)

setkey(Incidentes.IA1,Fecha)
setkey(Incidentes.IA2,Fecha)
Incidentes.IA4<-Incidentes.IA2[Incidentes.IA1, all= TRUE]
mes<-(substr(Incidentes.IA4$Fecha,3,4))
dia<-(substr(Incidentes.IA4$Fecha,5,6))
año<-(substr(Incidentes.IA4$Fecha,1,2))
Incidentes.IA4<-Incidentes.IA4[,Mes:=mes]
Incidentes.IA4<-Incidentes.IA4[,Dia:=dia]
Incidentes.IA4<-Incidentes.IA4[,año:=paste(20,año,sep ="")]
Incidentes.IA4[,Fecha:=paste(año,mes,dia, sep = "-")]


mes<-(substr(Incidentes.IA$nombre_archivo,3,4))
dia<-(substr(Incidentes.IA$nombre_archivo,5,6))
año<-(substr(Incidentes.IA$nombre_archivo,1,2))
Incidentes.IA<-Incidentes.IA[,Mes:=mes]
Incidentes.IA<-Incidentes.IA[,Dia:=dia]
Incidentes.IA<-Incidentes.IA[,año:=paste(20,año,sep ="")]
Incidentes.IA[,Fecha:=paste(año,mes,dia, sep = "-")]

Incidentes.IA3<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA$Fecha,length))
Incidentes.IA3<-cbind(colnames(t(Incidentes.IA3)),Incidentes.IA3)
names(Incidentes.IA3)=c("Fecha","total")

BDincidentes<-Incidentes.IA

Tipo_incidenteeoperador1<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA$CODIGO_OPERADOR,length))
codigo<-colnames(t(Tipo_incidenteeoperador1))
Tipo_incidenteeoperador1<-cbind(codigo,Tipo_incidenteeoperador1)

Incidentes.IA[,mes:=(substr(Incidentes.IA$nombre_archivo,3,4))]
Incidentes.IAmes1<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA[,c("Concesionario","mes","X4")],length))
Incidentes.IAmes<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA$mes,length))

Incidentes.IA<-data.frame(tapply(Incidentes.IA$JERARQUIA,Incidentes.IA[,c("X4","Concesionario")],length))




#Incidentes.IA<-Incidentes.IA[,c(4,1,3,5,2)]

#filtrar por tipo incidentes
AD<-data_frame[data_frame$`Modificatorio apendice 3`=="AD3"]
AH<-data_frame[data_frame$`Modificatorio apendice 3`=="AH"]
AF<-data_frame[data_frame$`Modificatorio apendice 3`=="AF"]
Accidentes<-rbind(AH,AD,AF)
Accidentes$`Modificatorio apendice 3`<-as.character(Accidentes$`Modificatorio apendice 3`)
Accidentes$RUTA<-as.character(Accidentes$RUTA)
MES<-(substr(Accidentes$nombre_archivo,3,4))
dia<-(substr(Accidentes$nombre_archivo,5,6))
#Quincena<-(substr(Accidentes$nombre_archivo,5,6))
Accidentes<-cbind(Accidentes,MES,dia)

Accidentes$Concesionario<-as.character(Accidentes$Concesionario)
Accidentes$NUMERO_VEHICULO<-as.character(Accidentes$NUMERO_VEHICULO)
setkey(Accidentes,NUMERO_VEHICULO)
Accidentes[,Acc_Vehiculo1 :=.N,by=list(NUMERO_VEHICULO)]
setkey(Accidentes,CODIGO_OPERADOR)
Accidentes[,Acc_Operador1 :=.N,by=list(CODIGO_OPERADOR)]
Accidentes$SITIO_EVENTO<-as.character(Accidentes$SITIO_EVENTO)
AccidentesN.a<-Accidentes[Accidentes$SITIO_EVENTO!="N.A"]
AccidentesN.a<-AccidentesN.a[,Direcciones:=SITIO_EVENTO]
N.a<-Accidentes[Accidentes$SITIO_EVENTO=="N.A"]
isna<-Accidentes[is.na(Accidentes$SITIO_EVENTO)]
N.a<-N.a[,Direcciones:=SITIO_SALIDA]
isna<-isna[,Direcciones:=SITIO_SALIDA]
Accidentes<-rbind(N.a,AccidentesN.a,isna)
setkey(Accidentes,Direcciones)
Accidentes[,Acc_Dir :=.N,by=list(Direcciones)]

#salidas<-Accidentes[Accidentes$TIPO_EVENTO=="Salida"]
#contra<-substr(salidas$JERARQUIA,48,59)
#salidas<-salidas[,Contra:=contra]
#incidente<-Accidentes[Accidentes$TIPO_EVENTO=="Incidente"]
#conta<-substr(incidente$JERARQUIA,52,63)
#incidente<-incidente[,Contra:=conta]
#Accidentes<-rbind(salidas,incidente)
mes<-(substr(Accidentes$nombre_archivo,3,4))
dia<-(substr(Accidentes$nombre_archivo,5,6))
año<-(substr(Accidentes$nombre_archivo,1,2))
extipvehic<-data.frame(substr(Accidentes$NUMERO_VEHICULO,2,2))

#TAB<-strsplit(Accidentes$JERARQUIA,"::",fixed=T)
#TAB<- data.frame(TAB)
#TAB<- t(TAB)
#TAB<- data.frame(TAB)
#Accidentes<-cbind(Accidentes,TAB)
#Accidentes<-Accidentes[,-c(53,54,55)]
Accidentes$`Codificacion Concesionario`<-as.character(Accidentes$`Codificacion Concesionario`)
Accidentes$`Codificacion Concesionario`<-as.integer(Accidentes$`Codificacion Concesionario`)
Accidentes$CODIGO_OPERADOR<-as.character(Accidentes$CODIGO_OPERADOR)
Accidentes$CODIGO_OPERADOR<-as.integer(Accidentes$CODIGO_OPERADOR)
Accidentes$NUMERO_DE_CASO<-as.character(Accidentes$NUMERO_DE_CASO)
Accidentes$NUMERO_DE_CASO<-as.integer(Accidentes$NUMERO_DE_CASO)
Accidentes<-Accidentes[,Mes:=mes]
Accidentes<-Accidentes[,Dia:=dia]
Accidentes<-Accidentes[,Ano:=paste(20,año,sep ="")]
Accidentes[,Fecha:=paste(Accidentes$Ano,mes,dia, sep = "-")]
Accidentes$Fecha<-as.Date(Accidentes$Fecha)
Accidentes<-Accidentes[,Tipo_vehiculo:=extipvehic]
Accidentes$NUMERO_LESIONADOS<-as.character(Accidentes$NUMERO_LESIONADOS)
Accidentes$NUMERO_LESIONADOS<-as.integer(Accidentes$NUMERO_LESIONADOS)
Accidentes$JERARQUIA<-as.character(Accidentes$JERARQUIA)
Tipo_accidente<-str_split_fixed(Accidentes$JERARQUIA,"::",5)
Tipo_accidente<-data.frame(Tipo_accidente)
Accidentes<-cbind(Accidentes,Tipo_accidente)
Accidentes<-Accidentes[,-c(59,60,61)]
Accidentes$NUMERO_VEHICULO<-as.character(Accidentes$NUMERO_VEHICULO)
setkey(Accidentes,NUMERO_VEHICULO)
Accidentes[,Acc_Vehiculo1 :=.N,by=list(NUMERO_VEHICULO)]
setkey(Accidentes,CODIGO_OPERADOR)
Accidentes[,Acc_Operador1 :=.N,by=list(CODIGO_OPERADOR)]
AccidentesBYN<-Accidentes[Accidentes$Concesionario=="Concesionario Blanco y Negro"]
AccidentesBYN2<-Accidentes[Accidentes$Concesionario=="Concesionario Blanco y Negro2"]
AccidentesBYN<-rbind(AccidentesBYN,AccidentesBYN2)
AccidentesGIT<-Accidentes[Accidentes$Concesionario=="Concesionario GIT Masivo"]
AccidentesETM<-Accidentes[Accidentes$Concesionario=="Concesionario ETM"]
AccidentesUNM<-Accidentes[Accidentes$Concesionario=="Concesionario Unimetro"]
Tipo_accidenteB<-data.frame(tapply(AccidentesBYN$JERARQUIA,AccidentesBYN$X4,length))
Tipo_accidenteG<-data.frame(tapply(AccidentesGIT$JERARQUIA,AccidentesGIT$X4,length))
Tipo_accidenteE<-data.frame(tapply(AccidentesETM$JERARQUIA,AccidentesETM$X4,length))
Tipo_accidenteU<-data.frame(tapply(AccidentesUNM$JERARQUIA,AccidentesUNM$X4,length))
#Tipo_accidente<-cbind(Tipo_accidenteG,Tipo_accidenteB,Tipo_accidenteE,Tipo_accidenteU)
Tipo_accidente2<-data.frame(tapply(Accidentes$JERARQUIA,Accidentes[,c("X4","Concesionario")],length))
#Tipo_accidente2<-Tipo_accidente2[-5,]
Tipo_accidente<-Tipo_accidente2
Tipo_accidenteoperador1<-data.frame(tapply(Accidentes$JERARQUIA,Accidentes$CODIGO_OPERADOR,length))
codigo<-colnames(t(Tipo_accidenteoperador1))
Tipo_accidenteoperador<-data.frame(tapply(Accidentes$JERARQUIA,Accidentes[,c("CODIGO_OPERADOR","X4")],length))
Tipo_accidenteoperador1<-cbind(codigo,Tipo_accidenteoperador1)
names(Tipo_accidenteoperador1)=c("Operador","accidentes")
Tipo_accidenteoperador<-cbind(Tipo_accidenteoperador1,Tipo_accidenteoperador)
Tipo_accidenteoperador1$Operador<-as.character(Tipo_accidenteoperador1$Operador)
Tipo_accidenteoperador1$accidentes<-as.character(Tipo_accidenteoperador1$accidentes)
Tipo_accidenteoperador1$accidentes<-as.integer(Tipo_accidenteoperador1$accidentes)
Tipo_accidenteoperador1<-data.frame(tapply(Tipo_accidenteoperador1$Operador,Tipo_accidenteoperador1$accidentes,length))
Tipo_accidenteoperador<-as.data.table(Tipo_accidenteoperador)
Tipo_accidenteoperador[,COT:=substr(codigo,1,1)]
Opera2<-Tipo_accidenteoperador[Tipo_accidenteoperador$accidentes>=2]


Particulares<-Accidentes[Accidentes$X4=="VEHICULO PARTICULAR"]
OBJETOFIJO<-Accidentes[Accidentes$X4=="OBJETO FIJO"]
Particulares$X5<-as.character(Particulares$X5)
OBJETOFIJO$X5<-as.character(OBJETOFIJO$X5)
ACCIPARTICI<-data.frame(tapply(Particulares$JERARQUIA,Particulares[,c("X5","Concesionario")],length))
ACCIFIJO<-data.frame(tapply(OBJETOFIJO$JERARQUIA,OBJETOFIJO[,c("X5","Concesionario")],length))
PropiosB<-Accidentes[Accidentes$X4=="BUS DEL MIO"]
PropiosA<-Accidentes[Accidentes$X5=="ARBOL"]
Propios<-rbind(PropiosA,PropiosB)
Propios<-Propios[Propios$`Modificatorio apendice 3`=="AD3"]
Acci.propios<-data.frame(tapply(Propios$JERARQUIA,Propios[,c("Concesionario","Tipo_vehiculo")],length))
severidadpropios<-data.frame(tapply(Propios$JERARQUIA,Propios[,c("Concesionario","Tipo_vehiculo")],length))
severidad_tipologia<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Modificatorio apendice 3","Tipo_vehiculo")], length)
exruta<-data.frame(substr(Accidentes$RUTA,1,1))
Accidentes<-Accidentes[,Tipo_ruta:=exruta]
severidad_tipservicio<-tapply(Accidentes$Concesionario,Accidentes[,c("Modificatorio apendice 3","Tipo_ruta")], length)
severidad_COT<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Modificatorio apendice 3","Concesionario")], length)
severidad_COT<-replace(severidad_COT,is.na(severidad_COT),0)
severidad_COT<-data.frame(cbind(colnames(t(severidad_COT)),severidad_COT))
names(severidad_COT)=c("TIPO","BNM","BCPC","ETM","GIT")

#severidad_tipservicioB<-tapply(AccidentesBYN$JERARQUIA,AccidentesBYN[,c("Modificatorio apendice 3","Tipo_ruta")], length)
#severidad_tipservicioG<-tapply(AccidentesGIT$JERARQUIA,AccidentesGIT[,c("Modificatorio apendice 3","Tipo_ruta")], length)
#severidad_tipservicioE<-tapply(AccidentesETM$JERARQUIA,AccidentesETM[,c("Modificatorio apendice 3","Tipo_ruta")], length)
#severidad_tipservicioU<-tapply(AccidentesUNM$JERARQUIA,AccidentesUNM[,c("Modificatorio apendice 3","Tipo_ruta")], length)


lesi_Tiposerv<-tapply(Accidentes$NUMERO_LESIONADOS,Accidentes[,c("Concesionario","Tipo_ruta")], sum)
Cant_conLesi_Tiposerv<-tapply(Accidentes$NUMERO_LESIONADOS,Accidentes[,c("Concesionario","Tipo_ruta","Modificatorio apendice 3")], length)
Cant_conLesi_Tiposerv<-data.frame(Cant_conLesi_Tiposerv)
lesionados<-Accidentes[Accidentes$NUMERO_LESIONADOS>0]
Lesi_Tiposerv<-tapply(Accidentes$NUMERO_LESIONADOS,Accidentes[,c("Concesionario","Tipo_ruta")], sum)
Accidentes$Tipo_ruta<-as.character(Accidentes$Tipo_ruta)
Numerolesiona<-data.frame(tapply(lesionados$NUMERO_LESIONADOS,lesionados[,c("Concesionario","Tipo_ruta","Modificatorio apendice 3")], sum))
Numerolesiona<-replace(Numerolesiona,is.na(Numerolesiona),0)

severidad_tipologiaB<-tapply(AccidentesBYN$JERARQUIA,AccidentesBYN[,c("Modificatorio apendice 3","Tipo_vehiculo")], length)
severidad_tipologiaG<-tapply(AccidentesGIT$JERARQUIA,AccidentesGIT[,c("Modificatorio apendice 3","Tipo_vehiculo")], length)
severidad_tipologiaE<-tapply(AccidentesETM$JERARQUIA,AccidentesETM[,c("Modificatorio apendice 3","Tipo_vehiculo")], length)
#severidad_tipologiaU<-tapply(AccidentesUNM$JERARQUIA,AccidentesUNM[,c("Modificatorio apendice 3","Tipo_vehiculo")], length)
#Accidentes_RutasGIT<-tapply(AccidentesGIT$RUTA,AccidentesGIT$RUTA,length)
#Accidentes_RutasETM<-tapply(AccidentesETM$RUTA,AccidentesETM$RUTA,length)
#Accidentes_RutasUNM<-tapply(AccidentesUNM$RUTA,AccidentesUNM$RUTA,length)
#Accidentes_RutasBYN<-tapply(AccidentesBYN$RUTA,AccidentesBYN$RUTA,length)
#Accidentes_jerarquiaGIT<-tapply(AccidentesGIT$JERARQUIA,AccidentesGIT$JERARQUIA,length)
#Accidentes_jerarquiaETM<-tapply(AccidentesETM$JERARQUIA,AccidentesETM$JERARQUIA,length)
#Accidentes_jerarquiaBYM<-tapply(AccidentesBYM$JERARQUIA,AccidentesBYN$JERARQUIA,length)
#Accidentes_jerarquiaUNM<-tapply(AccidentesUNM$JERARQUIA,AccidentesUNM$JERARQUIA,length)
#Accidentes<-Accidentes[Accidentes$Mes=="06"]
accixserv<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Concesionario","Tipo_ruta")],length)
accixserv<-data.frame(accixserv)
accixTipov<-tapply(Accidentes$JERARQUIA,Accidentes$Tipo_vehiculo,length)
accixTipov<-data.frame(accixTipov)
accixCOT<-tapply(Accidentes$JERARQUIA,Accidentes$Concesionario,length)
accixCOT<-data.frame(accixCOT)
accixCOT<-data.frame(accixCOT[c(1,2,3,4),])

load(file.path(getwd(),"indicadores.RData"))
#Indi_subsi<-as.data.table(indicadores[-c(1,2),c(1,3,243:280)])
#Indi_subsi$...1<-as.character(Indi_subsi$...1)
#Indi_subsi$...1<-as.numeric(Indi_subsi$...1)
#Indi_subsi$...1<-as.numeric(Indi_subsi$...262)

load(file.path(getwd(),"Diatipo.RData"))
Diatipo<-as.data.table(Diatipo[-c(1,2),c(1,3)])
names(Diatipo)=c("Fecha","Diatipo")
Diatipo$Fecha<-as.numeric(Diatipo$Fecha)
Diatipo$Fecha<-as.Date(Diatipo$Fecha,origin = "1899-12-30")
Diatipo$Fecha<-as.character(Diatipo$Fecha)
Accidia<-data.table(Accidentes[,c("nombre_archivo","JERARQUIA","Fecha")])
Accidia$Fecha<-as.character(Accidia$Fecha)
setkey(Diatipo,Fecha)
setkey(Accidia,Fecha)
Accidia<-Diatipo[Accidia, all= TRUE]
Accidia<-data.frame(tapply(Accidia$Fecha,Accidia$Diatipo,length))
Accidia<-data.frame(Accidia)



#Organizacion severidad

severidad_tipologia<-(as.data.table(severidad_tipologia<-cbind(colnames(t(severidad_tipologia)),severidad_tipologia)))
severidad_tipologia[,COT:="MIO"]
severidad_tipologiaB<-(as.data.table(severidad_tipologiaB<-cbind(colnames(t(severidad_tipologiaB)),severidad_tipologiaB)))
severidad_tipologiaB[,COT:="B"]
severidad_tipologiaE<-(as.data.table(severidad_tipologiaE<-cbind(colnames(t(severidad_tipologiaE)),severidad_tipologiaE)))
severidad_tipologiaE[,COT:="E"]
severidad_tipologiaG<-(as.data.table(severidad_tipologiaG<-cbind(colnames(t(severidad_tipologiaG)),severidad_tipologiaG)))
severidad_tipologiaG[,COT:="G"]
#severidad_tipologiaU<-(as.data.table(severidad_tipologiaU<-cbind(colnames(t(severidad_tipologiaU)),severidad_tipologiaU)))
#severidad_tipologiaU[,COT:="U"]
#severidad_tipologia<-rbind(severidad_tipologia,severidad_tipologiaB,severidad_tipologiaE,severidad_tipologiaG)
Acci.propios<-(as.data.table(Acci.propios<-cbind(Acci.propios,colnames(t(Acci.propios)))))
Acci.propios[,Severidad:="AD1"]
#Acci.propios<-Acci.propios[c(4,1,3,5,2),]
Tipo_accidente<-(as.data.table(Tipo_accidente<-cbind(colnames(t(Tipo_accidente)),Tipo_accidente)))
Tipo_accidente<-Tipo_accidente[,c(1,5,2,4,3)]
names(Tipo_accidente)=c("Tipo","GIT","BNM","ETM","BCPC")
#Tipo_accidente$ETM<-replace(Tipo_accidente$ETM,is.na(Tipo_accidente$ETM),0)
#Tipo_accidente$UNM<-replace(Tipo_accidente$UNM,is.na(Tipo_accidente$UNM),0)
#Tipo_accidente$GIT<-replace(Tipo_accidente$GIT,is.na(Tipo_accidente$GIT),0)
#Tipo_accidente$BNM<-replace(Tipo_accidente$BNM,is.na(Tipo_accidente$BNM),0)

#Tipo_accidente<-Tipo_accidente[,Total:=c(Tipo_accidente$GIT+Tipo_accidente$BNM+Tipo_accidente$ETM+Tipo_accidente$UNM)]
#Tipo_accidente<-Tipo_accidente[,TotalT:=c(((Tipo_accidente$GIT+Tipo_accidente$BNM+Tipo_accidente$ETM+Tipo_accidente$UNM)/sum(Total))*100)]

severidad_COTdia<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Fecha","Modificatorio apendice 3")], length)
Accid.COT.dia<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Fecha","Concesionario")], length)
Accid.COT.dia<-Accid.COT.dia[,c(4,1,3,2)]
Accid.serv.dia<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Fecha","Tipo_ruta")], length)

Accid.serv.dia<-replace(Accid.serv.dia,is.na(Accid.serv.dia),0)
nomb<-colnames(t(Accid.serv.dia))

Accid.serv.dia<-as.data.table(cbind(nomb,Accid.serv.dia))
Accid.serv.dia$E<-as.numeric(Accid.serv.dia$E)
Accid.serv.dia$T<-as.numeric(Accid.serv.dia$T)
Accid.serv.dia[,Troncal:=(Accid.serv.dia$E+Accid.serv.dia$T)]
#Accid.serv.dia[,Padron:=(Accid.serv.dia$P+Accid.serv.dia$C)]

#Accid.serv.dia<-Accid.serv.dia[,c(5,3,1)]

Accid.tipol.dia<-tapply(Accidentes$JERARQUIA,Accidentes[,c("Fecha","Tipo_vehiculo")], length)
accidentesdia<-cbind((colnames(t(severidad_COTdia))),Accid.serv.dia,Accid.tipol.dia,Accid.COT.dia,severidad_COTdia)
severidad_tipologia<-cbind((colnames(t(severidad_tipologia))),severidad_tipologia)
Incidentes.IA<-cbind((colnames(t(Incidentes.IA))),Incidentes.IA)
ACCIFIJO<-cbind((colnames(t(ACCIFIJO))),ACCIFIJO)
ACCIPARTICI<-cbind((colnames(t(ACCIPARTICI))),ACCIPARTICI)
accidentesdia<-as.data.table(accidentesdia)
accidentesdia<-accidentesdia[,-1]

PARTIdia<-data.frame(tapply(Particulares$Fecha,Particulares[,c("Fecha","X5")],length))

OBJETOFIJOdia<-data.frame(tapply( OBJETOFIJO$Fecha,OBJETOFIJO[,c("Fecha","X5")],length))

ACCIFIJO<-replace(ACCIFIJO,is.na(ACCIFIJO),0)
colnames(ACCIFIJO)=c("Tipo","BNM","BNCPC","ETM","GIT")
#colnames(ACCIFIJO)=c("Tipo","BNM","ETM","GIT")

ACCIFIJO<-ACCIFIJO[,c(1,5,2,4,3)]
#ACCIFIJO<-ACCIFIJO[,c(1,4,2,3)]

ACCIPARTICI<-replace(ACCIPARTICI,is.na(ACCIPARTICI),0)
colnames(ACCIPARTICI)=c("Tipo","BNM","BNCPC","ETM","GIT")

#ACCIPARTICI<-ACCIPARTICI[,c(1,5,2,4,6,3)]
ACCIPARTICI<-ACCIPARTICI[,c(1,5,2,4,3)]

Incidentes.IA<-replace(Incidentes.IA,is.na(Incidentes.IA),0)
colnames(Incidentes.IA)=c("Tipo","BNM","BNCPC","ETM","GIT")
#colnames(Incidentes.IA)=c("Tipo","BNM","ETM","GIT")

Incidentes.IA<-Incidentes.IA[,c(1,5,2,4,3)]
Incidentes.IA<-Incidentes.IA[,c(1,4,2,3)]

Tipo_accidente<-as.data.frame(Tipo_accidente)
Tipo_accidente<-replace(Tipo_accidente,is.na(Tipo_accidente),0)
Tipo_accidente<-as.data.table(Tipo_accidente)


Tipo_accidente[,TotalT:=GIT+BNM+ETM+BCPC]

Accidentesruta<- data.frame(tapply(Accidentes$RUTA,Accidentes$RUTA,length))
Accidentesruta<-cbind((colnames(t(Accidentesruta))),Accidentesruta)
colnames(Accidentesruta)=c("Ruta","TOTAL")

BusMio<-Accidentes[Accidentes$X4=="BUS DEL MIO"]
BusMio1<-tapply(BusMio$JERARQUIA,BusMio[,c("Concesionario","MES")], length)
BusMio1<-cbind((colnames(t(BusMio1))),BusMio1)
BusMio1<-replace(BusMio1,is.na(BusMio1),0)



AH$NUMERO_LESIONADOS<-as.numeric(AH$NUMERO_LESIONADOS)
Numerolesiona<-cbind((colnames(t(Numerolesiona))),Numerolesiona)

heridos<-data.frame(tapply(AH$NUMERO_LESIONADOS,AH$nombre_archivo,sum))
heridos<-cbind(colnames(t(heridos)),heridos)
names(heridos)=c("Dia","numero de heridos")

accidentesdia<-replace(accidentesdia,is.na(accidentesdia),0)

accidentesdia[,total:=accidentesdia$`Concesionario GIT Masivo`+accidentesdia$`Concesionario Blanco y Negro`+accidentesdia$`Concesionario ETM`+accidentesdia$`Concesionario Blanco y Negro2`]


reposici<-consobita[,c(1,3,4,5,12,13,21,16,17,24,26,27,28,58,61)]
reposici<-sapply(reposici,as.character)
reposici<-as.data.table(reposici)
Tiporep<-str_split_fixed(reposici$JERARQUIA,"::",5)
reposici<-cbind(reposici,Tiporep)


reposici<-reposici[reposici$V3=="POR REPOSICIONAMIENTO"] 
reposicidia<-tapply(reposici$JERARQUIA,reposici$Fecha,length)
#reposicitip<-tapply(reposici$JERARQUIA,reposici[,c("RUTA","mes","JERARQUIA")],length)
reposicidia<-data.frame(reposicidia)

reposicidia<-cbind(colnames(t(reposicidia)),reposicidia)                                

names(reposicidia)=c("Fecha","Total")

source(file.path(current_dir, "vandalismo_2025.R"))
source(file.path(current_dir, "Puntos_2025.R"))
#source(file.path(current_dir, "Kil-table.R"))

load(file.path(getwd(),"salidasBD.RData"))
salidas_todas_dia1<-salidas_todas_dia1[,c(9,68)]
load(file.path(getwd(),"salidas.RData"))
load(file.path(getwd(),"Tablero2024_25.RData"))
load(file.path(getwd(),"FlotaMax_Tipologia22_24_25.RData"))
Tablero2024_25$Fecha<-gsub("X","",Tablero2024_25$Fecha)
Tablero2024_25$Fecha<-gsub("[.]","-",Tablero2024_25$Fecha)
Tablero2024_25[,Fecha:=substr(Fecha,1,10)]
Tablero2024_25<-Tablero2024_25[Tablero2024_25$Fecha!="nombre"]
Tablero2024_25$Total<-as.numeric(Tablero2024_25$Total)

FlotaMax_Tipologia22_24_25$COT<-replace(FlotaMax_Tipologia22_24_25$COT,is.na(FlotaMax_Tipologia22_24_25$COT),0)
FlotaMax_Tipologia22_24_25$Tipologia<-replace(FlotaMax_Tipologia22_24_25$Tipologia,is.na(FlotaMax_Tipologia22_24_25$Tipologia),0)

FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$COT!=0]
FlotaMax_Tipologia22_24_25<-FlotaMax_Tipologia22_24_25[FlotaMax_Tipologia22_24_25$Tipologia!=0]


setkey(salidas,NUMERO_DE_CASO)
setkey(salidas_todas_dia1,NUMERO_DE_CASO)
salidas<-salidas_todas_dia1[salidas, all= TRUE]

salidas$salidastipo<-replace(salidas$salidastipo,is.na(salidas$salidastipo),0)
salidas1<-salidas[salidas$salidastipo=="0"]
salidas<-salidas[salidas$salidastipo!="0"]
salidas1[,salidastipo:=salidas1$X3]
salidas1$salidastipo<-replace(salidas1$salidastipo,salidas1$salidastipo== "PELEA O RINA EN VEHICULO","vandalismos")
salidas<-rbind(salidas,salidas1)
rm(salidas1)