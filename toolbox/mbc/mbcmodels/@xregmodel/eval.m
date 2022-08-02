function y=eval(M,x);
% XREGMODEL/EVAL does nothing

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:51:46 $



% Obsolete function defines m(x)= NaN for all x.

warning('MODEL/EVAL is obsolete. Please report to IHN');
y = repmat(NaN,size(x,1),1);