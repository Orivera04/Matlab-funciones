function h = createntwk(varargin)
%CREATENTWK Create LC highpass tee ladder filter network
%
%   Outputs:
%       h - Handle to this object
%   See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:59 $

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC highpass tee network
numSections = floor((numel(l)+numel(c)+1)/2);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    ckts{indx} = rfckt.seriesrlc('C', c(num));
    indx = indx+1;
    if num <= numel(l)
        ckts{indx} = rfckt.shuntrlc('L', l(num));
    end
end

% Create cascade from individual RLC circuits
set(h, 'Ckts', ckts);