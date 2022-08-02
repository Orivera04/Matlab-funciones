function [m,OK,Stats,B]=stepwise(m,StepTerms)
% xreglinear/STEPWISE 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:01 $

if nargin>1
   [m2,OK,Stats,B]=stepwise(get(m,'currentmodel'),StepTerms);
else
   [m2,OK,Stats,B]=stepwise(get(m,'currentmodel'));
end
m=set(m,'currentmodel',m2);