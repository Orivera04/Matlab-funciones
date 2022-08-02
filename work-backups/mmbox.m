function p=mmbox(Ha)
%MMBOX Get 2-D Axis Vector of a Rubberband Box. (MM)
% MMBOX returns an axis vector [xmin xmax ymin ymax]
% of a rubberband box drawn in the current axis by the user
% with the mouse.
% The returned vector cannot be larger than the current
% axis limits, nor smaller than 1/20 of the limits.
% MMBOX returns [] if an error occurs or if the user presses
% a key on the keyboard.
%
% MMBOX(Ha) returns an axis vector from the axis having handle Ha.

% Calls: mmgcf mmgca mmis2d

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/20/96, modified 4/2/96, 8/30/96, v5: 1/14/97, 8/22/97, 3/11/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

p=[]; % default response
if nargin==0 | isempty(Ha)
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
elseif ~ishandle(Ha) | ~strcmp(get(Ha,'type'),'axes')
   error('Handle Must Point to an Axes.')
else
   Hf=get(Ha,'Parent');
end
if ~mmis2d(Ha)
   error('Axis Must be 2D.')
end

figure(Hf)  % bring current figure forward and make it current
axes(Ha)    % make this axes current
if waitforbuttonpress, return, end % key pressed, abort

cp=get(Ha,'CurrentPoint');  	 % get first axes point
cfp=get(Hf,'CurrentPoint'); 	 % get figure point
rbbox([cfp 0 0],cfp)			    % drag rubberband box at cfp
cp=[cp;get(Ha,'CurrentPoint')];% get second axes point

%convert points to useful limited axis vector
p=[min(cp(:,1)) max(cp(:,1)) min(cp(:,2)) max(cp(:,2))];
alims=[get(Ha,'Xlim') get(Ha,'Ylim')];
dalims=diff(alims);

% max zoom is 20X, just in case user drags too small
dlims=max(dalims/20,diff(p));
p=[p(1) p(1)+dlims(1) p(3) p(3)+dlims(3)];

% don't allow zoom out
p=[	max(p(1),alims(1)) min(p(2),alims(2)) ...
      max(p(3),alims(3)) min(p(4),alims(4))];
