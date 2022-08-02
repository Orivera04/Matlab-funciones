% EXAMPLE1.m
% Learning about relationships
% Linear regression example with vague priors.

% Observe paired data (x,y) where y is distributed
% normal with mean a+bx and standard deviation s.
% Assign (a,b) a uniform prior and s the prior 1/s.
% [Albert (1996), p. 140.]

x=[ 1  1  1  1  1  1  1  1  1  1
   20 16 20 18 17 16 15 17 15 16]'; % design matrix
y=[89 72 93 84 81 75 70 82 69 83]'; % response vector
num=1000;                           % number of simulations

[Sbeta,Ss]=bay_reg(y,x,num);          

% Sbeta is matrix of simulated values where first column
% contains simulated values of a and second column contains
% simulated values of b.  Ss is vector of simulated values of
% standard deviation s.
 
