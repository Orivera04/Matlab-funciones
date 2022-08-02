% example2.m

% prediction of essay scores from grammar attributes example

load grader.dat % loads matrix grader=[y x] for essay grader example

% first five rows of grader:
%   y    con    WL       SqW        PC        PS         PP     SL
%   8    1    4.7600   15.4600    0.0560    5.5490    0.0800  19.5270
%   7    1    4.2440    9.0550    0.0360    1.2690    0.0950  16.3760
%   2    1    4.0870   16.1860    0.0110    2.6080    0.1400  18.4330
%   5    1    4.3550    7.5500    0.0180    1.8080         0  14.6480
%   7    1    4.3060    9.6440    0.0230         0    0.1000  18.7210   
   
% mle fit using probit link

link='probit';      
K = 10;  % number of categories
[mle,cov,dev,devRes,fits] = ordinalMLE(grader,K,link);  
mle',sqrt(diag(cov))'

% plot deviance contributions against covariate 3

figure; plot(grader(:,4),devRes,'*')
xlabel('square root of number of words'); ylabel('deviance contribution')

% screening for important variables

drop_out_dev=zeros(6,1);
for i=1:6
   rmodel=grader; rmodel(:,2+i)=[];
   [mle1,cov1,dev1] = ordinalMLE(rmodel,K,link); 
   drop_out_dev(i)=dev1-dev;
end

drop_out_dev

% Bayesian fit using MCMC
% using mle as starting value, m iterations
m=1000; K = 10;
[sampleBeta, lat_resid, accept] = sampleOrdProb(grader,K,mle,m);

mean(sampleBeta),std(sampleBeta)  % computer posterior means and stand dev's

figure
norm_plot(lat_resid)  % constructs normal probability plot for latent residuals

% compute quartiles of posterior predictive residuals y - y*
% plots quartiles as function of observation number

quan=o_post_pred(grader,K,sampleBeta);