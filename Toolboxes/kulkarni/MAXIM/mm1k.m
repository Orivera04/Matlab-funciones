function y = mm1k(l,m,K,i);
%y = mm1k(l,m,K,i)
%l arrival rate;
%m service rate m;
%K capacity;
%i = 1 => y = mean number in system,
%i = 2 => y = mean number in queue,
%i = 3 => y = mean waiting time of entering customers,
%i = 4 => y = mean queueing time of entering customers,
%i = 5 => y(j) = P(j-1 in system),
%i = 6 => y(j) = P(entering customer sees j-1 in system).
y='error';
R = ex6ssq(l,m,K);
if R(1,1) ~= 'error'
     yy=ctmcod(R);
   if yy(1,1) ~= 'error'
  switch i

case 1,
   y=yy*[0:K]';

case 2,
   y=yy*[0 0:K-1]';

case 3,
   y =yy*[0:K]'/(l*(1-yy(K+1)));

case 4,
   y =yy*[0 0:K-1]'/(l*(1-yy(K+1)));

case 5,
   y = yy;

case 6'
   y = yy(1:K)/(1-yy(K+1));
otherwise,
msgbox('invalid entry for i');  return;
end;

end;
end;
