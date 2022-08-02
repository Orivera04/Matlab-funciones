function y=subsref(A,S);
% cage/Function/SUBSREF evaluation of xregexportmodel class.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:14:21 $

% Evaluation
if length(S)==1 & strcmp(S.type,'()') 
      y = eval(A,S(1).subs{:});
else
   error('Invalid Function Evaluation p(x) ');
end
