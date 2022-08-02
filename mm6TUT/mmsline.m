function mmsline(arg)
%MMSLINE Set Line Specifications using a GUI. (MM)
% MMSLINE creates a GUI to set or modify the specifications of all
% lines on the current axes.
% MMSLINE(Ha) considers the axes having handle Ha.
%
% GUI Pushbuttons:
% Revert - Revert to original line specs (but don't apply them).
% Apply - apply changes.
% Done - quit without making further changes.

% Calls: mmgcf mmgca mmget mmrgb mmsetpos mmonoff

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/6/96, revised 12/2/96, v5: 1/15/97, 3/17/97, 4/2/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0  % use current axes
   Hfgui=findall(0,'Type','figure','Tag','MMSLINE');
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
   rgb=get(0,'DefaultUicontrolBackgroundColor');
   Ha=arg;
   Hl=findobj(Ha,'Type','line');
   Nl=length(Hl);
   if Nl==0, error('No Lines Exist for Modification.'), end
   if Nl>12
      warning('Can Only Modify 12 Most Recent Lines.')
      Nl=12;
      Hl(Nl+1:end)=[];
   end
   Hl=Hl(Nl:-1:1);
   %w=[40 60 60 60 60 75 95];
   w=[40 60 60 60 60 85 95];
   s=[10  5  10 5  10 5  5];
   f=[5 cumsum(w+s)];
   h=20; hp=h+5;
   gpos=mmsetpos([0 0 f(8) (Nl+2)*hp+10],Hf,'pixels','center','below');
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
      'Name','MM: Set Line Specs',...
      'Color',rgb,...
      'Visible','off',...
      'Tag','MMSLINE');
   
   bot=(Nl+1)*hp+10;
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(1) bot w(1) h],...
      'String','Visible')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(2) bot w(2) h],...
      'String','Style')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(3) bot w(3) h],...
      'String','Width')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(4) bot w(4) h],...
      'String','Marker')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(5) bot w(5) h],...
      'String','Size')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(6) bot w(6) h],...
      'String','Color')
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[f(7) bot w(7) h],...
      'String','RGB')
   uicontrol('Parent',Hfgui,'Style','PushButton',...
      'Position',[f(4) 5 60 h],...
      'String','Revert',...
      'Callback','mmsline(-1)')
   uicontrol('Parent',Hfgui,'Style','Pushbutton',...
      'Position',[(f(4)+f(6))/2 5 60 h],...
      'String','Apply',...
      'Callback','mmsline(-2)')
   uicontrol('Parent',Hfgui,'Style','PushButton',...
      'Position',[f(6) 5 60 h],...
      'String','Done',...
      'Callback','close(findobj(''Type'',''figure'',''Tag'',''MMSLINE''))')
   
   Hui=zeros(Nl,7);  % handle storage
   val=zeros(Nl,6);  % popup value storage
   rgb=zeros(Nl,3);  % line color storage
   
   styles='___|- -|. . .|-.-.|none';
   widths=sprintf('%.2g|',0.5:.5:6);
   widths(end)=[];
   marks='o|+|.|*|x|s|d|^|v|>|<|p|h|none';
   sizes=sprintf('%.0f|',4:2:20);
   sizes(end)=[];
   colors='Yellow|Magenta|Cyan|Red|Green|Blue|White|Black|RGB->';
   
   for i=1:Nl  % place popups for each line
      bot=(Nl+1-i)*hp+10;
      val(i,1)=mmonoff(get(Hl(i),'Visible'));
      Hui(i,1)=uicontrol('Parent',Hfgui,'Style','checkbox',...
         'Position',[f(1) bot w(1) h],...
         'Min',0,'Max',1,'Value',val(i,1),...
         'String',sprintf('%.0f',i));
      
      
      switch get(Hl(i),'Linestyle')
      case '-',  v=1;
      case '--', v=2;
      case ':',  v=3;
      case '-.', v=4;
      otherwise ,v=5;
      end
      val(i,2)=v;
      Hui(i,2)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(2) bot w(2) h],...
         'String',styles,...
         'Value',v);
      
      val(i,3)=min(round(2*get(Hl(i),'Linewidth')),6);
      Hui(i,3)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(3) bot w(3) h],...
         'String',widths,...
         'Value',val(i,3));
      
      tmp=get(Hl(i),'Marker');
      v=find(tmp(1)=='o+.*xsd^v><phn');
      val(i,4)=v;
      Hui(i,4)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(4) bot w(4) h],...
         'String',marks,...
         'Value',v);
      
      val(i,5)=max(4,min(get(Hl(i),'MarkerSize'),20))/2-1;
      Hui(i,5)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(5) bot w(5) h],...
         'String',sizes,...
         'Value',val(i,5));
      
      tmp=get(Hl(i),'Color');
      if     all(tmp==mmrgb('y')), v=1;
      elseif all(tmp==mmrgb('m')), v=2;
      elseif all(tmp==mmrgb('c')), v=3;
      elseif all(tmp==mmrgb('r')), v=4;
      elseif all(tmp==mmrgb('g')), v=5;
      elseif all(tmp==mmrgb('b')), v=6;
      elseif all(tmp==mmrgb('w')), v=7;
      elseif all(tmp==mmrgb('k')), v=8;
      else                         v=9;
      end
      val(i,6)=v;
      rgb(i,:)=tmp;
      Hui(i,6)=uicontrol('Parent',Hfgui,'Style','PopUp',...
         'Position',[f(6) bot w(6) h],...
         'String',colors,...
         'Value',v);
      Hui(i,7)=uicontrol('Parent',Hfgui,'Style','Edit',...
         'Position',[f(7) bot w(7) h],...
         'String',sprintf('[%.1f  %.1f  %.1f]',tmp));
   end
   
   set(Hfgui,'UserData',{Hl Hui val rgb},'Visible','on')
   mmputptr(Hfgui)
   
