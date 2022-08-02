num = 1; den = [1 0.5]; dt = 1;
tmax = 20; r = [1 1 1]; r = [r zeros(1,tmax-length(r)+1)];
if ( exist('c2dm') ) % MATLABs' Control System Toolbox
  eval('[n,d] = c2dm(num,den,dt,''zoh'');');
else
  n = (den(1)*num/den(2))*(1-exp(-den(2)*dt));
  d = [1 -exp(-den(2)*dt)];
end;
if ( exist('dlsim') ) % MATLABs' Control System Toolbox
  eval('[c,x] = dlsim(n,d,r);');
else
  [a,b,c,dd] = tf2ss(n,d);
  x = 0*diag(a);
  for ii = 2:length(r); x(:,ii) = a*x(:,ii-1)+b*r(:,ii); end;
  y = c*x+dd*r; x = x.'; c = y.';
end;
clf; hold off; sbplot(211);
axis([0 20 -1 3]); plot(0:tmax,r,'o'),grid;  axis([0 20 -1 3]);
title('Input { r(t) }');
xlabel('Time (seconds)'); ylabel('Amplitude');
r(3) = 0; hold on; stairs(0:tmax,r); hold off;
sbplot(212);
stairs(0:tmax,c); grid; title('Output { c*(t) }');
xlabel('Time (seconds)'); ylabel('Amplitude');
