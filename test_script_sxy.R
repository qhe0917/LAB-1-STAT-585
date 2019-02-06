#command read_fwf from package readr
library(readr)

# 2. STATION LIST AND DATA FORMATS
# 
# FORMAT OF "ushcn-v2.5-stations.txt"
# 
# ----------------------------------------
#   Variable             Columns    Type
# ----------------------------------------
#   COUNTRY CODE             1-2    Character
# NETWORK CODE               3    Character
# ID PLACEHOLDERS ("00")   4-5    Character
# COOP ID                 6-11    Character
# LATITUDE               13-20    Real
# LONGITUDE              22-30    Real
# ELEVATION              33-37    Real
# STATE                  39-40    Character
# NAME                   42-71    Character
# COMPONENT 1 (COOP ID)  73-78    Character
# COMPONENT 2 (COOP ID)  80-85    Character
# COMPONENT 3 (COOP ID)  87-92    Character
# UTC OFFSET             94-95    Integer
# -----------------------------------------


ushcn_data <- read_fwf("ushcn-v2.5-stations.txt",
                       fwf_widths(c(2,1,2,7,
                                    9,11,6,
                                    3,31,7,7,7,
                                    2),
                       c("country","network","ID","coop_ID","lat","long","elev","state","name","comp1","comp2","comp3","utc")),
                       col_types = cols('c','c','c','c','n','n','n','c','c','c','c','c','i'))
head(ushcn_data)

#show lat, long, evaluation, time zone, state
library(ggplot2)
library(ggmap)

#us_map <- qmplot(long, lat, data = ushcn_data, colour = I('red'), size = I(0.5), darken = .2)

theme_set(theme_bw(16))
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

