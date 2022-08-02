function sol = dde23(ddes,lags,history,tspan,options,varargin)
%DDE23   Solve delay differential equations (DDEs) with constant delays.
%   SOL = DDE23('F',LAGS,HISTORY,TSPAN) integrates the system of DDEs
%   y'(t) = f(t,y(t),y(t - tau_1),...,y(t - tau_k)). The constant delays 
%   tau_1,...,tau_k are input as the vector LAGS. The equations are 
%   integrated from T0 to TF where T0 < TF and TSPAN = [T0 TF]. The 
%   solution at T < T0 is specified by HISTORY.  If it is a constant
%   (column vector), HISTORY can be this vector.  If it is not constant,
%   HISTORY is the name of a function that evaluates the solution at T 
%   and returns it as a column vector.  DDES is the name of a function of
%   the form YP = F(T,Y,Z) for evaluating the DDEs.  Here T is the current 
%   value t of the independent variable, the column vector Y approximates 
%   y(t), and Z(:,j) approximates y(t - tau_j) for delay tau_j = LAGS(J).  
%   YP is the column vector y'(t).  
%
%   The solution is returned by DDE23 as a structure SOL.  Row K of the
%   field SOL.Y, i.e., SOL.Y(K,:), is component K of the solution at times
%   returned in the field SOL.X.  (SOL.X and SOL.Y correspond to T and Y 
%   as returned by [T,Y] = ODE23(... ).)  Using SOL and the auxiliary 
%   function DDEVAL, the solution Y and optionally its first derivative YP
%   can be obtained at an array of times T in the interval [T0 TF] by  
%   [Y, YP] = DDEVAL(SOL,T). Generally the fields SOL.X and SOL.Y provide 
%   a smooth graph, but when they do not, a smooth graph can always be 
%   obtained by evaluating the solution at enough points using DDEVAL.
%
%   SOL = DDE23('F',LAGS,HISTORY,TSPAN,OPTIONS) solves as above with default
%   parameters replaced by values in OPTIONS, an argument created with the 
%   auxiliary function DDESET.  See DDESET for details.  Commonly used options
%   are scalar relative error tolerance 'RelTol' (1e-3 by default) and vector 
%   of absolute error tolerances 'AbsTol' (all components 1e-6 by default).
%
%   DDE23 can solve problems with discontinuities in the solution prior to 
%   T0 (the history) or discontinuities in coefficients of the equations at 
%   known values of t after T0 if the locations of these discontinuites are 
%   provided in a vector as the value of the 'Jumps' option. 
%
%   DDE23 can find where functions g(t,y(t),y(t - tau_1),...,y(t - tau_k))
%   vanish.  These event functions are all evaluated in a function of the
%   form [VALUE,ISTERMINAL,DIRECTION] = G(T,Y,Z).  The name of this 
%   function is provided as the value of the 'Events' option.  The input 
%   arguments are as for the DDES function.  VALUE(K) is the value of the 
%   Kth event function. ISTERMINAL(K) = 1 if the integration is to terminate 
%   at a zero of this event function and 0 otherwise. DIRECTION(K) = 0 if all
%   zeros of this event function are to be computed, +1 if  only zeros where 
%   the event function is increasing, and -1 if only zeros where the event 
%   function is decreasing. On return from DDE23, the field SOL.XE contains 
%   the locations of all events (times when an event function vanished), 
%   SOL.YE contains the solutions there, and SOL.IE contains the index of 
%   the event function that vanished.
%   
%   SOL = DDE23('F',LAGS,HISTORY,TSPAN,OPTIONS,P1,P2,...) passes the 
%   additional parameters P1,P2,... to the DDES function as 
%   F(T,Y,Z,P1,P2,...) and similarly to the HISTORY and EVENTS functions
%   if they are present.  Use OPTIONS = [] as a place holder if no options 
%   are set.
%
%   The tutorial "Solving Delay Differential Equations with DDE23"  includes 
%   a brief discussion of DDEs, a brief discussion of the numerical methods 
%   used by DDE23, complete solutions of many examples from the literature 
%   that illustrate how to use DDE23, and some exercises (with solutions).

%   DDE23 was written by L.F. Shampine and S. Thompson.  A detailed 
%   discussion of the numerical methods used by DDE23 can be found in 
%   "Solving DDEs in Matlab" by L.F. Shampine and S. Thompson.
%
%   Copyright (c) 2000-2014 by L.F. Shampine and S. Thompson.

