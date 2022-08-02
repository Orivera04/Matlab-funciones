function Q=midloop(outvar, intfcn, inmin, inmax,midmin,midmax, tol, method) 
%MIDLOOP Used with TRPLQUAD to evaluate middle loop of integral.
%   Do not call this function directly; instead, call TRPLQUAD, which then
%   calls this function. 
%
%   Q = MIDLOOP(OUTVAR,INTFCN,INMIN,INMAX,MIDMIN,MIDMAX,TOL,METHOD)
%   OUTVAR is the value(s) of the outer variable at which 
%   evaluation is desired, passed directly by QUAD. 
%   INTFCN is the name of the object function, passed indirectly 
%   from TRPLQUAD. INMIN, INMAX, MIDMIN and MIDMAX are the integration limits for 
%   the inner and middle variables, passed indirectly from TRPLQUAD. 
%   TOL is passed to QUAD (QUAD8) when evaluating the inner 
%   loop, passed indirectly from DBLQUAD. The string METHOD determines 
%   what quadrature method is used, such as QUAD, QUAD8 or some
%   user-defined method.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1997/11/21 23:30:48 $

% Preallocate memory for the output variable. 
Q = ones(size(outvar)); 

% Evaluate the integrand function at each specified value of the 
% outer variable. 

trace = [];     % No trace for dblquad

  for i=1:length(outvar) 
    Q(i)=feval(method,'innerloop',midmin,midmax,tol,trace,outvar(i),intfcn, inmin, inmax, tol,method); 
  end 

