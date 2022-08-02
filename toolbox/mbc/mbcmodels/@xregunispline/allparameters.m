function p= allparameters(m)
%ALLPARAMETERS  Return vector of all parameters for model
%
%  P = ALLPARAMTERS(M) returns a vector containing both the knot and model
%  fit parameters for this model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:58:13 $

k = get(m.mv3xspline,'knots');
p = [k(:) ; double(m.mv3xspline)];
