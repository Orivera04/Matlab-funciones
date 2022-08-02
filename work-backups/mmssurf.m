function mmssurf(arg)
%MMSSURF Set Surface Specifications using a GUI. (MM)
% MMSSURF creates a GUI to set or modify the specifications of all
% surfaces and patches on the current axes.
% MMSSURF(Ha) considers the axes having handle Ha.
%
% GUI Pushbuttons:
% Revert - Revert to original surface specs (but don't apply them).
% Apply - apply changes.
% Done - quit without making further changes.

% Calls: mmgcf mmgca mmget mmrgb mmsetpos mmonoff

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/2/96, v5: 1/15/97, 3/17/97, 4/2/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0  % use current axes
   Hfgui=findall(0,'Type','figure','Tag','MMSSURF');
   if ~isempty(Hfgui) % GUI exists, just go to it
      figure(Hfgui)
      return
   end
   Hf=mmgcf(1);
   arg=mmgca(Hf,1);
elseif arg>0  % use axes provided
   if ~strcmp(get(arg,'Type'),'axes')
      error('Handle Does Not Point to an Axes.')
   end
   Hf=get(arg,'Parent');
end
if arg>0  % initialize GUI
   figure(Hf)
   Ha=arg;
   Hs=[findobj(Ha,'Type','patch'); findobj(Ha,'Type','surface');];
   Ns=length(Hs);
   if Ns==0, error('No Surfaces or Patches Exist for Modification.'), end
   if Ns>12
      warning('Can Only Modify 12 Most Recent Patches or Surfaces.')
      Ns=12;
      Hs(Ns+1:end)=[];
   end
   w=[40 75 95 70 95 55 75];  % width of uicontrols
   s=[10  5  10 5  5  5  5];  % spacing between uicontrols
   f=[5 cumsum(w+s)];
   h=20; hp=h+5;              % height and vertical spacing of controls
   gpos=mmsetpos([5 5 f(8) (Ns+2)*hp+10],Hf,'pixels','center','below');
   rgb=get(0,'DefaultUicontrolBackgroundColor');
   Hfgui=figure('units','pixels',...
      'Position',gpos,...
      'MenuBar',menubar,...
      'Resize','off',...
      'BackingStore','off',...
      'Colormap',[],...
      'HandleVisibility','callback',...
      'InvertHardcopy','off',...
      'PaperPositionMode','auto',...
      'IntegerHandle','off',...
      'NumberTitle','off',...
      'Name','MM: Set Surface Specs',...
      'Color',rgb,...
      'Visible','off',...
      'Tag','MMSSURF');
   
   bot=(Ns+1)*hp+10;
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(1) bot w(1) h],...
      'String','Visible')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(2) bot w(2) h],...
      'String','Face')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(3) bot w(3) h],...
      'String','RGB')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(4) bot w(4) h],...
      'String','Edge')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(5) bot w(5) h],...
      'String','RGB')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(6) bot w(6) h],...
      'String','Width')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(7) bot w(7) h],...
      'String','Axis')
   uicontrol('Parent',Hfgui,'Style','PushButton',...
      'Position',[f(8)/2-100 5 60 h],...
      'String','Revert',...
      'Callback','mmssurf(-1)')
   uicontrol('Parent',Hfgui,'Style','Pushbutton',...
      'Position',[f(8)/2-30 5 60 h],...
      'String','Apply',...
      'Callback','mmssurf(-2)')
   uicontrol('Parent',Hfgui,'Style','PushButton',...
      'Position',[f(8)/2+40 5 60 h],...
      'String','Done',...
      'Callback','close(findobj(''Type'',''figure'',''Tag'',''MMSSURF''))')
   
   Hui=zeros(Ns,7);  % handle storage
   val=zeros(Ns,5);  % popup value storage
   frgb=zeros(Ns,3); % face color storage
   ergb=frgb;        % edge color storage
   
   faces=char('none','flat','interp','texture','RGB->');
   edges='none|flat|interp|RGB->';
   widths=sprintf('%.2g|',0.5:.5:6);
   widths(end)=[];
   styles='both|row|column';
   
   for i=1:Ns  % place popups for each surface or patch
      bot=(Ns+1-i)*hp+10;
      
      val(i,1)=mmonoff(get(Hs(i),'Visible'));
      Hui(i,1)=uicontrol('Parent',Hfgui,'Style','checkbox',...
         'Position',[f(1) bot w(1) h],...
         'Min',0,'Max',1,'Value',val(i,1),...
         'String',sprintf('%.0f',i));
      
      tmp=get(Hs(i),'FaceColor');
      en='on';
      if ischar(tmp)
         switch tmp
         case 'none',   v=1;
         case 'flat',   v=2;
         case 'interp', v=3;
         otherwise,     v=4; en='off';
         end
      else                   v=5;
      end
      val(i,2)=v;
      Hui(i,2)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(2) bot w(2) h],...
         'String',faces,...
         'Value',v,...
         'Enable',en);
      
      if v~=5, tmp=[0 0 0]; end
      frgb(i,:)=tmp;
      Hui(i,3)=uicontrol('Parent',Hfgui,'Style','Edit',...
         'Position',[f(3) bot w(3) h],...
         'String',sprintf('[%.1f  %.1f  %.1f]',tmp));
      
      tmp=get(Hs(i),'EdgeColor');
      if ischar(tmp)
         switch tmp
         case 'none', v=1;
         case 'flat', v=2;
         otherwise,   v=3;
         end
      else                 v=4;
      end
      val(i,3)=v;
      Hui(i,4)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(4) bot w(4) h],...
         'String',edges,...
         'Value',v);
      
      if v~=4, tmp=[0 0 0]; end
      ergb(i,:)=tmp;
      Hui(i,5)=uicontrol('Parent',Hfgui,'Style','Edit',...
         'Position',[f(5) bot w(5) h],...
         'String',sprintf('[%.1f  %.1f  %.1f]',tmp));
      
      val(i,4)=min(round(2*get(Hs(i),'Linewidth')),6);
      Hui(i,6)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(6) bot w(6) h],...
         'String',widths,...
         'Value',val(i,4));
      
      if strcmp(get(Hs(i),'type'),'patch')
         Hui(i,7)=uicontrol('Parent',Hfgui,'Style','PopUp',...
            'Position',[f(7) bot w(7) h],...
            'String','n.a.',...
            'Enable','off',...
            'Value',1);
         val(i,5)=1;
      else
         tmp=get(Hs(i),'MeshStyle');
         switch tmp
         case 'both',   v=1;
         case 'row',    v=2;
         case 'column', v=3;
         end
         val(i,5)=v;
         Hui(i,7)=uicontrol('Parent',Hfgui,'Style','PopUp',...
            'Position',[f(7) bot w(7) h],...
            'String',styles,...
            'Value',v);
      end
   end
   
   set(Hfgui,'UserData',{Hs Hui val frgb ergb},'Visible','on')
   mmputptr(Hfgui)
   
