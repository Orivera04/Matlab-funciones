function out = i_eval(m)
%I_EVAL  Evaluate expresssion
%
%  OUT = I_EVAL(M)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:50 $

if isempty(m)
   out = [];
else
   inputs = pveceval(getinputs(m), @i_eval);
   out = zeros(max(cellfun('length',inputs)), 1);
   if m.min
       out(:) = inf;
       for n = 1:length(inputs)
           out(:) = min(out, inputs{n}); 
       end
   else
       out(:) = -inf;
       for n = 1:length(inputs)
           out(:) = max(out, inputs{n}); 
       end
   end
end