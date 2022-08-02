% mm2609.m
x = linspace(0,2*pi,30);
y = sin(x);
z = cos(x);
a = 2*sin(x).*cos(x);
b = sin(x)./(cos(x)+eps); 
subplot(2,2,1) % pick the upper left of a 2-by-2 grid of subplots
plot(x,y), axis([0 2*pi -1 1]), title('Figure 26.9a: sin(x)') 
subplot(2,2,2) % pick the upper right of the 4 subplots
plot(x,z), axis([0 2*pi -1 1]), title('Figure 26.9b: cos(x)') 
subplot(2,2,3) % pick the lower left of the 4 subplots
plot(x,a), axis([0 2*pi -1 1]), title('Figure 26.9c: 2sin(x)cos(x)') 
subplot(2,2,4) % pick the lower right of the 4 subplots
plot(x,b), axis([0 2*pi -20 20]), title('Figure 26.9d: sin(x)/cos(x)') 