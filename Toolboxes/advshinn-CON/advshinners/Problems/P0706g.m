num = 292*[0.685 1]; den = conv(conv([1 1],[1 1]),[1 22 149]);
den = poly_add(den,num);  % closed loop system (negative feedback)
t = linspace(0,5,200); y = step(num,den,t);
plot(t,y,'-'); grid;
xlabel('TIME (t)'); ylabel('C(t)');
