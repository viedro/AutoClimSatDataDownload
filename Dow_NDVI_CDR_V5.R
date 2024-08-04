setwd("C:/Users/ASUS/Desktop/Tesissss/NDVI/AVHRR_CDR_NDVI")
library(rvest)
library(terra)
#Para que el tiempo de desacarga no se limite
options(timeout=Inf)
####Descarga de datos diarios NDVI NOAA AVHRR CDR V5 1981 al 2020
# Define la URL de la página web

url <- "https://www.ncei.noaa.gov/data/land-normalized-difference-vegetation-index/access/"
for (i in 1981:2020){    ###Seleccionar años a descargar
  ####Accediendo a los enlaces
  pag <- read_html(paste0(url,i,"/"))   ###Leer la pagina html
  data <- html_nodes(pag, "table")      ###Filtrar nodo de tabla
  table <- html_table(data,header=T)[[1]][-c(1,2),]   ###Extraer tabla
  name_data <- table[-(nrow(table)),]$Name    ###Nombres de archivos

  for (j in 1:length(name_data)){       ### Descarga de datos diarios por año
    download.file(
      url = paste0(url,i,"/",name_data[j]),  ### Enlace de descarga
      destfile = paste0("NDVI_data/",name_data[j]),mode="wb", timeout = Inf)  ###Destino de guardado
    
    NDVI<- rast(paste0("NDVI_data/",name_data[j]),subds="NDVI")    ###Leyendo el netcdf
  
    e <- ext(-79, -75, -12, -4)  ###Extensión de región de estudio
    NDVI_crop <- crop(NDVI, e)          ###Recortando de data global
    readStop(NDVI)              ###Cerrando el archivo netcdf abierto
    unlink(NDVI)
    rm(NDVI)
    
    name_tif <- sub("\\.nc$", ".tif", paste0("NDVI_data/Huallaga_",name_data[j])) ### Renombrando a formato tif
    
    writeRaster(NDVI_crop ,name_tif, overwrite=TRUE)  ### Creando nuevo archivo tif
    file.remove(paste0("NDVI_data/",name_data[j]))    ###Eliminando netcdf original
  }
}


plot(rast(name_tif))


