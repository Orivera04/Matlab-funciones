num = [1 0.2];
den = [1 -1];
%
zeta = 0.7; theta = 36;
z = exp(theta*pi/180*(sqrt(-1)-tan(asin(zeta))));
a = polyval(num,z); b = -polyval(den,z)*[1 z];
c = roots(real(b)*imag(a)-imag(b)*real(a));
k = polyval(real(b),c)/real(a);
den = conv(den,[1  c]);
%
if ( exist('cloop') ) % MATLABs' Control System Toolbox
  eval('[n,d] = cloop(k*num,den,-1);');
else
  n = k*num; d = poly_add(den,k*num); 
end;
t = (1:21)-1;
if ( exist('dstep') ) % MATLABs' Control System Toolbox
  eval('[y,x] = dstep(n,d,length(t));');
else
  [aa,bb,cc,dd] = tf2ss(n,d);
  u = 1+0*t; u(1) = 0; x = 0*diag(aa);
  for ii = 2:length(u); x(:,ii) = aa*x(:,ii-1)+bb*u(:,ii); end;
  y = cc*x+dd*u; x = x.'; y = y.';
end;
stairs(t,y); grid;
xlabel('Time (seconds)'); ylabel('Amplitude');
title('Closed Loop response to a Unit Step');
