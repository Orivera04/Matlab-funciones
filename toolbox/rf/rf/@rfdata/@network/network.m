function h = network(varargin)
%NETWORK Constructor.
%   H = RFDATA.NETWORK('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   network data object, H, based on the specified properties. The
%   properties include,
% 
%      Name: 'rfdata.network object' (read only)
%       Type: Type of the network parameters
%       Freq: Frequency (Hz)
%       Data: Network parameters
%         Z0: Reference impedance
% 
%   Properties you do not specify retain their default values.
%
%   See also RFDATA.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:32 $

% Create an RFDATA.NETWORK object
h = rfdata.network;

% Update the properties using the user-specified values
set(h, varargin{:}, 'Name', 'rfdata.network object');
