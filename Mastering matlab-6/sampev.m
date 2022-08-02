function sampev(varargin)
%SAMPEV Sample event handle for ActiveX server.
%  SAMPEV is a sample event handler function for the Matlab sample 
%  control. The only event fired by the control is 'Click', which is fired 
%  when the user clicks on the control with the mouse. The event handler
%  displays a text message in the Matlab command window when the event is 
%  fired.
%
%  See also: MWSAMP and ACTXCONTROL.

% Copyright 1984-2000 The MathWorks, Inc. 
% $Revision: 1.6 $ $Date: 1997/10/25 18:52:06 

if (str2num(varargin{1}) == -600);
	disp ('Click Event Fired');
end
if (str2num(varargin{1}) == -601);
	disp ('DblClick Event Fired');
end
if (str2num(varargin{1}) == -605);
	disp ('MouseDown Event Fired');
    disp ('The position is: [');
    varargin(5)
    disp (',');
    varargin(6)
    disp (']');
end