if nargin < 4
   error('Must specify DDEs, lags, history, and tspan.');
elseif nargin == 4
   options = [];
end

true = 1;
false = ~true;

% Initialize statistics.
nsteps = 0;             
nfailed = 0;            
nfevals = 0;                           

t0 = tspan(1);
tfinal = tspan(end);   % Ignore all entries of tspan except first and last.
if tfinal <= t0
   error('Must have tspan(1) < tspan(end).')
end

if isnumeric(history)
   temp = history;
   sol.history = history;
elseif isstruct(history)
   if history.x(end) ~= t0
     error('Must continue from last point reached.')
   end
   temp = history.y(:,end);
   sol.history = history.history;
else
   temp = feval(history,t0,varargin{:});
   sol.history = history;
end 
y0 = temp(:);
maxlevel = 4;
initialy = ddeget(options,'InitialY',[]);
if ~isempty(initialy)
   y0 = initialy(:);
   maxlevel = 5;
end

t = t0;
y = y0;
neq = length(y);

% If solving a DDE, locate potential discontinuities. We need to step to 
% each of the points of potential lack of smoothness. Because we start at 
% t0, we can remove it from discont.  The solver always steps to tfinal, 
% so it is convenient to add it to discont.
if isempty(lags)
   discont = tfinal;
   minlag = Inf;
else
   lags = lags(:)';
   minlag = min(lags);
   if minlag <= 0
      error('The lags must all be positive.')
   end
   if isstruct(history)
     vl = history.discont;
   else
     vl = t0;
   end
   jumps = ddeget(options,'Jumps',[]);
   if ~isempty(jumps)
      if any(jumps < t0) & ~isstruct(history)
         maxlevel = 5;
      end
      % Restrict to tspan.
      jumps = jumps(:)';
      indices = find(jumps <= tfinal);
      vl = [vl jumps(indices)];
   end
   discont = vl;
   for level = 2:maxlevel
      vlp1 = vl(1) + lags;
      for i = 2:length(vl)
         vlp1 = [vlp1 (vl(i)+lags)];
      end
      % Restrict to tspan.
      indices = find(vlp1 <= tfinal);
      vl = vlp1(indices);
      if isempty(vl)
         break;
      end
      nvl = length(vl);
      if nvl > 1
         % Purge duplicates in vl.
         vl = sort(vl);
         indices = find(abs(diff(vl)) <= 10*eps*abs(vl(1:nvl-1))) + 1;
         vl(indices) = [];
      end
      discont = [discont vl];
   end
   if length(discont) > 1
      discont = sort(discont);
      % Purge duplicates.
      indices = find(abs(diff(discont)) <= 10*eps*abs(discont(1:end-1))) + 1;
      discont(indices) = [];
   end
end
% Add tfinal to the list of discontinuities if it is not already included.
if abs(tfinal - discont(end)) <= 10*eps*abs(tfinal)
   discont(end) = tfinal;
else
   discont = [discont tfinal];
end
sol.discont = discont;
% Discard t0 and discontinuities in the history.
indices = find(discont <= t0);
discont(indices) = [];
nextdsc = 1;
ndxdsc = 1;
   
% Get options, and set defaults.
rtol = ddeget(options,'RelTol',1e-3);
if (length(rtol) ~= 1) | (rtol <= 0)
   error('RelTol must be a positive scalar.');
end
if rtol < 100 * eps 
   rtol = 100 * eps;
   warning(['RelTol has been increased to ' num2str(rtol) '.']);
end

atol = ddeget(options,'AbsTol',1e-6);
if any(atol <= 0)
   error('AbsTol must be positive.');
end

if (length(atol) ~= 1) & (length(atol) ~= neq)
   error(sprintf(['Solving %s requires a scalar AbsTol, ' ...
                   'or a vector AbsTol of length %d'],upper(ddefile),neq));
end
atol = atol(:);
threshold = atol / rtol;

% By default, hmax is 1/10 of the interval of integration.
hmax = min((tfinal-t), abs(ddeget(options,'MaxStep',0.1*(tfinal-t))));
if hmax <= 0
  error('MaxStep must be greater than zero.');
end

minstep = ddeget(options,'MinStep',[]);
if isempty(minstep)
   minstep = 0;
   rept_minh = false;
elseif minlag <= minstep
   error(['MinStep must be smaller than ', num2str(minlag),', the minimum lag.']);
else
   rept_minh = true;
end   

