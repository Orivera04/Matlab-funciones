function y = mms(l,m,s,i);
%y = mms(l,m,s,i)
%l arrival rate;
%m service rate m;
%s number of servers;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time,
%i = 4 => y = mean queueing time,
%i = 5 => y(j) = P(j-1 in system),
%i = 6 => y = mean number of busy servers.
y='error';
if  l < 0 
msgbox('invalid entry for l'); return;
elseif  m < 0 
msgbox('invalid entry for m'); return;
elseif  s < 0 | s - fix(s) ~= 0 
msgbox('invalid entry for s'); return;
else

rho = l/(s*m);
if rho >= 1
msgbox('Queue is unstable'); return;
end;
yy=exp(l/m)*poissonpmf(l/m,s);
normf = sum(yy(1:s)) + yy(s+1)/(1-rho);
yy=yy/normf;
switch i

case 1,
   y=l/m + yy(s+1)*rho/(1-rho)^2;

case 2,
   y=yy(s+1)*rho/(1-rho)^2;

case 3,
   y =1/m + yy(s+1)/(s*m*(1-rho)^2);

case 4,
   y = yy(s+1)/(s*m*(1-rho)^2);

case 5,
   k=max(s,fix((-10-log(yy(s+1)))/log(rho)));
   y=[yy(1:s) yy(s+1)*rho.^[0:max(0,k-s)] ];
case 6,
   y = l/m;  
otherwise,
msgbox('invalid entry for i');
end;   
end;
