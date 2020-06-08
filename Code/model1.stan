# This script is for STATS 551 Final Project, fitting fMRI data and draw samples.
# Arthur: Rongqian Zhang
# Date: April 25, 2020

data {
int<lower=0> N; // number of data items
 // number of predictors
vector[N] x; // predictor matrix
real y[N]; // outcome vector
}
parameters {
 
real beta; // coefficients for predictors
real alpha;// intercept

real sigma;// error scale

}
model {
 
      beta ~ normal(0,10);//prior
alpha ~normal(0,1);//prior
sigma~ inv_gamma(1, 1);//prior
y ~ normal(alpha+x * beta, sigma); // likelihood
   

}

generated quantities {
  real y_rep[N];//posterior predictive samples

  for(i in 1:N) {
    y_rep[i] = normal_rng(x[i] * beta + alpha, sigma);
  }
}
