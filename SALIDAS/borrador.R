output$dwd<-downloadHandler(filename = function()
  
{}



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
