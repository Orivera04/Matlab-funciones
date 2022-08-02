%% Section 10.7 Problem 4

%% 
% Solve the wave equation with initial value f(x), initial velocity 0, 
% where f(x)=1 if L/2-1<x<L/2+1 and 0 otherwise.  Here, we take L=10, a=1.

syms x k n t

%%
% First we calculate the Fourier sine coefficients of f.

b = @(k) 2*int(sin(k*pi*x/10),x,4,6)/10;

 

%%
% The nth partial sum of the solution is

u = @(x,t,n) symsum(b(k)*sin(k*pi*x/10)*cos(k*pi*t/10),k,1,n);


%%
% Here are some plots of the solution u(x,t) versus x for some fixed values
% of t (taking 100 terms in the series for u).

ezplot(u(x,0,100),[0,10])
title('t=0')
 
%%

ezplot(u(x,5,100),[0,10])
title('t=5')

%%

ezplot(u(x,10,100),[0,10])
title('t=10')

%% 
% Here are some plots of u(x,t) versus t for some fixed values of x.

T = 0:0.01:20;
U = inline(vectorize(u(5,t,100)));
plot(T,U(T))
title('x=5')

%%

ezplot(u(10,t,100),[0,20])
title('x=10')

%%
% Here is a movie of the motion of the string.  

X = 0:0.01:20;
for n = 0:100
    U = inline(vectorize(u(x,n,100)));
    plot(X, U(X)), axis([0,10,-1.5,1.5]);
    M(n+1) = getframe;
end


mplay(M)
