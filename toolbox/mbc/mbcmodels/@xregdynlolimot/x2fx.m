function fx = x2fx( m, x )
%XREGDYNLOLIMOT   Regression matrix for XREGLOLIMOT
%   X2FX(M,X) is the regression matrix for LOLIMOT model M at the data 
%   points X.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:47:10 $

switch lower( m.Mode ),
case 'parallel',
    fx = feedbackx2fx( m.xreglolimot, x, m.delmat(1,:), m.delmat(2,:) );
case 'series-parallel',
    fx = x2fx( m.xreglolimot, x );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
