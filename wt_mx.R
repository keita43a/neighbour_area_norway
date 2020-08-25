# making spatial weight matrix

# load package

pacman::p_load(sp,
               rgdal,
               spdep,
               sf,
               dplyr)


# load data 
# the original data is downloaded from Geonorge
# https://kartkatalog.geonorge.no/metadata/postnummeromraader/462a5297-33ef-438a-82a5-07fff5799be3
shapefile <- rgdal::readOGR("Basisdata_0000_Norge_25833_Postnummeromrader_GML.gml")

# check layer of the file (multiple layers found)
ogrListLayers("Basisdata_0000_Norge_25833_Postnummeromrader_GML.gml")

# retrieve spatial coordinates from a Spatial object
coordinatess <- sp::coordinates(shapefile)

# method 1: contiguity 

# use poly2nb to find the contiguity (adjacent postal code areas)
shapefile.nei.nb <- poly2nb(shapefile, row.names = postnummer)

nei.nb.mx <- nb2mat(shapefile.nei.nb, style = "B", zero.policy = TRUE)
nrow(nei.nb.mx)

nei.nb.df <- as.data.frame(nei.nb.mx)
colnames(nei.nb.df) <- shapefile$postnummer
nei.nb.df$postal_number <- shapefile$postnummer
nei.nb.df$postal_address <- shapefile$poststed

nei.nb.df = nei.nb.df %>%
  relocate(postal_number,postal_address)

# save file
readr::write_csv(nei.nb.df,"postalcode_adjacent_matrix_NOR.csv")


# ----- method 2: k-nearest neghibour ------
# 10-nearest neighibour zipcode areas are listed (by distance)
shapefile.nn10 <- spdep::knearneigh(coordinatess, k = 10)

# convert the k-nn object into nb object, which is a list of interger vector of ID's 
nn10.nb <- spdep::knn2nb(shapefile.nn10)

nn10.nb.mx <- nb2mat(nn10.nb, style = "B", zero.policy = TRUE)
nrow(nn10.nb.mx);ncol(nn10.nb.mx)

nn10.nb.df <- as.data.frame(nn10.nb.mx)
colnames(nn10.nb.df) <- shapefile$postnummer
nn10.nb.df$postal_number <- shapefile$postnummer
nn10.nb.df$postal_address <- shapefile$poststed

# just change the location of the columns
nn10.nb.df = nn10.nb.df %>%
  relocate(postal_number,postal_address)

# save file
readr::write_csv(nn10.nb.df,"postalcode_10_nn_matrix_NOR.csv")


# the code below is for getting weight matrix
if(FALSE){
# distances based on the link provided (10-nearest neighbour)
dist.nn10 <- spdep::nbdists(nn10.nb,coordinatess)
dist2 <- lapply(dist, function(x) 1/(x^2)) 

#listw:
dist2.listw <- spdep::nb2listw(shapefile.nb, glist=dist2)

#matrix:
dist2.mat <- spdep::listw2mat(dist2.mat)
}





# ----- method 3: within r km distance from a centroid ------
# 
# First, find 1-nearest neighibour zipcode area to get the maximum distance that include at least 1 neighbour
shapefile.nn1 <- spdep::knearneigh(coordinatess, k = 1)

# convert the k-nn object into nb object, which is a list of interger vector of ID's 
nn1.nb <- spdep::knn2nb(shapefile.nn1)

# calculate the distance to the nearest neighbours
dist.data <- unlist(nbdists(nn1.nb,coordinatess))
summary(dist.data) # the shortest is 26.7m, furthest is 294.721 km
max_inn <- max(dist.data)
q3_inn <- quantile(dist.data,0.75, names = FALSE)
mean_inn <-mean(dist.data)

# get the distances within given distances
max_d.nb <- dnearneigh(coordinatess,d1 = 0, d2 = max_inn)
q3_d.nb <- dnearneigh(coordinatess,d1 = 0, d2 = q3_inn)
mean_d.nb <- dnearneigh(coordinatess,d1 = 0, d2 = mean_inn)


    # make matrix of 0/1, then make them data.frame
    max_d.nb.mx <- nb2mat(max_d.nb, style = "B", zero.policy = TRUE)
    nrow(max_d.nb.mx);ncol(max_d.nb.mx)
    
    max_d.nb.df <- as.data.frame(max_d.nb.mx)
    colnames(max_d.nb.df) <- shapefile$postnummer
    max_d.nb.df$postal_number <- shapefile$postnummer
    max_d.nb.df$postal_address <- shapefile$poststed
    
    # just change the location of the columns
    max_d.nb.df = max_d.nb.df %>%
      relocate(postal_number,postal_address)
    
    # save file
    readr::write_csv(max_d.nb.df,"postalcode_radius_max_matrix_NOR.csv")
    
    
    
    # make matrix of 0/1, then make them data.frame
    q3_d.nb.mx <- nb2mat(q3_d.nb, style = "B", zero.policy = TRUE)
    nrow(q3_d.nb.mx);ncol(q3_d.nb.mx)
    
    q3_d.nb.df <- as.data.frame(q3_d.nb.mx)
    colnames(q3_d.nb.df) <- shapefile$postnummer
    q3_d.nb.df$postal_number <- shapefile$postnummer
    q3_d.nb.df$postal_address <- shapefile$poststed
    
    # just change the location of the columns
    q3_d.nb.df = q3_d.nb.df %>%
      relocate(postal_number,postal_address)
    
    # save file
    readr::write_csv(q3_d.nb.df,"postalcode_radius_q3_matrix_NOR.csv")
    
    
    # make matrix of 0/1, then make them data.frame
    mean_d.nb.mx <- nb2mat(mean_d.nb, style = "B", zero.policy = TRUE)
    nrow(mean_d.nb.mx);ncol(mean_d.nb.mx)
    
    mean_d.nb.df <- as.data.frame(mean_d.nb.mx)
    colnames(mean_d.nb.df) <- shapefile$postnummer
    mean_d.nb.df$postal_number <- shapefile$postnummer
    mean_d.nb.df$postal_address <- shapefile$poststed
    
    # just change the location of the columns
    mean_d.nb.df = mean_d.nb.df %>%
      relocate(postal_number,postal_address)
    
    # save file
    readr::write_csv(mean_d.nb.df,"postalcode_radius_mean_matrix_NOR.csv")

