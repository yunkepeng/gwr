library(ncdf4)
library(spgwr)

#load a nc file including lon,lat,z 
#This file can be download at WFDEI: ftp://rfdata:forceDATA@ftp.iiasa.ac.at/
#File name: WFD-land-lat-long-z.nc

ncpath <- "E:/climate/61_80/"
ncname <- "WFD-land-lat-long-z"
ncfname <- paste (ncpath, ncname, ".nc", sep="")
ncin <- nc_open(ncfname)

lon <- ncvar_get(ncin,"Longitude") #length:67420 (NA values removed in advance)
lat <- ncvar_get(ncin,"Latitude") #length:67420 (NA values removed in advance)
Z <- ncvar_get(ncin,"Z")#length:67420 (NA values removed in advance)

#Now, input climate gridded data from WFDEI
#We used Shortwave radiation (SWdown) as an example, it is a daily average data from a monthly nc file.
#This example file can be downloaded at WFDEI:ftp://rfdata:forceDATA@ftp.iiasa.ac.at/SWdown_daily_WFD/
#File name here as an example: SWdown_daily_WFD_196001.nc

ncpath <- "E:/climate/61_80_radi/"
ncname <- "SWdown_daily_WFD_196001"
ncfname <- paste (ncpath, ncname, ".nc", sep="")
dname <- "SWdown"

#Extract gridded data for daily average at this month: 67420 grid* 31 days
ncin <- nc_open(ncfname)
pre.array <- as.data.frame(ncvar_get(ncin, dname))
nc_close(ncin)

#Combine this daily gridded data with coordinates
climate_grid <- cbind(lon,lat,Z,pre.array)

#Start implementing Geographically weighted Regressions

a <- 1.5 # Here a is 1.5 degrees. It means that when extract values on a site, we only need site ¡À 1.5 lat/lon degrees of grid.
         # This is reasonable, Because on below, we set our bandwidth = 1.06 in our gwr function, considered as the best value in previous research

#Now input our extracted site, let's create a site as an example
plot <- data.frame(matrix(NA)) # for final sites climate data
plot$Latitude <- 44.26
plot$Longitude <- -122.2
plot$Z <- 780


# specify gridded area, where grid is ¡À1.5 degree of focus sites. See description above
climate_grid2 <- subset(climate_grid,lon>(plot$Longitude -a)&lon<(plot$Longitude+a)&lat>(plot$Latitude-a)&lat<(plot$Latitude+a)) 
coordinates(climate_grid2) <- c("lon","lat")
gridded(climate_grid2) <- TRUE

coordinates(plot) <- c("Longitude","Latitude")

#Finally, extracted values by GWR
#SWdown_1960_01_01 represent the first day of the month
#Change V1 to V1-V31, get the value for day 1 to day 31 of the nc file
SWdown_1960_01_01 <- (gwr(V1 ~ Z, climate_grid2, bandwidth = 1.06, fit.points = plot,predictions=TRUE))$SDF$pred


