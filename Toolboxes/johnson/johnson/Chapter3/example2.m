% EXAMPLE2.M
% -------------------------------------------------------------------
% MATLAB 5 ROUTINES FOR COMPUTATIONS IN CHAPTER 3
%-------------------------------------------------------------  
%  Jim Albert - May 15, 1998
%-------------------------------------------------------------
%
% Conduct disorder example in Section 3.5

load conduct.dat % load grade data of form [y n 1 gender aggressive social_reject]

%---------------------------------------------------------------------
% logistic mle fit
% output is regression estimates, var_cov matrix, fitted probabilities,
% and three types of classical residuals

[beta,var,fitted_probs,pearson_res,dev_res,adev_res]=breg_mle(conduct,'l');  

%---------------------------------------------------------------------
% Bayesian logistic fit using Metropolis algorithm 
% output is Mb, matrix of simulated values, and acceptance rate of algorithm arate

[Mb,arate]=breg_bay(conduct,5000,'l'); 

%---------------------------------------------------------------------
% computes summaries (5th, 50th, 95th percentiles) of the fitted probability 
% and Bayesian residual distributions

[fit_prob,residuals]=lfitted(Mb,conduct,'l');

%---------------------------------------------------------------------
% scatterplot of deviance residuals against fitted probabilities

figure(1); 
plot(fitted_probs,dev_res,'o')
xlabel('FITTED PROBABILITIES'); ylabel('DEVIANCE RESIDUAL')
title('CLASSICAL RESIDUAL PLOT')

%---------------------------------------------------------------------
% plot residual distributions against posterior means of fitted probabilities
% using line graphs

figure(2); clf
plotfitted(1:172,residuals,'OBSERVATION NUMBER','BAYESIAN RESIDUAL')
title('BAYESIAN RESIDUAL POSTERIOR DISTRIBUTIONS')
axis([0 180 -1 1])

%---------------------------------------------------------------------
% samples from posterior predictive distribution for logistic model
% displays histogram of simulated sample of standard dev (y1*,...,y172*)

figure(3);
p_std=post_pred(Mb,conduct);
figure(3); clf
hist(p_std,50)
title('HISTOGRAM OF SDS OF POST. PRED. SAMPLE - LOGISTIC MODEL')

%---------------------------------------------------------------------
% fits random effects model 
% samples from posterior predictive distribution for random effects model
% displays histogram of simulated sample of standard dev (y1*,...,y172*)

[Mbeta,Ms2,p_std2]=logit_re2(conduct,5000);

figure(4); clf
hist(p_std2,50)
title('HISTOGRAM OF SDS OF POST. PRED. SAMPLE - RANDOM EFFECTS MODEL')

