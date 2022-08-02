function [xbox,ybox,prect]=getbox
%GETBOX Get axes information from user-drawn selection rectangle.
% [Xbox,Ybox,Prect]=GETBOX waits for the user to drag a selection box The
% x and y axis data limits of the selection box are returned in Xbox, Ybox,
% and Prect.
% Xbox is a two element vector containing the minimum and maximum limits
% along the x axis, i.e., Xbox = [min(x) max(x)]
% Ybox is a two element vector containing the minimum and maximum limits
% along the y axis, i.e., Ybox = [min(y) max(y)]
% Prect is a four element vector containing the selection box position
% in standard position vector format, Prect = [left bottom width height]
% Data returned is in the axis data units.
%
% The selection box is limited to the x and y axis limits of the axes where
% the selection rectangle was drawn.

% waitforbuttonpress waits until user presses a mouse button over a figure
% waitforbuttonpress return False if that happens. Alternatively, it
% returns True if the user presses a key on the keyboard.

if waitforbuttonpress % Returns True if a key is pressed, abort
   xlim=[];
   ylim=[];
   prect=[];
   return
end
% Function only gets here if user presses a mouse button in a figure

Hf = gcf;      % get current figure when button was pressed
Ha = gca(Hf);  % get current axes where button was pressed

AxesPt = get(Ha,'CurrentPoint'); % get first axes data point clicked
FigPt = get(Hf,'CurrentPoint');  % get first figure point clicked

% call the function rbbox, i.e., rubberband box, to create the selection
% rectangle. This function needs to know where to start from. It does not
% automatically start at the mouse click unless told to do so.

% drag selection rectangle starting at first figure point
rbbox([FigPt 0 0],FigPt) % function returns as soon as mouse button is up

% get point on opposite corner of selection rectangle; add to first point
AxesPt = [AxesPt;get(Ha,'CurrentPoint')];

% get axis limits of axes where selection rectangle was drawn
[Xlim,Ylim] = getn(Ha,'Xlim','Ylim');

% convert AxesPt data into usable output vectors.
xbox = [min(AxesPt(:,1)) max(AxesPt(:,1))]; % x axis limits of selection
xbox = [max(xbox(1),Xlim(1)) min(xbox(2),Xlim(2))]; % limit to axes size

ybox = [min(AxesPt(:,2)) max(AxesPt(:,2))];
ybox = [max(ybox(1),Ylim(1)) min(ybox(2),Ylim(2))]; % limit to axes size

prect = [xbox(1) ybox(1) diff(xbox) diff(ybox)]; % position rectangle