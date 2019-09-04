###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# The script is called by the file Rcode_Seebens-etal_InvasionModel_PropPress_MAIN.r
# which reproduces the modelling results shown in Supplementary Fig. 5 of the article.
#
# This file simulates the model scenario: increase related to number of botanic gardens.
#
# The model implemented here describes the temporal development of the 
# accumulation of alien species on an island, which were randomly depicted
# from an arbitrary mainland community. The probability of depicting a species
# may change during the simulation depending on the scenario to account for increases
# in propagule and colonisation pressures due to e.g. increases of trade volumes.
# For further details, consult the article.
# Five scenarios were simulated assuming different increases in the rate of 
# introduction (constant, linear or exponential increase, related to import 
# volumes or the number of founded botanic gardens).
#
# The code is free of use as long as the article is properly cited.
#
# Author of code: Hanno Seebens, Frankfurt, Germany
# 25. August, 2016
###################################################################################

##### Defintion of objects/variables for simulation ###########################################################

n_spec <- 50000 # number of species of the mainland community
t_max <- 202000 # max simulation time

n_bins <- 1000 # number of steps abundances of the mainland community are stored

add <- "botgar" # type of increase in propagule pressure, required for output file

## Define temporal development of propagule pressure ###########################################################

## calculate propagule pressure as a function of newly founded botanical gardens ###############################
# The year of foundation of botanical gardens can be obtained from Botanic Gardens Conservation International
# (https://www.bgci.org/). We selected the years of foundation for botanic gardens in those countries, which
# have records of vascular plants in our first record database resulting in 2762 years of foundation:
botgar <- c(1971,1832,1898,1929,1988,1980,1989,1947,1924,2006,1963,1995,1997,1988,1999,1855,1952,1928,1877,1997,1956,1971,1996,1984,1964,1967,1987,1902,1901,1993,1887,1901,1949,1926,2005,1993,1981,1966,1983,1985,1970,1886,1957,1984,
            1946,1978,1988,1965,1976,1998,1988,1941,1967,1988,1953,1818,1978,1951,1968,1955,1982,1990,1981,1991,1988,2003,1994,1965,1864,1965,1989,1992,1984,1986,1984,1970,1980,1964,1980,1958,1961,1992,1961,1928,1960,1970,1981,1968,
            1929,1986,1988,2001,1981,1933,1898,1966,1976,1970,1816,1992,1986,1987,1985,1976,1932,1932,1970,1969,1988,1983,1969,1895,1964,1982,1974,1914,1947,1887,1954,1909,1952,1993,1987,1997,1754,1950,1973,1980,1910,1954,1983,1966,
            1979,1960,1981,1922,1978,1980,1985,1797,1899,1985,1952,1970,1937,2011,1902,1962,1991,1986,1984,1994,1998,1991,1968,1974,1985,1998,1990,1991,1992,1997,1998,2000,2003,1961,1808,1994,1938,1978,1997,1948,1930,1967,1959,1976,
            1993,1967,1926,1970,1942,2000,1985,1967,1998,1980,1931,2000,1924,1936,2000,1990,1950,1966,1999,1980,1970,1998,1971,1952,1972,1975,1958,1973,1916,1971,1904,1979,1968,1908,1904,1968,1999,1987,1994,1970,1970,1969,1960,1956,
            2006,1972,1955,1951,1977,1982,1985,1983,1991,1985,1959,1989,1985,1986,1980,1964,1929,1927,1956,1985,1956,1952,1871,1981,1986,1938,1983,1934,1980,1947,1954,1929,1958,1976,1974,1976,1955,1963,1983,2010,1956,1976,1976,1962,
            1956,2007,1959,1955,1985,1981,1915,1959,1980,1986,1982,2004,1955,1982,1979,2001,1983,1968,1960,1979,1969,1997,1988,1968,1960,1976,1967,1963,1889,1902,1968,1996,1929,1936,1922,1975,1954,1980,1901,1956,1961,1969,1931,1961,
            1927,1963,1958,2002,1943,1923,1970,1858,1976,1936,1933,1991,1976,1942,1958,1928,1875,1960,1961,1984,2010,1958,1988,1902,1678,1985,1982,1960,1978,1924,1936,1987,1953,1993,1957,1986,1977,1689,1953,1988,1976,1947,1942,1986,
            1992,1979,1979,1989,1899,2008,1970,1948,1983,1958,1970,1857,1903,1985,1986,1999,1987,1987,1905,1987,1990,1593,1901,1982,1965,1624,1994,1867,1995,1626,1777,1969,1986,1970,1986,1924,1988,1993,1992,1906,1932,1924,1965,1887,
            1843,1975,1968,1912,1845,1912,1953,1936,1971,1978,1879,1912,1968,1818,1989,1936,1955,1874,1905,1979,1945,1927,1868,1948,1945,1609,1736,1970,1967,1965,1927,1593,1586,1912,1970,1669,1864,1963,1973,1928,1946,1975,1977,1803,
            1901,1914,1975,1882,1984,1927,1950,1977,1885,1952,1903,1998,1846,1776,1910,1890,1905,1970,1965,1950,1835,1965,1947,2000,2004,2000,2007,2001,1984,1820,1963,1771,1771,1954,1928,1951,1922,1952,1961,1912,1930,1964,1978,1962,
            1962,1960,1923,1975,1964,2019,1973,1963,1964,1965,1985,1971,1975,1918,1971,1991,1961,1986,1971,1906,1979,1948,1958,1934,1947,1976,1963,1786,1958,1963,1787,1908,1968,1934,1951,1953,1964,1973,1970,1930,1964,1967,1981,1972,
            1980,1958,1961,1979,1978,1946,1966,1959,1980,1979,1979,1968,1972,1969,1963,1959,1817,1852,1941,1968,1931,1850,1795,1948,1968,1994,1958,1948,1930,1933,1954,1949,1971,1954,1987,1985,1972,1998,1981,1568,1979,1990,1828,1938,
            1858,1955,1984,1984,1771,1990,1904,1545,1959,1990,1980,1967,1994,1953,1980,1966,2001,1774,1954,1807,1989,1545,1933,1985,1720,1981,1955,1979,1967,1984,1988,1961,1968,1953,1991,1964,1965,1876,1938,1964,1842,1962,1951,1983,
            1990,1985,1955,1969,1961,1961,1984,1985,1952,1965,1930,1980,1971,1921,1976,1969,1939,1974,1976,1985,1974,1976,1971,1969,1967,1961,1950,1967,1957,1933,1958,1954,1933,1953,1924,1964,1958,1964,1911,1953,1968,1929,1958,1955,
            1961,1945,1684,1988,1980,1979,2002,2002,1948,1990,1940,1907,1990,1938,1922,1956,1997,1958,1923,1997,1958,1781,1925,1980,1987,1987,1926,1981,1974,1982,1976,1970,1981,1986,1989,1971,1974,1982,1977,1967,1990,1979,1979,1986,
            2002,1980,1982,1985,1978,1929,1983,1976,1979,1959,1987,1983,2005,1993,1994,1987,1993,2005,1990,1993,1970,1978,1991,1989,1980,1999,1949,2002,1976,1968,1974,1950,1997,1952,1961,1982,1863,1863,1910,1951,1927,1947,1966,1926,
            1868,1999,1954,1948,1976,1978,1958,1986,1969,1814,1971,1991,1973,1989,2006,1912,1999,1965,1973,2007,1959,1968,1968,1977,1980,1947,1930,1925,1951,1946,1960,1963,1989,1984,1925,1924,1947,1933,1925,1974,1890,1811,1953,1986,
            1960,1768,1878,1906,1951,2000,1970,1987,1901,1971,1991,1987,1903,1920,2000,1953,1856,1968,2018,1952,1913,1983,1991,1903,1960,1903,1960,1986,1859,1942,1967,1950,1982,1892,1965,1977,1959,1967,1927,1913,1849,1989,1996,1853,
            1967,1970,1982,1969,2008,1957,1874,1962,1934,1958,1976,1991,1922,1921,1979,2006,1967,1965,1966,1999,1987,1969,1989,2003,1987,1976,1991,1934,1988,1918,1952,1979,2003,2000,1952,2007,1755,1994,1945,1965,1986,1567,1962,1986,
            1950,1986,1964,1923,1860,1981,1970,1859,1968,1589,1968,1950,1925,1937,1943,1927,1946,1965,1896,1954,1945,1977,1931,1966,1906,1999,1896,1990,1902,2006,1953,1993,1993,2011,1941,1978,1968,1988,1993,1913,1919,1990,1999,1972,
            1950,1964,2009,1949,1935,1980,2003,1898,2001,1945,2000,1877,1930,1931,1963,1930,1934,1921,1935,1928,1974,1977,1934,1965,1912,1796,1946,1963,1933,2001,1963,1988,1977,1925,1929,1829,1903,1997,1906,1996,1955,1934,1971,1971,
            1670,1922,1817,1950,1950,1965,1948,1946,1921,1964,1673,1910,1975,1898,1997,1967,1621,1923,1972,1953,1966,1836,1951,1961,1950,1889,1978,1968,1960,1926,1856,1991,1996,1971,1986,1938,1904,1969,1970,1981,2000,1995,1986,1907,
            1948,1960,1986,1980,1995,1968,1976,1985,1889,1963,1982,1982,1935,1970,1981,1922,1984,1991,2000,1991,1940,1892,1911,1997,1964,1984,1984,1991,1872,1992,1987,1972,1907,1891,1965,1966,1910,1900,1831,1972,1990,1975,1971,1912,
            1934,1967,1961,1966,1870,1968,1966,1768,1958,1956,1977,1908,1890,2004,1873,1873,1933,1845,1927,1958,1929,1930,1970,2002,1977,1999,1895,1981,1938,1947,1959,1965,1983,1926,1974,1936,1997,1885,1927,1936,1962,1990,2000,1999,
            1951,1979,1955,1976,1990,1966,1980,1932,1999,1934,1873,1965,1975,2000,1990,1999,1963,1961,1926,1972,1951,1973,1992,1991,1950,1994,1989,1993,1981,1959,1939,1961,1974,1947,1984,1985,1983,1933,1931,1984,1971,1978,1953,1983,
            1948,1987,1965,2001,1995,1982,2000,1925,1887,1996,1973,1939,1935,1974,1939,1978,1937,1981,1964,1922,1935,1963,1929,1970,1930,1918,1930,1956,1967,1999,1974,1992,1988,1926,1978,1970,1935,1926,1925,1989,1998,2007,1964,1960,
            1967,1974,2001,2004,1906,1978,2005,2009,1937,2006,1957,1988,1931,1983,1968,1954,1981,1971,2002,1929,1987,1989,1948,2000,1990,1985,1991,1969,1922,1996,1961,1997,1929,1952,1934,1969,1974,1953,1955,1972,1985,1993,1962,1967,
            1946,1976,1953,1940,1922,1974,1980,1898,1936,1899,1971,1966,1959,1907,1974,1929,2000,1971,1909,1928,1988,1970,1931,1995,1917,1960,1988,1903,1934,1923,1934,1931,1884,1969,1936,1929,1950,1964,1942,1938,1900,1958,1895,1959,
            1929,1964,1988,1904,1958,2001,2008,1962,1983,1960,1934,1947,1963,1993,1955,1970,1961,1979,1976,1897,1932,1939,1967,1979,1952,1978,1893,1925,1928,1981,1963,1978,1991,1941,1976,1926,1972,1986,1959,1984,1925,1980,1963,1888,
            1999,1998,1959,1915,1973,1988,1961,1980,1916,1964,1937,1879,1993,1973,1903,1969,1993,1926,1964,1987,1973,1983,1832,1996,1975,1971,2002,1994,1972,1934,2003,1911,1912,1907,1958,1906,1999,1878,1936,1949,1903,1998,1998,1972,
            1985,1859,1965,1975,1989,1938,1976,1934,1977,1974,1994,1927,1929,1969,1977,1932,1997,1945,1964,1952,1964,1958,1985,2002,1999,1967,1937,1989,1986,1997,2001,1980,1961,2000,1957,1960,1972,1931,1950,1990,1926,2001,1816,1927,
            1916,1990,1852,1875,1975,1983,1958,1898,1972,1969,1955,1915,1901,1962,1930,1976,1908,1958,1979,1993,1972,1973,1956,1991,1967,1950,1962,1947)

