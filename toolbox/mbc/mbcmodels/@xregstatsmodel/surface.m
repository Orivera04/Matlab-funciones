function varargout= surface(m,x,varargin)
%SURFACE Draws a surface of the model
%
% SURFH = SURFACE( MODEL, X, AXHANDLE, [PEVSHADE,XTRANS] )
%
%    S          Cell array with input values {X1,X2,X3,...}
%               All but two inputs must be scalar
%    AXHANDLE   Axis handle (optional, default=gca)
%    PEVSHADE   shade surface with prediction error (optional, default= 0)
%    XTRANS     Transform X values (optional, default= 1)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:58:01 $

% check the number of inputs and outputs
error(nargchk(2,5, nargin, 'struct'));
error(nargoutchk(0, 2, nargout, 'struct'));


if ~iscell( x ) || (length(find(cellfun('length', x)>1))>2) || nfactors(m)~=length(x)
    error('mbc:xregstatsmodel:InvalidSize', 'The second argument must be a cell array with a cell for each input value.\nAll but two of the inputs must be scalar');
end

if nargin>2
    axH = varargin{1}; 
    if ~ishandle(axH) || ~strcmp(get(axH, 'Type'), 'axes')
        error('mbc:xregstatsmodel:InvalidHandle', 'Must provide a valid axes handle');
    end
end

if nargin>3
   opt = varargin{2};
   if ~isnumeric(opt) || length(opt)~=2 || (any(opt>1)) || (any(opt<0))
       error('mbc:xregstatsmodel:InvalidArgument', 'Final argument must be a 1x2 vector containing only 1 or 0');
   end
end

% finally pass this onto the underlying method 
[varargout{1:nargout}] = surface( m.mvModel, x, varargin{:} );



