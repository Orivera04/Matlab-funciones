function w = evalweight( m, x, index )
%EVALWEIGHT   Evaluate the weight functions of the an XREGLOLIMOT model.
%   W = EVALWEIGHT(M,X) is the matrix of weight functions for the XREGLOLIMOT 
%   model M evaluated at the points X. W(I,J) is the value of the J-th weight 
%   function at the I-th point.
%   EVALWEIGHT(M,X,J) evaluates only the J-th weight function of M. To get a 
%   subset of the weight functions, J may be vector of indices.
%
%   See also XREGLOLIMOT/EVAL, XREGLOLIMOT/EVALSINGLE.
  
%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 07:50:37 $


% evaluate all the RBFs at the data points
rbfx = x2fx( m.xregrbf, x );

% normalize the rbf fx matrix: divide each row by its sum
s = sum( rbfx, 2 );
ind = find(abs( s ) < eps);
if ~isempty( ind )
    % protect against divide by zero
    s(ind) = sign( s(ind) ) * eps;
    ind = s == 0;
    if ~isempty( ind )
        s(ind) = eps;
    end
end

if nargin < 3,
    w = rbfx ./ s(:,ones(1,size(rbfx,2)) );
elseif length( index ) > 1,
    w = rbfx(:,index) ./ s(:,ones(1,length(index) ) );
else
    w = rbfx(:,index) ./ s;
end

return


%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
