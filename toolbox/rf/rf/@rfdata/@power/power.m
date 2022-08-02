function h = power(varargin)
%POWER Constructor.
%   H = RFDATA.POWER('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   power data object, H, based on the specified properties. The properties
%   include,
% 
%      Name: 'rfdata.power object' (read only)
%      Freq: Frequency (Hz)
%       Pin: Input power (W)
%      Pout: Output power (W)
%     Phase: Phase shift (degree)
% 
%   Properties you do not specify retain their default values.
%
%   See also RFDATA.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:38 $

% Create an RFDATA.POWER object
h = rfdata.power;

% Update the properties using the user-specified values
set(h, varargin{:}, 'Name', 'rfdata.power object');
