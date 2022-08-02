function h = lcbandpasspi(varargin)
%LCBANDPASSPI Constructor.
%   H = RFCKT.LCBANDPASSPI('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC bandpass pi filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Bandpass Pi' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:40 $

h = rfckt.lcbandpasspi;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', [1.4446e-9, 4.3949e-8, 1.4446e-9], ...
            'C', [3.5785e-11, 1.1762e-12, 3.5785e-11]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Bandpass Pi');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;