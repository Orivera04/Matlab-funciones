
%% USING MATLAB TO SOLVE A HIGHER ORDER ODE

%%
% Here is an example of using MATLAB to solve an inhomogeneous higher order
% differential equation.  The equation is:
%%
% 
% $$y^{iv} \mbox{--} 2 y'' + y' = t^3 + 2e^t.$$
% 


eqn = 'D4y - 2*D2y + Dy = t^3 +2*exp(t)'

%%
% The notation *D4y* means the 4th derivative of |y|, *Dky* means the
% kth derivative (where k is a positive integer).
%%
% I can solve this equation with the command *dsolve*.  I'll call the solution
% _sol_. I'll supress printing it, because the answer will give too long a 
% line, then use the command *pretty* to print it, which will make it fit
% reasonably.  
sol = dsolve(eqn);
pretty(sol)

%%
% In this case, the answer appears much too complicated.  The next thing to
% try is *simplify*.  

pretty(simplify(sol))

%%
% I can also try *simple*.

pretty(simple(sol))

%%
% This has the terms in a different order from the previous answer but
% isn't simpler. 
%%
% Notice that the equation is fourth order and the solution depends on 4 
% constants, C7, C8, C9 and C10.
