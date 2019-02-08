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
states=map_data("state")
ushcn_data$utc=as.factor(ushcn_data$utc)
ushcn_data$state=as.factor(ushcn_data$state)
#rename the utc levels
levels(ushcn_data$utc) <- c("EST","CST","MST","PST")
#us_map <- qmplot(long, lat, data = ushcn_data, colour = I('red'), size = I(0.5), darken = .2)

# library(ggplot2)
# cl <- kmeans(iris[, 1:2], 3, nstart = 25)
# ggplot(transform(iris[, 1:2], cl = factor(cl$cluster)), 
#        aes(x = Sepal.Length, y = Sepal.Width, colour = cl)) +
#   geom_point() + 
#   scale_colour_manual(values=c("purple", "green","orange")) + 
#   annotate("point", x = cl$centers[, 1], y = cl$centers[, 2], size = 5, colour = c("purple", "green","orange")) + 
#   annotate("text", x = cl$centers[, 1], y = cl$centers[, 2], font = 2, size = 10,
#            label = apply(cl$centers, 1, function(x) paste(sprintf('%02.2f', x), collapse = ",") ), 
#            colour = c("purple", "green","orange") )
# library(ggplot2)
# library(ggmap)
# library(maps)
# library(mapdata)
# 
# usa <- map_data("usa") # we already did this, but we can do it again
# ggplot() + geom_polygon(data = usa, aes(x=long, y = lat, group = group)) + 
#   coord_fixed(1.3)
# 
# ggplot(data = states) + 
#   geom_polygon(aes(x = long, y = lat, fill = region, group = group), color = "white") + 
#   coord_fixed(1.3) +
#   guides(fill=FALSE)  # do this to leave off the color legend

ggplot(data=states) + 
  geom_polygon(aes(x = long, y = lat, fill = region, group=group),col="white",alpha=0.4)+
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

#https://ggplot2.tidyverse.org/reference/map_data.html

#https://stackoverflow.com/questions/31173278/r-ggplot-show-cluster-labels-on-the-plot


library(maps)
library(ggplot2)
library(ggmap)
states <- map_data("state")


cnames <- aggregate(cbind(long, lat) ~ state, data=ushcn_data, 
                    FUN=function(x)mean(range(x)))






