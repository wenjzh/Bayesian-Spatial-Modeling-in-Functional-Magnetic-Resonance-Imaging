# This script is for STATS 551 Final Project, implementing posterior probability maps.
# Arthur: Wenjing Zhou(wenjzh@umich.edu)
# Date: April 25, 2020

ppm <- function(beta, chi){
  # This function implements eq(20) in https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4346370/#FD1
  
  # beta - a 1000*1 vector
  # chi - activation threshold: one standard deviation of the prior variance of
  #       the contrast / percentage of whole-brain mean signal, 2.2 or 0.7 are all acceptable
  # Output - wether this voxel should be displayed active, 1 indicating Yes
  
  # Constants:
  # w - contrast weight vector, here is 1
  
  # cumulative density function of the unit normal distribution
  m = mean(beta, na.rm = TRUE)
  c = var(beta, na.rm = TRUE)
  q = (chi - m)/sqrt(c)
  p = 1 - pnorm(q, mean=0, sd=1)
  
  # the probability the voxel must exceed to be displayed is set at 0.95
  # p = ifelse(p>=0.95, 1, 0)
  return(p)
}

# sim_beta_res
pvalue = matrix(, nrow = 62, ncol=62)
for (i in 1:62){
  for (j in 1:62){
    beta = sim_beta_res[i,j,]
    pvalue[i,j] = ppm(beta, chi=2.2)
  }
}
plot_ly(x = 1:62, y = 1:62, z = pvalue, type = "contour")

# fit_24_1
library(rstan)
pvalue = matrix(, nrow = 62, ncol=62)
for (i in 1:62){
  for (j in 1:62){
    sim_beta = sprintf('sim_beta[%s, %s]', i , j)
    beta = extract(fit_24_1, pars = sim_beta)$sim_beta
    pvalue[i,j] = ppm(beta, chi=0.025)
  }
}
library(plotly)
plot_ly(x = 1:62, y = 1:62, z = pvalue, type = "contour")

beta_mean = vector()
m = 1
for (i in 1:64){
  for (j in 1:64){
    beta = result[i,j,]
    beta_mean[m] = mean(beta)
    m = m + 1
  }
}

# Stan Data
pvalue = matrix(, nrow = 62, ncol=62)
for (i in 1:62){
  for (j in 1:62){
    sim_beta = sprintf('sim_beta[%s, %s]', i , j)
    beta = extract(fit, pars = sim_beta)$sim_beta
    pvalue[i,j] = ppm(beta)
  }
}

saveRDS(pvalue, "pvalue.rds")

contour(x = 1:62, y = 1:62, z = pvalue)

