function varargout = GenTable(m,x,varargin)
%GENTABLE Generate an N-D table of model evaluations
%
%   [YN, XN, YV, XG] = GENTABLE( MODEL, X );
% 
%   If NF is the number of input factors,
%   X is a (1-by-NF) cell array of input points at which to evaluate the model
% 
%   YN   N-D array of model evaluations
%   XN   N-D array of evaluation points
%   YV   Vector of model evaluation 
%   XG   NxNF array of evaluation points
%
% See also XREGSTATSMODEL/EVALMODEL, XREGSTATSMODEL/PEV, XREGSTATSMODEL/PEVGRID


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:41 $

% check the number of inputs and outputs
error(nargchk(2,inf, nargin, 'struct'));
error(nargoutchk(0, 4, nargout, 'struct'))

% check the second input has correct type and size
if ~iscell( x ) || length(x)~=nfactors(m)
    error('mbc:xregstatsmodel:InvalidArgument', 'Second argument must be a 1x%d cell array.', nfactors( m ) );
end

% pass the arguments onto the enclosed model
[varargout{1:nargout}] = GenTable( m.mvModel, x, varargin );
