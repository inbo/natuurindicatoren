###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# The script reproduces the modelling results shown in Fig. 5 of the article.
#
# The model implemented here describes the temporal development of the 
# accumulation of alien species on an island, which were randomly depicted
# from an arbitrary mainland community. The probability of depicting a species
# increased exponentially during the simulation to account for increases in 
# propagule and colonisation pressures due to e.g. increases of trade volumes.
# For further details, consult the article.
#
# The code is free of use as long as the article is properly cited.
#
# Author of code: Hanno Seebens, Frankfurt, Germany
# 25. August, 2016
###################################################################################


graphics.off() # close windows
rm(list=ls()) # clear R environment

options(scipen=5)

##### Defintion of objects/variables for simulation ##############################

t_max <- 50000 # max simulation time
res <- 1/100 # resolution of time steps
n_steps <- t_max*1/res # total simulation time steps

n_bins <- 100 # n_spec/bins = number of bins

n_spec <- 10^seq(2,5,0.5) # species number for different model scenarios

## define temporal variation of propagule pressure ###################
m <- rev(exp(-0.7*seq(0,10,length.out=n_steps))) # exponential increase
m <- m-min(m) # normalise
m <- m/max(m) # normalise

## define x-axis for plotting
timeaxis <- seq(1,t_max,length.out=n_steps) # for plotting

## define object to store temporal dynamics of species accumulation on island: 
## an empty matrix (rows: time steps, columns: different scenarios)
island <- matrix(0,nr=n_steps,nc=length(n_spec)+1)
island[,1] <- 1:(n_steps)

## define object to store the shape of the communities
all_pop <- matrix(0,nr=n_bins,nc=length(n_spec))


###### SIMULATION #######################################################################

out_list <- list() # output file
x <- 0 # counter
for (i in 1:length(n_spec)){ # loop through all scenarios consisting of different community sizes
  x <- x + 1 # increase counter
  
  ## define mainland community from a log-normal distribution
  specabund <- dlnorm((seq(0.1,2,length.out=n_bins)),meanlog=-1,sdlog=1)*100000000
  axis1 <- seq(10,1000,length.out=n_bins) # for plotting
  specabund <- ceiling(specabund) # round values to avoid decimals
  specabund <- round(specabund/sum(specabund)*n_spec[i]) # rescale numbers
  
  ## extract species numbers and abundances
  tot_spec <- sum(specabund) # number of species
  abundances <- rep(axis1,round(specabund)) # set abundances
  tot_abund <- sum(abundances) # number of individuals
  all_pop[,x] <- specabund # store community
  print(tot_spec)
  print(tot_abund)
  
  #### simulation ############################################################################
  for (t in 1:n_steps){ # loop through time steps
    
    ## select individual from mainland community and transfer it on the island
    if (runif(1)<m[t]){ # determine if new individual arrives, depending on propagule pressure m at time t
      ind <- runif(1)*tot_abund # if individual arrives, determine new individual
      spec <- max(which(c(0,cumsum(abundances))<=ind)) # select species accordingly
      island[t,x+1] <- spec # store species entry at time t and scenario x
    }
  }
  
  ## consider an Allee effect ###############################################################
  ## A species is only considered to be able to establish a population on the island
  ## if certain number of individuals (defined in variable 'allee') exists simultaneously 
  ## during a time window of size 'window'. That is, a species is considered as established on the 
  ## island if the number of individuals of that species living simultaneously on the island
  ## within the time window 'window' exceeds the Allee threshold 'allee'.
  
  data <- as.integer(island[,x+1]) # time series of species accumulation without the consideration of an Allee effect
  window <- 100000 # time window for the calculation of total population size
  step <- 1 # time step for the assessments of Allee effects (each time)
  allee <- 10 # minimum population for an established population, Allee threshold
  
  total <- length(data) # length of data set
  spots <- seq(from=1, to=(total-window), by=step) # starting values of the time windows
  out <- matrix(NA,nc=1,nr=tot_spec) # results file
  
  isl_spec <- 0
  for(j in which(data[1:(length(data)-window)]!=0)){ # loop through time series and check moving time windows
    
    dat <- data[spots[j]:(spots[j]+window)] # extract individuals of all species during the respective time window
    tab <- tabulate(dat[dat!=0]) # calculate population sizes for all species
    abund_spec <- which(tab>allee) # check if population sizes exceed Allee threshold
    
    new_spec <- abund_spec[!abund_spec%in%isl_spec] # select species, which populations exceed the Allee threshold
    out[new_spec] <- j # store the date, when species was recognised to have an established population on the island
    isl_spec <- (c(isl_spec,new_spec)) # store all species on the island
    if (length(isl_spec)==tot_spec) break # break if all species reached the island
  }
  out_list[[x]] <- out # store result
  ######################################################################################
  
  ## process time series without Allee effect
  dupl <- duplicated(island[,x+1]) # identify duplicated entries of species in time series
  island[which(dupl),x+1] <- 0 # set all duplicated entries to zero (i.e., remove all entries after the first occurrence of that species)
  island[which(!dupl),x+1] <- 1 # set all species numbers to 1 (species identity is not required any more)
  island[,x+1] <- cumsum(island[,x+1]) # calculate accumulation of species numbers on the island
}
out_ls <- lapply(out_list,function(s) sort(s,na.last=T)) # sort time when species exceeded the Allee threshold (for plotting)



