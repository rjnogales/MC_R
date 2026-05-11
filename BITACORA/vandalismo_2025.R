#Vandalismo 
#Buses_estaciones<-read_excel("G:/Users/Eric/Desktop/calificacion/Base_Consolidada_Hasta_Julio_2020.xlsx", sheet = 1, col_names = T)

vandalismos<-data_frame
vandalismos$`Modificatorio apendice 3`<-as.character(vandalismos$`Modificatorio apendice 3`)
vandalismos1<-vandalismos[vandalismos$`Modificatorio apendice 3`==1105]
vandalismos2<-vandalismos[vandalismos$`Modificatorio apendice 3`=="1105.000000"]
vandalismos<-rbind(vandalismos2,vandalismos1)
vandalismos$JERARQUIA<-as.character(vandalismos$JERARQUIA)
TABV<-str_split_fixed(vandalismos$JERARQUIA,"::",4)
TABV<- data.frame(TABV)
vandalismos<-cbind(vandalismos,TABV)
vandalismos<-vandalismos[,-c(53,54,55)]
exrutav<-substr(vandalismos$RUTA,1,1)
extipvehicv<-substr(vandalismos$NUMERO_VEHICULO,2,2)
vandalismos<-vandalismos[,Tipo_ruta:=exrutav]
vandalismos<-vandalismos[,Tipo_vehiculo:=extipvehicv]
vandalismos$Concesionario<-as.character(vandalismos$Concesionario)
vandalismos$X4<-as.character(vandalismos$X4)

AgrecionOperador<-vandalismos[vandalismos$X4=="AGRESION FISICA A OPERADOR"]

totalvanda<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("Concesionario","Tipo_ruta")],length))
totalvanda1<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("Concesionario","Tipo_vehiculo")],length))
totalvanda<-replace(totalvanda,is.na(totalvanda),0)
totalvanda1<-replace(totalvanda1,is.na(totalvanda1),0)
totalvanda<-cbind(colnames(t(totalvanda)),totalvanda)
totalvanda1<-cbind(colnames(t(totalvanda1)),totalvanda1)
totalvanda1<-as.data.table(totalvanda1)
totalvanda<-as.data.table(totalvanda)


totalvanda[,total:=c(totalvanda$A+totalvanda$E+totalvanda$T+totalvanda$P)]

Diatipo$Fecha<-as.character(Diatipo$Fecha)
vandadia<-data.table(vandalismos[,c("nombre_archivo","JERARQUIA","RUTA")])
vandadia[,Fecha:=paste((substr(vandadia$nombre_archivo,1,2)),(substr(vandadia$nombre_archivo,3,4)),(substr(vandadia$nombre_archivo,5,6)),sep = "-")]
vandadia[,Fecha:=paste(20,Fecha,sep = "")]
setkey(Diatipo,Fecha)
setkey(vandadia,Fecha)
vandadia<-Diatipo[vandadia, all= TRUE]
vandadiahabil<-vandadia
vandadia<-data.frame(tapply(vandadia$JERARQUIA,vandadia$Diatipo,length))
totalvanda<-data.frame(totalvanda)
totalvanda1<-data.frame(totalvanda1)
Van.Tipovan<-tapply(vandalismos$JERARQUIA,vandalismos$X4,length)
Van.Tipovan<-data.frame(Van.Tipovan)
data_frame$VEHICULOS_NO_CONFORMES<-as.character(data_frame$VEHICULOS_NO_CONFORMES)
data_frame$VEHICULOS_NO_CONFORMES<-as.integer(data_frame$VEHICULOS_NO_CONFORMES)
muestra<-data_frame[data_frame$VEHICULOS_NO_CONFORMES>=1]
totmuestr<-data.frame(tapply(muestra$JERARQUIA,muestra[,c("nombre_archivo","Concesionario")],length))

vandalismos[,MES:=(substr(vandalismos$nombre_archivo,3,4))]
vandalismos[,Fecha:=paste((substr(vandalismos$nombre_archivo,1,2)),(substr(vandalismos$nombre_archivo,3,4)),(substr(vandalismos$nombre_archivo,5,6)),sep = "-")]
vandalismos[,Fecha:=paste(20,Fecha,sep = "")]
vandalismos$RUTA<-as.character(vandalismos$RUTA)
vanda.ruta<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("RUTA","Tipo_ruta")],length))
vanda.ruta.cot<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("RUTA","Concesionario")],length))
vanda.ruta.mes<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("RUTA","MES")],length))
vanda.ruta.mes<-cbind(colnames(t(vanda.ruta.mes)),vanda.ruta.mes)
vanda.ruta.dia<-as.data.frame(tapply(vandalismos$JERARQUIA,vandalismos[,c("RUTA","Fecha")],length))
vanda.ruta.dia<-data.frame(t(vanda.ruta.dia))
vanda.ruta.dia<-cbind(colnames(t(vanda.ruta.dia)),vanda.ruta.dia)

