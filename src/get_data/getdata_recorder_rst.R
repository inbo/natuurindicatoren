getdata_recorder_rst <- function(){
  
  require(DBI)
  require(odbc)
  require(tidyverse)
  
  con <- dbConnect(odbc::odbc(),
                   Driver = "SQL Server Native Client 11.0",
                   Server = "inbo-sql07-prd.inbo.be",
                   Database = "D0017_00_NBNData",
                   Trusted_Connection="yes") 
  
  sampledata <- dbGetQuery(con, "SELECT * from inbo.vw_Rossestekelstaart_sampledata")
  taxondata <- dbGetQuery(con, "SELECT * from inbo.vw_Rossestekelstaart_taxondata")
  
  return(list(sample = sampledata, taxon = taxondata))
}