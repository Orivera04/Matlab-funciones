function [d,ok]=gui_import(d,varargin)
%GUI_IMPORT Import GUI for designs
%
%  [D,OK]=GUI_IMPORT(D)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:27:09 $

if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [d,ok]=i_createfig(d);
end
return



function [dout,ok]=i_createfig(d)


figh=xregdialog('name','Import Design',...
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
helpbtn=mv_helpbutton(figh,'xreg_desImport');
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
   [dout,ok]=i_import(lyt);
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
   'string','Import from:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.txt2=uicontrol('parent',figh,...
   'style','text',...
   'string','Source file:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.txt3=uicontrol('parent',figh,...
   'style','text',...
   'string','Source variable:',...
   'hittest','off',...
   'enable','inactive',...
   'horizontalalignment','left');
ud.import=uicontrol('parent',figh,...
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
   'userdata','',...
   'callback',{@i_setname,udp});
ud.destfile=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','...',...
   'interruptible','off',...
   'callback',{@i_getfile,udp});
ud.destnamebutton=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','...',...
   'interruptible','off',...
   'callback',{@i_getvar,udp});
ud.code=uicontrol('parent',figh,...
   'style','checkbox',...
   'value',0,...
   'enable','off',...
   'string','Convert design points from [-1 1] range');

grd=xreggridbaglayout(figh,...
   'packstatus','off',...
   'dimension',[9 4],...
   'rowsizes',[3 15 2 5 3 15 2 10 20],...
   'colsizes',[85 100 -1 20],...
   'gapx',5,...
   'mergeblock',{[1 3],[2 3]},...
   'mergeblock',{[1 3],[4 4]},...
   'mergeblock',{[5 7],[2 3]},...
   'mergeblock',{[5 7],[4 4]},...
   'mergeblock',{[9 9],[1 4]},...
   'elements',{[],ud.dest,[],ud.destfile;...
      ud.txt2,[],[],[];...
      [],[],[],[];...
      [],[],[],[];...
      [],ud.destname,[],ud.destnamebutton;...
      ud.txt3,[],[],[];...
      [],[],[],[];...
      [],[],[],[];...
      ud.code,[],[],[]});
   
frm=xregframetitlelayout(figh,'title','Import Options',...
   'center',grd,'innerborder',[15 10 10 10]);

lyt=xreggridbaglayout(figh,...
   'dimension',[5 2],...
   'rowsizes',[3 15 2 10 -1],...
   'colsizes',[70 -1],...
   'mergeblock',{[5 5],[1 2]},...
   'mergeblock',{[1 3],[2 2]},...
   'elements',{[],ud.txt1,[],[],frm,ud.import},...
   'userdata',udp);

udp.info=ud;
i_setvalues(udp)
i_doEnable(udp);
return



function i_setvalues(udp)
ud=udp.info;
%set([ud.dest;ud.destname],{'string'},{[name(ud.design) '.mvd'];validmlname(name(ud.design),'d')});
%set(ud.destname,'userdata',get(ud.destname,'string'));
return



function i_doEnable(udp)
% set correct enable settings for options
ud=udp.info;
sc=xregGui.SystemColorsDbl;
switch get(ud.import,'value')
case 1
   en={'on';'on';'on';'off';'off';'off';'off'};
   clr={[1 1 1];sc.CTRL_BACK};
case 2
   en={'on';'on';'on';'off';'off';'off';'on'};
   clr={[1 1 1];sc.CTRL_BACK};
case 3
   en={'off';'off';'off';'on';'on';'on';'on'};
   clr={sc.CTRL_BACK;[1 1 1]};
end
set([ud.txt2;ud.dest;ud.destfile;ud.txt3;ud.destname;ud.destnamebutton;ud.code],{'enable'},en);
set([ud.dest;ud.destname],{'backgroundcolor'},clr);
return


function i_setopts(src,evt,udp)
% callback from main popup
i_doEnable(udp);
return


function i_getfile(src,evt,udp)
% callback from file choosing button
ud=udp.info;
switch get(ud.import,'value')
case 1
   spec='*.mvd';
case 2
   spec='*.csv';
end

defp = fullfile(xregGetDefaultDir('Designs'), spec);

[f,p]=uigetfile(defp);
if f~=0
   set(ud.dest,'string',fullfile(p,f));
end
return


function i_getvar(src,evt,udp)
ud=udp.info;

[x,ok,s]=mv_getmatrix([NaN,nfactors(ud.design)],'double');
if ok
   set(ud.destname,'string',s);
end
return


function i_setname(src,evt,udp)
% callback from name 
str=get(src,'string');
ud=udp.info;
if isvarname(str)
   exist= evalin('base',['who(''' str ''')']);
   if ~isempty(exist)
      X=evalin('base',str);
      if isnumeric(X) & size(X,2)==nfactors(ud.design)
         set(src,'userdata',str);
         doerror=0;
      else
         doerror=1;
      end
   else
      doerror=1;
   end
else
   doerror=1;
end
if doerror
   h=errordlg([str ' does not exist or does not have the correct number of columns.'],'MBC Toolbox','modal');
   waitfor(h);
   set(src,'string',get(src,'userdata'));
end
return




function [d,ok]=i_import(lyt)
udp=get(lyt,'userdata');
ud=udp.info;
d=ud.design;
switch get(ud.import,'value')
case 1
   % mvd file
   str=get(ud.dest,'string');
   if ~isempty(str)
      [d,ok,err]= importfromfile(d,str);
   else
      ok=0;
      err='No filename specified.';
   end
case 2
   % csv file
   str=get(ud.dest,'string');
   if ~isempty(str)
      [d,ok,err]= importfromcsv(d,get(ud.dest,'string'),get(ud.code,'value'));
   else
      ok=0;
      err='No filename specified.';
   end
case 3
   % workspace
   str=get(ud.destname,'string');
   if ~isempty(str)
      d=ud.design;
      fs=evalin('base',str);
      realm=model(d);
      if get(ud.code,'value')
         % invcode from [-1 1] space
         newm=xregmodel('nfactors',nfactors(realm));
         newm=copymodel(realm,newm);
         fs=invcode(newm,fs);
      end
      % code back to target range for the design object
      fs=code(realm,fs);
      % put into design object
      d=reinit(d,fs,'defined');
      ok=1;
   else
      ok=0;
      err='No variable name specified.';
   end
end
if ~ok
   h=errordlg([sprintf('An error occurred while importing the design:\n') err],'MBC Toolbox','modal');
   waitfor(h);
end
return