htry = abs(ddeget(options,'InitialStep'));
if htry <= 0
  error('Option ''InitialStep'' must be greater than zero.');
end

printstats = strcmp(ddeget(options,'Stats','off'),'on');

% Allocate storage for output arrays and initialize them.
chunk = min(100,floor((2^13)/neq));

tout = zeros(1,chunk);
yout = zeros(neq,chunk);
ypout = zeros(neq,chunk);
nout = 1;
tout(nout) = t;
yout(:,nout) = y;

% Initialize method parameters.
pow = 1/3;
B = [
    1/2         0               2/9
    0           3/4             1/3
    0           0               4/9
    0           0               0
    ]; 
E = [-5/72; 1/12; 1/9; -1/8];

f = zeros(neq,4);

% Evaluate initial history at t0 - lags.
Z = lagvals(t,lags,history,t,y,[],varargin{:});
f0 = feval(ddes,t,y,Z,varargin{:});
ypout(:,nout) = f0;
nfevals = nfevals + 1;                  % stats
[m,n] = size(f0);
if n > 1
  error([upper(ddefile) ' must return column vectors.'])
elseif m ~= neq
  msg = sprintf('returned derivative and history vectors of different lengths.');
  error([upper(ddefile) msg]);
end

events = ddeget(options,'Events');
haveeventfun = ~isempty(events);
if haveeventfun
   valt = feval(events,t,y,Z,varargin{:});
end
teout = [];
yeout = [];
ieout = [];

hmin = 16*eps*t;
if isempty(htry)
  % Compute an initial step size h using y'(t).
  h = min(hmax, tfinal - t0);
  rh = norm(f0 ./ max(abs(y),threshold),inf) / (0.8 * rtol^pow);
  if h * rh > 1
    h = 1 / rh;
  end
  h = max(h, hmin);
else
  h = min(hmax, max(hmin, htry));
end
% Make sure that the first step is explicit so that the code can
% properly initialize the interpolant.
h = min(h,0.5*minlag);

f(:,1) = f0;

% THE MAIN LOOP