botgar_ts <- as.data.frame(table(botgar),stringsAsFactors=F) # get annual time series of foundations
colnames(botgar_ts) <- c("Year","BotGar") # set column names
botgar_ts$Year <- as.numeric(botgar_ts$Year) # redefine column types
botgar_ts <- subset(botgar_ts,Year<2002) # consider only foundation during the time period of the first record database
botgar_ts[,2] <- cumsum(botgar_ts[,2]) # calculate cumulative sum of the annual number of foundations

raw <- cbind(1800:2000,NA) # create dummy file for the full time period to identify gaps in time series of botanic garden foundations
colnames(raw) <- c("Year","Dummy")
botgar_fullts <-merge(botgar_ts,raw,by=c("Year"),all=T) 
botgar_fullts[which(is.na(botgar_fullts[,2])),2] <- approx(botgar_fullts[,2],xout=which(is.na(botgar_fullts[,2])),method="constant")$y # fill gaps with constant values
botgar_fullts <- subset(botgar_fullts,Year>1799) # cut entries before start of simulation (note that these early botanic gardens are still considered in the  cumulative number of foundations)

botgar_interpol <- approx(botgar_fullts[,1],botgar_fullts[,2],n=t_max) # interpolate annual values to achieve a continuous development of increasing propagule pressure according to the simulation time steps
timeaxis <- botgar_interpol[[1]] # identify time axis (for plotting)

