function [x, fx, evals, iters, badinds] = newtonraphson(fun, deriv, x0, varargin)
%NEWTONRAPHSON	  		General Newton Raphson root finder
%
%   NEWTONRAPHSON(fun, deriv, x0) returns a root of the function [fun] 
%   near [x0], using a standard Newton-Raphson iteration procedure:
%
%               x_i+1 = x_i - f(x_i) / f'(x_i)
%
%   The general method requires a derivative (f') of the function [fun], 
%   which is given by [deriv]. This argument may be left empty, in which 
%   case the derivative is computed numerically by central differences.
%
%   By default, the function tolerance is set to 1e-6. The tolerance 
%   may also be set manually, by providing a fourth argument, 
%   NEWTONRAPHSON(fun, deriv, x0, tol).
%
%   If the function [fun] is only defined on a certain interval, this 
%   interval may be explicitly given by NEWTONRAPHSON(..., tol, Lb, Ub), 
%   where [Lb] and [Ub] are the lower- and upper boundaries for the 
%   interval. Both [Lb] and [Ub] are (+-)INF by default. If the value for 
%   the trial variable [x] exceeds one of these boundaries during the 
%   iterations, it is forced back into the interval at a location equal to 
%   the distance from the boundary it exceeded (reflection). An error is 
%   produced if such a reflection again brings [x] outside the interval. 
%
%   [x, fval] = NEWTONRAPHSON(..) returns the corresponding function value  
%   at the solution [x].
%
%   [x, fval, evals] = NEWTONRAPHSON(..) also returns the number of
%   function evaluations required. This includes the functions evaluations
%   made of the (given or numerical ) function derivative. 

%   [x, fval, evals, iters] = NEWTONRAPHSON(..) also returns the amount of 
%   iterations that was needed to achieve convergence. This is different
%   from [evals], since [evals] increases 2N every iteration, for 
%   N-dimensional (vectorized) functions, whereas the amount of iterations
%   increases by only 1.
%
%   [..., iters, badinds] = NEWTONRAPHSON(..) returns the indices 
%   of values of [x] that caused function values in [fun] to become 
%   complex-valued, INF or NaN, or caused the derivative to become 0. 
%   In all these cases, the routine terminates and returns NaN 
%   for the corresponding indices in [x].    
%
%   See also regulafalsi, halley, laguerre.


%   Author: Rody P.S. Oldenhuis
%   Delft University of Technology
%   E-mail: oldenhuis@dds.nl
%   Last edited 13/Feb/2009

    % default errortrap
	error(nargchk(3, 6, nargin));
	
	% default parameters
	tol      = 1e-6;
    maxiters = 1e3;
    Lb       = -inf;
    Ub       = +inf;
    
    % initial values
    if isempty(deriv)
        annum = 2;
        analytical = false;
    else
        annum = 1;
        analytical = true;
    end
    
    % parse input parameters	
    if (nargin >= 4), tol = varargin{1};
     if isempty(tol), tol = 1e-6; end,  end
    if (nargin >= 5), Lb  = varargin{2};
     if isempty(Lb),  Lb  = -inf; end,  end
    if (nargin == 6), Ub  = varargin{3};
     if isempty(Ub),  Ub  = +inf; end,  end
    
    % perform Newton-Raphson rootfinding    
    x   = x0;     iters = 0;
    fac = 1e9;  badinds = [];
    evals = 0;
    while true

        % prepare values
        fx    = fun(x);
        if analytical
            dfdx = deriv(x);
        else
            dfdx = (fun(x+fac*eps) - fun(x-fac*eps)) ./ (2*fac*eps);
        end
        
        % exit condition
        if all(abs(fx) < tol)
            break
        end 

        % Derivative might be zero
        if any(dfdx(:) == 0)
            warning('newtonraphson:derivative_zero', ...
                'Derivative reaches zero in given interval.')
            badinds = (dfdx == 0);
            x(badinds) = NaN;
            break
        end

        % Values might be complex
        if any(imag(x(:)) ~= 0) || any(imag(fx(:)) ~= 0)
            warning('newtonraphson:complex_values',...
                    'Calculation yields complex numbers. Exiting...');
            badinds = (imag(x(:)) ~= 0) | (imag(fx(:)) ~= 0);
            x(badinds) = NaN;
            break
        end

        % Values might not be finite
        if any(~isfinite(x(:))) || any(~isfinite(fx(:))) || any(~isfinite(dfdx(:)))
            warning('newtonraphson:not_finite',...
                    'Values not finite. Exiting...');
            badinds = ~isfinite(x(:)) | ~isfinite(fx(:)) | ~isfinite(dfdx(:));
            x(badinds) = NaN;
            break
        end

        % Solution might not converge
        if (iters > maxiters)
            warning('newtonraphson:no_convergence', ...
                    'Solution does not seem to be converging. Exiting...')
            convind = abs(fx) < tol;
            badinds = ~convind;
            x(badinds) = NaN;
            break
        end
        
        % Newton-Raphson        
        x = x - fx ./ dfdx;   
        
        % increase counters
        evals = evals + numel(fx) + annum*numel(dfdx);
        iters = iters + 1;
        
        % check boundaries
        if any(x < Lb)
            x(x < Lb) = Lb + abs(x(x < Lb) - Lb);            
        end
        if any(x > Ub)
            x(x > Ub) = Ub - abs(x(x > Ub) - Ub);
        end
        if any(x < Lb)
            warning('newtonraphson:reflection_unsuccesful',...
                    'Solution could not be kept inside the interval. Exiting...' );
            badinds    = x < Lb;
            x(badinds) = NaN;
            break
        end

    end
end