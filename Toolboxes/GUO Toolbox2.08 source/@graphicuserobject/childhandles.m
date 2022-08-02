function h = childhandles(GUO);

% function h = childhandles(GUO);
% 
% Returns the handles of the children (uicontrols and axes) within "GUO". This
% method should only be used when absolutely necessary, because the integrity
% of a graphicuserobject can be compromised when child object properties such
% as Parent, Position or Units are set via handles.  Such properties should 
% only be set via the "setchild" method.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

warning('Integrity of graphicuserobject may be compromised - child handles accessed!');
h = GUO.Children;
