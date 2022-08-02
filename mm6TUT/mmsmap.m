function mmsmap(arg)
%MMSMAP Set Figure Colormap using a GUI. (MM)
% MMSMAP creates a gui to set or modify the colormap in
% the current figure.
% MMSMAP(H) modifies the colormap in the figure having handle H.
%
% GUI Interface:
% Check Flip Up/Down to flip colormap upside down.
% 0 < Rotate < 100 to rotate the colormap by a percentage.
% -100 < Brighten < 100 to brighten the colormap by a percentage.
% 6 < length < 64 specifies the colormap length.
% RGB PopUp menu chooses RGB Order of colormap.
% PopUp menu chooses the desired colormap.
% 	initial is the colormap in use when MMSMAP is called.
% 	default is default figure colormap.
% Apply - apply changes to the colormap.
% Done - quit MMSMAP without making further changes.
%
% See also COLORMAP, RAINBOW, MMAP

% Calls: mmgcf mmisv5 mmdeal mmlimit mmap rainbow mmsetpos

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/2/96, v5: 1/14/97, 4/2/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0  % use current figure
   Hfgui=findall(0,'Type','figure','Tag','MMSMAP');
   if ~isempty(Hfgui) % GUI exists, just go to it
      figure(Hfgui)
      return
   end
   arg=mmgcf(1);
elseif arg>0  % use figure provided
   if ~strcmp(get(arg,'Type'),'figure')
      error('Handle Does Not Point to a Figure.')
   end
end
if arg>0  % Initialize gui
   Hf=arg;
   figure(Hf);
   rgb=get(0,'DefaultUicontrolBackgroundColor');
   gpos=[1 1 140 220];
   gpos=mmsetpos(gpos,Hf,'pixels','onleft','bottom');
   inimap=get(Hf,'Colormap');
   inilen=size(inimap,1);
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
      'Name','SETMAP',...
      'Color',rgb,...
      'Visible','off',...
      'Tag','MMSMAP');
   
   H_apply=uicontrol('Parent',Hfgui,'Style','pushbutton',... % Apply Button
      'Position',[10 10 55 20],...
      'String','Apply',...
      'Userdata',inimap,...
      'CallBack','mmsmap(-1)');
   
   H_done=uicontrol('Parent',Hfgui,'Style','pushbutton',...  % Done Button
      'Position',[75 10 55 20],...
      'String','Done',...
      'Userdata',inilen,...
      'CallBack','close(findobj(0,''Tag'',''MMSMAP''))');
   
   maps=['Bone|Cool|Copper|Flag|Gray|Hot|Hsv|Jet|Pink|Prism',...
         '|Spring|Summer|Autumn|Winter|'...
         'Rainbow|Yellow|Cyan|Magenta|Red|Green|Blue|Default|Initial Map|'];;
   inim=23;
   H_map=uicontrol('Parent',Hfgui,'Style','popup',...    % Choice Popup
      'Position',[10 40 120 20],...
      'String',maps,...
      'Value',inim);
   
   rgbs='R-G-B Order|B-R-G|G-B-R|B-G-R|G-R-B|R-B-G';
   H_rgb=uicontrol('Parent',Hfgui,'Style','popup',...    % RGB popup
      'Position',[10 70 120 20],...
      'String',rgbs,...
      'Value',1);
   
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[60 100 70 20],...
      'String','Length')
   H_len=uicontrol('Parent',Hfgui,'Style','edit',...     % Length Edit
      'Position',[10 100 45,20],...
      'String',sprintf('%.0f',inilen));
   
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[60 130 70 20],...
      'String','% Brighten')
   H_br=uicontrol('Parent',Hfgui,'Style','edit',...      % Brighten Edit
      'Position',[10 130 45,20],...
      'String','0');
   
   uicontrol('Parent',Hfgui,'Style','text',...
      'Position',[60 160 70 20],...
      'String','% Rotate')
   H_rot=uicontrol('Parent',Hfgui,'Style','edit',...     % Rotate Edit
      'Position',[10 160 45,20],...
      'String','0');
   
   H_inv=uicontrol('Parent',Hfgui,'Style','checkbox',... % Invert Check box
      'Position',[10 190 120,20],...
      'String','Flip Up/Down',...
      'Min',0,'Max',1,...
      'Value',0);	
   
   handles=[Hf H_apply H_done H_map H_rgb H_len H_br H_rot H_inv];
   set(Hfgui,'UserData',handles,'Visible','on')
   mmputptr(Hfgui)
   
elseif arg==-1  % Apply button
   Hfgui=findobj(0,'Tag','MMSMAP');
   handles=get(Hfgui,'UserData');
   [Hf,H_apply,H_done,H_map,H_rgb,H_len,H_br,H_rot,H_inv]=mmdeal(handles);
   
   len=eval(get(H_len,'String'),'64');
   len=mmlimit(abs(len),6,64);
   slen=sprintf('%.0f',len);
   set(H_len,'String',slen)
   
   brt=eval(get(H_br,'String'),'0');
   brt=mmlimit(brt,-99,99);
   set(H_br,'String',sprintf('%.0f',brt))
   
   rot=eval(get(H_rot,'String'),'0');
   rot=mmlimit(abs(rot),-100,100);
   set(H_rot,'String',sprintf('%.0f',rot))
   
   pop=get(H_map,'Value');
   maps=['    bone(';'    cool(';'  copper(';'    flag(';'    gray(';...
         '     hot(';'     hsv(';'     jet(';'    pink(';'   prism(';...
         '  spring(';'  summer(';'  autumn(';'  winter(';...
         ' rainbow(';'mmap(''y'',';'mmap(''c'',';'mmap(''m'',';...
         'mmap(''r'',';'mmap(''g'',';'mmap(''b'','];
   lmap=size(maps,1);
   if pop<=lmap          % use selected colormap
      eval(['cmap=' maps(pop,:) slen ');']);
   elseif pop==(lmap+1)  % use default colormap
      cmap=get(0,'DefaultFigureColorMap');
      len=size(cmap,1);
      set(H_len,'String',sprintf('%.0f',len))
   else                  % revert to initial colormap
      cmap=get(H_apply,'Userdata');
      len=get(H_done,'Userdata');
      set(H_len,'String',sprintf('%.0f',len))
   end
   if brt~=0  % brighten selected colormap
      cmap=brighten(cmap,brt/100);
   end
   if rot~=0  % rotate selected colormap
      irot=round(rot*len/100)+1;
      ic=rem((irot:irot+len-1),len)+1;
      cmap=cmap(ic,:);
   end
   if get(H_inv,'Value')==1  % flip up/down selected colormap
      cmap=cmap(len:-1:1,:);
   end
   pop=get(H_rgb,'Value');
   if     pop==2, cmap=cmap(:,[3 1 2]);
   elseif pop==3, cmap=cmap(:,[2 3 1]);
   elseif pop==4, cmap=cmap(:,[3 2 1]);
   elseif pop==5, cmap=cmap(:,[2 1 3]);
   elseif pop==6, cmap=cmap(:,[1 3 2]);
   end	
   
   set(Hf,'Colormap',cmap)  % Finally do the job!
end
