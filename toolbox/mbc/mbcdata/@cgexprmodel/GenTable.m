function y=GenTable(M,x,natural);
% evaluates an cgExprModel M over a grid of data specifed by the CELL x. 
% If data is passed in in another form an error will result.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:34 $
valPtrs = M.allPtrs(M.valPtrs);
if length(x) == length(M.valPtrs)
   for i = 1:length(x)
      valPtrs(i).info = valPtrs(i).set('value',x{i}(:));
   end
else
   error('cgExprModel \ EvalModel : Wrong number of inputs');
end
y= eval(M.modObj);