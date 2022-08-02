function outMatrix = extract(h, outtype, z0)
%EXTRACT Extract network parameters.
%   OUTMATRIX = EXTRACT(H, OUTTYPE) extracts the network parameters of type
%   OUTTYPE and returns it.
%
%   OUTTYPE:    'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%               'Z_PARAMETERS', 'H_PARAMETERS', 'T_PARAMETERS'

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:13 $

% Get S-Parameters
sparams = get(h, 'S_Parameters');
% Check the S-Parameters
if isempty(sparams)
    id = sprintf('rf:%s:extract:EmptySParameters', strrep(class(h),'.',':'));
    error(id, 'The object does not have network parameters.');
end

% Do matrix conversion
if nargin == 3
    outMatrix = convertmatrix(h, sparams, 'S_PARAMETERS', outtype, ...
        get(h, 'Z0'), z0);
else
    outMatrix = convertmatrix(h, sparams, 'S_PARAMETERS', outtype, ...
        get(h, 'Z0'));
end
