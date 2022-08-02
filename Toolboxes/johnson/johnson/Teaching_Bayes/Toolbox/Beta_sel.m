function par=beta_sel(r,rplus)
%
% BETA_SEL Selecting a beta prior using predictive statements.
%	PAR=BETA_SEL(R,RPLUS) returns parameters of a beta distribution, where
%	R is the probability of a future success and RPLUS is the probability
%	of a second future success conditional on a first success.

a=r*(1-rplus)/(rplus-r);
b=(1-r)*(1-rplus)/(rplus-r);
par=[a b];


