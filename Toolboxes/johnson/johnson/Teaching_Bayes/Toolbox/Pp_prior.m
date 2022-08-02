function [p1,p2,prior]=pp_prior(dat,type)
%
% PP_PRIOR Construction of prior for two proportions using discrete models.
%	[P1,P2,PRIOR]=PP_PRIOR(DAT,TYPE) returns vectors P1 and P2 of values
%	of two proportions and a matrix PRIOR of probabilities, where DAT
%	is a vector containing the smallest, largest and grid size for each
%	proportion, and TYPE indicates the type of prior ('u' for uniform prior
%	't' for testing prior which assigns a probability of .5 to P1=P2).

if nargin==1, type='u'; end

n=dat(3);
p1=linspace(dat(1),dat(2),dat(3));
p2=p1;
[P1,P2]=meshgrid(p1,p2);     
if type=='u'
  prior=1/n^2*ones(n,n);
elseif type=='t'
  prior=.5/n*(P1==P2)+.5/(n^2-n)*(P1~=P2);
end
  



