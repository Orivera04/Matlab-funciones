function magnifyrecttofig(varargin)
% function magnifyrecttofig(varargin)
%
% NOTE this function was based on and inspired by magnify.m by Rich
% Hindman.  In fact, some code was directly lifted.  Thanks.
%
% Displays the contents of a displayed draggable rectangle on one axis of a
% source figure into an axis in a target figure.  The difference in the
% screen size of the target axis and the size of the rectangle represents
% the magnification factor that the contents of the source rectangle will
% appear in the target figure.
%
% magnifyrecttofig -  source figure is gcf, target figure is created fresh.
% magnifyrecttofig(sourcefig) - source figure is sourcefig,...
% magnifyrecttofig(sourcefig, targetfigure) - target figure is targetfigure
%   Warning: It's contents will be destroyed (a clf will be called on it).
% magnifyrecttofig(...,'m',....) - sets the target axis to occupy the full
% target figure rather than being the same size as the source axis.  Note
% that this argument can be in any position and the positon of the other 
% arguments will be as if it was not given at all.
%
% Operation - executing this function will install the various call back
% handlers to facilitate the functionality.  After that, dragging the mouse
% on the desired source axis will cause the outline of a correspondingly
% positioned rectangle to appear on the source window and the portion of
% that axes within the rectangle will appear in the target figure.  If the
% target window is created by this function it will appear to the right of
% the original figure and be the same size. 
%
% Keys for controlling box size (using SHIFT key not necessary):
% The '<' and '>' keys  while dragging will cause the rectangle size to
% increase or decrease respectively which will cause the magnficiation to
% decrease or increase respectively.
% The '<-' and '->' arrow keys  while dragging will cause the rectangle width to
% increase or decrease respectively which will cause the width magnficiation to
% decrease or increase respectively.
% The up and down arrow keys  while dragging will cause the rectangle height to
% increase or decrease respectively which will cause the height magnficiation to
% decrease or increase respectively.
% The 'r' key will reset the rectange box to be 20% of the axes
% The 'm' key will toggle the copied target axis to occupy the full target 
% figure or the same size as the original.
%
% Notes
%   1) This DOES work well with figure zoom (button and dragging) so
%   zooming the source window into some basic area of interest and then
%   dragging a rectangle on that IS recommended.
%   2) Higher magnification can, obviously, be obtained by 
%   enlarging the target window.
%   3) FYI - The target window actually has a complete copy of the source
%   axis and so magnification is done by merely setting the axis of the
%   target axes to the same portion encompassed by the rectangle on the
%   source axes.  Result: Fast but more memory for the copy.
%
% Issues
%   1) If the target figure is created it will be created to the right of
%   the source figure so don't put the source figure at the right of the
%   screen.
%   2) Since the target figure is not a copy of the whole figure there are
%   things that don't get copied that effect the display of the axis.  I
%   don't know what all of them are but colormap was one of them and I did
%   copy that to the target as well.
%   3) I have on rare occassions seen the rectangle not be deleted upon
%   button up (and so leaves a residual rectangle).  Though this can be
%   deleted through the figures menu (selecting then hitting the delete
%   button) it's not very nice.  I don't know why it happens but on the
%   guess that it has something to do with interrupted event callbacks due
%   to a call to figure inside them I have replace them with
%   set(0,'CurrentFigure,...) as much as possible.  I'm still testing that.
%    Anybody who has other ideas by all means write me or fix it.  Thanks.
%   4) After all this time I still can't seem to figure out when I should
%   use the word axis or axes.  Sorry.
%
% Andrew Diamond, EnVision Systems LLC, 3/27/05
%   
% Revision
% Andrew Diamond, EnVision Systems LLC, 3/28/05
%   1) Put in arrow keys to have individual control over rectangle width
%   and height
%   2) Saved size state of rectangle between drags and added 'r' key to
%   restore default rectangle proportion (20% of axes)
%   3) Added 'm' key to toggle between maximizing target axis and having it
%   be the original.  Also, 'm' as argument to default to maximized vs
%   orignal size.
%   4) Tried to fix wierd event timing bugs that would result in residual
%   rectangles.  The biggest fix came by disallowing the right mouse
%   button.
%
% Revision
% Andrew Diamond, EnVision Systems LLC, 4/27/05
%   Bug fix to correct focust of window on first drag not being the source
%   window which therefore didn't get keyboard input.
nin = nargin;
moptionpos = find(strncmpi(varargin,'m',1));
bMaxTargetAxisSize=0;
if(length(moptionpos)== 1)
    bMaxTargetAxisSize = 1;
    varargin = varargin([1:moptionpos-1,moptionpos+1:end]);
    nin = nin - 1;
