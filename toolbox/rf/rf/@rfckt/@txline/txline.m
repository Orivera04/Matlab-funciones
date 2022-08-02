function h = txline(varargin)
%TXLINE Constructor.
%   H = RFCKT.TXLINE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   transmission line object, H, based on the specified properties. The
%   properties include,
%
%           Name: 'Transmission Line' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%             Z0: Characteristic impedance
%             PV: Phase velocity (m/sec)
%           Loss: Line loss (dB/m)
%     LineLength: Line length (m)
%       StubMode: 'None', 'Series' or 'Shunt'
%    Termination: 'None', 'Open' or 'Short'
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/20 23:19:45 $

h = rfckt.txline;

% Set the values for the properties
set(h, varargin{:}, 'Name', 'Transmission Line');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;