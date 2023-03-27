library(stringi)
library(COGugaison)
library(readxl)
library(jsonlite)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(readr)


year_geom_desired = 2020
work_d = getwd()
data_path = paste("../",work_d, "data")
print(getwd())

path_to_data = 'C:/_DEV/CODE/DIVERS/r/cogugaison/data'
path_to_save = paste("C:/_DEV/CODE/DIVERS/r/cogugaison/output",sep='')

lst_files = list.files(path = path_to_data)

for (files in lst_files){
  #Get the year of original COG from file's name
  year_geom = as.numeric(substr(files, nchar(files)-7, nchar(files)-4))
  print(year_geom)
  #Get the year of validity from file's name
  year_data = as.numeric(substr(files, nchar(files)-12, nchar(files)-9))
  print(year_data)
  #read file
  MyData <- read.csv(file= paste(path_to_data, files, sep = '/'), header=TRUE, sep=",")
  # Delete boroughs, keep duplicates, do not sum columns
  Table_sans_arron <- enlever_PLM(table_entree=MyData,libgeo=NULL,agregation = F,vecteur_entree=F)  
  # Application de la Cogugaison
  Table <- changement_COG_varNum(table_entree=Table_sans_arron, annees=c(year_geom:year_geom_desired), agregation=T,libgeo=T,donnees_insee=F)
  # insert new column in each file made of the year of validity from file's name
  Table['year_data'] = year_data
  # Save to csv
  write.csv(Table, file = paste(path_to_save, files, sep = '/') ,  row.names = FALSE)
  
  print(paste0('Le fichier : ', files, ', a bien été enregistré'))
}

## Merge all the new .csv together
df <- list.files(path=path_to_save, full.names = TRUE) %>% 
  lapply(read_csv) %>% 
  bind_rows

## Write the merged df to csv
write.csv(df, file = paste(path_to_save, 'merged.csv', sep = '/'),  row.names = FALSE)

## Get a schema of town's administrative trajectory (need -> install.packages('visNetwork'))
trajectoire_commune('49023', 2010)
