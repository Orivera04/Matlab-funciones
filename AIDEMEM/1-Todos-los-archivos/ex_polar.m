N =22;
t = linspace(0,N*pi,11*N);
r = 10*ones(1,length(t));
r(1:2:end)=r(1:2:end)*2;
polar(t,r);
axis equal