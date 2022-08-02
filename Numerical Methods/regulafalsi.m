function [x, fval, evals, iters, badinds] = regulafalsi(fun, a, b, varargin)
% REGULAFALSI        Regula Falsi (derivative-free) root finding algorithm.
%
%   [x, fsol, evals] = REGULAFALSI(fun, a, b) returns a root of the 
%   function [fun] in the interval [a]-[b]. It returns the location of the
%   root [x], the function value at that point [fsol], and the number of
%   function evaluations [evals] made. Note that the routine requires that 
%   fun(a)*fun(b) < 0, in other words: the function is negative on one end 
%   of the interval, and positive on the other.
%
%   [..., evals, iters] = REGULAFALSI(..) also returns the number of
%   iterations required to achieve convergece. This is only different from
%   [evals] if the function [fun] is vectorized and [x0] is an N-dimensional 
%   vector. In that case, each entry in the new solution [fun(x)] counts as 
%   one function evaluation and thus increases by N every 1 iteration.  
%
%   Error tolerances may be set by hand by calling REGULAFALSI(fun, a, b, 
%   delta, epsilon), where [delta] is the tolerance in the variable, and
%   [epsilon] is the tolerance in the function value near the zero. When
%   both are omitted, both default to (1e-12).
%
%   If the function is only defined on a certain interval, this interval 
%   may be explicitly given by REGULAFALSI(..., delta, epsilon, Lb, Ub), 
%   where [Lb] and [Ub] are the lower- and upper boundaries for the 
%   interval. Both [Lb] and [Ub] are (+-)INF by default. If the value for 
%   the trial variable [x] exceeds one of these boundaries during the 
%   iterations, it is forced back into the interval at a location equal to 
%   the distance from the boundary it exceeded (reflection). An error is 
%   produced if such a reflection again brings [x] outside the interval. 
%
%   [..., iters, badinds] = REGULAFALSI(..) returns the indices of values 
%   of [x] that caused function values in [fun] to become complex-valued, 
%   INF or NaN. In all these cases, the routine terminates and returns NaN 
%   for the corresponding indices in [x].   

%   Author: Rody P.S. Oldenhuis
%   Delft University of Technology
%   E-mail: oldenhuis@dds.nl
%   Last Edited: 13/Feb/2009

    % standard errortrap
    error(nargchk(3, 7, nargin));
    
    % default parameters
    delta    = 1e-12;
    epsilon  = 1e-12;
    maxiters = 1000;
    Lb       = -inf;
    Ub       = +inf;
    
    % extract parameters       
    if (nargin >= 4), delta   = varargin{1}; end
    if (nargin >= 5), epsilon = varargin{2}; end
    if (nargin >= 6), Lb      = varargin{3}; 
           if isempty(Lb), Lb = -inf; end,   end
    if (nargin == 7), Ub      = varargin{4}; 
           if isempty(Ub), Ub = +inf; end,   end
    
    % start the routine    
    fa = feval(fun, a);
    fb = feval(fun, b);
    if any(any( (fa.*fb > 0) ))    
        error('Constraint f(a)*f(b) yields value larger than zero.');
    end
    
    % initial values
    iters = 0;
    dx    = inf;    
    fsol  = inf;
    evals = 2*numel(fa);
    if (size(a, 2) ~= size(fa, 2))
        a = repmat(a, size(fa));
        b = repmat(b, size(fa));       
    end 
    
    % start iteration    
    while any(any( (abs(dx) > delta) & (abs(fval) > epsilon) ))
        
        % make step
        dx = fb .* (b - a)./(fb - fa);       
        x  = b - dx;          
        
        % check boundaries
        if any(x < Lb)
            x(x < Lb) = Lb + abs(x(x < Lb) - Lb);            
        end
        if any(x > Ub)
            x(x > Ub) = Ub - abs(x(x > Ub) - Ub);
        end
        if any(x < Lb)
            warning('regulafalsi:reflection_unsuccesful',...
                    'Solution could not be kept inside the interval. Exiting...' );
            badinds      = x < Lb;
            x(badinds) = NaN;
            break
        end
        
        % evaluate function at new trial location
        fval  = feval(fun, x);
        
        % results may not be finite
        if any(~isfinite(fval))
            warning('regulafalsi:not_finite',...
                    'Values not finite. Exiting...');
            badinds      = ~isfinite(fsol(:));
            x(badinds) = NaN;
            break
        end
        
        % results may be complex-valued
        if any(~isreal(fval))
            warning('regulafalsi:complex',...
                    'Calculation yields complex numbers. Exiting...');
            badinds    = ~isreal(fval(:));
            x(badinds) = NaN;
            break
        end
        
        % solution might not be converging
        if (iters > maxiters)
            warning('regulafalsi:no_convergence',...
                    'Solution does not seem to be converging. Exiting...');            
            break
        end

        % compute new step
        az       = x - a;
        ind1     = (fb.*fval > 0);
        ind2     = ~ind1;          
        b(ind1)  = x(ind1);
        fb(ind1) = fval(ind1);
        a(ind2)  = x(ind2);
        fa(ind2) = fval(ind2);
        dx       = min(abs(dx), az);
        
        % increase counters
        iters = iters + 1;
        evals = evals + numel(fval);
        
    end
end