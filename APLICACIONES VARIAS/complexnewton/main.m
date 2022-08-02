% MAIN   Script file plotting regions of attraction and speed of
% convergence for several complex-valued functions. 

% Authors: Eugen Bubolz, Andreas Klimke (Uni Stuttgart)
% Version: 1.0
% Date   : January 14, 2004


f  = {'f1', 'f2', 'f4', 'f5', 'f6', 'f7'};
df = {'d1', 'd2', 'd4', 'd5', 'd6', 'd7'};
fstrings = {'f(z) = z^2+1, [-2 2]x[-1 1]', ...
						'f(z) = z^3+i, [-1 1]x[-1 1]', ...
						'f(z) = z^5+i, [-0.5 0.5]x[-0.5 0.5]', ...
						'f(z) = 2iz^4-3z^3+2z-i, [-2 2]x[-2 2]', ...
						'f(z) = iz^4-2iz+1, [-2 2]x[-2 2]', ...
						'f(z) = 5z^3-3iz^2+6, [-2 2]x[-2 2]', ...
					 };

intre = {[-2 2], [-1 1], [-0.5 0.5], [-2 2], [-2 2], [-2 2]};
intim = {[-2 2], [-1 1], [-0.5 0.5], [-2 2], [-2 2], [-2 2]};

exactZeros = {...
		roots([1 0 1]), roots([1 0 0 i]), roots([1 0 0 0 0 i]), ...
		roots([2*i -3 0 2 -i]), roots([i 0 0 -2*i 1]), ...
		roots([5 -3*i 0 6])};

res = [200; 200];
maxit = 30;
abstol = 1e-2;
escape = 1e40;

done = 0;
while done ~= 1
	k = menu('Please choose a function:', ...
					 fstrings{:} , 'Exit');
	if k <= length(fstrings)
		attract(f{k},df{k},intre{k},intim{k},res,exactZeros{k},maxit, ...
						abstol,escape,fstrings{k});  
	else
		done = 1;
	end
end
close all;