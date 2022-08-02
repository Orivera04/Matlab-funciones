function y=subsref(A,S);
% XREGMODEL/SUBSREF evaluation and differentiation of model classes
%
% md = m{n} nth derivative
% y  =  m(x) evaluate model at x (vectorised)
%    or a combination of the above 
%      yd= y{n}(x);
% Now supports Multi-input variable models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:16 $


% Evaluation
if length(S)==1 & strcmp(S.type,'()') 
      y = EvalModel(A,S(1).subs{:});
else
   error('Invalid Function Evaluation p(x) ');
end

