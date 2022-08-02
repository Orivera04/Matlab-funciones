function y=EvalModel(M,x);
% evaluates an cgExprModel M at the data specifed by the CELL x. 
% If data is passed in in another form an error will result.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:33 $

if ~iscell(x)
   for i = 1:size(x,2)
      temp{i} = x(:,i);
   end
   x = temp;
end
valPtrs = M.allPtrs(M.valPtrs);
if length(x) == length(M.valPtrs)
   for i = 1:length(x)
      valPtrs(i).info = valPtrs(i).set('value',x{i}(:));
   end
else
   error('cgExprModel \ EvalModel : Wrong number of inputs');
end
y= i_eval(M.modObj);