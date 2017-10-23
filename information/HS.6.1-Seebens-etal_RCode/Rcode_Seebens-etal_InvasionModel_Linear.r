###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# The script is called by the file Rcode_Seebens-etal_InvasionModel_PropPress_MAIN.r
# which reproduces the modelling results shown in Supplementary Fig. 5 of the article.
#
# This file simulates the model scenario: linear increase.
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

add <- "lininc" # type of increase in propagule pressure, required for output file; here: linear increase

## Define temporal development of propagule pressure ###########################################################
m <- seq(0,mean(m)*2,length.out=t_max) # linear increase
timeaxis <- seq(1,t_max/1000,length.out=t_max) # for plotting


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
