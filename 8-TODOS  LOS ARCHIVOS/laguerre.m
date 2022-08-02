function [x, fx, evals, iters, badinds] = laguerre(fun, dfun, ddfun, x0, n, varargin)
%LAGUERRE    	  		Root finder -- Laguerre's method
%
%   [x, fval] = LAGUERRE(fun, dfun, ddfun, x0, n) returns a root of the 
%   function [fun] near [x0], and its corresponding function value [fval], 
%   using the standard Laguerre iteration procedure. The general method 
%   requires the first two derivatives of the function [fun], which are 
%   given by [dfun] and [ddfun], respectively:
%
%               
%
%   The second derivative (f'') may be left empty, in which case the 
%   derivative is computed numerically by central differences.
%
%   This method is designed to work for polynomials of degree n, which 
%   needs to be provided as the argument [n]. In case the objective 
%   function is not a polynomial, some numerical experimentation is 
%   required to find a "suited" value for [n], since Laguerre's method 
%   almost always converges to *some* root of [fun].
%
%   By default, the function tolerance is set to 1e-6. The tolerance may 
%   also be set manually, by providing a fifth argument; LAGUERRE(fun, 
%   dfun, ddfun, x0, n, tol).
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
%   [x, fx, evals] = LAGUERRE(..) returns te solution [x] and corresponding
%   function value [fx], and the amount of function evaluations required to
%   achieve this result. This includes the function evaluations made of the
%   two derivatives, and increases thus by 3N every iteration, for
%   N-dimensional functions. 
%
%   [..., evals, iters] = LAGUERRE(..) also returns the amount of 
%   iterations that was needed to achieve convergence within [tol]. 
%
%   [..., iters, badinds] = LAGUERRE(..) returns the indices of values of 
%   [x] that caused function values in [fun] to become complex-valued, 
%   INF or NaN, or caused the first derivative to become 0. In all these 
%   cases, the routine terminates and returns NaN for the corresponding 
%   indices in [x].
%
%   See also newtonraphson, regulafalsi, halley.
    
    % default errortrap
	error(nargchk(5, 8, nargin));
	
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
    if (nargin >= 6), tol = varargin{1};
     if isempty(tol), tol = 1e-6; end, end
    if (nargin >= 7), Lb  = varargin{2};
     if isempty(tol), Lb  = -inf; end, end
    if (nargin == 8), Ub  = varargin{3};
     if isempty(tol), Ub  = +inf; end, end 
    
    % perform Laguerre-rootfinding        
    iters = 0;             evals = 0;
    x     = x0;            fac   = 10;
    nm12  = (n - 1).^2;    nnm1  = n*(n-1);
    badinds = [];
    while true
        
        % prepare values
        fx   = feval(fun, x);         
        dfdx = feval(dfun, x);
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
        if any(dfdx == 0 & d2fdx2 == 0)
            warning('laguerre:derivative_zero',...
                'Both derivatives reach zero for given interval.');
            badinds = (dfdx == 0 && d2fdx2 == 0);
            x(badinds) = NaN;
            break
        end

        % Values might be complex
        if any(imag(x(:)) ~= 0) || any(imag(fx(:)) ~= 0)
            warning('laguerre:complex_values',...
                'Calculation yields complex numbers. Exiting...');
            badinds = (imag(x) ~= 0) | any(imag(fx(:)) ~= 0);
            x(badinds) = NaN;
            break
        end

        % Values might not be finite
        if any(~isfinite(x(:)))    || any(~isfinite(fx(:))) ...
        || any(~isfinite(dfdx(:))) || any(~isfinite(d2fdx2(:))); 
            warning('laguerre:values_not_finite',...
                'Values not finite. Exiting...');
            badinds = ~isfinite(x)    | ~isfinite(fx(:)) ...
                    | ~isfinite(dfdx(:)) | ~isfinite(d2fdx2(:)); 
            x(badinds) = NaN;
            break
        end

        % Solution might not be converging
        if (iters > maxiters)
            warning('laguerre:no_convergence', ...
                'Solution does not seem to be converging. Exiting...');
            convind = abs(fx) < tol;
            badinds = ~convind;
            x(badinds) = NaN;
            break
        end  
        
        % Laguerre's method
        x = x - n*fx ./ (dfdx + sign(dfdx).*sqrt(abs(nm12*dfdx.^2 - nnm1*fx.*d2fdx2)));        
        
        % increase counters
        evals = fevals + numel(fx) + numel(dfdx) + annum*numel(d2dfdx2);
        iters = iters + 1;
        
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