# La commune Châtillon-en-Michaille (01091) devient commune déléguée en 2019 à la commune Valserhône (01033)
# Sa PRA en 2017 était Haut Bugey - 01 (01449), mais devient en 2020 Zone forestière du pays de Gex (01215)
library(magrittr) # needs to be run every time you start R and want to use %>%
library(dplyr)    # alternatively, this also loads %>%
library(readxl)
library(COGugaison)
library(sqldf)
library(data.table)
library(dplyr)




setwd("C:/_DEV/CODE/DIVERS/r/cogugaison/data/pra")

table_correspondance_commune_pra_2017 <- read_xls("Referentiel_CommuneRA_PRA_2017.xls", skip = 5) %>%
  select(CODGEO, RA_Code, PRA_Code, PRA_Lib)

table_passage_commune_2017_2020 <- read_xlsx("table_passage_annuelle_2020.xlsx", skip = 5) %>%
  select(CODGEO_2017, CODGEO_2020) %>%
  filter(substr(CODGEO_2017,1,2) < "96") %>%
  unique()

communes_problematiques <- table_correspondance_commune_pra_2017 %>%
  left_join(table_passage_commune_2017_2020, by = c("CODGEO" = "CODGEO_2017")) %>%
  mutate(modification = ifelse(CODGEO != CODGEO_2020, 1,0)) %>%
  left_join(table_correspondance_commune_pra_2017, by = c("CODGEO_2020"="CODGEO")) %>%
  filter(PRA_Code.x != PRA_Code.y) %>%
  rename(PRA_Code_2017_sur = PRA_Code.x,
         PRA_Lib_2017_sur = PRA_Lib.x,
         PRA_Code_2020_supp = PRA_Code.y,
         PRA_Lib_2020_supp = PRA_Lib.y,
         CODGEO_2017 = CODGEO) %>%
  select(-RA_Code.x,-RA_Code.y, -modification)


head(communes_problematiques, 10)
print(communes_problematiques, n=140)
head(table_correspondance_commune_pra_2017, 10)

write.csv(communes_problematiques, file = "communes_problematiques.csv", row.names = FALSE)



before_cog <- table_correspondance_commune_pra_2017 %>%
              filter(CODGEO == "01033" | CODGEO == "01091" | CODGEO == "01205")
before_cog
cog_commune_pra <- changement_COG_typo(table_correspondance_commune_pra_2017, c(2017:2019), 'CODGEO', methode_fusion = 'methode_max_pop', libgeo=T ,typos= c("RA_Code", "PRA_Code", "PRA_Lib"))
head(cog_commune_pra, 10)

dftest <- cog_commune_pra %>%
          filter(CODGEO == "01033" | CODGEO == "01091" | CODGEO == "01205")
dftest


cog_commune_pra_detail <- changement_COG_typo_details(table_correspondance_commune_pra_2017, c(2017:2019), 'CODGEO',typo= "RA_Code")
head(cog_commune_pra_detail[["2017_2018"]], 10)

trajectoire_commune('59350', 2010)
dftest
head(communes_problematiques, 10)