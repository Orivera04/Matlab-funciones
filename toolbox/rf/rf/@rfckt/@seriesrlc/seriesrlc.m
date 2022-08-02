function h = seriesrlc(varargin)
%SERIESRLC Constructor for this object.
%
%   Outputs:
%       h - Handle to this object
%   See also RFCKT.
  
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:37:51 $

h = rfckt.seriesrlc;

% Set the values for the properties
set(h, 'R', 0, 'L', 0, 'C', Inf);
set(h, varargin{:}, 'Name', 'Series RLC');

% Activate listeners
L(1) = handle.listener(h,'ObjectBeingDestroyed',@destroy);
set(L(1),'CallbackTarget',h);
h.Listeners = L;