end
if(nin > 0)
    f1 = varargin{1};
    if(~isfigure(f1))
        error('source is not a figure');
    end
else
    f1 = gcf;
end

if(nin > 1)
    hTargetWindow = varargin{2};
    if(~isfigure(hTargetWindow))
        error('target is not a figure');
    end
else
    hTargetWindow = [];
end

UserDataInfo = struct('TargetWindow',hTargetWindow,'RectFrac',[0.2, 0.2], 'bMaxTargetAxisSize',bMaxTargetAxisSize,'ready',0);
UserDataInfo.f1Info.hRect=-1;
set(f1, ...
    'WindowButtonDownFcn',  @ButtonDownCallback, ...
    'WindowButtonUpFcn', @ButtonUpCallback, ...
    'WindowButtonMotionFcn', @ButtonMotionCallback, ...
    'KeyPressFcn', @KeyPressCallback,...
    'UserData', UserDataInfo);
return;


function ButtonDownCallback(f1,eventdata)
if(~strcmpi(get(f1,'SelectionType'),'Normal')) % allow left click only
    % Originally, I didn't check this and so a right click would work but
    % that caused problems if the right button and left buttons were
    % clicked pretty much together.  Probably caused this routine to be
    % entered for the second click before it finished for the first one or
    % perhaps it resulted in a buttonup callback being done while the
    % other one was being done.  Anyway, I couldn't find a way to fix that
    % so I just side stepped the issue.
    return;
end
UserDataInfo = get(f1,'UserData');
if(ishandle(UserDataInfo.f1Info.hRect)) % this, a residual rectangle, shouldn't happen
    delete(hRect);
    UserDataInfo.f1Info.hRect=-1;
end
a1 = get(f1,'CurrentAxes');
if(~isfigure(UserDataInfo.TargetWindow))
    UserDataInfo.TargetWindow=figure;
    set(0,'CurrentFigure',f1); % figure(f1);
    f1pos = get(f1,'Position');
    set(UserDataInfo.TargetWindow,'Position',[f1pos(1)+f1pos(3), f1pos(2),f1pos(3:4)])
end
set(0,'CurrentFigure',UserDataInfo.TargetWindow); % figure(UserDataInfo.TargetWindow); 
clf; 
set(0,'CurrentFigure',f1); % figure(f1); % for backwards compatibility.
set(UserDataInfo.TargetWindow, 'Colormap',get(f1, 'Colormap'));
copyobj(a1,UserDataInfo.TargetWindow);
hRect=rectangle('Position',[1,1,1,1],'visible', 'on','EraseMode','xor');
a2 = get(UserDataInfo.TargetWindow,'CurrentAxes');
if(UserDataInfo.bMaxTargetAxisSize)
    set(a2,'Position',[0,0,1,1]) % Using OuterPosition might be better but that's not backward compatible.  Debatable anyway.
end
    
RectFrac=UserDataInfo.RectFrac; % default if not already overridden
if(isfield(UserDataInfo,'f1Info'))
    if(isfield(UserDataInfo.f1Info,'RectFrac'))
        RectFrac = UserDataInfo.f1Info.RectFrac; % previously set.
    end
end
UserDataInfo.f1Info = struct('hfig',f1,'hax',a1,'hRect',hRect,'RectFrac',RectFrac);
UserDataInfo.f2Info = struct('hfig',UserDataInfo.TargetWindow,'hax',a2);
UserDataInfo.ready=1;
set(f1,'UserData',UserDataInfo);
figure(f1);
% set(0,'CurrentFigure',f1);  % for backwards compatibility.
set(f1, 'CurrentAxes',a1);
return;

function ButtonUpCallback(src,eventdata)
% get(src,'SelectionType')
UserDataInfo = get(src,'UserData');
if isempty(UserDataInfo) return; end;
if UserDataInfo.ready == 0 return; end;
UserDataInfo.ready=0;
delete(UserDataInfo.f1Info.hRect);
UserDataInfo.f1Info.hRect=-1;
set(src,'UserData',UserDataInfo);
return;

function ButtonMotionCallback(src,eventdata)
UserDataInfo = get(src,'UserData');
if isempty(UserDataInfo) return; end;
if UserDataInfo.ready == 0 return; end;

