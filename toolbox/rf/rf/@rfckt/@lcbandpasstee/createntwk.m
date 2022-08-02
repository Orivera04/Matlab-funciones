function h = createntwk(varargin)
%CREATENTWK Create LC bandpass tee ladder filter network
%
%   Outputs:
%       h - Handle to this object
%   See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:43 $

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC bandpass tee network
numSections = floor((numel(c)+1)/2);
la = l(1:2:end);
lb = l(2:2:end);
ca = c(1:2:end);
cb = c(2:2:end);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    comp1 = rfckt.seriesrlc('L', la(num)); 
    comp2 = rfckt.seriesrlc('C', ca(num)); 
    seriesckt = rfckt.cascade;
    seriesckt.Ckts = {comp1, comp2}; 
    ckts{indx} = seriesckt;

    indx = indx+1;
    if num <= numel(lb)
        comp1 = rfckt.shuntrlc('L', lb(num)); 
        comp2 = rfckt.shuntrlc('C', cb(num)); 
        shuntckt = rfckt.cascade;
        shuntckt.Ckts = {comp1, comp2}; 
        ckts{indx} = shuntckt;
    end
end

% Create cascade from individual LC circuits
set(h, 'Ckts', ckts);