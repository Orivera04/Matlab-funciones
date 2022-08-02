num = 3; den = [.25 1 0]; t = 0.5;
if ( exist('c2dm') & exist('d2cm') ) % MATLABs' Control System Toolbox
  eval('[n,d] = c2dm(num,den,t,''zoh'');');  % Convert from S to Z
  eval('[n,d] = d2cm(n,d,t,''tustin'');');   % Convert from Z to W
else
  % The Student version requires manual method look-up.
  % In the form of k*a/(s*(s+a)), converting to the Z domain :
  k = num/den(2); a = den(2)/den(1);
  b = (1-exp(-a*t)-a*t*exp(-a*t))/(a*t-1+exp(-a*t));
  n = [1 b]*k*(a*t-1+exp(-a*t))/a;
  d = conv([1 -1],[1 -exp(-a*t)]);
  % Tustins method is simply polynomial substitution
  [n,d] = polysbst(n,d,[t/2 1],[-t/2 1]); % Convert from Z to W
end;
%
w = logspace(-1,2);
[mag,ph] = bode(n,d,w); mag = 20*log10(mag);
[Gm,Pm,Wcg,Wcp] = margins(n,d); Gm = 20*log10(Gm);
ii = find(Wcg < 1e5); Gm = Gm(ii); Wcg = Wcg(ii); % reasonableness
%
clf; hold off; sbplot(211);
semilogx(w,mag); grid;
xlabel('Frequency (radians)'); ylabel('Gain (db)');
hold on; semilogx(Wcg,-Gm,'*b'); hold off;
hold on; semilogx([w(1) Wcg Wcg],-[Gm Gm 20],'--'); hold off;
text(Wcg,-Gm,[' G.M. = ' num2str(Gm) ' db @ W = ' num2str(Wcg)]);
[nn,dd] = polysbst(n,d,[sqrt(-1) 0],1);
BW = polymag(nn,dd,10^(-3/20));
BW = BW(find(real(BW) > 0));  % positive frequencies only
BW = BW(find(100*abs(real(BW)) > abs(imag(BW)))); BW = real(BW);
hold on; semilogx(BW,-3+0*BW,'*g'); hold off;
text(BW,-3,[' Gain = -3 db @ W = ' num2str(BW)]);
%
hold off; sbplot(212);
axis([-1 2 -200 -50]); semilogx(w,ph); grid;
xlabel('Frequency (radians)'); ylabel('Phase (Degrees)');
hold on; semilogx(Wcp,Pm-180,'*b'); hold off;
hold on; semilogx([w(1) Wcp Wcp],[Pm Pm -900]-180,'--'); hold off;
text(Wcp,Pm-180,[' P.M. = ' num2str(Pm) ' deg. @ W=' num2str(Wcp)]);
frz_axis([-1 2 -200 -50],1);
