function [dout,ok]=gui_reset(d,action,figh,ptr,varargin)
%GUI_RESET GUI for reinitialising design
%
%  [D,OK]=GUI_RESET(D) brings up a gui for reinitialising a design.
%  D=GUI_RESET(D,'layout',figh,ptr,callback) create the layout version.
%  OK=GUI_RESET(D,'finalise',lyt)  finalises the layout and returns an ok flag
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:27:12 $


if nargin<2
   action='create';
end


switch lower(action)
case 'layout'
   dout=i_createlyt(d,figh,ptr,varargin{:});
   ok=1;
case 'create'
   [dout,ok]=i_createfig(d);
case 'finalise'
   dout=i_finalise(figh);

end
return




function [dout,ok]=i_createfig(d);
% precheck the design to make sure it will initialise
minp=min_points(d);
if isempty(minp)
   h=errordlg(['No points were found that will initialize this design with valid ',...
         'factor settings.  Check that the candidate set has not been over-constrained'],...
      'Error','modal');
   waitfor(h);
   dout=d;
   ok=0;
   return
end

scr=get(0,'screensize');
figh=xregdialog('name','Reset Design',...
   'tag','design_reinit',...
   'position',[scr(3)*0.5-150 scr(4)*0.5-125 270 300],...
   'resize','off');

ptr= xregGui.RunTimePointer(d);
lyt=i_createlyt(d,figh,ptr);
set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');');   


biglyt=xreggridbaglayout(figh,'dimension',[2 3],...
   'rowsizes',[-1 25],'colsizes',[-1 65 65],...
   'gapy',10,'gapx',7,...
   'border',[10 10 10 10],...
   'mergeblock',{[1 1],[1 3]},...
   'packstatus','off',...
   'elements',{lyt,[],[],okbtn,[],cancbtn});


figh.LayoutManager=biglyt;
set(biglyt,'packstatus','on');
figh.showDialog(okbtn);


tg=get(figh,'tag');
if strcmp(tg,'ok')
   ok=i_finalise(lyt);   % apply the re-init
   dout=ptr.info;
   ok=1;
else
   dout=d;
   ok=0;
end
delete(figh);  
return





function mainlyt=i_createlyt(des,figh,ptr,varargin)

if ~isa(figh,'xregcontainer')
   if nargin>3
      if strcmp(lower(varargin{1}),'callback')
         cbstr=varargin{2};
      else
         cbstr='';
      end
   else
      cbstr='';
   end
   ud.fromcurrent=0;
   ud.totalp=0;
   ud.callback=cbstr;
   ud.pointer=ptr;
   ud.minp=0;
   
   udptr=xregGui.RunTimePointer;
   ud.rbg=xregGui.rbgroup('parent',double(figh),...
      'visible','off',...
      'nx',1,'ny',3,...
      'string',{'Keep current design points'; ...
          'Keep current fixed design points'; ...
          'Do not keep any current design points'},...
      'gapy',2,...
      'callback',{@i_radioclick,udptr});
   
   txt(1)=uicontrol('style','text',...
      'parent',figh,...
      'string','Points from current design:',...
      'horizontalalignment','left',...
      'visible','off');
   txt(2)=uicontrol('style','text',...
      'parent',figh,...
      'string','Minimum additional points required:',...
      'horizontalalignment','left',...
      'visible','off');
   txt(3)=uicontrol('style','text',...
      'parent',figh,...
      'string','Optional additional points:',...
      'horizontalalignment','left',...
      'visible','off');
   txt(4)=uicontrol('style','text',...
      'parent',figh,...
      'string','Total number of points:',...
      'horizontalalignment','left',...
      'visible','off',...
      'fontweight','bold');
   
   ud.current=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off');
   ud.minextra=uicontrol('style','text',...
      'parent',figh,...
      'horizontalalignment','left',...
      'visible','off');
   ud.extra = xregGui.clickedit('parent',double(figh),...
      'min',0,...
      'clickincrement',1,...
      'dragincrement',5,...
      'rule','int',...
      'horizontalalignment','left',...
      'visible','off',...
      'callback',{@i_extraclick,udptr});
   ud.total = xregGui.clickedit('parent',double(figh),...
      'min',0,...
      'clickincrement',1,...
      'dragincrement',5,...
      'rule','int',...
      'horizontalalignment','left',...
      'visible','off',...
      'fontweight', 'bold', ...
      'callback',{@i_totalclick,udptr});
   
   
   grd=xreggridlayout(figh,'dimension',[1 1],...
      'rowsizes',64,...
      'correctalg','on',...
      'packstatus','off',...
      'elements',{ud.rbg});
   frmtop=xregframetitlelayout(figh,...
      'visible','off',...
      'title','Initial Points From Current Design',...
      'center',grd,...
      'innerborder',[15 10 10 10]);
   
   grd=xreggridbaglayout(figh,'dimension',[11 2],...
      'rowsizes',[15 5 15 5 3 15 2 5 3 15 2],...
      'colsizes',[170 60],...
      'gapx',10,...
      'mergeblock',{[5 7],[2 2]},...
      'mergeblock',{[9 11],[2 2]},...
      'elements',{txt(1),[],txt(2),[],[],txt(3),[],[],[],txt(4),[],...
         ud.current,[],ud.minextra,[],ud.extra,[],[],[],ud.total});
   frmbtm=xregframetitlelayout(figh,...
      'visible','off',...
      'title','Additional Design Points',...
      'center',grd,...
      'innerborder',[15 10 10 10]);
   mainlyt=xreggridlayout(figh,'correctalg','on',...
      'dimension',[2 1],...
      'gapy',10,...
      'elements',{frmtop,frmbtm},...
      'userdata',udptr);
   udptr.info=ud; 
   i_initud(udptr);
   i_radioclick([],[],udptr);
