#Puntos
#caracteres<-consobita[,c(1,3,4,5,12,13,21,16,17,26,57)]
#caracteres<-sapply(caracteres,as.character)
#caracteres<-as.data.table(caracteres)

#caracteres$Puntos<-as.integer(caracteres$Puntos)
#P_IE<-caracteres[caracteres$Indice=="IE"]
#P_IO<-caracteres[caracteres$Indice=="IO"]
#P_Totales<-rbind(P_IE,P_IO)
#mes<-(substr(P_Totales$nombre_archivo,3,4))
P_Totales<-P_Totales[,mes:=Mes]
P_Totales[,Tipologia:=substr(P_Totales$NUMERO_VEHICULO,2,2)]
P_Totales$Tipologia<-replace(P_Totales$Tipologia,P_Totales$Tipologia== "1","ART")
P_Totales$Tipologia<-replace(P_Totales$Tipologia,P_Totales$Tipologia== "3","COM")
P_Totales$Tipologia<-replace(P_Totales$Tipologia,P_Totales$Tipologia== "2","PAD")
P_Totales$Tipologia<-replace(P_Totales$Tipologia,P_Totales$Tipologia== "4","DUAL")

Puntos<-data.frame(tapply(P_Totales$Puntos,P_Totales[,c("Indice","Concesionario")],sum))

P_IE<-replace(P_IE,is.na(P_IE),0)
P_IO<-replace(P_IO,is.na(P_IO),0)

PuntosIE<-data.frame(tapply(P_IE$Puntos,P_IE[,c("Fecha","Concesionario")],sum))
PuntosIO<-data.frame(tapply(P_IO$Puntos,P_IO[,c("Fecha","Concesionario")],sum))
#PuntosIE<-PuntosIE[,c(4,1,3,5,2)]
#PuntosIO<-PuntosIO[,c(4,1,3,5,2)]
#PuntosIO<-PuntosIO[,c(3,1,2)]
PuntosIO<-PuntosIO[,c(4,1,3,2)]
PuntosIE<-PuntosIE[,c(4,1,3,2)]
#PuntosIO<-PuntosIO[,c(3,1,2,4)]

#rm(P_IE,P_IO)

#Analisis de puntos 


PuntosIE<-cbind(colnames(t(PuntosIE)),PuntosIE)
PuntosIO<-cbind(colnames(t(PuntosIO)),PuntosIO)
#PuntosIO<-PuntosIO[,c(1,4,2,3,5)]

names(PuntosIE)=c("Fecha","GIT_IE","BYN_IE","ETM_IE","BYNCPC_IE")
names(PuntosIO)=c("Fecha","GIT_IO","BYN_IO","ETM_IO","BYNCPC_IO")

PuntosIE<-as.data.table(PuntosIE)
PuntosIO<-as.data.table(PuntosIO)

setkey(PuntosIE,Fecha)
setkey(PuntosIO,Fecha)

PuntosIE_IO<-PuntosIO[PuntosIE, all= TRUE]

PuntosIE_IO<-replace(PuntosIE_IO,is.na(PuntosIE_IO),0)


PuntosIE_IO[,Total:=PuntosIE_IO$GIT_IE+PuntosIE_IO$BYN_IE+PuntosIE_IO$ETM_IE+PuntosIE_IO$BYNCPC_IE+PuntosIE_IO$GIT_IO+PuntosIE_IO$BYN_IO+PuntosIE_IO$ETM_IO+PuntosIE_IO$BYNCPC_IO]

