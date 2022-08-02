function explore3d(varargin)
%EXPLORE3D   Explore your 3-D image interactively.
%   EXPLORE3D(ax) activates the 3-D explorer for the axes specified
%   by the handle "ax".  Once activated you can use the keyboard to
%   fly through your image in a manner similar to a flight simulator.
%
%   Once activated, the arrow keys will allow you to look up, down,
%   left, and right.  In addition, the following keys produce the
%   following actions:
%
%   f  - zoom forward
%   b  - zoom backward
%   r  - rotate right
%   l  - rotate left
%   a  - decrease your zooming step (for the "f" and "b" keys)
%   s  - increase your zooming step (for the "f" and "b" keys)
%   z  - decrease your angular step (for the arrow, "r", and "l" keys)
%   x  - increase your angular step (for the arrow, "r", and "l" keys)
%  ESC - closes EXPLORE3D and restores original figure properties
%
%  % EXAMPLE 1:
%  surf(peaks)
%  explore3d(gca)
%  Now you can fly!
%
% % EXAMPLE 2:
% % Run this code and then try to find the sphere
% figure('color',[0 0 0])
% [x,y,z]=sphere;
% xspot=round(5*(rand-0.5));
% yspot=round(5*(rand-0.5));
% surf(x+xspot-0.5,y+yspot+0.5,z./3)
% hold on
% xwall=[-1 -1 1 1];
% ywall=[0 0 0 0];
% zwall=[-1 1 1 -1];
% patch([-10 -10 10 10],[-10 10 10 -10],[2 2 2 2]+eps,'b')
% patch([-10 -10 10 10],[-10 10 10 -10],[-2 -2 -2 -2]-eps,'r')
% for j=1:25,
%     xspot=round(20*(rand-0.5));
%     yspot=round(20*(rand-0.5));
%     if round(rand),
%         patch(xwall+xspot,ywall+yspot,zwall,rand(1,3))
%     else
%         patch(ywall+xspot,xwall+yspot,zwall,rand(1,3))
%     end
% end
% view(3),axis([-15 15 -15 15 -5 5],'off')
% explore3d(gca)
% % Now see if you can find the sphere!
% 

%  By Mickey Stahl  2-26-02
%  Engineering Development Group
%  Aspiring Developer

if strcmp(class(varargin{1}),'double')
    initialize(varargin{1})
else
    feval(varargin{:})
end

function initialize(ax)
drawnow
handles.ax=ax;
handles.fig=get(ax,'parent');
handles.axesProperties=get(ax);
handles.figureProperties=get(handles.fig);
set(ax,...
    'ALimMode','manual',...
    'CameraTargetMode','manual',...
    'camerapositionmode','manual',...
    'CameraViewAngleMode','manual',...
    'cameraupvectormode','manual',...
    'projection','perspective')
handles.dist=sqrt(sum((ctarg(ax)-cpos(ax)).^2));
handles.step=80;
handles.radianTurn=80;
set(handles.fig,'doublebuffer','on',...
    'keypressfcn','explore3d(''keypressfcn'',guidata(gcbo))')
path=ctarg(ax)-cpos(ax);
set(ax,'cameratarget',cpos(ax)+path./sqrt(sum(path.^2)));
guidata(handles.fig,handles)

function keypressfcn(handles)
ax=handles.ax;
c=abs(lower(get(handles.fig,'currentcharacter')));
persistent keydown;
if isempty(keydown)
    keydown=1;
end
%try
    if ~isempty(c) & keydown
        keydown=0;
        switch c
        case 102
            zoomcamera(handles,1)
        case 98
            zoomcamera(handles,-1)
        case 30
            movetarget(handles,1,1)
        case 31
            movetarget(handles,-1,1)
        case 28
            movetarget(handles,-1,0)
        case 29
            movetarget(handles,1,0)
        case 115
            if handles.step>1,
                handles.step=handles.step-1;
            end
        case 97
            handles.step=handles.step+1;
        case 122
            handles.radianTurn=handles.radianTurn+1;
        case 120
            if handles.radianTurn>1,
                handles.radianTurn=handles.radianTurn-1;
            end
        case 114
            rotatecamera(handles,1)
        case 108
            rotatecamera(handles,-1)
        case 27
            escape(handles)
        end
        if c==120 | c==122 | c==97 | c==115,
            guidata(handles.fig,handles)
            pause(0.05)
        end
        keydown=1;
    end
    %catch
   % keydown=1;
   %end

function rotatecamera(handles,right)
cp=cpos(handles.ax);
ct=ctarg(handles.ax)-cp;
cuv=cupvec(handles.ax);
right=right/handles.radianTurn;
rightline=cross(ct,cuv);
cuv=(cuv+right.*rightline);
cuv=cuv./sqrt(sum(cuv.^2));
set(handles.ax,...
    'cameraupvector',cuv);
   
function movetarget(handles,direction,updown)
cp=cpos(handles.ax);
ct=ctarg(handles.ax)-cp;
cuv=cupvec(handles.ax);
direction=direction/handles.radianTurn;
if updown
    cuv=cuv-direction.*ct;
    ct=ct+direction.*cuv;
    cuv=cuv./sqrt(sum(cuv.^2));
    ct=ct./sqrt(sum(ct.^2));
else
    rightline=cross(ct,cuv);
    ct=(ct+direction.*rightline);
    ct=ct./sqrt(sum(ct.^2));
end
set(handles.ax,...
    'cameratarget',cp+ct,...
    'cameraupvector',cuv);

function zoomcamera(handles,in) 
ax=handles.ax;
path=ctarg(ax)-cpos(ax);
path=in*handles.dist.*path./(sqrt(sum(path.^2))*handles.step);
newcp = cpos(ax) + path;
newtarg=ctarg(ax)+ path;
set(ax,'cameraposition',newcp,...
    'cameratarget',newtarg)

function out = cpos(ax)
out = get(ax,'CameraPosition');
function out = ctarg(ax)
out = get(ax,'CameraTarget');
function out = cupvec(ax)
out = get(ax,'CameraUpVector');

function escape(handles)
h=[handles.fig handles.ax];
props(1).struct=handles.figureProperties;
props(2).struct=handles.axesProperties;
for j=1:2,
    names=fieldnames(props(j).struct);
    for k=1:length(names)
        try
            set(h(j),names{k},getfield(props(j).struct,names{k}))
        catch
        end
    end
end

