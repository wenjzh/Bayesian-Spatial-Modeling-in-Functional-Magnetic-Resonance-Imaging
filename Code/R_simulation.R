# This script is for STATS 551 Final Project
# It is used to conduct the spatial model, double smoothing model, and the weighted spatial model
# based on the coefficients from the previous Observation model
#
# Arthur: Yongkai Qiu
# Date: April 25, 2020

load("C:/study/STATS_551/final_project/result.RData")


# simulation of coefficients for spatial model
sim_beta_res<-array(0,dim = c(64,64,1000))

for (i in 2:63) {
  for (j in 2:63) {
    for (k in 1:1000) {
      sim_beta_res[i,j,k]<-rnorm(1,(result[i-1,j,k]+result[i+1,j,k]+result[i,j-1,k]+result[i,j+1,k])/4,1)
    }
  }
}

save(sim_beta_res,file = "sim_beta_res.RData")

# simulation of coefficients for double smoothing model
sim_beta_res2<-array(0,dim = c(64,64,1000))

for (i in 2:63) {
  for (j in 2:63) {
    for (k in 1:1000) {
      sim_beta_res2[i,j,k]<-rnorm(1,(sim_beta_res[i-1,j,k]+sim_beta_res[i+1,j,k]+sim_beta_res[i,j-1,k]+sim_beta_res[i,j+1,k])/4,1)
    }
  }
}

save(sim_beta_res2,file = "sim_beta_res2.RData")

# simulation of coefficients for weighted spatial model
sim_beta_res3<-array(0,dim = c(64,64,1000))

for (i in 3:62) {
  for (j in 3:62) {
    for (k in 1:1000) {
      sim_beta_res3[i,j,k]<-rnorm(1,(result[i-1,j,k]+result[i+1,j,k]+result[i,j-1,k]+result[i,j+1,k]+
                                       result[i-2,j,k]/2+result[i+2,j,k]/2+result[i,j-2,k]/2+result[i,j+2,k]/2+
                                       result[i-1,j-1,k]/sqrt(2)+result[i+1,j-1,k]/sqrt(2)+result[i-1,j+1,k]/sqrt(2)+result[i+1,j+1,k]/sqrt(2))/
                                    (4+4*1/2+4/sqrt(2)),1)
    }
  }
}
save(sim_beta_res3,file = "sim_beta_res3.RData")
