function h = createntwk(varargin)
%CREATENTWK Create LC highpass pi ladder filter network
%
%   Outputs:
%       h - Handle to this object
%   See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:55 $

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC highpass pi network
numSections = floor((numel(l)+numel(c)+1)/2);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    ckts{indx} = rfckt.shuntrlc('L', l(num));
    indx = indx+1;
    if num <= numel(c)
        ckts{indx} = rfckt.seriesrlc('C', c(num));
    end
end

% Create cascade from individual LC circuits
set(h, 'Ckts', ckts);