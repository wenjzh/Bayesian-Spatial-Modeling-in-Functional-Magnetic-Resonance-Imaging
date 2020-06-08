# This script is for STATS 551 Final Project. It takes the coefficient
# results from the previous Observation model and conduct the spatial model
# Arthur: Yongkai Qiu
# Date: April 25, 2020

load("result.RData")

library(rstan)
library(tools)
# library(tidyverse)
# library(tidybayes)

options(mc.cores = parallel::detectCores() - 2)
rstan_options(auto_write = TRUE)

betadata<-list(beta=result)

fit<-stan(file = "spatial_z33.stan",
          data = betadata,
          chains = 2,
          warmup = 5,
          iter = 10,
          cores = 4,
          seed = 2020
)

var(extract(fit,pars="sim_beta[20,20]")$sim_beta)

stan_trace(fit,pars = c("sim_beta[20,20]"),inc_warmup = T)
print(fit,pars = c("sim_beta[40,40,20]","sim_beta[40,41,20]","sim_beta[40,40,21]","sim_beta[39,40,20]","sim_beta[40,49,20]","sim_beta[40,40,19]"))

load("MOD1.RData")

acf(bigim1_mod[44,40,33,])


