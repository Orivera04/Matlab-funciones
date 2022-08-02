function y = mminf(l,m,i);
%y = mminf(l,m,i)
%l arrival rate;
%m service rate m;
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
else

switch i

case 1,
   y=l/m;

case 2,
   y=0;

case 3,
   y =1/m;

case 4,
   y =0;

case 5,
   k=fix(-15/log(l/m));
   y=poissonpmf(l/m,k);
case 6,
   y = l/m;  
otherwise,
msgbox('invalid entry for i');return;
end;   
end;