# rescale accumulation of botanic gardens to get a propagule pressure comparable to other scenario runs
m_bg <- botgar_interpol[[2]]
m_bg <- m_bg/mean(m_bg)*0.05
m <- m_bg
###############################################################################################################


# define basic characteristics of community size #############################################################
mlog <- seq(-3,1,length.out=5) # size of communities (defined as mean of log-normal distribution) for different model scenarios
sdlog <- 300 # standard deviation of log-normal distribution, constant
run_tot <- length(mlog)*length(sdlog) # number of model scenarios


######### SIMULATION #########################################################################################

island <- matrix(0,nr=t_max,nc=run_tot+1) # results file
island[,1] <- 1:t_max # include time axis in first column 
all_main <- matrix(0,nr=n_bins,nc=run_tot) # store communities (abundances and species)
x <- 0 # counter
for (j in 1:length(mlog)){# loop through model scenarios depending on the number of defined means
  for (i in 1:length(sdlog)){# loop through model scenarios depending on the number of defined standard deviations
    x <- x + 1 # increase counter
    
    ## define mainland community ###############################################
    specabund <- dlnorm((seq(0.1,2,length.out=n_bins)),meanlog=mlog[j],sdlog=1)*10000
    axis1 <- seq(10,10000,length.out=n_bins) # steps of storing individuals per species (for plotting)
    specabund <- ceiling(specabund) # avoid decimals in abundances
    specabund <- round(specabund/sum(specabund)*n_spec) # rescale numbers
    
    tot_spec <- sum(specabund) # number of species
    abundances <- rep(axis1,round(specabund)) # set abundances
    tot_abund <- sum(abundances) # number of individuals
    all_main[,x] <- specabund # store community
    print(tot_spec)
    print(tot_abund)
    
    #### simulation ############################################################################
    for (t in 1:t_max){ # loop through time steps
      
      ## select individual from mainland community and transfer it on the island
      if (runif(1)<m[t]){  # determine if new individual arrives, depending on propagule pressure m at time t
        ind <- runif(1)*tot_abund # if individual arrives, determine new individual
        spec <- max(which(c(0,cumsum(abundances))<=ind)) # select species accordingly
        # if (spec==-Inf) break # 
        island[t,x+1] <- spec # store species entry at time t and scenario x
      }
    }
    ## process time series of arriving individuals 
    dupl <- duplicated(island[,x+1]) # identify duplicated entries of species in time series
    island[which(dupl),x+1] <- 0 # set all duplicated entries to zero (i.e., remove all entries after the first occurrence of that species)
    island[which(!dupl),x+1] <- 1  # set all species numbers to 1 (species identity is not required any more)
  }
}

