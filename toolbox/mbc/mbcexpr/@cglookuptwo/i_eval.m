function Y = i_eval(LT);
%I_EVAL Evaluate expression
%
%	OUT = I_EVAL(LT)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:45 $

% Check to see if the object is full

if isempty(LT)
   Y = NaN;
else
   cgm = cgmathsobject;
   extinterp2fH = gethandle(cgm,'extinterp2');

   data = LT.Values;
   [M,N] = size(data);
   
   % Evaluate inputs.  These must must return 0-based indices into the
   % table
   u = LT.Xexpr.i_eval;
   v = LT.Yexpr.i_eval;
   Clip = LT.Clips;
   
   Y = feval(extinterp2fH, 0:N-1, 0:M-1, data, u, v);
   Y = min(Clip(2), max(Clip(1), Y(:)));
end