# Neighbouring areas in Norway
This repo is to generate neighbour areas based on geographic data of Norway

# Postal code areas

Using the data from [Geonorge](https://kartkatalog.geonorge.no/metadata/postnummeromraader/462a5297-33ef-438a-82a5-07fff5799be3) accesseed August 24th 2020.
I calculate the neighbour areas of the postal code areas.
The generated data is a form of matrix inluding dummy variables (0/1) which takes 1 if the areas are neighbour by provided definition. 

## 1. Contiguity
First, we calculate the adjacent areas, which shares the border of postal code areas. 
The data is [postalcode_neighbour_matrix_NOR.csv](https://github.com/keita43a/neighbour_area_norway/blob/master/postalcode_neighbour_matrix_NOR.csv).


## 2. 10-nearest neighboour
Next, I calculate the 10-nearest neighbour. 
The number (k) is easily changed in the R code.
The data is [postalcode_10_nn_matrix_NOR.csv](https://github.com/keita43a/neighbour_area_norway/blob/master/postalcode_10_nn_matrix_NOR.csv).

## 3. Within radius of r kilo meter
I calculate the neighbouring areas that are within r kilo meter.
Here I chose three numbers for the distance r.

i. the maximum distances among the nearest neighbours (294.721 km): [postalcode_radius_max_matrix_NOR.csv](https://github.com/keita43a/neighbour_area_norway/blob/master/postalcode_radius_max_matrix_NOR.csv)

ii. the third quantile of the distances among the nearest neighbours (82.237km) [postalcode_radius_q3_matrix_NOR.csv](https://github.com/keita43a/neighbour_area_norway/blob/master/postalcode_radius_q3_matrix_NOR.csv)

iii. the mean of the the distances among the nearest neighbours (56.49km) [postalcode_radius_mean_matrix_NOR.csv](https://github.com/keita43a/neighbour_area_norway/blob/master/postalcode_radius_mean_matrix_NOR.csv)

FYI, the minimum of the distance is 26.7m (yes, meter, not kilometer). Maybe somewhere in Oslo?

# Municipality level neighbours

WIP
