function attract(fun, dfun, intre, intim, res, exact, maxit, abstol, ...
								 escape, plotTitle) 
% ATTRACT   Regions of attraction of Newton iteration for complex
% functions. 
%    ATTRACT(FUN, DFUN, INTRE, INTIM, RES, EXACT, MAXIT, ABSTOL, ESCAPE,
%    PLOTTITLE)   Illustrates the regions of attraction to a local
%    minimizer for a given complex-valued function FUN and its
%    jacobian DFUN. The considered start values are taken
%    equally spaced with resolution RES within the intervals INTRE
%    (the real axis) and INTIM (the imaginary axis). EXACT
%    must contain a list of the actual zeros of the function in the
%    considered box. If the
%    euclidean norm of the function value reaches a value less than
%    ABSTOL, the Newton iteration is successfully
%    terminated. ESCAPE is a skalar indicating the escape 
%    condition, if the euclidean norm of the function value attains
%    a value greater than ESCAPE, the Newton iteration is
%    considered to diverge. MAXIT is an integer denoting the
%    maximum number of iterations to perform for each start
%    value. PLOTTITLE is the title plotted with the graph.

% Authors: Eugen Bubolz, Andreas Klimke (Uni Stuttgart)
% Version: 1.0
% Date   : January 14, 2004

% Initialization
minre = intre(1);
maxre = intre(2);
minim = intim(1);
maxim = intim(2);
nre   = res(1);
nim   = res(2);
M = zeros(nre, nim);
N = M;

disp('Exact roots:');
disp(exact);
disp('Please wait...');

warning off;
for s = 1:nim
	for t = 1:nre
		a = minre+t*(maxre-minre)/nre;
		b = minim+s*(maxim-minim)/nim;
		x = [a;b];
		k = 0;
		y = feval(fun, x);
		
		% Perform Newton iteration
		while norm(y)<escape & norm(y)>abstol & k<maxit
			k = k+1;
			x = x - feval(dfun, x) \ y;
			y = feval(fun, x);
		end
		% Store number of iterations in M
		M(s,t)=k;
		
		% Classify zero found with respect to exact zeros.
		converged = 0;
		for l = 1:size(exact, 1)
			if norm(x-[real(exact(l)); imag(exact(l))])<abstol 
				N(s,t) = l;
				converged = 1;
				break;
			end
		end
		if ~converged
			N(s,t) = size(exact, 1) + 1;
		end
	end
end
warning on;

% Plot results
colormap(hot);
subplot(1,2,1);
imagesc(N);
title(plotTitle);
xlabel('Convergence regions');
set(gca,'Box','on');
set(gca,'XTickLabel', []);
set(gca,'YTickLabel', []);
subplot(1,2,2);
imagesc(M);
title(plotTitle);
xlabel('Number of iterations');
set(gca,'Box','on');
set(gca,'XTickLabel', []);
set(gca,'YTickLabel', []);
colorbar
disp('Done!');
disp(' ');
