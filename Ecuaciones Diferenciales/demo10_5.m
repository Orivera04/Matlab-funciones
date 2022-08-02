%% Graph of Solution of the Heat Equation

%%
% I will graph the solution of $u_{xx} = u_t$ for $x \in (0,1),\  0 < t$ with 
% $u(0, t) = 0$ and $u(1, t) = 0$ for $0 < t$ and $u(x,0) = \sin(2 \pi
% x)\,\mbox{--}\,\sin(5\pi x)$
% for x in [0,1].  The solution is
% 
% $$ u = e^{\,\mbox{--}\,4\pi ^2t}\sin(2\pi x) \,\mbox{--}\, 
% e^{\,\mbox{--}\,25\pi^2t}\sin(5\pi x) $$
% 
  
%%
x = linspace(0,1,50); t = linspace(0,0.05,50); [X,T]= meshgrid(x,t);

%%
u = exp(-4.*pi.^2.*T).*sin(2.*pi.*X) - exp(-25.*pi.^2.*T).*sin(5.*pi.*X) ;


%%
surf(T,X,u)
view(-14,32)
xlabel('t'), ylabel('x'), zlabel('u')
title('Solution of the heat equation')
