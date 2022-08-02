% example1.m

% grades in a statistics class example in Chapter 4

load ostat.dat % loads matrix ostat=[y x] for statistics class dataset

% first five rows of ostat:
%   2  1   525
%   2  1   533
%   4  1   545
%   2  1   582
%   3  1   581

% mle fit using logistic link

link='logistic';      
K = 5;  % number of categories
[mle1,cov1,dev1,devRes1,fits1] = ordinalMLE(ostat,K,link);  
mle1',sqrt(diag(cov1))'

% display fitted probabilities (Figure 4.3)

figure;
plotfit(mle1(1:3)',mle1(4:5)',linspace(460,660,20));

% plot deviance contributions 

figure; plot(devRes1,'*')
xlabel('student number'); ylabel('deviance contribution')

% mle fit using probit link

link='probit';         
K = 5;  % number of categories
[mle2,cov2,dev2,devRes2,fits2] = ordinalMLE(ostat,K,link);  
mle2',sqrt(diag(cov2))'

% compare fitted probs using logit and probit links

figure; plot(fits2,fits1,'*'); line([0 1],[0 1])
xlabel('ordinal probit estimates of cell probabilities')
ylabel('proportional odds estimates of cell probabilities')

% Bayesian fit using MCMC
% using mle as starting value, m iterations
m=2000; K = 5;
[sampleBeta, lat_resid, accept] = sampleOrdProb(ostat,K,mle2,m);

mean(sampleBeta),std(sampleBeta)  % computer posterior means and stand dev's

figure
norm_plot(lat_resid)  % constructs normal probability plot for latent residuals

