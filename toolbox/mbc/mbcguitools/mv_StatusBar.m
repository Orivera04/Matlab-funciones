function mv_StatusBar(Action,varargin);
%MV_STATUSBAR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:33:30 $

switch lower(Action)
case 'create'
   i_Create(varargin{:});
case 'clear'
   i_Clear(varargin{:});
case 'progress'
   i_Progress(varargin{:});
case 'message'
   i_Message(varargin{:});
case 'progressvis'
   i_Progressvis(varargin{:});
case 'move'
   i_Move(varargin{:});
case 'messagecolour'
   i_msgclr(varargin{:});
end


function i_Create(hFig,pos);

uicontrol('parent',hFig,...
   'style','text',...
   'HorizontalAlignment','left',...
   'tag','mvStatusText',...
   'pos',[pos(1)+20,pos(2)+5,pos(3)/2 15]);

uicontrol('Parent',hFig,...
   'style','text',...
   'Position',[pos(1)+pos(3)*2/3 pos(2)+5 pos(3)/4 15],...
   'tag','mvStatusWindow',...
   'BackGroundColor','w');
uicontrol('Parent',hFig,...
   'style','text',...
   'Position',[pos(1)+pos(3)*2/3 pos(2)+5 pos(3)/4 15],...
   'visible','off',...
   'tag','mvStatusProgress',...
   'BackGroundColor',[0 0.5 0.5],...
   'userdata','off');
uicontrol('Parent',hFig,...
   'style','text',...
   'Position',[pos(1)+pos(3)*2/3-pos(3)/4-10 pos(2)+5 pos(3)/4 15],...
   'visible','off',...
   'HorizontalAlignment','right',...
   'tag','mvStatusProgText',...
   'userdata','off');


function [hText,hProg,hWind,hProgText]= i_FindStatus(hFig)

hText= findobj(hFig,'tag','mvStatusText');
hProg= findobj(hFig,'tag','mvStatusProgress');
hWind= findobj(hFig,'tag','mvStatusWindow');
hProgText= findobj(hFig,'tag','mvStatusProgText');



function i_Clear(hFig)

[hText,hProg]= i_FindStatus(hFig);
set(hText,'string','');
ProgPos= get(hProg,'pos');
ProgPos(3) = 1;
set(hProg,'pos',ProgPos);

function i_Message(hFig,Message,Progress,varargin)

[hText,hProg,hWind]= i_FindStatus(hFig);
set(hText,'string',Message);
if nargin > 2
   WholePos=get(hWind,'pos');
   ProgPos= get(hProg,'pos');
   if length(Progress)>1
      ProgPos(3) = WholePos(3)* (Progress(1)/Progress(2));
   else
      ProgPos(3) = WholePos(3)* Progress(1)/100;
   end   
   if ProgPos(3)>0
      set(hProg,'pos',ProgPos,'Visible','on');
   else
      set(hProg,'Visible','off');
   end   
end

% Option for not redrawing - big performance hit in DOE gui here!
if (nargin>3 & strcmp(varargin{1},'noredraw')) | strcmp(get(hFig,'visible'),'off')
else
   drawnow;
end

function i_Progress(hFig,Progress,ProgText)

[hText,hProg,hWind,hProgText]= i_FindStatus(hFig);
WholePos=get(hWind,'pos');
ProgPos= get(hProg,'pos');
if length(Progress)>1
   ProgPos(3) = WholePos(3)* (Progress(1)/Progress(2));
else
   ProgPos(3) = WholePos(3)* Progress(1)/100;
end   
if ProgPos(3)>0  
   set(hProg,'pos',ProgPos,'userdata','on');
   if strcmp(get(hWind,'visible'),'on')
      % Only bring up if the window is visible (implies the waitbar is on)
      set(hProg,'Visible','on');
   end
else
   set(hProg,'Visible','off','userdata','off');
end   
if nargin>2
   set(hProgText,'string',ProgText,'vis','on')
end
drawnow


function i_Progressvis(hFig,vis)
% Switches progress meter visibility

[hText,hProg,hWind,hProgText]= i_FindStatus(hFig);

if strcmp(vis,'off');
   set([hWind;hProg;hProgText],'visible','off');
elseif strcmp(vis,'on')
   if ~strcmp(get(hProg,'userdata'),'off')
      % Turn on the Progress meter
      set(hProg,'visible','on');
   end
   %Turn on the Progress window
   set(hProgText,'visible','on','string','');
   set(hWind,'visible','on');
end



function i_Move(hFig,pos)
% Allows repositioning of statusbar

[hText,hProg,hWind,hProgTxt]= i_FindStatus(hFig);

WholePos=get(hWind,'pos');
ProgPos= get(hProg,'pos');
ratio=ProgPos(3)/WholePos(3);
set([hText;hWind;hProg;hProgTxt],{'Position'},...
   {  [pos(1)+20,pos(2)+5,pos(3)/2 15];...
      [pos(1)+pos(3)*2/3 pos(2)+5 pos(3)/4 15];...
      [pos(1)+pos(3)*2/3 pos(2)+5 (pos(3)/4)*ratio 15];...
      [pos(1)+pos(3)*2/3-pos(3)/4-10 pos(2)+5 pos(3)/4 15]});

function i_msgclr(hFig, clr, varargin)
% Allows changing of message ui background/foreground

if nargin==2
   prop='backgroundcolor';
elseif strcmp(varargin{1},'fg')
   prop='foregroundcolor';
else
   prop='backgroundcolor';
end

[hText,hProg,hWind]= i_FindStatus(hFig);

set(hText,prop,clr);








   