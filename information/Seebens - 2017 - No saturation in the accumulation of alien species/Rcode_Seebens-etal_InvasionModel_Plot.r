###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# The script is called by the file .... which reproduces the modelling results 
# shown in Supplementary Fig. 5 of the article.
#
# This file plots the model results.
#
# The model implemented here describes the temporal development of the 
# accumulation of alien species on an island, which were randomly depicted
# from an arbitrary mainland community. The probability of depicting a species
# increased exponentially during the simulation to account for increases in 
# propagule and colonisation pressures due to e.g. increases of trade volumes.
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


x11(width=12,height=6)
layout(matrix(c(1:15),nr=3))
op <- par(oma=c(0,4,1,1),mar=c(3,2,0.5,0.5),las=1,cex=0.9,mgp=c(2.5,0.35,0),tck=-0.02,xaxs="i",yaxs="i")

### constant propagule pressure ############################################################
## load data
all_main <- read.table("SimInvAcc_VarMain_allmain_const.csv",sep=";",header=T)
axis1 <- read.table("SimInvAcc_VarMain_axis1_const.csv",sep=";",header=T)
timeaxis <- read.table("SimInvAcc_VarMain_timeaxis_const.csv",sep=";",header=T)
m <- read.table("SimInvAcc_VarMain_PropPress_const.csv",sep=";",header=T)
isl_agg <- read.table("SimInvAcc_VarMain_island_const.csv",sep=";",header=T)
realtime <- read.table("SimInvAcc_VarMain_realtime_const.csv",sep=";",header=T)

