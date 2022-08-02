function y = mm1(l,m,i);
%y = mm1(l,m,i)
%l arrival rate;
%m service rate;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time,
%i = 4 => y = mean queueing time,
%i = 5 => y(j) = P(j-1 in system).
if  l < 0 
msgbox('invalid entry for l');y='error'; return;
elseif  m < 0 
msgbox('invalid entry for m'); y='error';return;
else
rho=l/m;
if rho >= 1 
      msgbox('Queue is unstable');y='error';
      return;
      end;

switch i
case 1,
   y=rho/(1-rho);

case 2,
   y=rho^2/(1-rho);

case 3,
   y = 1/(m-l);

case 4,
   y = rho/(m-l);

case 5,
   k=fix((-10 - log(1-rho))/log(rho));
   y=geometricpmf(1-rho,max(k,5));
otherwise,
msgbox('invalid entry for i');y='error';
end;   
end;
