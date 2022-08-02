function h = lcbandpasstee(varargin)
%LCBANDPASSTEE Constructor.
%   H = RFCKT.LCBANDPASSTEE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC bandpass tee filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Bandpass Tee' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:44 $

h = rfckt.lcbandpasstee;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', [2.7812e-8, 3.013e-9, 2.7812e-8], ...
            'C', [1.8587e-12, 1.7157e-11, 1.8587e-12]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Bandpass Tee');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;