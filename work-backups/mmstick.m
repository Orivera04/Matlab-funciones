function mmstick(arg)
%MMSTICK Set Axis Tick Specifications using a GUI. (MM)
% MMSTICK creates a GUI to set or modify the specifications
% of the current axes.
% MMSTICK(Ha) considers the axes having handle Ha.
%
% GUI Pushbuttons:
% Revert - Revert to Original Specifications.
% Apply - Apply Changes.
% Done - Quit without making further changes.

% Calls: mmgcf mmgca mmsetpos mmprintf

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 4/2/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0  % use current axes
   Hfgui=findall(0,'Type','figure','Tag','MMSTICK');
   if ~isempty(Hfgui) % GUI exists, just go to it
      figure(Hfgui)
      return
   end
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1);
   arg='initial';
elseif ishandle(arg)  % use axes provided
   if ~strcmp(get(arg,'Type'),'axes')
      error('Handle Does Not Point to an Axes.')
   end
   Ha=arg;
   Hf=get(Ha,'Parent');
   arg='initial';
elseif ~ischar(arg)
   error('Unknown Input Argument.')
end
switch arg
case 'initial' % initialize GUI
   figure(Hf)
   ud.Ha=Ha;
   ud.lim={get(Ha,'Xlim') get(Ha,'Ylim') get(Ha,'Zlim')};
   ud.tick={get(Ha,'Xtick') get(Ha,'Ytick') get(Ha,'Ztick')};
   ud.tickl={get(Ha,'Xticklabel') get(Ha,'Yticklabel') get(Ha,'Zticklabel')};
   ud.tickp={'XTick' 'YTick' 'ZTick'};
   ud.ticklp={'XTickLabel' 'YTickLabel' 'ZTickLabel'};
   ud.tickmp={'XTickMode' 'YTickMode' 'ZTickMode' };
   ud.ticklmp={'XTickLabelMode' 'YTickLabelMode' 'ZTickLabelMode'};
   
   sp=10; csp=6; wb=80; hb=20; ht=hb-4; g=3;
   w=3*(sp+wb);
   wv=100; wl=w-2*sp-g-wv; he=12*ht;
   
   h=csp+hb+csp+csp+he+g+hb+csp+ht+csp+hb+csp;
   gpos=mmsetpos([0 0 w h],Hf,'pixels','onleft','bottom');
   rgb=get(0,'DefaultUicontrolBackgroundColor');
   
   Hfgui=figure('units','pixels',...
      'Position',gpos,...
      'MenuBar',menubar,...
      'Resize','off',...
      'BackingStore','off',...
      'Colormap',[],...
      'InvertHardcopy','off',...
      'PaperPositionMode','auto',...
      'HandleVisibility','callback',...
      'IntegerHandle','off',...
      'NumberTitle','off',...
      'Name','MM: Set Tick Specs',...
      'Color',rgb,...
      'Visible','off',...
      'Tag','MMSTICK');
   
   b=csp+hb+csp+csp+he+g+hb+csp+ht+csp+g;
   ud.xyzpopup=uicontrol('Parent',Hfgui,'Style','Popup',... % axes choice popup
      'Units','Pixels','Position',[(w-wb)/2 b wb hb],...
      'String','X-axis|Y-axis|Z-axis','Value',1,...
      'Callback','mmstick xyzpopup');
   uicontrol('Parent',Hfgui,'Style','Frame',... % Tick frame
      'Units','Pixels','Position',[g csp+hb+csp w-2*g he+g+hb+csp+ht+csp+g])
   
   uicontrol('Parent',Hfgui,'Style','Text',... % Tick value text
      'HorizontalAlignment','Left',...
      'Units','Pixels','Position',[sp csp+hb+sp+he+csp+hb+g wv ht],...
      'String','Tick Values')
   ud.vpopup=uicontrol('Parent',Hfgui,'Style','Popup',... % Tick value popup
      'Units','Pixels','Position',[sp csp+hb+sp+he+g wv hb],...
      'String','Default|Custom|None','Value',2,...
      'Callback','mmstick vpopup');
   ud.vedit=uicontrol('Parent',Hfgui,'Style','Edit',... % Tick value edit
      'Min',0,'Max',2,...
      'HorizontalAlignment','left',...
      'String',mmprintf(ud.tick{1}),...
      'Callback','mmstick vedit',...
      'Units','Pixels','Position',[sp csp+hb+sp wv he]);
   
   uicontrol('Parent',Hfgui,'Style','Text',... % Tick label text
      'HorizontalAlignment','Left',...
      'Units','Pixels','Position',[sp+wv+g csp+hb+sp+he+csp+hb+g wl ht],...
      'String','Tick Labels')
   ud.lpopup=uicontrol('Parent',Hfgui,'Style','Popup',... % Tick label popup
      'Units','Pixels','Position',[sp+wv+g csp+hb+sp+he+g wl hb],...
      'String','Default|Custom|None','Value',1,...
      'Callback','mmstick lpopup');
   ud.ledit=uicontrol('Parent',Hfgui,'Style','Edit',... % Tick label edit
      'Min',0,'Max',2,...
      'HorizontalAlignment','left',...
      'String',ud.tickl{1},...
      'Enable','off',...
      'Units','Pixels','Position',[sp+wv+g csp+hb+sp wl he]);
   
   uicontrol('Parent',Hfgui,'Style','PushButton',... % revert pushbutton
      'Units','Pixels','Position',[sp csp wb hb],...
      'String','Revert',...
      'Callback','mmstick revert');
   uicontrol('Parent',Hfgui,'Style','Pushbutton',... % apply pushbutton
      'Units','Pixels','Position',[sp+wb+csp csp wb hb],...
      'String','Apply',...
      'Callback','mmstick apply');
   uicontrol('Parent',Hfgui,'Style','PushButton',... % done pushbutton
      'Units','Pixels','Position',[sp+wb+csp+wb+csp csp wb hb],...
      'String','Done',...
      'Callback','close(findobj(''Type'',''figure'',''Tag'',''MMSTICK''))');
   
   set(Hfgui,'UserData',ud,'Visible','on')
   mmputptr(Hfgui)
   
