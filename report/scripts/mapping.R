library(sf)
library(sp)
library(raster)
library(tidyverse)
library(albersusa)
library(rnaturalearth)

shp_path <- "D:/Economics/Projects/public-land/data/raw/shapefiles/"
us_shp <- 
  st_read( paste(shp_path, "PADUS2_0Designation.shp", sep="/")) %>%
  st_transform(crs= st_crs(us_longlat_proj) ) %>%
  points_elided_sf() 

###

us_borders_sf <- 
  ne_countries( country = "united states of america", scale = 'large', returnclass = 'sf') %>%
  dplyr::select(geometry)

us_borders_sp <- 
  as(st_geometry(us_borders_sf), "Spatial")

us_relief <- 
  raster("D:\\Economics\\Projects\\public-land\\data\\raw\\big-rasters\\MSR_50M\\MSR_50M.tif") %>%
  crop(extent(-170,-65,17,75)) %>%
  mask(x=.,
       mask= us_borders_sp) %>%
  rasterToPoints( spatial = T ) %>%
  spTransform( CRSobj = CRS(us_longlat_proj)) %>%
  st_as_sf() %>%
  points_elided_sf() 

#us_contour <- 
#  raster("D:\\Economics\\Projects\\public-land\\data\\raw\\big-rasters\\MSR_50M\\MSR_50M.tif") %>%
#  crop(extent(-170,-65,17,75)) %>%
#  mask(x=.,
#       mask= us_borders_sp) %>%
#  aggregate( x = .,
#             fact = 10 ) %>%
#  rasterToContour( nlevels = 10 ) %>%
#  st_as_sf( crs = st_crs(us_longlat_proj)) %>%
#  points_elided_sf()
#  

#st_write( us_relief , 
#          "data/raw/shapefiles/us_relief.shp" 
#          )

state_boundaries <- 
  usa_sf(proj = "laea" ) 

