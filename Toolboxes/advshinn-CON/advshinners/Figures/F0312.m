if exist('solve')
  s1 = 'K = 72'
  s2 = 'K*h4 + 1 = 1'
  s3 = 'K*(h3 + 13*h4) + (11 + a) = 26.4'
  s4 = 'K*(h2 + 12*h3 + 32*h4) + (10 + 11*a) = 180.4'
  s5 = 'K*(h1 + 2*h2 + 20*h3 + 20*h4) + 10*a = 229'
  s6 = '2*K*h1 = 144'
  eval('[K,a,h1,h2,h3,h4] = solve(s1,s2,s3,s4,s5,s6,''K,h1,h2,h3,h4,a'')');
  K = eval('numeric(K)');
  h1 = eval('numeric(h1)');
  h2 = eval('numeric(h2)');
  h3 = eval('numeric(h3)');
  h4 = eval('numeric(h4)');
  a = eval('numeric(a)');
else
  K = 72;
  h1 = 1;
  h2 = .0121;
  h3 = .0017;
  h4 = 0;
  a = 15.28;
end;
h = poly_add(poly_add(h1,[h2 0]),poly_add(h3*[1 10 0],h4*[1 11 10 0]));
num = conv([1 2],h);
den = conv(conv([1 0],[1 a]),conv([1 10],[1 1]));
[kbreak,sbreak] = rlpoba(num,den);
kk = [0 logspace(log10(kbreak),5) 1e+8];
rr = rlocus(num,den,kk);
frz_axis([-20 5 -30 30]);
plot(real(rr),imag(rr),'-'); grid; frz_axis([-20 5 -30 30]);
xlabel('Real Axis'); ylabel('Imaginary Axis');
zz = roots(num); pp = roots(den);
hold on; plot(real(zz),imag(zz),'o',real(pp),imag(pp),'x'); hold off;
[k45,s45] = rootangl(num,den,135);
hold on; plot(real(s45),imag(s45),'*'); hold off;
text(real(s45),imag(s45),[' K = ' num2str(k45)]);
