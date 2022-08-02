function h = data(varargin)
%DATA Constructor.
%   H = RFDATA.DATA('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   data object, H, based on the specified properties. The properties
%   include,
% 
%             Name: 'rfdata.data object' (read only)
%             Freq: Frequency (Hz)
%     S_Parameters: S Parameters
%               Z0: Reference impedance
%             OIP3: Output third order intercept point (W)
%               NF: Noise figure
%         IntpType: 'Linear', 'Cubic' or 'Spline'
%               ZS: Source impedance
%               ZL: Load impedance
% 
%   Properties you do not specify retain their default values.
%
%   See also RFDATA.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:11 $

% Create an RFDATA.DATA object
h = rfdata.data;

% Update the properties using the user-specified values
set(h, varargin{:}, 'Name', 'rfdata.data object');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
% L(2) = handle.listener(h,h.findprop('Z0'),'PropertyPostSet',@draw);
% set(L(2),'CallbackTarget',h);

h.Listeners = L;