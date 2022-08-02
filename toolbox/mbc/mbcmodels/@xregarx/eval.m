function y = eval( m, x, y0 )
%XREGARX/EVAL   Evaluation of a dynamic ARX model at a sequence of points.
%   EVAL(M,X) is a vector of values of the dynamic ARX model M evalauted at the 
%   sequnce of points given in the rows of X. Becuase of the dynamic nature of 
%   the model, the order of the evaluation points in X will effect the model 
%   values. EVAL(M,X,Y0) evaluates M with initial (response) values Y0.
%
%   See also XREGMODEL/DYNEVAL.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:51 $


delmat = get( m, 'OrderAndDelay' );
md = max( sum( delmat, 1 ) );

if nargin < 3 | isempty( y0 ),
    y0 = get( get( m, 'StaticModel' ), 'InitialConditions' );
end
if size( y0,1 ) < md-1,
    error( 'Insufficient initial values given' );
 else
    y0(:,1) = code(m.StaticModel,double(y0),nfactors(m.StaticModel));
end

y = dyneval( m.StaticModel, x, delmat, y0 );

% If the model has feedback, the output will coded. Need to invert this coding.
if m.DynamicOrder(end),
    y = invcode( m.StaticModel, y, nfactors( m.StaticModel ) );
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
