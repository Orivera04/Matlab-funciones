function [set,eprob]=disc_int(dist,prob)
%
% DISC_INT Computes a highest probability interval for a discrete distribution.  
%	[SET,EPROB]=DISC_INT(DIST,PROB) gives the vector SET of values and
% 	the exact probability context EPROB, where DIST=[VALUE,PROBABILITY]
%	is the matrix which contains the discrete distribution and PROB
%	is the probability content desired.
 	
x=dist(:,1); p=dist(:,2); n=length(x);

[ps,i]=sort(p); i=i(n:-1:1); ps=p(i); xs=x(i);
cp=cumsum(ps);
j=min(find(cp>=prob));
eprob=cp(j); set=sort(xs(1:j))';

  