done = false;
while ~done
  
   % By default, hmin is a small number such that t+hmin is only slightly
   % different than t.  It might be 0 if t is 0.
   hmin = 16*eps*t;
   h = min(hmax, max(hmin, h));    % couldn't limit h until new hmin
   
   % Adjust step size to hit discontinuity. tfinal = discont(end).
   hitdsc = false;  
   distance = discont(nextdsc) - t;
   if min(1.1*h,hmax) >= distance          % stretch
      h = distance;
      hitdsc = true;
   elseif 2*h >= distance                  % look-ahead
      h = distance/2; 
   end
   if ~hitdsc & (minlag < h) & (h < 2*minlag)
      h = minlag;
   end
   
   % LOOP FOR ADVANCING ONE STEP.
   nofailed = true;                      % no failed attempts
   while true
      hB = h * B;
      t1 = t + 0.5*h;
      t2 = t + 0.75*h;
      tnew = t + h;
            
      % If a lagged argument falls in the current step, we evaluate the
      % formula by iteration. Extrapolation is used for the evaluation 
      % of the history terms in the first iteration and the tnew,ynew,
      % ypnew of the current iteration are used in the evaluation of 
      % these terms in the next iteration.
      if minlag < h
         maxit = 5;
      else
         maxit = 1;
      end
      X =  tout(1:nout);
      Y =  yout(:,1:nout);   
      YP = ypout(:,1:nout);
      itfail = false;
      for iter = 1:maxit      
         Z = lagvals(t1,lags,history,X,Y,YP,varargin{:});
         f(:,2) = feval(ddes,t1,y+f*hB(:,1),Z,varargin{:});
         Z = lagvals(t2,lags,history,X,Y,YP,varargin{:});
         f(:,3) = feval(ddes,t2,y+f*hB(:,2),Z,varargin{:});
         ynew = y + f*hB(:,3);
         Z = lagvals(tnew,lags,history,X,Y,YP,varargin{:});
         f(:,4) = feval(ddes,tnew,ynew,Z,varargin{:});
         nfevals = nfevals + 3;              
         if maxit > 1 
            if iter > 1
               errit = norm((ynew - last_y) ./ ...
                            max(max(abs(y),abs(ynew)),threshold),inf);
               if errit <= 0.1*rtol
                  break;
               end
            end
            % Use the tentative solution at tnew in the evaluation of the
            % history terms of the next iteration.
            X =  [tout(1:nout) tnew];
            Y =  [yout(:,1:nout) ynew];
            YP = [ypout(:,1:nout) f(:,4)];
            last_y = ynew;
            itfail = (iter == maxit);
         end
      end

      % Estimate the error.
      err = h * norm((f * E) ./ max(max(abs(y),abs(ynew)),threshold),inf);
      % If h <= minstep, adjust err so that the step will be accepted.
      % Note that minstep < minlag, so maxit = 1 and itfail = false.  Report
      % once that a step of minimum size was taken.
      if h <= minstep
         err = min(err,rtol);
         if rept_minh
            warning('Steps of size MinStep were taken.')
            rept_minh = false;
         end
      end
            
      % Accept the solution only if the weighted error is no more than the
      % tolerance rtol.  Estimate an h that will yield an error of rtol on
      % the next step or the next try at taking this step, as the case may be,
      % and use 0.8 of this value to avoid failures.
      if err > rtol | itfail                        % Failed step               
         nfailed = nfailed + 1;            
         if h <= hmin
            msg = sprintf(['Failure at t=%e.  Unable to meet integration ' ...
                       'tolerances without reducing the step size below ' ...
                       'the smallest value allowed (%e) at time t.\n'],t,hmin);
            warning(msg);
            if printstats                  
               fprintf('%g successful steps\n', nsteps);
               fprintf('%g failed attempts\n', nfailed);
               fprintf('%g function evaluations\n', nfevals);
            end
            % Trim output arrays, place in solution structure, and return.
            sol = trim(sol,history,nout,tout,yout,ypout,ndxdsc,...
                       haveeventfun,teout,yeout,ieout);
            return;
         end
         
         if itfail
            h = 0.5*h;
            if h < 2*minlag
               h = minlag;
            end
         elseif nofailed
            nofailed = false;
            h = max(hmin, h * max(0.5, 0.8*(rtol/err)^pow));
         else
            h = max(hmin, 0.5*h);
         end
         hitdsc = false;
         
      else                                % Successful step
         break;
      
      end
   end
   nsteps = nsteps + 1;                  % stats       

   if haveeventfun
      X =  [tout(1:nout) tnew];
      Y =  [yout(:,1:nout) ynew];
      YP = [ypout(:,1:nout) f(:,4)]; 
      [te,ye,ie,valt,stop] = ddezero(events,valt,lags,history,...
                                     X,Y,YP,varargin{:});
      if ~isempty(te)
         nte = length(te);
         teout = [teout te];
         yeout = [yeout ye];
         ieout = [ieout ie];
         if stop                           % stop on a terminal event
            tnew = te(nte);
            ynew = ye(:,nte);
            done = true;
         end
      end
   end
   
   % Advance the integration one step.
   t = tnew;
   y = ynew;
   f(:,1) = f(:,4);                      % BS(2,3) is FSAL.
   nout = nout + 1;

   if nout > length(tout)
      tout  = [tout zeros(1,chunk)];
      yout  = [yout zeros(neq,chunk)];
      ypout = [ypout zeros(neq,chunk)];
   end
   tout(nout) = t;
   yout(:,nout) = y;
   ypout(:,nout) = f(:,1); 
    
   % If there were no failures, compute a new h.
   if nofailed & ~itfail
      % Note that h may shrink by 0.8, and that err may be 0.
      temp = 1.25*(err/rtol)^pow;
      if temp > 0.2
         h = h / temp;
      else
         h = 5*h;
      end
      h = max(h,minstep);
   end

   % Have we hit tfinal = discont(end)?
   if hitdsc
      nextdsc = nextdsc + 1;
      done = nextdsc > length(discont);
      if ~done
         ndxdsc = [ndxdsc nout];
      end
   end
  
end

% Successful integration:

if printstats                           
   fprintf('%g successful steps\n', nsteps);
   fprintf('%g failed attempts\n', nfailed);
   fprintf('%g function evaluations\n', nfevals);
end

% Trim output arrays, place in solution structure, and return.
sol = trim(sol,history,nout,tout,yout,ypout,ndxdsc,...
           haveeventfun,teout,yeout,ieout);
        
% End of function dde23.
        
        
%=========================================================================
function sol = trim(sol,history,nout,tout,yout,ypout,ndxdsc,...
                    haveeventfun,teout,yeout,ieout)
