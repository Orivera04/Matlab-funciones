function h = mixer(varargin)
%MIXER Constructor.
%   H = RFCKT.MIXER('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   mixer object, H, based on the specified properties. The properties
%   include,
% 
%                Name: 'Mixer' (read only)
%               nPort: 2 (read only)
%              RFdata: Handle to rfdata.data object (read only)
%                File: Data file name
%            IntpType: 'Linear', 'Cubic' or 'Spline'
%                OIP3: Output third order intercept point (dBm)
%                  NF: Noise figure (dB)
%                 FLO: Local oscillator frequency (Hz)
%           MixerType: 'Downconverter', or 'Upconverter'
%          FreqOffset: Phase noise frequency offset (Hz)
%     PhaseNoiseLevel: Phase noise level (dBc/Hz)
% 
%   Use the 'File' property to specify a source .AMP, .S2P, .Y2P, or .Z2P
%   file that describes a mixer. Properties you do not specify retain their
%   default values. 
% 
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:37:15 $

h = rfckt.mixer;

% Check the data file
hasfile = false;
for i=1:2:nargin
    while strcmpi(varargin{i}, 'File')
        hasfile = true;
        break;
    end
end
if ~hasfile    
    % Set the default data file
    set(h, 'File', 'default.s2p');
end
% Set the values for the properties
set(h, varargin{:}, 'Name', 'Mixer');


% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;