else
   % update with new pointer
   mainlyt=figh;
   udptr=get(mainlyt,'userdata');
   ud=udptr.info;
   ud.pointer=ptr;
   udptr.info=ud;
   i_radioclick([],[],udptr);
end
return


function i_initud(p)
ud=p.info;
des=ud.pointer.info;

minp=min_points(des);
if isempty(minp)
   minp=0;
end
ud.minp=minp;

% decide which options in radio-button group are available
if npoints(des)
   if length(fixpoints(des))
      envect=[1;1;1];
      sel=1;
   else
      envect=[1;0;1];
      sel=1;
   end
else
   envect=[0;0;1];
   sel=3;
end
set(ud.rbg,'enablearray',envect,'selected',sel);

val=get(ud.rbg,'selected');
switch val
case 1
   ud.fromcurrent=npoints(des);
case 2
   ud.fromcurrent=length(fixpoints(des));
case 3
   ud.fromcurrent=0;
end

ud.totalp=max(ud.minp,ud.fromcurrent)+ud.extra.value;
p.info=ud;
return



function i_extraclick(src,evt,p)
ud = p.info;
ud.totalp = max(ud.minp,ud.fromcurrent)+ud.extra.value;
p.info = ud;
ud.total.value = ud.totalp;


function i_totalclick(src,evt,p)
ud = p.info;
ud.totalp = ud.total.value;
p.info = ud;
needed = max(0,ud.minp-ud.fromcurrent);
extra = max(0,ud.totalp-ud.fromcurrent-needed);
ud.extra.value = extra;


function i_radioclick(src,evt,p)
ud=p.info;
des=ud.pointer.info;
% try to keep total number of points the same
val=get(ud.rbg,'selected');
switch val
case 1
   ud.fromcurrent=npoints(des);
case 2
   ud.fromcurrent=length(fixpoints(des));
case 3
   ud.fromcurrent=0;
end
needed=max(0,ud.minp-ud.fromcurrent);
extra=max(0,ud.totalp-ud.fromcurrent-needed);
ud.extra.value = extra;

ud.totalp=ud.fromcurrent+needed+extra;
set(ud.total, 'value', ud.totalp, ...
    'min', max(ud.minp,ud.fromcurrent));

set([ud.current;ud.minextra],{'string'},...
   {sprintf(' %d',ud.fromcurrent); sprintf(' %d',needed)});
p.info=ud;
return



function ok=i_finalise(lyt)
ptr=get(lyt,'userdata');
ud=ptr.info;
val=get(ud.rbg,'selected');
des=ud.pointer.info;

ok=0;
n=0;
while ~ok &n<=10
   n=n+1;
   switch val
   case 1
      np=max(0,ud.minp-ud.fromcurrent)+ud.extra.value;
      des=augment(des,np);
   case 2
      des=deletefreepoints(des);
      np=max(0,ud.minp-ud.fromcurrent)+ud.extra.value;
      des=augment(des,np);
   case 3
      des=clear(des);
      des=augment(des,ud.totalp);
   end
   ok=rankcheck(des);
end

ud.pointer.info=des;
xregcallback(ud.callback);
return