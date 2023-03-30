# La commune Châtillon-en-Michaille (01091) devient commune déléguée en 2019 à la commune Valserhône (01033)
# Sa PRA en 2017 était Haut Bugey - 01 (01449), mais devient en 2020 Zone forestière du pays de Gex (01215)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(readxl)
library(COGugaison)
library(sqldf)
library(data.table)

### The initial problem ###
trajectoire_commune('01033', 2010)

# SET PATHs
# Get the location of the script file
file_path <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(file_path)
# Get data/input path
setwd("./../data/pra/")
path_to_data = getwd()
print(path_to_data)
setwd(file_path)
# Get output path
setwd("./../output/")
path_to_save = getwd()
print(paste('data_path : ' , path_to_data, 'output_path : ', path_to_save))

# Read the table of towns, with COG and discretes variables (RA_Code, PRA_Code, PRA_Lib)
table_correspondance_commune_pra_2017 <- read_xls(paste(path_to_data, "Referentiel_CommuneRA_PRA_2017.xls", sep = '/'),
                                        skip = 5) %>%
                                        select(CODGEO, RA_Code, PRA_Code, PRA_Lib)
# head(table_correspondance_commune_pra_2017, 10)

# We know three towns which where merged in 2019. Two belongs to PRA "ZONE FORESTIERE DU PAYS DE GEX (1RE ZONE) - 01"
# one belongs to  HAUT BUGEY - 01:
before_cog <- table_correspondance_commune_pra_2017 %>%
              filter(CODGEO == "01033" | CODGEO == "01091" | CODGEO == "01205")
before_cog

                ############-------------------##############

# We need to find a solution to assign a PRA to the unique town remaining after merging because 
# PRA corresponding table produced by INSEE was not updated between 2017 and 2019
# For that we'll use the function "changement_COG_typo" with
# the parameter "methode_fusion" set to 'methode_max_pop'
cog_commune_pra_maxPop <- changement_COG_typo(table_correspondance_commune_pra_2017, 
                  annees = c(2017:2019),
                  codgeo_entree = 'CODGEO', 
                  methode_fusion = 'methode_max_pop',
                  libgeo=T ,
                  typos= c("RA_Code", "PRA_Code", "PRA_Lib"))

# We can check what has become of our three towns
post_cog_maxPop <- cog_commune_pra_maxPop %>%
          filter(CODGEO == "01033" | CODGEO == "01091" | CODGEO == "01205")
post_cog_maxPop

                ############-------------------##############

## But we can try it using other parameters like "methode_difference"
cog_commune_pra_diff <- changement_COG_typo(table_correspondance_commune_pra_2017 , 
                  c(2017:2019) , 
                  'CODGEO' , 
                  methode_fusion = 'methode_difference' ,
                  libgeo=T ,
                  typos= c("RA_Code", "PRA_Code", "PRA_Lib")) 
                 
post_cog_diff <- cog_commune_pra_diff %>%
          filter(CODGEO == "01033" | CODGEO == "01091" | CODGEO == "01205")
          
post_cog_diff
# cog_commune_pra_detail <- changement_COG_typo_details(table_correspondance_commune_pra_2017, c(2017:2019), 'CODGEO',typo= "RA_Code")
# head(cog_commune_pra_detail[["2017_2018"]], 10)

trajectoire_commune('01033', 2010)
# head(communes_problematiques, 10)