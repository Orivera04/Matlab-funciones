function h = lchighpasspi(varargin)
%LCHIGHPASSPI Constructor.
%   H = RFCKT.LCHIGHPASSPI('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC highpass pi filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Highpass Pi' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:56 $

h = rfckt.lchighpasspi;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', [1.1881e-6  1.1881e-6], 'C', 2.2363e-9);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Highpass Pi');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;