library(hrbrthemes)
#library(viridis)
#
#
#usa_flat <- 
#  ggplot( ) + 
#  geom_sf(data = state_boundaries , color = 'black' , fill = NA) + 
#  geom_sf( data = us_shp_elided , aes( fill = as.factor(d_Mang_Nam) ), color = NA ) + 
#  coord_sf( xlim=c(-130,-65) , 
#            ylim =c(20,50) ,
#            crs = us_longlat_proj ) + 
#  labs( title = "Public and Protected Lands of the United States",
#        x = "" , 
#        y = "" , 
#        fill = "Managing Agency") + 
#  theme_ipsum_rc( plot_title_size = 60 , 
#                  axis_text_size = 23  ) + 
#  guides( fill = guide_legend( ncol = 1 ) ) +
#  theme( legend.title = element_text( size = 25 ) , 
#         legend.text = element_text( size = 18 )) 
#
#usa_night_flat <- 
#  ggplot( ) + 
#  geom_sf(data = state_boundaries , color = 'white' , fill = NA) + 
#  geom_sf( data = us_shp , aes( fill = as.factor(d_Mang_Nam) ), color = NA ) + 
#  coord_sf( xlim=c(-130,-65) , 
#            ylim =c(20,50) ,
#            crs = us_longlat_proj ) +
#  labs( title = "Public and Protected Lands of the United States",
#        x = "" , 
#        y = "" , 
#        fill = "Managing Agency") + 
#  theme_ft_rc( plot_title_size = 60 , 
#               axis_text_size = 23 ) +  
#  guides( fill = guide_legend( ncol = 1 ) ) +
#  theme( legend.title = element_text( size = 25 ) , 
#         legend.text = element_text( size = 18 )) 
#
#usa_laea <- 
#  ggplot( ) + 
#  geom_sf( data = us_shp , aes( fill = as.factor(d_Mang_Nam) ), color = NA ) +
#  geom_sf( data = us_relief , aes( color = MSR_50M ), fill = NA ) + 
#  geom_sf(data = state_boundaries , color = 'black' , fill = NA) +
#  scale_fill_viridis_d( direction = -1 , option = "C") +
#  coord_sf( xlim=c(-2699479 ,3724541 ) , 
#            ylim =c(-2712598 ,795644.2) ,
#            crs = us_laea_proj ) + 
#  labs( title = "Public and Protected Lands of the United States",
#        x = "" , 
#        y = "" , 
#        fill = "Managing Agency") + 
#  theme_ipsum_rc( plot_title_size = 60 , 
#                  axis_text_size = 23  ) + 
#  guides( fill = guide_legend( ncol = 1 ) ) +
#  theme( legend.title = element_text( size = 25 ) , 
#         legend.text = element_text( size = 18 )) 
#
#usa_laea_elev <- 
#  ggplot( ) + 
#  geom_sf(data = state_boundaries , aes(alpha=elevation), color = 'black' , fill = 'darkgrey') + 
#  geom_sf( data = us_shp , aes( fill = as.factor(d_Mang_Nam) ), color = NA ) +  
#  scale_fill_viridis_d( direction = -1 , option = "C") +
#  coord_sf( xlim=c(-2699479 ,3724541 ) , 
#            ylim =c(-2712598 ,795644.2) ,
#            crs = us_laea_proj ) + 
#  labs( title = "Public and Protected Lands of the United States",
#        x = "" , 
#        y = "" , 
#        fill = "Managing Agency") + 
#  theme_ipsum_rc( plot_title_size = 60 , 
#                  axis_text_size = 23  ) + 
#  guides( fill = guide_legend( ncol = 1 ) ) +
#  theme( legend.title = element_text( size = 25 ) , 
#         legend.text = element_text( size = 18 )) 
#
#
#usa_night_laea <- 
#  ggplot( ) + 
#  geom_sf(data = state_boundaries , color = 'white' , fill = NA) + 
#  geom_sf( data = us_shp , aes( fill = as.factor(d_Mang_Nam) ), color = NA ) + 
#  coord_sf( xlim=c(-2699479 ,3724541 ) , 
#            ylim =c(-2712598 ,795644.2) ,
#            crs = us_laea_proj )+
#  labs( title = "Public and Protected Lands of the United States",
#        x = "" , 
#        y = "" , 
#        fill = "Managing Agency") + 
#  theme_ft_rc( plot_title_size = 60 , 
#               axis_text_size = 23 ) +  
#  guides( fill = guide_legend( ncol = 1 ) ) +
#  theme( legend.title = element_text( size = 25 ) , 
#         legend.text = element_text( size = 18 )) 
#
#ggsave(filename = "us_national_longlat.png", 
#       plot = usa_flat , 
#       dpi = 320 , width = 953 , height = 803 , 
#       units = "mm" ) # really big 12,000 x 10,121 high-res pic
#
#ggsave(filename = "us_national_longlat_dark.png", 
#       plot = usa_night_flat , 
#       dpi = 320 , width = 953 , height = 803 , 
#       units = "mm" ) # dark mode of previous
#
#ggsave(filename = "us_national_laea.png", 
#       plot = usa_laea , 
#       dpi = 320 , width = 953 , height = 803 , 
#       units = "mm" ) # really big 12,000 x 10,121 high-res pic
#
#ggsave(filename = "us_national_laea_elevtest.png", 
#       plot = usa_laea_elev , 
#       dpi = 320 , width = 953 , height = 803 , 
#       units = "mm" ) # really big 12,000 x 10,121 high-res pic
#
#ggsave(filename = "us_national_laea_dark.png", 
#       plot = usa_night_laea , 
#       dpi = 320 , width = 953 , height = 803 , 
#       units = "mm" ) # dark mode of previous  

elevation_public_land_plot <- 
  ggplot( ) + 
  geom_sf( data = us_relief , aes( color = MSR_50M ), fill = NA, alpha = 0.1 ) + 
  scale_color_gradient( low = 'darkgrey' , high = '#F1E9D2' , limits = c(128,205)) +
  geom_sf(data = state_boundaries , color = 'black' , fill = NA) +
  geom_sf( data = us_shp , aes( fill = as.factor(d_Mang_Nam) ), color = NA, alpha = 0.7 ) +
  coord_sf( xlim=c(-2699479 ,3724541 ) , 
            ylim =c(-2712598 ,795644.2) ,
            crs = us_laea_proj ) + 
  labs( title = "Public and Protected Lands of the United States",
        x = "" , 
        y = "" , 
        fill = "Managing Agency") + 
  theme_ipsum_rc( plot_title_size = 60 , 
                  axis_text_size = 23  ) + 
  guides( 
    color = F ,
    fill = guide_legend( ncol = 1 ) 
    ) +
  theme( legend.title = element_text( size = 25 ) , 
         legend.text = element_text( size = 18 ) , 
         legend.background = element_rect( color = 'black',
                                           fill = '#F1E9D2') , 
         legend.position = c(0.9,0.2) , 
         panel.background = element_rect( fill = '#F1E9D2') , 
         plot.background = element_rect(fill = "#F1E9D2") , 
         panel.grid = element_line( color = 'darkgrey')
         )


ggsave(filename = "us_national_laea_cornerlegend.png", 
       plot = elevation_public_land_plot , 
       dpi = 320 , width = 953 , height = 803 , 
       units = "mm" )
