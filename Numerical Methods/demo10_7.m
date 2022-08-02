%% Section 10.7 The Wave Equation

%%  A vibrating string
% The following commands create and show
% an animation of the solution of the wave equation 
% $u(x,t) = \sin(5x)\cos(5t),\ 0 < x < \pi,\ 0 < t < 2 \pi$. In the animation, 
% $t = n\pi/50$.

X = 0:0.01:pi;
for n = 0:100
    plot(X, sin(5*X)*cos(n*pi/10)), axis([0,pi,-2,2])
    M(n+1) = getframe;
end

mplay(M,6)


 