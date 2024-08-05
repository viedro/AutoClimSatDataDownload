setwd("C:/Users/ASUS/Desktop/Tesissss/chelsa")

library(terra)
##############Código para descargar datos mensuales chelsa
#Para que no haya limite de tiempo de descarga
options(timeout=Inf)
##Se elige la variable, en este caso precipitación 
var="pr"
#Meses a descargar
mes <- c("01","02","03","04","05","06","07","08","09","10","11","12")
for (i in 1985:2018){  ###Años a descargar
  for (j in 1:length(mes)){
    
    download.file(#Link de datos mensuales, el monthly se puede modificar para datos anuales, diarios, climatologias,etc.
      url = paste0("https://os.zhdk.cloud.switch.ch/envicloud/chelsa/chelsa_V2/GLOBAL/monthly/",var,"/CHELSA_",var,"_",mes[j],"_",i,"_V.2.1.tif"), 
      destfile = paste0("CHELSA_",var,"_",mes[j],"_",i,"_V.2.1.tif"),mode="wb", timeout = Inf) #Nombre de archivo a descargar
    
    #Leyendo el archivo tif
    data <- rast(paste0("CHELSA_",var,"_",mes[j],"_",i,"_V.2.1.tif"))
    #Recortando para zona de estudio
    e <- ext(-82, -67, -19, 1)
    r <- crop(data, e)
    r
  
    #Cerrando el tif
    readStop(data)
    unlink(data)
    rm(data)
    #Exportando nuevo tif
    writeRaster(r,paste0("sm_CHELSA_",var,"_",j,"_",i,"_V.2.1.tif"), overwrite=TRUE)
    #Eliminando antiguo tif para ahorrar espacio
    file.remove(paste0("CHELSA_",var,"_",mes[j],"_",i,"_V.2.1.tif"))
   
  }
}


