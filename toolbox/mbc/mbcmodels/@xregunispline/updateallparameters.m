function m = updateallparameters(m,p)
%UPDATEALLPARAMETERS Update all parameters required for use in xregunispline
%
%  M = UPDATEALLPARAMETERS(M, P) updates the model M with the parameters in
%  P.  P contains both a list of knot positions and spline model
%  parameters.
%
%  See also: XREGUNISPLINE/ALLPARAMETERS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:00:40 $

nk = get(m.mv3xspline,'numknots');
m.mv3xspline = set(m.mv3xspline,'knots', p(1:nk)');
m.mv3xspline = update(m.mv3xspline,p(nk+1:end));
