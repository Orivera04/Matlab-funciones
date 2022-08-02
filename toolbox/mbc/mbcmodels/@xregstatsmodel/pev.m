function varargout = pev(m, x, varargin)
%PEV Prediction error variance of the model
%
%  [PEV, Y] = PEV( MODEL, X );
%
%  See also XREGSTATSMODEL/PEVCHECK, XREGSTATSMODEL/PEVGRID,
%  XREGSTATSMODEL/GENTABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:57:55 $

% check the number of inputs and outputs
error(nargchk(2,inf, nargin, 'struct'));
error(nargoutchk(0, 2, nargout, 'struct'))

NF = nfactors(m);
if NF==size(x, 2)
    [varargout{1:nargout}] = pev( m.mvModel, x, varargin{:} );
else
    str = '';
    if NF>1
        str = 's';
    end
    error('mbc:xregstatsmodel:InvalidSize', 'Incorrect number of inputs.  Model has %d input%s', NF, str );
end
