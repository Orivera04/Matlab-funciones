% From P 10.27A :
n = 3*[-.05960146 -.523188312 3.0463766]; d = [1 3.0463766 0];
BW = 3.813521778;
%
alpha = 2; beta = .53177;  % desired compemsation
k = sqrt((1+(BW*beta)^2)/(1+(BW*alpha)^2)); % BW limitation on mag.
n = k*conv([alpha 1],n); d = conv([beta 1],d);
%
w = logspace(-1,2);
[mag,ph] = bode(n,d,w); mag = 20*log10(mag);
[Gm,Pm,Wcg,Wcp] = margins(n,d); Gm = 20*log10(Gm);
ii = find(Wcg < 1e5); Gm = Gm(ii); Wcg = Wcg(ii); % reasonableness
%
clf; hold off; sbplot(211);
semilogx(w,mag); grid; frz_axis; hold on;
xlabel('Frequency (radians)'); ylabel('Gain (db)');
semilogx(Wcg,-Gm,'*b');
semilogx([w(1) Wcg Wcg],-[Gm Gm 100],'--');
text(Wcg,-Gm,[' G.M. = ' num2str(Gm) ' db @ W = ' num2str(Wcg)]);
[nn,dd] = polysbst(n,d,[sqrt(-1) 0],1);
BW = polymag(nn,dd,10^(-3/20));  % check BW from new polynomial
BW = BW(find(real(BW) > 0));  % positive frequencies only
BW = BW(find(100*abs(real(BW)) > abs(imag(BW)))); BW = real(BW);
semilogx(BW,-3+0*BW,'*g');
text(BW,-3,[' Gain = -3 db @ W = ' num2str(BW)]);
hold off; sbplot(212);
semilogx(w,ph); grid; frz_axis; hold on;
xlabel('Frequency (radians)'); ylabel('Phase (Degrees)');
semilogx(Wcp,Pm-180,'*b');
semilogx([w(1) Wcp Wcp],[Pm Pm -900]-180,'--');
text(Wcp,Pm-180,[' P.M. = ' num2str(Pm) ' deg. @ W=' num2str(Wcp)]);
hold off;