### PLOT results (Fig. 5 in the main text) ###############################################################################################

x11(width=3.5,height=6) # define size of plot window
layout(matrix(c(1:3),nr=3)) # define layout of plot
op <- par(oma=c(0,3.5,0,1),mar=c(3,2,0.5,0.5),las=1,cex=0.9,mgp=c(2.5,0.35,0),tck=-0.02,xaxs="i",yaxs="i") # some additional options

## panel a: plot communities on mainland, one for each model scenario ##################################
matplot(axis1,all_pop,type="p",log="yx",pch=1,cex=0.7,col=rainbow(length(n_spec),start=0,end=4/6),lty=1,ylab="Species",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,5,1),las=1)
axis(2,at=(1:10*rep(10^seq(0,5,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("a",side=3,adj=-0.45,line=-0.5,font=2)
mtext("Species",side=2,line=2.5,cex=0.9,las=0)
mtext("Mainland",side=2,las=0,cex=1,font=2,line=4)

## panel b: plot temporal development of propagule pressure (exponential increase) #####################
plot(timeaxis[seq(1,n_steps,length.out=200)],m[seq(1,n_steps,length.out=200)],xlim=c(0,t_max),ylim=c(0,1),xlab="",ylab="Rate of introduction",type="l")
mtext("Simulation time",side=1,line=2)
mtext("b",side=3,adj=-0.45,line=-0.5,font=2)
mtext("Probability",side=2,line=2.5,cex=0.9,las=0)
mtext("Translocation",side=2,las=0,cex=1,font=2,line=4)

## panel c: plot temporal development of species accumulation on island ################################
## without Allee effect
matplot(seq(1,t_max,length.out=200),island[seq(1,n_steps,length.out=200),(1:length(n_spec))+1],yaxt="n",type="l",xlim=c(0,t_max),ylim=c(1,100000),log="y",col=rainbow(length(n_spec),start=0,end=4/6),lty=1,xlab="",ylab="Species")
mtext("Simulation time",side=1,line=2)
axis(2,at=10^seq(0,5,1),las=1)
axis(2,at=(1:10*rep(10^seq(0,5,1)/10,each=10)),labels=F,tcl=-0.3)

## with Allee effect
for (i in 1:length(out_ls)){
  lines(out_ls[[i]]*res,1:length(out_ls[[i]]),lty=2,col=rainbow(length(n_spec),start=0,end=4/6)[i])
}
mtext("c",side=3,adj=-0.45,line=-0.5,font=2)
mtext("Species",side=2,line=2.5,cex=0.9,las=0)
mtext("Island",side=2,las=0,cex=1,font=2,line=4)

par(op)
