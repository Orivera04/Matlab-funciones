function aeroassertmsg(varargin)
% AEROASSERTMSG function containing assert messages of Aerospace Blockset.

%   Copyright 1990-2003 The MathWorks, Inc.
%   $Revision $  $Date: 2004/04/06 01:03:52 $

if nargin==0
    error('aeroblks:aeroassertmsg:invalidusage','AEROASSERTMSG is a function used by the Aerospace Blockset for assertion messages.');
end
action = varargin{1};

switch action
    % messages for aerolib blocks:
case 'aeroblkascorr'
    warning('aeroblks:aeroassertmsg:invalidairspeed','True airspeed must be subsonic');
case 'aeroblkwmm'
    action2 = varargin{2};
    switch action2
        case 'lon'
            warning('aeroblks:aeroassertmsg:invalidlongitude','Longitude must be in the range of -180 to 180 degrees');
        case 'lat'
            warning('aeroblks:aeroassertmsg:invalidlatitude','Latitude must be in the range of -90 to 90 degrees');
        case 'alt'
            warning('aeroblks:aeroassertmsg:invalidaltitude','Height must be in the range of 0 to 1,000,000 meters');
        case 'time'
            warning('aeroblks:aeroassertmsg:invaliddecimalyear','Decimal year must be within model 5-year life span of 2000 to 2005');
        otherwise
            error('aeroblks:aeroassertmsg:invalidwmmaction','WMM action not defined');
    end    
otherwise
    error('aeroblks:aeroassertmsg:invalidblock','Block not defined');
end