% Trim output arrays and place in solution structure.                
sol.x = tout(1:nout);   
sol.y = yout(:,1:nout);
sol.yp = ypout(:,1:nout);
sol.ndxdsc = ndxdsc;
if haveeventfun
   sol.xe = teout;
   sol.ye = yeout;
   sol.ie = ieout;
end
% Merge with previous solution.
if isstruct(history)
   sol.x = [history.x sol.x];
   sol.y = [history.y sol.y];
   sol.yp = [history.yp sol.yp];
   if haveeventfun
      sol.xe = [history.xe sol.xe];
      sol.ye = [history.ye sol.ye];
      sol.ie = [history.ie sol.ie];
   end
end

%=========================================================================
function Z = lagvals(tnow,lags,history,X,Y,YP,varargin)
% For each I, Z(:,I) is the solution corresponding to TNOW - LAGS(I).
% This solution can be computed in several ways: the initial history,
% interpolation of the computed solution, extrapolation of the computed
% solution, interpolation of the computed solution plus the tentative
% solution at the end of the current step.  The various ways are set
% in the calling program when X,Y,YP are formed.

% No lags corresponds to an ODE.
if isempty(lags)
   Z = [];
   return;
end

% Typically there are few lags, so it is reasonable to process 
% them one at a time.  NOTE that the lags may not be ordered and 
% that it is necessary to preserve their order in Z.
xint = tnow - lags;
Nxint = length(xint);
if isstruct(history)
   given_history = history.history;
   tstart = history.x(1);
   neq = length(history.y(:,1));
else
   neq = length(Y(:,1));
end
Z = zeros(neq,Nxint);

 
for j = 1:Nxint
   if xint(j) < X(1)
      if isnumeric(history)
         temp = history;
      elseif isstruct(history)
         % Is xint(j) in the given history?          
         if xint(j) < tstart
            if isnumeric(given_history)
               temp = given_history;
            else
               temp = feval(given_history,xint(j),varargin{:});
            end
         else    
            % Evaluate computed history by interpolation.
            temp = ddeval(history,xint(j));
         end
      else
         temp = feval(history,xint(j),varargin{:});
      end
      Z(:,j) = temp(:); 
   else
      % Find n for which X(n) <= xint(j) <= X(n+1).  xint(j) bigger
      % than X(end) are evaluated by extrapolation, so n = end-1 then.
      indices = find(xint(j) >= X(1:end-1));
      n = indices(end);
      Z(:,j) = hermite(xint(j),X(n),Y(:,n),YP(:,n),X(n+1),Y(:,n+1),YP(:,n+1));
   end 
end

%=========================================================================
function v = hermite(x,xn,yn,ypn,xnp1,ynp1,ypnp1)
h = xnp1 - xn;            
s = (x - xn)/h;
A1 = (1 + 2*s)*(s - 1)^2;
A2 = (3 - 2*s)*s^2;
B1 = h*s*(s - 1)^2;
B2 = h*(s - 1)*s^2;
v = A1*yn + A2*ynp1 + B1*ypn + B2*ypnp1;

%=========================================================================
function [tout,yout,iout,vnew,stop] = ddezero(events,v,lags,history,...
                                              X,Y,YP,varargin);
%   DDEZERO is an event location helper function for DDE23.  It uses
%   Regula Falsi and information passed from the solver to locate
%   any zeros in the half open time interval (T,TNEW] of the event 
%   functions coded in the EVENTS file.
%   
%   DDEZERO is a modification of the ODEZERO function written by
%   Mark W. Reichelt and Lawrence F. Shampine.

% Initialize.
t0 = X(1);
t = X(end-1);
y = Y(:,end-1);
yp = YP(:,end-1);
tnew = X(end);
ynew = Y(:,end);
ypnew = YP(:,end);

tol = 128*eps*max(abs(t),abs(tnew));
tol = min(tol, abs(tnew - t));
tout = [];
yout = [];
iout = [];
tdir = sign(tnew - t);
stop = 0;

% Set up tL, tR, yL, yR, vL, vR, isterminal and direction.
tL = t;
yL = y;
vL = v;
Z  = lagvals(tnew,lags,history,X,Y,YP,varargin{:});
[vnew,isterminal,direction] = feval(events,tnew,ynew,Z,varargin{:});
tR = tnew;
yR = ynew;
vR = vnew;

% Initialize ttry so that we won't extrapolate if vL or vR is zero. 
ttry = tR;

