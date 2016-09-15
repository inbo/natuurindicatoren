#
# INBO Natuurindicatoren
# collect and tidy data for red-list freshwater index
#
# author Van Hoey S.
#

library(gdata)

# Read the data file
df = read.xls("~/projecten/2016_natuurindicatoren/prototypes/rodelijst_zoetwatervissen/RodeLijstZoetwatervissen_excel_2012_figHDM.xlsx",
              sheet = 1, header = FALSE, skip = 2)

# define column names manually
colnames(df) <- c("categorie", "aantal")
# number of species need to be a number, not a character
df$aantal <- as.numeric(as.character(df$aantal))

# sort towards the number of species
df <- df[order(df$aantal),]

df$categorie <- factor(df$categorie, ordered = TRUE,
                       levels = c("momenteel niet in gevaar",
                                  "kwetsbaar",
                                  "bijna in gevaar",
                                  "bedreigd",
                                  "ernstig bedreigd",
                                  "regionaal uitgestorven",
                                  "onvoldoende data"))


write.csv(df,
          file = "../data/processed/rodelijst-zoetwatervissen.csv",
          row.names = FALSE)