function h = parallelplate(varargin)
%PARALLELPLATE Constructor.
%   H = RFCKT.PARALLELPLATE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...)
%   returns a parallel-plate transmission line object, H, based on the
%   specified properties. The properties include,
% 
%           Name: 'Parallel-Plate Transmission Line' (read only)
%          nPort: 2 (read only)
%         RFdata: Handle to rfdata.data object (read only)
%             Z0: Characteristic impedance (read only)
%             PV: Phase velocity (m/sec) (read only)
%           Loss: Line loss (dB/m) (read only)
%     LineLength: Line length (m)
%       StubMode: 'None', 'Series' or 'Shunt'
%    Termination: 'None', 'Open' or 'Short'
%          Width: Plate width (m)
%     Separation: Plate separation (m)
%            MuR: Relative permeability constant
%       EpsilonR: Relative permittivity constant
%      SigmaCond: Conductivity in conductor (S/m)
%      SigmaDiel: Conductivity in dielectric (S/m)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFCKT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/20 23:19:38 $

h = rfckt.parallelplate;

% Set the values for the properties
set(h, varargin{:}, 'Name', 'Parallel-Plate Transmission Line');

% LS(1) = handle.listener(h,h.findprop('Width'),'PropertyPostSet',@update);
% set(LS(1),'CallbackTarget',h);
% LS(2) = handle.listener(h,h.findprop('Separation'),'PropertyPostSet',@update);
% set(LS(2),'CallbackTarget',h);
% LS(3) = handle.listener(h,h.findprop('MuR'),'PropertyPostSet',@update);
% set(LS(3),'CallbackTarget',h);
% LS(4) = handle.listener(h,h.findprop('EpsilonR'),'PropertyPostSet',@update);
% set(LS(4),'CallbackTarget',h);
% set(h, 'Listeners', LS);
% 
% h = h.update;

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;
