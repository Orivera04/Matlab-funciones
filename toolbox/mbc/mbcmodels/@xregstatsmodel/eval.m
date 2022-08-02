function y = eval( m, x )
%EVAL Internal function to evaluate a model.
%
% If you wish to evaluate your model use 
%
%   Y = MODEL( X ) instead
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:46 $

y = eval( m.mvModel, x );
