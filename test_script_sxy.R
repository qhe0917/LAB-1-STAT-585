#command read_fwf from package readr
library(readr)

ushcn_data <- read_fwf("ftp://ftp.ncdc.noaa.gov/pub/data/ushcn/v2.5/ushcn-v2.5-stations.txt",
                       fwf_widths(c(2,1,2,7,
                                    9,11,6,
                                    3,31,7,7,7,
                                    2),
                       c("country","network","ID","coop_ID","lat","long","elev","state","name","comp1","comp2","comp3","utc")),
                       col_types = cols('c','c','c','c','n','n','n','c','c','c','c','c','i'))
head(ushcn_data)
str(ushcn_data)

#show lat, long, evaluation, time zone, state
library(ggplot2)
library(ggmap)
library(maps)
state=map_data("state")
ushcn_data$utc=as.factor(ushcn_data$utc)
#rename the utc levels
levels(ushcn_data$utc) <- c("EST","CST","MST","PST")
#us_map <- qmplot(long, lat, data = ushcn_data, colour = I('red'), size = I(0.5), darken = .2)
ggplot(data=state,aes(x=long,y=lat)) + 
  geom_polygon(aes(group=group),col="grey",alpha=0.4)+
  geom_point(data=ushcn_data,aes(x=long,y=lat,col=elev,shape=utc),size=0.8) +  
  theme(text = element_text(size=10)) 
#theme_set(theme_bw(16))
# min(ushcn_data$lat)
# min(ushcn_data$long)
us_map <- get_map(c(left=min(ushcn_data$long), bottom=min(ushcn_data$lat), 
                    right=max(ushcn_data$long), top=max(ushcn_data$lat)))
#ggmap(us_map)
#str(us_map)
USMap <- ggmap(us_map, 
               base_layer = ggplot(aes(x = long, y = lat),
                                            data = ushcn_data))

USMap +
  stat_density2d(aes(x = long, y = lat, fill = ..level.., alpha = ..level..),
                 bins = 50, geom = "polygon",
                 data = ushcn_data) +
  scale_fill_gradient(low = "black", high = "red")

#http://www.storybench.org/plot-state-state-data-map-u-s-r/
#https://socviz.co/maps.html



