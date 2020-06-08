//This script is for STATS 551 Final Project. It takes the coefficient
//results from the previous Observation model and conduct the spatial model
//Arthur: Yongkai Qiu
//Date: April 25, 2020

data {
  real beta[64,64,1000];
}

parameters {
  real sim_beta[62,62];
}

model {
  vector[1000] betasum;
  for(i in 2:63){
    for(j in 2:63){
      for(k in 1:1000){
      betasum[k]=beta[i-1,j,k]+beta[i+1,j,k]+beta[i,j-1,k]+beta[i,j+1,k];
      }
      sim_beta[i-1,j-1]~normal(0.25*betasum,10);
    }
  }
}
