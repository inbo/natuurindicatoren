library(DBI)
library(odbc)

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

dbo_TaxonOccurence <- dbGetQuery(con,
                                 "SELECT [TaxonWVKey],
                                  [SampleDateKey],
                                  [SeasonKey],
                                  [SampleKey],
                                  [LocationWVKey]
                          FROM [dbo].[FactTaxonOccurrence]
                          WHERE TaxonWVKey = 158") 

dbo_Taxon <- dbGetQuery(con, "SELECT [commonname],
                        [scientificname],
                        [TaxonWVKey],
                        FROM dbo.DimTaxonWV") 

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

