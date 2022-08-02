function [y, weights] = eval( m, x )
%XREGDYNLOLIMOT/EVAL   Evaluation of a LOLIMOT model at a sequence of points.
%   EVAL(M,X) is a vector of values of the LOLIMOT model M evalauted at the 
%   sequnce of points given in the rows of X. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:45:54 $


switch lower( m.Mode ),
case 'parallel',
    [y, weights] = feedbackeval( m, x, m.delmat(1,:), m.delmat(2,:) );
case 'series-parallel',
    [y, weights] = eval( m.xreglolimot, x );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
