function h = shuntrlc(varargin)
%SHUNTRLC Constructor for this object.
%
%   Outputs:
%       h - Handle to this object
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:55 $

h = rfckt.shuntrlc;

% Set the values for the properties
set(h, 'R', Inf, 'L', Inf, 'C', 0);
set(h, varargin{:}, 'Name', 'Shunt RLC');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;