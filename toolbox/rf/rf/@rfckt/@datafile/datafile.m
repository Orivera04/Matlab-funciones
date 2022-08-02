function h = datafile(varargin)
%DATAFILE Constructor.
%   H = RFCKT.DATAFILE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   passive circuit object, H, based on the specified properties. The
%   properties include,
% 
%         Name: 'Data File' (read only)
%        nPort: 2 (read only)
%       RFdata: Handle to rfdata.data object (read only)
%         File: Data file name
%     IntpType: 'Linear', 'Cubic' or 'Spline'
% 
%   Use the 'File' property to specify a source .SNP, .YNP, .ZNP, .HNP, or
%   .AMP file that describes an N-port circuit. Properties you do not
%   specify retain their default values. 
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:36:29 $

h = rfckt.datafile;

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
    set(h, 'File', 'passive.s2p');
end
% Set the values for the properties
set(h, varargin{:}, 'Name', 'Data File');


% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;