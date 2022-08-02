function [y,x,g] = ex8olpl(l,m,Kmax,c,d)
%y = ex8olpl(l,m,Kmax,c,d)
%c = revenue from   a call in dollars per minute
%d =  cost of line in dollars per minute;
%l =  arrival rate in calls per minute;
%m =  1/ call duration in minutes;
%Kmax = Maximum number of lines ;
% output y(1) = optimal longrun revenue rate
% y(2) = optimal number of lines
r = l/m;
g=[0];
for K = 1:Kmax
sum = 1; term = 1;
for j = 1:K
term = term*r/j;
sum = sum +term;
end;
g=[g c*r*(1 - term/sum) - K*d];
end;
% g(K) is the net revenue of using K lines;
[gmax,i]=max(g);
y(1)=gmax;
y(2)=i(1)-1;
x=[0:Kmax];