% Find all events before tnew or the first terminal event.
while 1
  
  lastmoved = 0;
  while 1
    % Events of interest shouldn't have disappeared, but new ones might
    % be found in other elements of the v vector.
    indzc = find((vL .* vR <= 0) & ((vL ~= 0) | (vR ~= 0)) & ...
        (direction .* (vR - vL) >= 0));
    if isempty(indzc)
      if lastmoved ~= 0
        error('ddezero: an event disappeared (internal error)');
      end
      return;
    end
    
    % Check if the time interval is too short to continue looking.
    delta = tR - tL;
    if abs(delta) <= tol
      break;
    end
    
    if (tL == t) & any(vL(indzc) == 0 & vR(indzc) ~= 0)
      ttry = tL + tdir*0.5*tol;
      
    else
      % Compute Regula Falsi change, using leftmost possibility.
      change = 1;
      for j = indzc(:)'
        % If vL or vR is zero, try using old ttry to extrapolate.
        if vL(j) == 0
          if (tdir*ttry > tdir*tR) & (vtry(j) ~= vR(j))
            maybe = 1.0 - vR(j) * (ttry-tR) / ((vtry(j)-vR(j)) * delta);
            if (maybe < 0) | (maybe > 1)
              maybe = 0.5;
            end
          else
            maybe = 0.5;
          end
        elseif vR(j) == 0.0
          if (tdir*ttry < tdir*tL) & (vtry(j) ~= vL(j))
            maybe = vL(j) * (tL-ttry) / ((vtry(j)-vL(j)) * delta);
            if (maybe < 0) | (maybe > 1)
              maybe = 0.5;
            end
          else
            maybe = 0.5;
          end
        else
          maybe = -vL(j) / (vR(j) - vL(j)); % Note vR(j) ~= vL(j).
        end
        if maybe < change
          change = maybe;
        end
      end
      change = change * abs(delta);

      % Enforce minimum and maximum change.
      change = max(0.5*tol, min(change, abs(delta) - 0.5*tol));

      ttry = tL + tdir * change;
    end
    
    % Compute vtry.
    ytry = hermite(ttry,t,y,yp,tnew,ynew,ypnew);
    Z    = lagvals(ttry,lags,history,X,Y,YP,varargin{:});
    vtry = feval(events,ttry,ytry,Z,varargin{:});

    % Check for any crossings between tL and ttry.
    indzc = find((vL .* vtry <= 0) & ((vL ~= 0) | (vtry ~= 0)) & ...
        (direction .* (vtry - vL) >= 0));
    if ~isempty(indzc)
      % Move right end of bracket leftward, remembering the old value.
      tswap = tR; tR = ttry; ttry = tswap;
      yswap = yR; yR = ytry; ytry = yswap;
      vswap = vR; vR = vtry; vtry = vswap;
      % Illinois method.  If we've moved leftward twice, halve
      % vL so we'll move closer next time.
      if lastmoved == 2
        % Watch out for underflow and signs disappearing.
        maybe = 0.5 * vL;
        i = find(maybe ~= 0);
        vL(i) = maybe(i);
      end
      lastmoved = 2;
    else
      % Move left end of bracket rightward, remembering the old value.
      tswap = tL; tL = ttry; ttry = tswap;
      yswap = yL; yL = ytry; ytry = yswap;
      vswap = vL; vL = vtry; vtry = vswap;
      % Illinois method.  If we've moved rightward twice, halve
      % vR so we'll move closer next time.
      if lastmoved == 1
        % Watch out for underflow and signs disappearing.
        maybe = 0.5 * vR;
        i = find(maybe ~= 0);
        vR(i) = maybe(i);
      end
      lastmoved = 1;
    end
  end

  j = ones(length(indzc),1);
  tout = [tout; tR(j)];
  yout = [yout, yR(:,j)];
  iout = [iout; indzc];
  if any(isterminal(indzc))
    if tL ~= t0
      stop = 1;
    end
    break;
  elseif abs(tnew - tR) <= tol
    %  We're not going to find events closer than tol.
    break;
  else
    % Shift bracket rightward from [tL tR] to [tR+0.5*tol tnew].
    ttry = tR; ytry = yR; vtry = vR;
    tL = tR + tdir*0.5*tol;
    yL = hermite(tL,t,y,yp,tnew,ynew,ypnew);
    Z  = lagvals(tL,lags,history,X,Y,YP,varargin{:});
    vL = feval(events,tL,yL,Z,varargin{:});
    tR = tnew; yR = ynew; vR = vnew;
  end
end

