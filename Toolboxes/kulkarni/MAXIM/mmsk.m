function y = mmsk(l,m,s,K,i);
%y = mmsk(l,m,s,K,i)
%l arrival rate;
%m service rate m;
%s number of servers;
%K capacity;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time of entering customers,
%i = 4 => y = mean queueing time of entering customers,
%i = 5 => y(j) = P(j-1 in system),
%i = 6 => y(j) = P(entering customer sees j-1 in system),
%i = 7 => y = mean number of busy servers,
%i = 8 => y = P(an arriving customer has to wait).
y='error';
R = ex6cc(l,m,s,K-s);
if R(1,1)~= 'error'
   yy=ctmcod(R);
   if yy(1,1) ~= 'error'
switch i

case 1,
   y=yy*[0:K]';

case 2,
   y=yy(s+1:K+1)*[0:K-s]';

case 3,
   y =yy*[0:K]'/(l*(1-yy(K+1)));

case 4,
   y =yy(s+1:K+1)*[0:K-s]'/(l*(1-yy(K+1)));

case 5,
   y = yy;

case 6,
   y = yy(1:K)/(1-yy(K+1));

case 7,
   y = l*(1-yy(K+1))/m;

case 8,
   y = yy*[0*ones(1,s) ones(1,K-s+1)]';
otherwise,
msgbox('invalid entry for i');
end;   
end;
end;