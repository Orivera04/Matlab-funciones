function h = lchighpasstee(varargin)
%LCHIGHPASSTEE Constructor.
%   H = RFCKT.LCHIGHPASSTEE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2) returns
%   an LC highpass tee filter object, H, based on the specified properties.
%   The properties include,
% 
%           Name: 'LC Highpass Tee' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%              L: Vector containing the inductances (Henrys)
%              C: Vector containing the capacitances (Farads)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:00 $

h = rfckt.lchighpasstee;

switch nargin
    case 0
        % Set default L and C
        set(h, 'L', 5.5907e-6, 'C', [4.7524e-10  4.7524e-10]);
    otherwise
        % Set the values for the properties
        set(h, varargin{:});
end
set(h, 'Name', 'LC Highpass Tee');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;