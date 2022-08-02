function h = noise(varargin)
%NOISE Constructor.
%   H = RFDATA.NOISE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   noise data object, H, based on the specified properties. The properties
%   include,
% 
%        Name: 'rfdata.noise object'  (read only)
%         Freq: Frequency (Hz)
%         FMIN: The optimum noise figure
%     GAMMAOPT: The optimum source reflection coefficient
%           RN: The equivalent normalized noise resistance
% 
%   Properties you do not specify retain their default values.
%
%   See also RFDATA.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:35 $


% Create an RFDATA.NOISE object
h = rfdata.noise;

% Update the properties using the user-specified values
set(h, varargin{:}, 'Name', 'rfdata.noise object');

