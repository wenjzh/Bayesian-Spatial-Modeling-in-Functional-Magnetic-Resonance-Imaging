# This script is for STATS 551 Final Project, implementing model1.stan.
# Arthur: Rongqian Zhang
# Date: April 25, 2020

set.seed(8168686)
library(MCMCpack)

library(fmri)
library(foreach)

library(rstan)
library(tidyverse)
library(tidybayes)
library(ggplot2)
library(bayesplot)
options(mc.cores = parallel::detectCores() - 2)
rstan_options(auto_write = TRUE)

##loading data
load('MOD1.RData')
data<- bigim1_mod[,,33,]

###scaling data
A.mean <- apply(data, c(1,2), mean)
mean<-replicate(160, A.mean)
data<-data-mean

###HRF transformation
ons <- c(1, 21, 41, 61, 81, 101, 121, 141)
dur <- c(10, 10, 10, 10, 10, 10, 10, 10)
dur2<-c(1:10,21:30,41:50,61:70,81:90,101:110,121:130,141:150)

fixed_stim<-fmri.stimulus(160,ons = dur2,TR=3)
raw_design<-fmri.design(fixed_stim,order = 1)
X_fmri<-raw_design[,-2]
X_fmri<-as.data.frame(X_fmri)
colnames(X_fmri)<-c("BOLD_signal","linear_signal")

###pixelwise one-subject model
result<-array(dim = c(64,64,1000))

for (i in 1:64){
  for (j in 1:64)
  {
    stan_data <- within(list(), { 
  N <- 160
  
 x<-fixed_stim
 y<-data[i,j,]
  
})

model <- stan_model('model1.stan')
fit <- sampling(model, data = stan_data, chains = 4)
result[i,j,]<-as.array(fit)[,1,1]
  }
}
result[64,64,]

print(fit,pars = 'beta')
save(result,file='result.RData')

###model checking for some pixel
stan_data <- within(list(), { 
  N <- 160
  
  x<-fixed_stim
  y<-data[5,5,]})

model <- stan_model('model1.stan')
fit <- sampling(model, data = stan_data, chains = 4)
print(fit)
traceplot(fit)
y_rep <- as.matrix(fit, pars = "y_rep")
ppc_dens_overlay(stan_data$y, y_rep)
