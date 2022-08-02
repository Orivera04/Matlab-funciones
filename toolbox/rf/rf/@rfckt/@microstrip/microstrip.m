function h = microstrip(varargin)
%MICROSTRIP Constructor.
%   H = RFCKT.MICROSTRIP('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns
%   a microstrip transmission line object, H, based on the specified
%   properties. The properties include,
% 
%           Name: 'Microstrip Transmission Line' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%             Z0: Characteristic impedance (read only)
%             PV: Phase velocity (m/sec) (read only)
%           Loss: Line loss (dB/m) (read only)
%     LineLength: Line length (m)
%       StubMode: 'None', 'Series' or 'Shunt'
%    Termination: 'None', 'Open' or 'Short'
%          Width: Conductor strip width (m)
%         Height: Substrate height (m)
%      Thickness: Conductor strip thickness (m)
%       EpsilonR: Relative permittivity constant
%      SigmaCond: Conductivity in conductor (S/m)
%    LossTangent: Loss tangent of dielectric
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.8 $  $Date: 2004/04/20 23:19:37 $

h = rfckt.microstrip;

% Set the values for the properties
set(h, varargin{:}, 'Name', 'Microstrip Transmission Line');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;