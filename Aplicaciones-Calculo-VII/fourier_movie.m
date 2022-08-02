function fsm = fourier_movie(f,x,a,b,n)

% This animates the first n partial sums of the Fourier series of the 
% symbolic expression f(x) on the interval [a,b].  The function is assumed 
% to be periodic with period L = b-a.
L = (b-a);
X = a:0.001:b;
g = inline(vectorize(f));

partsum = 1/L * double(int(f,x,a,b));
for k =1:n 
    partsum = partsum ...
        + 2/L*double(int(f*sin(2*k*pi*x/L),x,a,b))*sin(2*k*pi*x/L) ... 
        + 2/L*double(int(f*cos(2*k*pi*x/L),x,a,b))*cos(2*k*pi*x/L);
    ps2 = inline(vectorize(partsum));
    plot(X,g(X),'r'); hold on
    plot(X,ps2(X)); hold off
    fsm(k) = getframe;
end