# plot panels a-b
run_tot <- dim(all_main)[2]
matplot(axis1,all_main,type="p",log="yx",pch=1,cex=0.7,col=rainbow(run_tot,start=0,end=4/6),lty=1,ylab="",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,4,1))
axis(2,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("a",side=3,adj=-0.23,line=0.5,font=2)
mtext("Constant",side=3,font=2,line=0.3)
mtext("Species",side=2,line=2,cex=0.9,las=0)
mtext("Mainland",side=2,las=0,cex=1,font=2,line=4)

plot(timeaxis[,1],m[,1],xlim=c(0,max(timeaxis)),ylim=c(0,1),xlab="",ylab="",type="l")
mtext("Simulation time",side=1,line=1.4)
mtext("b",side=3,adj=-0.23,line=0.5,font=2)
mtext("Probability",side=2,line=2,cex=0.9,las=0)
mtext("Translocation",side=2,las=0,cex=1,font=2,line=4)

matplot(realtime,isl_agg,type="l",xlim=c(0,max(timeaxis)),ylim=c(0,max(isl_agg)),col=rainbow(run_tot,start=0,end=4/6),lty=1,xlab="",ylab="")
mtext("Simulation time",side=1,line=1.4)
mtext("c",side=3,adj=-0.23,line=0.5,font=2)
mtext("First record rate",side=2,line=2,cex=0.9,las=0)
mtext("Island",side=2,las=0,cex=1,font=2,line=4)


### linear increase in propagule pressure ###########################################################
# load data
all_main <- read.table("SimInvAcc_VarMain_allmain_lininc.csv",sep=";",header=T)
axis1 <- read.table("SimInvAcc_VarMain_axis1_lininc.csv",sep=";",header=T)
timeaxis <- read.table("SimInvAcc_VarMain_timeaxis_lininc.csv",sep=";",header=T)
m <- read.table("SimInvAcc_VarMain_PropPress_lininc.csv",sep=";",header=T)
isl_agg <- read.table("SimInvAcc_VarMain_island_lininc.csv",sep=";",header=T)
realtime <- read.table("SimInvAcc_VarMain_realtime_lininc.csv",sep=";",header=T)

# plot panels d-f
run_tot <- dim(all_main)[2]
matplot(axis1,all_main,type="p",log="yx",pch=1,cex=0.7,col=rainbow(run_tot,start=0,end=4/6),lty=1,ylab="",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,4,1))
axis(2,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("d",side=3,adj=-0.16,line=0.5,font=2)
mtext("Linear increase",side=3,font=2,line=0.3)

plot(timeaxis[,1],m[,1],xlim=c(0,max(timeaxis)),ylim=c(0,1),xlab="",ylab="",type="l")
mtext("Simulation time",side=1,line=1.4)
mtext("e",side=3,adj=-0.16,line=0.5,font=2)

matplot(realtime,isl_agg,type="l",xlim=c(0,max(timeaxis)),ylim=c(0,max(isl_agg)),col=rainbow(run_tot,start=0,end=4/6),lty=1,xlab="",ylab="")
mtext("Simulation time",side=1,line=1.4)
mtext("f",side=3,adj=-0.16,line=0.5,font=2)


## exponential increase in propagule pressure ##############################################################
# load data
all_main <- read.table("SimInvAcc_VarMain_allmain_exp.csv",sep=";",header=T)
axis1 <- read.table("SimInvAcc_VarMain_axis1_exp.csv",sep=";",header=T)
timeaxis <- read.table("SimInvAcc_VarMain_timeaxis_exp.csv",sep=";",header=T)
m <- read.table("SimInvAcc_VarMain_PropPress_exp.csv",sep=";",header=T)
isl_agg <- read.table("SimInvAcc_VarMain_island_exp.csv",sep=";",header=T)
realtime <- read.table("SimInvAcc_VarMain_realtime_exp.csv",sep=";",header=T)

# plot panels g-i
run_tot <- dim(all_main)[2]
matplot(axis1,all_main,type="p",log="yx",pch=1,cex=0.7,col=rainbow(run_tot,start=0,end=4/6),lty=1,ylab="",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,4,1))
axis(2,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("g",side=3,adj=-0.16,line=0.5,font=2)
mtext("Exponential increase",side=3,font=2,line=0.3)

plot(timeaxis[,1],m[,1],xlim=c(0,max(timeaxis)),ylim=c(0,1),xlab="",ylab="",type="l")
mtext("Simulation time",side=1,line=1.4)
mtext("h",side=3,adj=-0.16,line=0.5,font=2)

matplot(realtime,isl_agg,type="l",xlim=c(0,max(timeaxis)),ylim=c(0,max(isl_agg)),col=rainbow(run_tot,start=0,end=4/6),lty=1,xlab="",ylab="")
mtext("Simulation time",side=1,line=1.4)
mtext("i",side=3,adj=-0.16,line=0.5,font=2)



### increase in propagule pressure related to trade ####################################################
# load data
all_main <- read.table("SimInvAcc_VarMain_allmain_trade.csv",sep=";",header=T)
axis1 <- read.table("SimInvAcc_VarMain_axis1_trade.csv",sep=";",header=T)
timeaxis <- read.table("SimInvAcc_VarMain_timeaxis_trade.csv",sep=";",header=T)
m <- read.table("SimInvAcc_VarMain_PropPress_trade.csv",sep=";",header=T)
isl_agg <- read.table("SimInvAcc_VarMain_island_trade.csv",sep=";",header=T)
realtime <- read.table("SimInvAcc_VarMain_realtime_trade.csv",sep=";",header=T)

# plot panels j-l
run_tot <- dim(all_main)[2]
matplot(axis1,all_main,type="p",log="yx",pch=1,cex=0.7,col=rainbow(run_tot,start=0,end=4/6),lty=1,ylab="Species",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,4,1))
axis(2,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("j",side=3,adj=-0.23,line=0.5,font=2)
mtext("Trade",side=3,font=2,line=0.3)

plot(timeaxis[,1],m[,1],xlim=c(1800,2010),ylim=c(0,0.8),xlab="",ylab="",type="l")
mtext("Simulation time",side=1,line=1.4)
mtext("k",side=3,adj=-0.23,line=0.5,font=2)

matplot(realtime,isl_agg,type="l",ylim=c(0,max(isl_agg)),col=rainbow(run_tot,start=0,end=4/6),xlim=c(1800,2000),lty=1,xlab="",ylab="Accumulation rate")
mtext("Simulation time",side=1,line=1.4)
mtext("l",side=3,adj=-0.23,line=0.5,font=2)


### increase in propagule pressure related to the number of botanic gardens ########################################
# load data
all_main <- read.table("SimInvAcc_VarMain_allmain_botgar.csv",sep=";",header=T)
axis1 <- read.table("SimInvAcc_VarMain_axis1_botgar.csv",sep=";",header=T)
timeaxis <- read.table("SimInvAcc_VarMain_timeaxis_botgar.csv",sep=";",header=T)
m <- read.table("SimInvAcc_VarMain_PropPress_botgar.csv",sep=";",header=T)
isl_agg <- read.table("SimInvAcc_VarMain_island_botgar.csv",sep=";",header=T)
realtime <- read.table("SimInvAcc_VarMain_realtime_botgar.csv",sep=";",header=T)

# plot panels m-o
run_tot <- dim(all_main)[2]
matplot(axis1,all_main,type="p",log="yx",pch=1,cex=0.7,col=rainbow(run_tot,start=0,end=4/6),lty=1,ylab="",xlab="",xaxt="n",yaxt="n")
axis(1,at=10^seq(0,4,1))
axis(1,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
axis(2,at=10^seq(0,4,1))
axis(2,at=(1:10*rep(10^seq(0,4,1)/10,each=10)),labels=F,tcl=-0.3)
mtext("Individuals per species",side=1,line=1.5)
mtext("m",side=3,adj=-0.2,line=0.5,font=2)
mtext("Botanic gardens",side=3,font=2,line=0.3)

plot(timeaxis[,1],m[,1],xlim=c(1800,2010),ylim=c(0,0.25),xlab="",ylab="",type="l")
mtext("Simulation time",side=1,line=1.4)
mtext("n",side=3,adj=-0.2,line=0.5,font=2)

matplot(realtime,isl_agg,type="l",ylim=c(0,max(isl_agg)),col=rainbow(run_tot,start=0,end=4/6),xlim=c(1800,2000),lty=1,xlab="",ylab="")
mtext("Simulation time",side=1,line=1.4,cex=0.9)
mtext("o",side=3,adj=-0.2,line=0.5,font=2)


par(op)
