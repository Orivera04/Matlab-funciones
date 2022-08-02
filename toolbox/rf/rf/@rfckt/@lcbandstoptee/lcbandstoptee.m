function h = lcbandstoptee(varargin)
%LCBANDSTOPTEE Constructor.
%   H = RFCKT.LCBANDSTOPTEE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC bandstop tee filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Bandstop Tee' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:52 $

h = rfckt.lcbandstoptee;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', [2.7908e-9  4.9321e-8  2.7908e-9], ...
            'C', [1.8523e-11  1.0481e-12  1.8523e-11]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Bandstop Tee');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;