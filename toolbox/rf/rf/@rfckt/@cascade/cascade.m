function h = cascade(varargin)
%CASCADE Constructor.
%   H = RFCKT.CASCADE('PROPERTY1',VALUE1,'PROPERTY2',VALUE2,...) returns a
%   cascaded network object, H, based on the specified properties. The
%   properties include,
%
%       Name: 'Cascaded Network' (read only)
%      nPort: 2 (read only)
%     RFdata: Handle to rfdata.data object (read only)
%       Ckts: Circuit objects
%
%   Use the 'Ckts' property to specify the 2-port rfckt objects to be
%   connected. 
%
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:36:13 $

h = rfckt.cascade;

% Set the values for the properties
set(h, varargin{:}, 'Name', 'Cascaded Network');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;