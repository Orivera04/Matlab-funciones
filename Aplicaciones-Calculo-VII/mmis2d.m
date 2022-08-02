function [tf,xa,ya]=mmis2d(H)
%MMIS2D True for Axes that are 2D. (MM)
% MMIS2D(H) returns True if the axes having handle H displays
% a 2D viewpoint of the X-Y plane where the X- and Y-axes are
% parallel to the sides of the associated figure window.
%
% [TF,Xa,Ya]=MMIS2D(H) in addition returns the angles of x- and y-axes 
% 
% e.g., if the x-axis increases from right-to-left Xa=180
% e.g., if the y-axis increases from left-to-right Ya=0
% e.g., if the x-axis increases from bottom-to-top Xa=90

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/22/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

if ~ishandle(H)
	error('H Must be a Handle.')
end
if ~strcmp(get(H,'Type'),'axes')
	error('H Must be a Handle to an Axes Object.')
end
v=get(H,'view');
az=v(1); el=v(2);
tf=rem(az,90)==0 & abs(el)==90;

if nargout==3
	xdir=strcmp(get(H,'Xdir'),'reverse');
	ydir=strcmp(get(H,'Ydir'),'reverse');
	s=sign(el);
	
	xa=mod(-s*az - xdir*180,360);
	ya=mod(s*(90-az) - ydir*180,360);
end
	
