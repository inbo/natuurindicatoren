###################################################################################
# R-script submitted as Supplementary Information to Seebens et al. (2016) No 
# saturation in the accumulation of alien species worldwide. Nature Communications ....
#
# This script calls the following five different scripts running the respective simulation. 
# The results will be written out in files, which requires the definition a working directory
# below. Otherwise the files will be stored in the same folder as the scripts. 
# Subsequently, a sixth script is called which creates the figure shown in 
# Supplementary Fig. 5 of the article thereby importing the newly stored result files.
#
# Rcode_Seebens-etal_InvasionModel_Constant.r
# Rcode_Seebens-etal_InvasionModel_Linear.r
# Rcode_Seebens-etal_InvasionModel_Exponential.r
# Rcode_Seebens-etal_InvasionModel_Trade.r
# Rcode_Seebens-etal_InvasionModel_BotGar.r
#
# Rcode_Seebens-etal_InvasionModel_Plot.r to create the final plot. 
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

graphics.off() # close windows
rm(list=ls()) # clear R environment

# setwd("/home/hanno/Bioinvasion/InvAccu")

source("Rcode_Seebens-etal_InvasionModel_Constant.r")
source("Rcode_Seebens-etal_InvasionModel_Linear.r")
source("Rcode_Seebens-etal_InvasionModel_Exponential.r")
source("Rcode_Seebens-etal_InvasionModel_Trade.r")
source("Rcode_Seebens-etal_InvasionModel_BotGar.r")

source("Rcode_Seebens-etal_InvasionModel_Plot.r")