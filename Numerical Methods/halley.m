function [x, fx, evals, iters, badinds] = halley(fun, dfun, ddfun, x0, varargin)
%HALLEY    	  		Root finder -- Halley's method
%
%   HALLEY(fun, dfun, ddfun, x0) returns a root of the function [fun] near 
%   [x0], using the standard Halley iteration procedure. The general method 
%   requires the first two derivatives of the function [fun], which are 
%   given by [dfun] and [ddfun], respectively:
%
%               x_i+1 = x_i - 2*f(x_i)*f'(x) / (2*f'(x)^2 - f(x)*f''(x));   
%
%   The second derivative (f'') may be left empty, in which case the 
%   derivative is computed numerically by central differences.
%
%   By default, the function tolerance is set to 1e-6. The tolerance may 
%   also be set manually, by providing a fifth argument, as in
%   HALLEY(fun, dfun, ddfun, x0, tol).
%
%   If the function [fun] is only defined on a certain interval, this 
%   interval may be explicitly given by LAGUERRE(..., tol, Lb, Ub), 
%   where [Lb] and [Ub] are the lower- and upper boundaries for the 
%   interval. Both [Lb] and [Ub] are (+-)INF by default. If the value for 
%   the trial variable [x] exceeds one of these boundaries during the 
%   iterations, it is forced back into the interval at a location equal to 
%   the distance from the boundary it exceeded (reflection). An error is 
%   produced if such a reflection again brings [x] outside the interval.
%
%   [x, fx, evals] = HALLEY(..) returns te solution [x] and corresponding
%   function value [fx], and the amount of function evaluations required to
%   achieve this result. This includes the function evaluations made of the
%   two derivatives, and increases thus by 3N every iteration, for
%   N-dimensional functions. 
%
%   [..., evals, iters] = HALLEY(..) also returns the amount of iterations 
%   that was needed to achieve convergence within [tol]. 
%
%   [..., iters, badinds] = HALLEY(..) returns the indices of values of [x] that caused 
%   function values in [fun] to become complex-valued, INF or NaN, or caused the first
%   derivative to become 0. In all these cases, the routine terminates and returns NaN for
%   the corresponding indices in [x].
%
%   See also newtonraphson, regulafalsi, laguerre.

%   Author: Rody P.S. Oldenhuis
%   Delft University of Technology
%   E-mail: oldenhuis@dds.nl
%   Last edited 13/Dec/2008

    % default errortrap
	error(nargchk(4, 7, nargin));
	
	% default parameters
	tol      = 1e-6;
    maxiters = 1e3;    
    Lb       = -inf;
    Ub       = +inf;
    
    % initial values
    if isempty(ddfun)
        annum = 2;
        analytical = false;
    else
        annum = 1;
        analytical = true;
    end
    
    % parse input parameters	
    if (nargin >= 5), tol = varargin{1};
     if isempty(tol), tol = 1e-6; end,   end
    if (nargin >= 6), Lb  = varargin{2};
     if isempty(tol), Lb  = -inf; end,   end
    if (nargin >= 7), Ub  = varargin{3};
     if isempty(tol), Ub  = +inf; end,   end
    
    % perform Halley-rootfinding        
    iters = 0;  evals   = 0;
    x   = x0;   badinds = [];
    fac = 10;
    while true

        % prepare values
        fx   = fun(x);         
        dfdx = dfun(x);
        if analytical
            d2fdx2 = feval(ddfun, x);  
        else
            d2fdx2 = (feval(dfun, x+fac*eps) - feval(dfun, x-fac*eps)) ./ (2*fac*eps);
        end    
        
        % exit condition
        if all(abs(fx) < tol)
            break
        end   
        
        % Derivatives might be zero
        if any(dfdx == 0) 
            warning('halley:derivativezero',...
                'Derivative reaches zero for given interval.');
            badinds = (dfdx == 0);
            x(badinds) = NaN;
            break
        end

        % Values might be complex
        if any(imag(x(:)) ~= 0) || any(imag(fx(:)) ~= 0)
            warning('halley:complex',...
                'Calculation yields complex numbers. Exiting...');
            badinds = (imag(x) ~= 0) | any(imag(fx(:)) ~= 0);
            x(badinds) = NaN;
            break
        end

        % Values might not be finite
        if any(~isfinite(x(:)))    || any(~isfinite(fx(:))) ...
        || any(~isfinite(dfdx(:))) || any(~isfinite(d2fdx2(:))); 
            warning('halley:complex',...
                'Values not finite. Exiting...');
            badinds = ~isfinite(x)       | ~isfinite(fx(:)) ...
                    | ~isfinite(dfdx(:)) | ~isfinite(d2fdx2(:)); 
            x(badinds) = NaN;
            break
        end

        % Solution might not be converging
        if (iters > maxiters)
            warning('halley:noconvergence', ...
                'Solution does not seem to be converging. Exiting...');
            convind = abs(fx) < tol;
            badinds = ~convind;
            x(badinds) = NaN;
            break
        end
        
        % Halley's method
        x  = x - 2*fx.*dfdx ./ (2*dfdx.^2 - fx.*d2fdx2);     
        
        % increase counters
        iters = iters + 1;
        evals = evals + numel(fx) + numel(dfdx) + annum*numel(d2fdx2);
        
        % check boundaries
        if any(x < Lb)
            x(x < Lb) = Lb + abs(x(x < Lb) - Lb);            
        end
        if any(x > Ub)
            x(x > Ub) = Ub - abs(x(x > Ub) - Ub);
        end
        if any(x < Lb)
            warning('laguerre:reflection_unsuccesful',...
                    'Solution could not be kept inside the interval. Exiting...' );
            badinds    = x < Lb;
            x(badinds) = NaN;
            break
        end

    end
    
end