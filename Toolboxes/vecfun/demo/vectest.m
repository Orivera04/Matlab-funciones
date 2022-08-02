%TEST  Tests some vector- and scalar functions

% Copyright (c) 2001-04-13, B. Rasmus Anthin

warns=warning;
warning off;
vecinit
R=scalar([-1 1],'sqrt(x^2+y^2+z^2)')
load fyconst;
V=4*pi*R^2
q=scalar(q);
epsilon_0=scalar(e0);
E=[x y z]/R*q/(epsilon_0*V)

E=setrange(E,[-1 1 5]);
plot(E)

disp('Press any key...')
pause
close all
E=setrange(E,[-1 1 30]); % to avoid singularity in origo.
plot(div(E))

disp('Press any key...')
pause
plot(curl(E),'slice')

warning warns
