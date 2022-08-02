function h = reference(varargin)
%REFERENCE Constructor.
%   H = RFDATA.REFERENCE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns
%   a reference data object, H, based on the specified properties. The
%   properties include,
% 
%           Name: 'rfdata.reference object' (read only)
%     NetworkData: Network parameters object
%       NoiseData: Spot noise parameters object
%       PowerData: Power data object
%            OIP3: Output 3rd order intercept (W)
%          OneDBC: 1dB gain compression power (W)
%              PS: Saturation power (W)
%             GCS: Gain compression at saturation (W)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFDATA.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:41 $

% Create an RFDATA.REFERENCE object
h = rfdata.reference;

% Update the properties using the user-specified values
set(h, varargin{:}, 'Name', 'rfdata.reference object');