f1 = UserDataInfo.f1Info.hfig;
a1 = UserDataInfo.f1Info.hax;
a2 = UserDataInfo.f2Info.hax;
[f_cp, a1_cp] = pointer2d(f1,a1);
axisa1 = axis(UserDataInfo.f1Info.hax);
rectdxdy = UserDataInfo.f1Info.RectFrac .* (axisa1([2,4])-axisa1([1,3]));
rectsxsy = a1_cp(1:2)  - rectdxdy ./ 2;
RectanglePosInfo = [rectsxsy,rectdxdy];
set(UserDataInfo.f1Info.hRect,'Position',RectanglePosInfo); % ,'visible', 'on');
a2axistoset=[rectsxsy(1),rectsxsy(1)+rectdxdy(1), rectsxsy(2),rectsxsy(2)+rectdxdy(2)];
axis(a2,a2axistoset);
drawnow;
return;

function KeyPressCallback(src,eventdata)
UserDataInfo = get(gcf,'UserData');
if isempty(UserDataInfo) 
    return; 
end;
if UserDataInfo.ready == 0 
    return; 
end;
    cc = get(UserDataInfo.f1Info.hfig,'CurrentCharacter');
    switch(cc)
        case {'<',','}
            UserDataInfo.f1Info.RectFrac = min(1,UserDataInfo.f1Info.RectFrac .* 1.2);
        case {'>','.'}
            UserDataInfo.f1Info.RectFrac = min(1,UserDataInfo.f1Info.RectFrac ./ 1.2);
        case {28} % left arrow - make rect wider which decreases horiz mag in target
            UserDataInfo.f1Info.RectFrac(1) = min(1,UserDataInfo.f1Info.RectFrac(1) .* 1.2);
        case {29} % right arrow - make rect narrower which increases horiz mag in target
            UserDataInfo.f1Info.RectFrac(1) = min(1,UserDataInfo.f1Info.RectFrac(1) ./ 1.2);
        case {30} % up arrow - make rect taller which decreases vert mag in target
            UserDataInfo.f1Info.RectFrac(2) = min(1,UserDataInfo.f1Info.RectFrac(2) .* 1.2);
        case {31} % right arrow - make rect shorter which increases vert mag in target
            UserDataInfo.f1Info.RectFrac(2) = min(1,UserDataInfo.f1Info.RectFrac(2) ./ 1.2);
        case {'r','R'}
            UserDataInfo.f1Info.RectFrac = UserDataInfo.RectFrac;
        case {'m','M'}
            UserDataInfo.bMaxTargetAxisSize = 1-UserDataInfo.bMaxTargetAxisSize;
            if(UserDataInfo.bMaxTargetAxisSize)
                set(UserDataInfo.f2Info.hax,'Position',[0,0,1,1]);
            else
                set(UserDataInfo.f2Info.hax,'Position',get(UserDataInfo.f1Info.hax,'Position'));
            end
        otherwise
            fprintf(1,'Other char input (char="%c", int=%d, hex=%x)\n',cc,cc,cc);
    end
    set(gcf,'UserData',UserDataInfo);
    ButtonMotionCallback(src);
return;



% Included for completeness (usually in own file)
function [fig_pointer_pos, axes_pointer_val] = pointer2d(fig_hndl,axes_hndl)
%
%pointer2d(fig_hndl,axes_hndl)
%
%	Returns the coordinates of the pointer (in pixels)
%	in the desired figure (fig_hndl) and the coordinates
%       in the desired axis (axes coordinates)
%
% Example:
%  figure(1),
%  hold on,
%  for i = 1:1000,
%     [figp,axp]=pointer2d;
%     plot(axp(1),axp(2),'.','EraseMode','none');
%     drawnow;
%  end;
%  hold off

% Rick Hindman - 4/18/01

if (nargin == 0), fig_hndl = gcf; axes_hndl = gca; end;
if (nargin == 1), axes_hndl = get(fig_hndl,'CurrentAxes'); end;

set(fig_hndl,'Units','pixels');

pointer_pos = get(0,'PointerLocation');	%pixels {0,0} absolute screen coord of mouse.
fig_pos = get(fig_hndl,'Position');	%pixels {l,b,w,h} absolute screen coord of figure

fig_pointer_pos = pointer_pos - fig_pos([1,2]); % relative screen coord of mouse w/r to figure
set(fig_hndl,'CurrentPoint',fig_pointer_pos); % sets the currenpoint to relative screen coord?

if (isempty(axes_hndl)),
    axes_pointer_val = [];
elseif (nargout == 2),
    axes_pointer_line = get(axes_hndl,'CurrentPoint');
    axes_pointer_val = sum(axes_pointer_line)/2;
end;

function b=isfigure(h)
b=0;
if(isempty(h))
    return;
end
b=zeros(size(h));
hb = ishandle(h);
b(hb) = strcmpi(get(h(hb),'type'), 'figure');
