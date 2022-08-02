function nport = getnport(h)
%GETNPORT Get the port number.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:17 $

% Set the default
nport = 2;

% Determine the port number
sparams = get(h, 'S_Parameters');
if ~isempty(sparams) 
    [n1, n2, m] = size(sparams);
    nport = n1;
end

