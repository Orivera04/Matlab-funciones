function h = lcbandstoppi(varargin)
%LCBANDSTOPPI Constructor.
%   H = RFCKT.LCBANDSTOPPI('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC bandstop pi filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Bandstop Pi' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:48 $

h = rfckt.lcbandstoppi;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', [2.8091e-8  2.2603e-9  2.8091e-8], ...
            'C', [1.8403e-12  2.2871e-11  1.8403e-12]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Bandstop Pi');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;