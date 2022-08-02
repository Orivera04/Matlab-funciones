function h = series(varargin)
%SERIES Constructor.
%   H = RFCKT.SERIES('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   series connected network object, H, based on the specified properties.
%   The properties include,
%
%       Name: 'Series Connected Network' (read only)
%      nPort: 2 (read only)
%     RFdata: Handle to rfdata.data object (read only)
%       Ckts: Circuit objects
%
%   Use the 'Ckts' property to specify the 2-port rfckt objects to be
%   connected. 
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:37:47 $

h = rfckt.series;

% Set the values for the properties
set(h, varargin{:}, 'Name', 'Series Connected Network');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;