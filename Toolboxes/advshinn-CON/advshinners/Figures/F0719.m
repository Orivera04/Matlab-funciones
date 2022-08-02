num = 30.7; den = [1 -.724];
t = [0:.5:100]; n = [1:11 13:2:29 31:5:201];
% The Professional Control Toolbox from MATLAB uses "DSTEP" :
% [y,x] = dstep(num,den,length(t));
[a,b,c,d] = tf2ss(num,den);
u = 1+0*t; u(1) = 0; x = 0*diag(b);
for ii = 2:length(u); x(:,ii) = a*x(:,ii-1)+b*u(:,ii); end;
y = c*x+d*u; x = x.'; y = y.';
axis([0 100 0 265]);
plot([1;1]*t(n),[y(n)*[0 1]]','r-',0,y(1),'*'); grid; 
axis([0 100 0 265]);
hold on; plot([0 100],[111.112*[1;1] 250*[1;1]],'--'); hold off;
title('Transient Response of Uncompensated System');
xlabel('t (seconds)'); ylabel('Tc(t)');
text(0,112,'  111.112');
text(40,180,'Steady - State Error');
hold on; plot(50+[0 0 -3 0 3],[190 248 238 248 238]); hold off;
hold on; plot(50+[0 0 -3 0 3],[178 112 122 112 122]); hold off;