elseif arg==-1  % Revert Callback
   Hfgui=findobj('Type','figure','Tag','MMSSURF');
   data=get(Hfgui,'Userdata');
   [Hs,Hui,val,frgb,ergb]=deal(data{:});
   Ns=size(Hs,1);
   for i=1:Ns
      set(Hui(i,1),'value',val(i,1))
      set(Hui(i,2),'value',val(i,2))
      set(Hui(i,3),'string',sprintf('[%.1f  %.1f  %.1f]',frgb(i,:)))
      set(Hui(i,4),'value',val(i,3))
      set(Hui(i,5),'string',sprintf('[%.1f  %.1f  %.1f]',ergb(i,:)))
      set(Hui(i,6),'value',val(i,4))
      set(Hui(i,7),'value',val(i,5))
   end
   
elseif arg==-2  % Apply Callback
   Hfgui=findobj('Type','figure','Tag','MMSSURF');
   data=get(Hfgui,'Userdata');
   [Hs,Hui,val,frgb,ergb]=deal(data{:});
   Ns=size(Hs,1);
   % 	faces=char('none','flat','interp','texture','RGB->');
   % 	edges='none|flat|interp|RGB->';
   % 	widths=sprintf('%.2g|',0.5:.5:6);
   % 	widths(end)=[];
   % 	styles='both|row|column';
   faces={'none','flat','interp'};
   
   for i=1:Ns
      if ishandle(Hs(i));
         [vi,fc,ec,lw,st]=mmget(Hui(i,[1 2 4 6 7]),'value');
         
         set(Hs(i),'Visible',mmonoff(vi))
         
         if fc==1
            set(Hs(i),'FaceColor','none')
            set(Hui(i,3),'string','[0 0 0]')
         elseif fc==2
            set(Hs(i),'FaceColor','flat')
            set(Hui(i,3),'string','[0 0 0]')
         elseif fc==3
            set(Hs(i),'FaceColor','interp')
            set(Hui(i,3),'string','[0 0 0]')
         elseif fc==4 & val(i,2)~=4
            set(Hs(i),'FaceColor',faces{val(i,1)})
            set(Hui(i,2),'value',val(i,1))
            set(Hui(i,3),'string','[0 0 0]')
         else
            tmp=eval(get(Hui(i,3),'String'),'rgb(i,:)');
            tmp=mmrgb(tmp(:).',frgb(i,:));
            set(Hs(i),'FaceColor',tmp)
         end
         
         if ec==1
            set(Hs(i),'EdgeColor','none')
            set(Hui(i,5),'string','[0 0 0]')
         elseif ec==2
            set(Hs(i),'EdgeColor','flat')
            set(Hui(i,5),'string','[0 0 0]')
         elseif ec==3
            set(Hs(i),'EdgeColor','interp')
            set(Hui(i,5),'string','[0 0 0]')
         else
            tmp=eval(get(Hui(i,5),'String'),'rgb(i,:)');
            tmp=mmrgb(tmp(:).',ergb(i,:));
            set(Hs(i),'EdgeColor',tmp)
         end
         
         set(Hs(i),'Linewidth',lw/2)
         
         if strcmp(get(Hs(i),'type'),'patch')
            set(Hui(i,7),'value',1)
         else
            if st==1,     set(Hs(i),'MeshStyle','both')
            elseif st==2, set(Hs(i),'MeshStyle','row')
            elseif st==3, set(Hs(i),'MeshStyle','column')
            end
         end
         
      end
   end
end
