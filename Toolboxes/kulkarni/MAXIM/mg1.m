function y = mg1(l,m,s2,i);
%y = mg1(l,m,s2,i)
%l arrival rate;
%m mean service time;
%s2 variance of the service time;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time,
%i = 4 => y = mean queueing time,
%i = 5 => y = p(sever busy).
y='error';
if  l < 0 
msgbox('invalid entry for l'); return;
elseif  m < 0 
msgbox('invalid entry for m'); return;
elseif l*m >= 1
msgbox('Queue is unstable'); return;
elseif  s2 < 0 
msgbox('invalid entry for s2'); return;
else
rho = l*m;
switch i

case 1,
   y=rho + .5*l^2*(s2+m^2)/(1-rho);

case 2,
   y=.5*l^2*(s2+m^2)/(1-rho);

case 3,
   y = m+ .5*l*(s2+m^2)/(1-rho);

case 4,
   y = .5*l*(s2+m^2)/(1-rho);

case 5,
   y=rho;
  
otherwise,
msgbox('invalid entry for i');return;
end;   
end;
