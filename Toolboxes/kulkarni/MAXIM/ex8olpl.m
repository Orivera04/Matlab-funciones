function y = ex8olpl(l,m,Kmax,c,d)
%y = ex8olpl(l,m,Kmax,c,d)
%c = revenue from   a call in dollars per minute
%d =  cost of line in dollars per minute;
%l =  arrival rate in calls per minute;
%m =  1/ call duration in minutes;
%Kmax = Maximum number of lines ;
% output y(i) = longrun revenue rate of using i
%lines.
y='error';
if l < 0
   msgbox('invalid entry for l'); return;
elseif m < 0
   msgbox('invalid entry for m'); return;
elseif Kmax < 0 | Kmax - fix(Kmax) ~= 0
   msgbox('invalid entry for Kmax'); return;
else
   r = l/m;
g=[];
for K = 1:Kmax
sum = 1; term = 1;
for j = 1:K
term = term*r/j;
sum = sum +term;
end;
g=[g c*r*(1 - term/sum) - K*d];
end;
% g(K) is the net revenue of using K lines;
y=g;
plot(g)
end;