Van.Tipovan1<-tapply(vandalismos$JERARQUIA,vandalismos[,c("Fecha","X4")],length)
Van.conce<-tapply(vandalismos$JERARQUIA,vandalismos[,c("Fecha","Concesionario")],length)
Van.conce<-Van.conce[,c(4,1,3,2)]
Van.Tipolog<-tapply(vandalismos$JERARQUIA,vandalismos[,c("Fecha","Tipo_vehiculo")],length)
Van.serv<-tapply(vandalismos$JERARQUIA,vandalismos[,c("Fecha","Tipo_ruta")],length)
vandalismodia<-cbind((colnames(t(Van.conce))),Van.Tipolog,Van.serv,Van.conce,Van.Tipovan1)
vandalismosalida<-vandalismos[vandalismos$TIPO_EVENTO=="Salida"]
Van.sali.conce<-tapply(vandalismosalida$JERARQUIA,vandalismosalida[,c("Fecha","Concesionario")],length)
Van.sali.conce<-cbind((colnames(t(Van.sali.conce))),Van.sali.conce)
Van.sali.ruta<-tapply(vandalismosalida$JERARQUIA,vandalismosalida[,c("RUTA","JERARQUIA")],length)
Van.sali.ruta<-cbind((colnames(t(Van.sali.ruta))),Van.sali.ruta)

vandadiahabil$JERARQUIA<-as.character(vandadiahabil$JERARQUIA)
vandadiahabil$RUTA<-as.character(vandadiahabil$RUTA)

Van.sali.rutahabil<-vandadiahabil[vandadiahabil$Diatipo=="HAB"]
Van.sali.rutahabil<-tapply(Van.sali.rutahabil$JERARQUIA,Van.sali.rutahabil[,c("RUTA","JERARQUIA")],length)
Van.sali.rutahabil<-cbind((colnames(t(Van.sali.rutahabil))),Van.sali.rutahabil)


#Buses_estaciones<-Buses_estaciones[,-1]

#directorioV <- "G:/Users/Eric/Desktop/calificacion/vadalismo/"
#lista_vand <- dir(directorioV)

#Van_esta <- data.table()

#for(i in 1:length(lista_vand))     {
  
#  Van_esta1 <- data.table(read_excel(str_c(directorioV,lista_vand[i]),sheet = 1,col_names = T ))
#  cat (directorioV[i])  #guia de archivos y muestra el error
#  cat("\n\n")
  
#  Van_esta1<-data.frame(Van_esta1)
#  Van_esta1<- data.table(Van_esta1)
  
 # Van_esta <- rbind(Van_esta,Van_esta1)    }

#  TABV<-str_split_fixed(Van_esta$JERARQUIA,"::",7)
#  TABV<- data.frame(TABV)
#  TABV<-TABV[,-c(1,2)]
#  TABV<-TABV[,c(1,2)]
#  names(TABV)=c("NOVEDAD","NOVEDAD_ACTUALIZADA")
#  Van_esta<-cbind(Van_esta,TABV)

vandalismoN.a<-vandalismos[vandalismos$SITIO_EVENTO!="N.A"]
vandalismoN.a<-vandalismoN.a[,Direcciones:=SITIO_EVENTO]
N.a<-vandalismos[vandalismos$SITIO_EVENTO=="N.A"]
isna<-vandalismos[is.na(vandalismos$SITIO_EVENTO)]
N.a<-N.a[,Direcciones:=SITIO_SALIDA]
isna<-isna[,Direcciones:=SITIO_SALIDA]
vandalismos<-rbind(N.a,vandalismoN.a,isna)
setkey(vandalismos,Direcciones)
vandalismos[,Acc_Dir :=.N,by=list(Direcciones)]

vandalismos[,Semestre:= as.numeric(vandalismos$MES)]
vandalismostot<-vandalismos

vandalismodia<-as.data.table(vandalismodia)

vandalismodia<-replace(vandalismodia,is.na(vandalismodia),0)

vandalismodia[,total:=as.numeric(vandalismodia$`Concesionario GIT Masivo`)+as.numeric(vandalismodia$`Concesionario Blanco y Negro`)+as.numeric(vandalismodia$`Concesionario ETM`)+as.numeric(vandalismodia$`Concesionario Blanco y Negro2`) ]
