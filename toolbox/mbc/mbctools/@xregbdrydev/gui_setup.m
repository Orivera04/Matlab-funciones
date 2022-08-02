function [bdev, ok] = gui_setup( bdev, action, factors )
%GUI_SETUP   Model parameter setup for constraint modelling
%   [BDEV,OK] = GUI_SETUP(BDEV,'Create',FACTORS) creates a blocking
%   GUI for choosing a constraint model and it's parameters for the
%   boundary development object BDEV.  It returns an updated version of
%   BDEV andand OK, which indicates whether the user pressed 'OK' or
%   'CANCEL'. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:13:07 $

if nargin < 3,
    factors = {'X1', 'X2'};
    warning( 'No factor information passed into GUI_SETUP' );
end

% Creation routine

fig = xregfigure(...
    'name','Boundary Constraint Settings',...
    'visible','off',...
    'closerequestfcn','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
xregcenterfigure(fig,[600, 360]);
fig.minimumsize=[590, 260];
opts=getconstrainttypes(bdev);    % return list of constraint options
nf=length(factors);

ptr=[];
for n=1:length(opts)
   obj=feval(opts{n},nf);
   rng=nfactorsallowed(obj);
   if nf>=rng(1) & nf<=rng(2)
      ptr=[ptr xregGui.RunTimePointer(obj)];
   end
end
ud.objects=ptr;
ud.created=zeros(1,length(ptr));
infoptr=xregGui.RunTimePointer;

str={};
for n=1:length(ptr)
   str(n)={typename(ptr(n).info)};
end

startobj=bdev.Model;
if isempty( startobj ),
    startobj = ptr(1).info;
end
% find the current one 
ind=find(strcmp(str,typename(startobj)));
ud.objects(ind).info=startobj;
ud.showing=0;
ud.thisobj=bdev;
ud.Factors=factors;

tptxt=uicontrol('parent',fig,...
   'style','text',...
   'HorizontalAlignment','left',...
   'string','Constraint type:');
ud.tppop=uicontrol('parent',fig,...
   'style','popup',...
   'BackGroundColor','w',...
   'string',str,...
   'callback',{@i_typeselect,infoptr},...
   'value',ind);
ud.descriptxt=axestext(fig,'verticalalignment','top');
ud.descripim=xregGui.axesimage('parent',fig);

okbut=uicontrol('parent',fig,...
   'style','push',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'');');
cancbut=uicontrol('parent',fig,...
   'style','push',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'',''tag'',''cancel'');');

helpbtn=mv_helpbutton(fig,'xreg_bdryConstraintSettings');

grd=xreggridbaglayout(fig,'dimension',[1 4],...
   'colsizes',[-1 65 65 65],...
   'gapx',7,...
   'elements',{[],okbut,cancbut,helpbtn},...
   'packstatus','off');

grd2=xreggridbaglayout(fig,'dimension',[5 5],...
   'rowsizes',[10 3 15 2 10],...
   'colsizes',[85 -1 20 330 40],...
   'mergeblock',{[2 4],[2 2]},...
   'mergeblock',{[1 5],[4 4]},...
   'mergeblock',{[1 5],[5 5]},...
   'elements',{[],[],tptxt,[],[],...
      [],ud.tppop,[],[],[],...
      [],[],[],[],[],...
      ud.descriptxt,[],[],[],[],...
      ud.descripim});
frmtop=xregframetitlelayout(fig,'title','Available constraints',...
   'center',grd2);
ud.crd=xregcardlayout(fig,'numcards',length(ud.objects));
frmmid=xregframetitlelayout(fig,'title','Constraint options',...
   'center',ud.crd);

lyt=xreggridlayout(fig,'correctalg','on',...
   'dimension',[3 1],...
   'rowsizes',[66 -1 25],'gapy',10,...
   'border',[7 7 7 7],...
   'elements',{frmtop,frmmid,grd});

infoptr.info=ud;

fig.LayoutManager=lyt;
set(lyt,'packstatus','on');

% trigger creation of first options layout
i_typeselect(ud.tppop,[],infoptr);

set(fig,'visible','on');
drawnow;
set(fig,'windowstyle','modal');
goforclose=0;
while ~goforclose
   set(fig,'tag','');
   waitfor(fig,'tag');
   % code blocks and waits here
   tg=get(fig,'tag');
   if strcmp(tg,'ok')
      ud=infoptr.info;
      val=ud.showing;
      % call finalise on this object
      lyt=getcard(ud.crd,val);
      [ok,msg]=gui_setup(ud.objects(val).info,'finalise',lyt{1});
      if ok
         bdev.Model=ud.objects(val).info;
         xregpointer( bdev );
         goforclose = 1;
     else
         % reshow figure?
         for n=1:length(msg)
            h=errordlg(msg{n},'Constraint error','modal');
            drawnow;
            waitfor(h);
         end
      end  
   else
      goforclose = 1;  %cancel
      ok = false;
   end
end
delete(fig);
return

%------------------------------------------------------------------------------|
function i_typeselect(src,evt,ptr)
ud=ptr.info;
val=get(src,'value');
if val~=ud.showing
   fig=get(src,'parent');
   set(fig,'pointer','watch');
   set(ud.descriptxt,'string',texdescription(ud.objects(val).info));
   set(ud.descripim,'image',imread(largeicon(ud.objects(val).info),'bmp'));
   drawnow;
   if ~ud.created(val)
      % create and attach layout
      lyt=gui_setup(ud.objects(val).info,'layout',fig,ud.objects(val),ud.Factors);
      attach(ud.crd,lyt,val);
      set(ud.crd,'packstatus','on');
      ud.created(val)=1;
   end
   set(ud.crd,'currentcard',val);
   ud.showing=val;
   ptr.info=ud;
   set(fig,'pointer','arrow');
end

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
