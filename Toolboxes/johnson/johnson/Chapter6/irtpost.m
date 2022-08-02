function [pr,lo,hi]=irtpost(av,gv,th)
%
% irtpost - computes 5th, 50th, 95th percentiles of
%           posterior of item response curve
%
% command:	[pr,lo,hi]=irtpost(av,gv,th)
%
% input:		av - matrix of simulated values of discrim par a
%				pv - matrix of simulated values of difficulty par g
%				th - vector containing grid of theta values
%
% output:	pr - matrix of medians of phi(a th - b)
%				lo - matrix of 5th percentiles of phi(a th - b)
%				hi - matrix of 95th percentiles of phi(a th - b)

n=length(th);
m=size(av,1);
k=size(av,2);
pr=zeros(n,k);

medloc=[m/2 m/2+1];
loloc=[.05*m .05*m+1];
hiloc=[.95*m .95*m+1];
h=waitbar(0,'running ...');

kk=0;
for i=1:n
for j=1:k
   kk=kk+1;
   s=sort(phi(av(:,j)*th(i)-gv(:,j)));
   pr(i,j)=mean(s(medloc));
   lo(i,j)=mean(s(loloc));
   hi(i,j)=mean(s(hiloc));
   waitbar(kk/(n*k))
end
end
close(h)

function val=phi(x)
val=.5*(1+erf(x/sqrt(2)));
