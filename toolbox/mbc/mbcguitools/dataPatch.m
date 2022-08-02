function varargout = dataPatch(ax,infoStr,FLAG,emergencyArea)
%% DATAPATCH(axesHandle,infoString,FLAG)
%% sets button down function of axes to display a fake "tooltip patch" containing infoString
%% if FLAG==1 is passed in, buttonDownFcn not set, function handle returned to sort this out yourself

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:33:11 $

if FLAG
   varargout{1}=@i_dataPatch;
else
   set(ax,'buttondownfcn',{@i_dataPatch,infoStr,emergencyArea});
   varargout={};
end




%----------------------------------------------------------------------
%  SUBFUNCTION i_dataPatch
%----------------------------------------------------------------------
function i_dataPatch(ax, null, infoStr,maxA)

downtype=get(gcbf ,'SelectionType');
switch downtype
case {'open','alt'},  % Double click, right mouse button...just return
   return
   %---Left mouse button...show info patch
case 'normal'
   OK=1;
   CP=get(gcf,'CurrentPoint');

   bgb = uicontrol('style','text',...
      'visible','off',...
      'backgroundcolor','k');
   bgy = uicontrol('style','text',...
      'visible','off',...
      'backgroundcolor',[1 1 0.8]);
   
   th = uicontrol('style','text',...
      'string',infoStr,...
      'backgroundcolor',[1 1 0.8],...
      'visible','off',...
      'tag','dataPatch',...
      'FontName','Lucida Console',...
      'horiz','left',...
      'units',get(gcbf,'units'),...
      'fontunits','point',...
      'fontsize',8);
   
   %% try to keep patch within gca
   Area = 1;
   APos = get(ax,'position');
   W = APos(3);
   H = APos(4);
   AreaOrigin = APos(1:2);
   ext = get(th,'extent');
   
   if ext(3)>W | ext(4)>H
      Area = 2;
      %% text will not fit on this axes alone
      W = maxA(3);
      H = maxA(4);
      AreaOrigin = maxA(1:2);
   end
   
   %% decide where to put the text/patch
   left = CP(1);
   bottom = CP(2);
   
   if (left+ext(3))>AreaOrigin(1)+W %% goes off axes right
      if (left-ext(3))<AreaOrigin(1) %% goes off left aswell
         left = AreaOrigin(1)+W-ext(3);
      else
         left = left-ext(3);
      end
   end
   
   if (bottom+ext(4))>AreaOrigin(2)+H %% goes off axes top
      if (bottom-ext(4))<AreaOrigin(2) %% goes off bottom
         bottom = AreaOrigin(2)+H-ext(4);         
      else
         bottom = bottom - ext(4);
      end
   end
   
   set(th,'position',[left,bottom,ext(3),ext(4)]);
   set(bgy,'position',[left-2,bottom-2,ext(3)+2,ext(4)+2]);
   set(bgb,'position',[left-3,bottom-3,ext(3)+4,ext(4)+4]);
   th = [th,bgb,bgy];
   oldUpFcn = get(gcbf ,'WindowButtonUpFcn');
   set(gcbf ,'WindowButtonUpFcn',{@i_killPatch, th,  oldUpFcn});
   set(th,'visible','on');
end % switch downtype

%----------------------------------------------------------------------
%  SUBFUNCTION i_killPatch
%----------------------------------------------------------------------
function i_killPatch(hFig, null,th, oldUpFcn)

% Remove text and patch
set(gcbf ,'WindowButtonUpFcn',oldUpFcn);
delete(th);

