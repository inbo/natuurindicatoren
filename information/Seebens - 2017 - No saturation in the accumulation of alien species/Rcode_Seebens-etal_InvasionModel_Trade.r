###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# The script is called by the file Rcode_Seebens-etal_InvasionModel_PropPress_MAIN.r
# which reproduces the modelling results shown in Supplementary Fig. 5 of the article.
#
# This file simulates the model scenario: increase related to trade.
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

##### Defintion of objects/variables for simulation ##############################

n_spec <- 50000 # number of species of the mainland community
t_max <- 202000 # max simulation time

n_bins <- 1000 # number of steps abundances of the mainland community are stored

add <- "trade" # type of increase in propagule pressure, required for output file


## Define temporal development of propagule pressure ###########################################################

## calculate propagule pressure as a function of trade volumes ###################
# Data of trade volumes exchanged between countries was obtained from 
# Barbieri, K., Keshk, O. M. G. & Pollins, B. M. Trading Data: Evaluating our Assumptions
# and Coding Rules. Confl. Manag. Peace Sci. 26, 471–491 (2009)
# which can be obtained from the website of the Correlates of War project
# (http://cow.dss.ucdavis.edu/). We summed all import volumes during one year to get the following data set:
tradevolumes <- c(2824.36,3302.72,3498.57,4690.643348,4243.107772,4068.074288,4265.26402,4286.86385885,4308.4636977,4587.5280831,4457.3046798,4726.150118,4885.889034,4903.74268,4693.7286749,4251.1395468,4500.3876928,4708.2539095,4937.7313703,5261.3497903,5080.4954238,5356.2268168,5079.613416,5093.1870353,4675.09837839,4837.43,5542.2243267,5763.3489549,6113.871366,5946.8215987,6242.7125746,6043.0085968,6754.6609193,7207.1072126,7375.9590973,8890.8977095,9170.8353218,9700.6230691,9228.9249001,9416.8472911,11240.2178793,11142.0550889,12975.6087907,13650.9465671,663.99,688.8,850.85,1075.19,1014.16,1270.36,27001.5138406,16286.0630189,16431.4365836781,16789.958921,19942.4734399,23888.0553001,20045.7220522,25222.9514053,23930.5159105,25086.4668921,11304.4970258,15019.9187484,9560.822894,9724.3340318,13035.9453153,14262.0444,15136.7524288,19026.9543212,17037.236,908.59,836.17,803.83,858.83,929.33,1009.93,597.53,466.2400144,603.43000954,40964.5,38619.85,39562.519969,53415.8399789,53996.2748928,51440.4099831,53098.6399775,76576.4078413,86172.4998896,95784.2299971,84142.5598223,89642.9100396,103640.689967,111659.0499831,121784.3900075,132980.1804195,151777.1102024,165709.5600991,185027.489732,195069.4204046,219573.6206776,250473.3996974,289814.4701202,325607.6204952,384882.8989409,533155.7094613,779430.579651,819736.9712403,922389.9912038,1056641.7618211,1221401.0726998,1535430.0977182,1878929.0305306,1860191.3669799,1741758.8243669,1686503.6873806,1785857.3082899,1837419.8368386,1992144.7418941,2317998.8068929,2645574.9642046,2881269.4555296,3261169.9802596,3367026.7160529,3577351.8521061,3509237.3084483,4002362.9411779,4772371.1229506,5003356.0049492,5189842.805272,5158905.031539,5611173.347778,6322589.161256,6102383.715763)
importyears <- 1870:2001
trade_ts <- cbind(importyears,tradevolumes)
colnames(trade_ts) <- c("Year","Import")

# Trade data before 1870 are lacking. For comparison with the other model scenarios, we filled the gaps from 1800 to 1869
# with a constant value obtained in the year 1870. The value is likely to be too high, but given the still very low value
# compared to recent ones, it has no effect on the simulation outcome.
add_trade <- cbind(1800:1869,trade_ts[1,2]) # create arbitrary time series before 1870
colnames(add_trade) <- c("Year","Import")
trade_ts <- rbind(add_trade,trade_ts) # combine with original data set

trade_interpol <- approx(trade_ts[,1],trade_ts[,2],n=t_max)  # interpolate annual values to achieve a continuous development of increasing propagule pressure according to the simulation time steps
timeaxis <- trade_interpol[[1]] # identify time axis (for plotting)

# rescale accumulation of botanic gardens to get a propagule pressure comparable to other scenario runs
m_trade <- trade_interpol[[2]]
m_trade <- m_trade/mean(m_trade)*0.05 # mean propagule pressure 0.05 per step
m <- m_trade
####################################################################################################


# define basic characteristics of community size ###################################################
mlog <- seq(-3,1,length.out=5) # size of communities (defined as mean of log-normal distribution) for different model scenarios
sdlog <- 300 # standard deviation of log-normal distribution, constant
run_tot <- length(mlog)*length(sdlog) # number of model scenarios


######### SIMULATION ################################################################

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
