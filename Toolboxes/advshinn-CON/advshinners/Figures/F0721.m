num = 23.655; den = [1 -.0345]; t = 0:.5:5;
% The Professional Control Toolbox from MATLAB uses "DSTEP" :
% [y,x] = dstep(num,den,length(t));
[a,b,c,d] = tf2ss(num,den);
u = 1+0*t; u(1) = 0; x = 0*diag(b);
for ii = 2:length(u); x(:,ii) = a*x(:,ii-1)+b*u(:,ii); end;
y = c*x+d*u; x = x.'; y = y.';
axis([0 5 0 30]); plot([1;1]*t,[y*[0 1]]','r-',0,0,'*'); grid; 
axis([0 5 0 30]);
hold on; plot([0 5],24.5*[1 1],'--',[0 5],[25 25],'--'); hold off;
title('Transient Response of Compensated System');
xlabel('t (seconds)'); ylabel('Tc(t)');
text(0,23.5,'  24.5');
hold on; plot([2.2 2.2 2.15 2.2 2.25],[27 25 25.5 25 25.5],'g-'); hold off;
hold on; plot([2.2 2.2 2.15 2.2 2.25],[22.5 24.5 24 24.5 24],'g-'); hold off;
text(2.3,25.5,'Steady-State Error');
