# this is the source code for the interactive map and it also has some more experimental elements i might want to try out later

library(tidyverse)
library(sf)
library(jsonlite)
library(lubridate)
#library(rnaturalearth)

#data_place <- "data/raw/index_2020-09-14T05.kml"
#test <-
#  rgdal::readOGR(dsn = "data/raw/index_2020-09-14T05.kml") 

gmt <- lubridate::hour(Sys.time()) + 7
date <- if_else( gmt > 23 , 
                ymd(Sys.Date() + days(1) ),
                ymd(Sys.Date()) )

startdate_str <- paste( paste0("?startDate=",date) ,
                        gmt%%24,
                        sep="T")
enddate_str <- paste( paste0("&endDate=",date) ,
                        gmt%%24,
                        sep="T")

url_str <- paste0("http://www.airnowapi.org/aq/data/",
                  startdate_str,
                  enddate_str,
                  "&parameters=OZONE,PM25,PM10,CO,NO2,SO2&BBOX=-126,15,-60.22,60&dataType=A&format=application/json&verbose=0&nowcastonly=1&includerawconcentrations=0&API_KEY=",
                  Sys.getenv("AIRNOW_API_KEY"))

aqi_point <- 
  fromJSON(url_str) %>%
  st_as_sf( coords = c("Longitude","Latitude"),
            crs = st_crs(albersusa::us_longlat_proj) ) %>% 
  select(AQI, geometry)

# leaving this stuff in as a nice demonstration of this kind of spatial aggregation
#
#counties <- 
#  tigris::counties( cb = T, 
#                    class = "sf" ) %>%
#  st_crop( xmin = -126 , 
#           xmax = -60 , 
#           ymin = 15 , 
#           ymax = 60 ) %>%
#  st_transform( crs = st_crs(albersusa::us_longlat_proj) )
#
#aqi_county <- 
#  st_intersection(x = counties , y = aqi_point ) %>%
#  group_by(GEOID) %>%
#  mutate(avg_aqi = mean(AQI)) %>%
#  select( avg_aqi , GEOID ) %>%
#  st_drop_geometry() %>%
#  merge( counties )
#
ggplot()+
  geom_sf( data = filter(aqi_point, AQI>0) ,
                   aes( color = AQI , size = AQI )) + 
    viridis::scale_color_viridis( direction = -1 )
