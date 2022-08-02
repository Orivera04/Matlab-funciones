function Q=innerloop(outvar,midvar, intfcn, inmin, inmax,tol, method) 
%INNERLOOP Used with TRPLQUAD to evaluate inner loop of integral.
%   Do not call this function directly; instead, call TRPLQUAD, which then
%   calls this function. 
%
%   Q = INNERLP(OUTVAR,MIDVAR,INTFCN,INMIN,INMAX,TOL,METHOD)
%   OUTVAR and MIDVAR are the value(s) of the outer and middle variable at which 
%   evaluation is desired, passed directly by QUAD. 
%   INTFCN is the name of the object function, passed indirectly 
%   from TRPLQUAD. INMIN and INMAX are the integration limits for 
%   the inner variable, passed indirectly from TRPLQUAD. 
%   TOL is passed to QUAD (QUAD8) when evaluating the inner 
%   loop, passed indirectly from DBLQUAD. The string METHOD determines 
%   what quadrature method is used, such as QUAD, QUAD8 or some
%   user-defined method.

%   Copyright (c) 1984-98 by The MathWorks, Inc.
%   $Revision: 1.7 $  $Date: 1997/11/21 23:30:48 $

% Preallocate memory for the output variable. 
Q = ones(length(outvar),length(midvar)); 

% Evaluate the integrand function at each specified value of the 
% outer variable. 

trace = [];     % No trace for dblquad

if isequal(method, 'quad')
   for i=1:length(outvar)
         for j=1:length(midvar)
         Q(i,j)=quad(intfcn, inmin, inmax, tol, trace, outvar(i),midvar(j));
      end
      end
elseif isequal(method, 'quad8')
    for i=1:length(outvar)
      for j=1:length(midvar)
         Q(i,j)=quad8(intfcn, inmin, inmax, tol, trace, outvar(i),midvar(j));
         
      end 
      end
else % call other user-defined quadrature method
   for i=1:length(outvar)
      for j=1:length(midvar)
         Q(i,j)=feval(method, intfcn, inmin, inmax, tol, trace, outvar(i),midvar(j));
      end   
  end 
end