## calculate number of first records per year #####################
ts_round <- round(timeaxis) # get an annual time axis
isl_agg <- matrix(NA,nr=length(unique(ts_round)),nc=dim(island)[2]-1) # results files
for (i in 2:dim(island)[2]){
  isl_agg[,i-1] <- tapply(island[,i],ts_round,sum) # sum up number of new species per year
}

### output (only the information which is required to create the plot) ######################################
write.table(isl_agg,paste("SimInvAcc_VarMain_island_",add,".csv",sep=""),sep=";",row.names=F)
write.table(unique(ts_round),paste("SimInvAcc_VarMain_realtime_",add,".csv",sep=""),sep=";",row.names=F)
write.table(all_main,paste("SimInvAcc_VarMain_allmain_",add,".csv",sep=""),sep=";",row.names=F)
write.table(axis1,paste("SimInvAcc_VarMain_axis1_",add,".csv",sep=""),sep=";",row.names=F)
write.table(timeaxis[seq(1,t_max,length.out=200)],paste("SimInvAcc_VarMain_timeaxis_",add,".csv",sep=""),sep=";",row.names=F)
write.table(m[seq(1,t_max,length.out=200)],paste("SimInvAcc_VarMain_PropPress_",add,".csv",sep=""),sep=";",row.names=F)


