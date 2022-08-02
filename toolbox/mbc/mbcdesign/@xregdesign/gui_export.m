function [d,ok]=gui_export(d,varargin)
%GUI_EXPORT Export GUI for designs
%
%  GUI_EXPORT(D)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.4 $  $Date: 2004/04/04 03:27:08 $

if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [d,ok]=i_createfig(d);
end
return



function [dout,ok]=i_createfig(d)


figh=xregdialog('name','Export Design',...
   'resize','off');
xregcenterfigure(figh,[360 250]);


lyt=i_createlyt(d,figh);

okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'interruptible','off',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'interruptible','off',...
   'callback','set(gcbf,''visible'',''off'');');
helpbtn=mv_helpbutton(figh,'xreg_desExport');
grd=xreggridbaglayout(figh,...
   'dimension',[2 4],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65 65],...
   'gapy',10,'gapx',7,...
   'border',[7 7 7 7],...
   'mergeblock',{[1 1],[1 4]},...
   'elements',{lyt,[],[],okbtn,[],cancbtn,[],helpbtn});
figh.LayoutManager=grd;
set(grd,'packstatus','on');

figh.showDialog(okbtn);

tg=get(figh,'tag');
if ~isempty(tg)
   i_export(lyt);
   dout=d;
   ok=1;
else
   dout=d;
   ok=0;
end
delete(figh);

return



function lyt=i_createlyt(d,figh)

udp=xregGui.RunTimePointer;
udp.LinkToObject(figh);

ud.design=d;
ud.txt1=uicontrol('parent',figh,...
   'style','text',...
   'string','Export to:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.txt2=uicontrol('parent',figh,...
   'style','text',...
   'string','Destination file:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.txt3=uicontrol('parent',figh,...
   'style','text',...
   'string','Export as:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.export=uicontrol('parent',figh,...
   'style','popupmenu',...
   'string',{'Design Editor file (*.mvd)','Comma separated format file (*.csv)', 'Workspace'},...
   'interruptible','off',...
   'backgroundcolor','w',...
   'callback',{@i_setopts,udp});
ud.dest=uicontrol('parent',figh,...
   'style','edit',...
   'string','',...
   'interruptible','off',...
   'horizontalalignment','left');
ud.destname=uicontrol('parent',figh,...
   'style','edit',...
   'string','',...
   'interruptible','off',...
   'horizontalalignment','left',...
   'callback',{@i_setname});
ud.destfile=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','...',...
   'interruptible','off',...
   'callback',{@i_getfile,udp});
ud.code=uicontrol('parent',figh,...
   'style','checkbox',...
   'value',0,...
   'enable','off',...
   'string','Convert design points to [-1 1] range');
ud.symb=uicontrol('parent',figh,...
   'style','checkbox',...
   'value',1,...
   'enable','off',...
   'string','Include factor symbols');


grd=xreggridbaglayout(figh,...
   'packstatus','off',...
   'dimension',[11 4],...
   'rowsizes',[3 15 2 5 3 15 2 10 20 5 20],...
   'colsizes',[85 100 -1 20],...
   'gapx',5,...
   'mergeblock',{[1 3],[2 3]},...
   'mergeblock',{[1 3],[4 4]},...
   'mergeblock',{[5 7],[2 2]},...
   'mergeblock',{[9 9],[1 4]},...
   'mergeblock',{[11 11],[1 4]},...
   'elements',{[],ud.dest,[],ud.destfile;...
      ud.txt2,[],[],[];...
      [],[],[],[];...
      [],[],[],[];...
      [],ud.destname,[],[];...
      ud.txt3,[],[],[];...
      [],[],[],[];...
      [],[],[],[];...
      ud.code,[],[],[];...
      [],[],[],[];...
      ud.symb,[],[],[]});
   
frm=xregframetitlelayout(figh,'title','Export Options',...
   'center',grd,'innerborder',[15 10 10 10]);

lyt=xreggridbaglayout(figh,...
   'dimension',[5 2],...
   'rowsizes',[3 15 2 10 -1],...
   'colsizes',[60 -1],...
   'mergeblock',{[5 5],[1 2]},...
   'mergeblock',{[1 3],[2 2]},...
   'elements',{[],ud.txt1,[],[],frm,ud.export},...
   'userdata',udp);

udp.info=ud;
i_setvalues(udp)
i_doEnable(udp);
return



function i_setvalues(udp)
ud=udp.info;
set([ud.dest;ud.destname],{'string'},{[name(ud.design) '.mvd'];validmlname(name(ud.design),'d')});
set(ud.destname,'userdata',get(ud.destname,'string'));
return



function i_doEnable(udp)
% set correct enable settings for options
ud=udp.info;
sc=xregGui.SystemColorsDbl;
switch get(ud.export,'value')
case 1
   en={'on';'on';'on';'off';'off';'off';'off'};
   clr={[1 1 1];sc.CTRL_BACK};
case 2
   en={'on';'on';'on';'off';'off';'on';'on'};
   clr={[1 1 1];sc.CTRL_BACK};
case 3
   en={'off';'off';'off';'on';'on';'on';'off'};
   clr={sc.CTRL_BACK;[1 1 1]};
end
set([ud.txt2;ud.dest;ud.destfile;ud.txt3;ud.destname;ud.code;ud.symb],{'enable'},en);
set([ud.dest;ud.destname],{'backgroundcolor'},clr);
return


function i_doName(udp)
ud=udp.info;
str=get(ud.dest,'string');
val=get(ud.export,'value');
switch val
case 1
   [p,f,e]=fileparts(str);
   str=fullfile(p,[f '.mvd']);
   set(ud.dest,'string',str);
case 2
   [p,f,e]=fileparts(str);
   str=fullfile(p,[f '.csv']);
   set(ud.dest,'string',str);
end
return

function i_setopts(src,evt,udp)
% callback from main popup
i_doEnable(udp);
i_doName(udp);
return


function i_getfile(src,evt,udp)
% callback from file choosing button
ud=udp.info;
switch get(ud.export,'value')
case 1
   spec='*.mvd';
case 2
   spec='*.csv';
end
defp = fullfile(xregGetDefaultDir('Designs'), spec);

[f,p]=uiputfile(defp);
if f~=0
   [nul,nul,ext]=fileparts(f);
   if isempty(ext)
      f=[f spec(2:end)];
   end
   set(ud.dest,'string',fullfile(p,f));
end
return


function i_setname(src,evt)
% callback from name 
str=get(src,'string');
if isvarname(str)
   set(src,'userdata',str);
else
   h=errordlg([str 'is not a valid MATLAB name.'],'MBC Toolbox','modal');
   waitfor(h);
   set(src,'string',get(src,'userdata'));
end
return



function i_export(lyt)
udp=get(lyt,'userdata');
ud=udp.info;
d=ud.design;
switch get(ud.export,'value')
case 1
   % mvd file
   [ok,err]= exporttofile(d,get(ud.dest,'string'));
case 2
   % csv file
   [ok,err]= exporttocsv(d,get(ud.dest,'string'),get(ud.code,'value'),get(ud.symb,'value'));
case 3
   % workspace
   fs=invcode(model(d),factorsettings(d));
   if get(ud.code,'value')
      % code to [-1 1] space
      realm=model(d);
      newm=xregmodel('nfactors',nfactors(realm));
      newm=copymodel(realm,newm);
      fs=code(newm,fs);
   end
   assignin('base',get(ud.destname,'string'),fs);
   ok=1;
end
if ~ok
   h=errordlg([sprintf('An error occurred while exporting the design:\n') err],'MBC Toolbox','modal');
   drawnow;
   waitfor(h);
end
return
