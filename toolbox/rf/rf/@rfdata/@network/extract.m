function outMatrix = extract(h, outtype, z0)
%EXTRACT Extract network parameters.
%   OUTMATRIX = EXTRACT(H, OUTTYPE, Z0) extracts the network parameters of
%   type OUTTYPE and returns it.
%   OUTTYPE:    'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%               'Z_PARAMETERS', 'H_PARAMETERS', 'T_PARAMETERS'

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:31 $

% Get Network Parameters
params = get(h, 'Data');

% Check the network parameters
if isempty(params)
    id = sprintf('rf:%s:extract:EmptyNetworkParameters', strrep(class(h),'.',':'));
     error(id, 'The object does not have network parameters.');
end

% Set the default result
outMatrix = [];

% Get the type of stored matrix
storedtype = get(h, 'Type');

storedtype = upper(storedtype);
outtype = upper(outtype);

% Do matrix conversion if the method is available
switch storedtype
case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
    own_z0 = get(h, 'Z0');
    switch outtype
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        if nargin < 3
            z0 = own_z0;
        end
        outMatrix = s2s(params, own_z0, z0);
    otherwise
        outMatrix = convertmatrix(h, params, storedtype, outtype, own_z0);
    end
otherwise
    own_z0 = get(h, 'Z0');
    switch outtype
    case {'S_PARAMETERS' 'S-PARAMETERS' 'S_PARAMS' 'S-PARAMS' 'S'}
        if nargin < 3
            z0 = own_z0;
        end
        outMatrix = convertmatrix(h, params, storedtype, outtype, z0);
    otherwise
        outMatrix = convertmatrix(h, params, storedtype, outtype);
    end
end

