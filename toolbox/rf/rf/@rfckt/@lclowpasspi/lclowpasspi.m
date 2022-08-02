function h = lclowpasspi(varargin)
%LCLOWPASSPI Constructor.
%   H = RFCKT.LCLOWPASSPI('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns an
%   LC lowpass pi filter object, H, based on the specified properties. The
%   properties include,
% 
%           Name: 'LC Lowpass Pi' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:04 $

h = rfckt.lclowpasspi;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', 2.8318e-6, 'C', [5.3296e-9  5.3296e-9]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Lowpass Pi');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;