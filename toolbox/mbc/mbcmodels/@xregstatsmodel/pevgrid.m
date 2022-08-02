function varargout = pevgrid(m, x, natural)
%PEVGRID Generate an N-D table of Prediction Error Variance for model
%
%  [PEVN, XN, XG, Y] = PEVGRID( MODEL, X );
%  If NF is the number of input factors,
%  X is a (1-by-NF) cell array of input points at which to evaluate PEV
% 
%  PEVN   N-D array of model PEV values
%  XN     N-D array of evaluation points
%  XG     NxNF array of evaluation points
%  Y      N-D array of model values
%
%  See also XREGSTATSMODEL/PEVCHECK, XREGSTATSMODEL/PEV,
%  XREGSTATSMODEL/GENTABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:57 $

% check the number of inputs and outputs
error(nargchk(2,3, nargin, 'struct'));
error(nargoutchk(0, 4, nargout, 'struct'))

% check the second input has correct type and size
if ~iscell( x ) || length(x)~=nfactors(m)
    error('mbc:xregstatsmodel:InvalidArgument', 'Second argument must be a 1x%d cell array.', nfactors( m ) );
end

if nargin == 2
   natural = 1;
end

[varargout{1:nargout}] = pevgrid(m.mvModel, x, natural);