elseif arg==-1  % Revert Callback
   Hfgui=findobj('Type','figure','Tag','MMSLINE');
   data=get(Hfgui,'Userdata');
   [Hl,Hui,val,rgb]=deal(data{:});
   Nl=size(Hl,1);
   for i=1:Nl
      set(Hui(i,1),'value',val(i,1))
      set(Hui(i,2),'value',val(i,2))
      set(Hui(i,3),'value',val(i,3))
      set(Hui(i,4),'value',val(i,4))
      set(Hui(i,5),'value',val(i,5))
      set(Hui(i,6),'value',val(i,6))
      set(Hui(i,7),'string',sprintf('[%.1f  %.1f  %.1f]',rgb(i,:)))
   end
   
elseif arg==-2  % Apply Callback
   styles=['- ';'--';': ';'-.';'no'];
   marks='o+.*xsd^v><phn';
   colors='ymcrgbwk';
   rgbm=[1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1;1 1 1;0 0 0];
   Hfgui=findobj('Type','figure','Tag','MMSLINE');
   data=get(Hfgui,'Userdata');
   [Hl,Hui,val,rgb]=deal(data{:});
   Nl=size(Hl,1);
   for i=1:Nl
      if ishandle(Hl(i));
         [vi,ls,lw,ms,sz,cc]=mmget(Hui(i,1:6),'value');
         set(Hl(i),'Visible',mmonoff(vi),...
            'LineStyle',styles(ls,:),...
            'Linewidth',lw/2,...
            'Marker',marks(ms),...
            'MarkerSize',2*(sz+1))
         if cc<9
            set(Hl(i),'Color',colors(cc))
            set(Hui(i,7),'String',sprintf('[%.1f  %.1f  %.1f]',rgbm(cc,:)))
         else
            tmp=eval(get(Hui(i,7),'String'),'rgb(i,:)');
            tmp=mmrgb(tmp(:).',rgb(i,:));
            set(Hl(i),'Color',tmp)
         end
      end
   end
end
