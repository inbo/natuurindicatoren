getdata_watervogeldatabank <- function(Taxonkey = NA_character_){
  require(DBI)
  require(odbc)
  require(tidyverse)
  
  con <- dbConnect(odbc::odbc(),
                   Driver = "SQL Server Native Client 11.0",
                   Server = "inbo-sql08-prd.inbo.be",
                   Database = "W0004_00_Waterbirds",
                   Trusted_Connection="yes") 
  
  #Deze data wordt opgehaald uit de DWH dmv bovenstaande odbc - verbinding. 
  #Om deze verbinding te doen werken heb je naast toelating 
  #ook nood aan een verbinding met het INBO - Netwerk. 
  #Deze verbinding kan bekomen worden door verbinding te maken met het 
  #VO-Werknemers netwerk (HT of andere VAC's) of door verbinding te maken dmv VPN.
  
  #Taxonkey van RST == 158 als je info van andere soorten wilt binnen halen dien je in onderstaande code 
  #de Taxonkey te vervangen.
  
  
  Query_TaxonOccurence_base <-"SELECT [TaxonWVKey],
                                  [SampleDateKey],
                                  [SeasonKey],
                                  [SampleKey],
                                  [LocationWVKey]
                          FROM [dbo].[FactTaxonOccurrence]"
  
  if(is.na(Taxonkey)){
    Query_TaxonOccurence <- Query_TaxonOccurence_base
    print("alle soorten")
  }else{
    Query_TaxonOccurence <- paste0(Query_TaxonOccurence_base, "WHERE TaxonWVKey = ", Taxonkey)
    print(paste0("enkel ", Taxonkey))
  }
  
  dbo_TaxonOccurence <- dbGetQuery(con, Query_TaxonOccurence) 
  
  dbo_Taxon <- dbGetQuery(con, "SELECT 
                        [TaxonWVKey],
                        [commonname],
                        [scientificname]
                        FROM [dbo].[DimTaxonWV]") 
  
  dbo_Sample <- dbGetQuery(con, "SELECT 
                         [SampleKey],
                         [Samplestatus],
                         [IsNulTelling]
                         FROM dbo.DimSample")
  
  dbo_Date <- dbGetQuery(con, "SELECT
                       [DateKey],
                       [Date],
                       [Year],
                       [Month]
                       FROM dbo.DimDate")
  
  output_data <- dbo_TaxonOccurence %>% 
    left_join(dbo_Taxon, by = "TaxonWVKey") %>% 
    left_join(dbo_Sample, by = "SampleKey") %>% 
    left_join(dbo_Date, by = c("SampleDateKey" = "DateKey")) %>% 
    select(commonname, scientificname, Samplestatus, IsNulTelling, Date, Year, Month)
  
  return(output_data)
}