case 'xyzpopup' % xyzaxes popup callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   xyz=get(ud.xyzpopup,'Value');
   [tick,tlab]=mmget(ud.Ha,ud.tickp{xyz},ud.ticklp{xyz});
   set(ud.vedit,'String',mmprintf(tick),'Enable','on')
   set(ud.ledit,'String',tlab,'Enable','off')
   set(ud.vpopup,'Value',2)
   set(ud.lpopup,'Value',1)
   
case 'vedit' % value edit callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   v=popupstr(ud.lpopup);
   if strcmp(v,'Default') % default labels
      set(ud.ledit,'String',get(ud.vedit,'String'))
   end
   
case 'vpopup' % value popup callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   xyz=get(ud.xyzpopup,'Value');
   v=popupstr(ud.vpopup);
   if strcmp(v,'Custom') % Custom ticks
      set(ud.vedit,'Enable','on')
      set(ud.Ha,ud.tickmp{xyz},'manual')
   elseif strcmp(v,'None') % No Ticks
      set(ud.vedit,'Enable','off','String','')
      set(ud.ledit,'Enable','off','String','')
   else % Default
      set(ud.Ha,ud.tickmp{xyz},'auto')
      set(ud.vedit,'String',get(ud.Ha,ud.tickp{xyz}),'Enable','off')
   end
   
case 'lpopup' % label popup callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   xyz=get(ud.xyzpopup,'Value');
   v=popupstr(ud.lpopup);
   if strcmp(v,'Custom') % Custom labels
      set(ud.ledit,'Enable','on')
      set(ud.Ha,ud.ticklmp{xyz},'manual')
   elseif strcmp(v,'None') % No Labels
      set(ud.ledit,'Enable','off','String','')
   else % Default
      set(ud.Ha,ud.ticklmp{xyz},'auto')
      set(ud.ledit,'String',get(ud.Ha,ud.ticklp{xyz}),'Enable','off')
   end
   
case 'revert' % revert button callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   xyz=get(ud.xyzpopup,'Value');
   set(ud.Ha,ud.tickp{xyz},ud.tick{xyz},...
      ud.ticklp{xyz},ud.tickl{xyz})
   set(ud.vedit,'String',mmprintf(ud.tick{xyz}))
   set(ud.ledit,'String',ud.tickl{xyz})	
   
case 'apply' % apply button callback
   Hf=gcbf;
   ud=get(Hf,'UserData');
   xyz=get(ud.xyzpopup,'Value');
   v=popupstr(ud.vpopup);
   if strcmp(v,'Custom') % Custom values
      v=get(ud.vedit,'string');
      nv=str2num(v);
      vlen=length(nv);
      if vlen~=0 % conversion to numbers worked
         lims=ud.lim{xyz};
         nv=unique(mmlimit(nv,lims(1),lims(2)));
         if length(nv)==vlen
            set(ud.Ha,ud.tickp{xyz},nv)
            set(ud.vedit,'String',mmprintf(nv))
         end
      end
   elseif strcmp(v,'None') % No ticks
      set(ud.Ha,ud.tickp{xyz},[])
   else % Default ticks
      set(ud.Ha,ud.tickmp{xyz},'auto')
   end
   v=popupstr(ud.lpopup);
   if strcmp(v,'Custom') % Custom labels
      v=get(ud.ledit,'String');
      set(ud.Ha,ud.ticklp{xyz},v)
   elseif strcmp(v,'None') % No labels
      set(ud.Ha,ud.ticklp{xyz},'')
   else
      set(ud.Ha,ud.ticklmp{xyz},'auto')
      set(ud.ledit,'String',get(ud.Ha,ud.ticklp{xyz}))
   end	
case 'mmsaxes'
   Hgui=findall(0,'Type','figure','Tag','MMSAXES');
   data=get(Hgui,'UserData');
   mmstick(data{1})
   
otherwise
   disp('MMSTICK: Unknown Input Argument.')
end
