function y = gm1(l,m,a,i);
%y = gm1(l,m,a,i)
%l arrival rate;
%m service rate;
%a solution to the functional equation;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time,
%i = 4 => y = mean queueing time,
%i = 5 => y(j) = p(j-1 customers in the system),
%i = 6 => y(j) = p(arrival sees j-1 customers in the system).
y='error';
if  l < 0 
msgbox('invalid entry for l'); return;
elseif  m < 0 
msgbox('invalid entry for m'); return;
elseif l >= m
msgbox('Queue is unstable'); return;
elseif  a < 0 | a >= 1
msgbox('invalid entry for a'); return;
else
rho = l/m;
switch i

case 1,
   y=rho/(1-a);

case 2,
   y=rho*a/(1-a);

case 3,
   y = 1/(m*(1-a));

case 4,
   y = a/(m*(1-a));

case 5,
   k=fix((-10-log(1-a))/log(a));
   y=[1-rho rho*geometricpmf(1-a,k)];

case 6,
   k=fix((-10 - log(1-a))/log(a));
   y=geometricpmf(1-a,k);
otherwise,
   msgbox('invalid entry for i');return;
end;   
end;
