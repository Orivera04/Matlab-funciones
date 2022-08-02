function [dout,ok]=gui_candspace(des,action,figh,ptr,varargin)
% GUI_CANDSPACE   GUI interface for the candspace settings
%
%  [D,OK]=GUI_CANDSPACE(D,'figure') creates a blocking figure
%  for editing the candidate set definitions.
%
%  LYT=GUI_CANDSPACE(D,'layout',FIG,PTR[,'callback',CBSTR])
%  creates and returns a layout object containg the gui for
%  editing the design D.  FIG is the figure to place the layout in.
%  PTR is a pointer to the design, used to maintain a dynamic
%  link with other parst of a GUI.  The optional arguments
%  'callback',CBSTR may be specified to have a callback function
%  evaluated whenever the set definition changes.
%
%  The callback string may contain the keywords %OBJECT% and %POINTER%
%  which will be parsed out and replaced with copies of the design object 
%  and the pointer to the object respectively.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:06:46 $



if nargin<2
   action='figure';
end

switch lower(action)
case 'figure'
   [dout,ok]=i_createfig(des);
case 'layout'
   dout=i_createlyt(figh,ptr,varargin{:});
   ok=1;
case 'finalise'
   i_finalise(figh);
end



function [dout,ok]=i_createfig(des)
% create figure
scr=get(0,'screensize');
figh=figure('visible','off',...
   'menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Candidate Set',...
   'doublebuffer','on',...
   'tag','CandSpace',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',[scr(3)*0.5-185 scr(4)*0.5-160 370 380],...
   'resize','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

% There are problems changing design candidate settings when 
% constraints are present.  This is a well neat fudge - remove
% the constraints temporarily!

saved_c=des.constraints;
des.constraints=[];

ptr=xregpointer(des);
[lyt,cptr]=i_createlyt(figh,ptr);
set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'');');
helpbtn=mv_helpbutton(figh,'xreg_desCandSet','position',[0 0 65 25]);

fl=xregflowlayout(figh,'orientation','right/center',...
   'gap',7,...
   'border',[0 0 -7 0],...
   'packstatus','off',...
   'elements',{helpbtn,cancbtn,okbtn});

mainlay=xregborderlayout(figh,...
   'container',figh,...
   'south',fl,...
   'center',lyt,...
   'innerborder',[10 45 10 10],...
   'packstatus','on');   

% block
set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');
dogui=1;
while dogui
   waitfor(figh,'tag');
   tg=get(figh,'tag');
   switch tg
   case 'ok'
      % finalise action allows property pages to action on settings
      i_finalise(lyt);
      % check the design definition isn't too big - if it is then
      % warn, with the possibility of not applying constraints yet.
      dout=ptr.info;
      if ~checkcandsize(dout)
         % warn user
         btn=questdlg(sprintf(['These candidate settings define a large candidate set (%d points).  ' ...
               'Too large a set may lock up your computer if used with constraints.  Do you want to ' ...
               'continue or go back and alter the settings?'], ncand(dout)),...
            'Warning','Continue','Alter','Alter');
         if strcmp(btn,'Continue')
            dout.constraints=saved_c;
            dout=EvalConstraints(dout);
            ok=1;
            dogui=0;
         else
            set(figh,'tag','CandSpace');
         end
      else
         dout.constraints=saved_c;
         dout=EvalConstraints(dout);
         ok=1;
         dogui=0;
      end
   case 'cancel'
      des.constraints=saved_c;
      dout=des;
      ok=0;
      dogui=0;
   end
end

% free pointer
freeptr(ptr);
delete(figh);
return



function [lyt,cptr]=i_createlyt(figh,ptr,varargin)

if ~isa(figh,'xregcontainer')
   csI=csetinterface;
   csI=set(csI,'typefilter',0);
   ud.pointer=ptr;
   ud.cspointer= xregGui.RunTimePointer(candspace(ud.pointer.info));
   ud.cspointer.LinkToObject(figh);
   ud.figure=figh;
   ud.funcs=get(csI,'classNames');
   ud.lytsdone=zeros(1,length(ud.funcs));
   ud.model=model(ud.pointer.info);          % used for coding/invcoding, not changed
   
   ud.unitsopt=xreguicontrol('parent',figh,...
      'style','checkbox',...
      'string','View coded values',...
      'value',0,...
      'visible','off');
   ud.txt1=xreguicontrol('style','text',...
      'parent',figh,...
      'string','Generation algorithm:',...
      'horizontalalignment','left',...
      'visible','off',...
      'enable','inactive');
   ud.popup=xreguicontrol('parent',figh,...
      'style','popupmenu',...
      'string',get(csI,'FullNames'),...
      'userdata',xregdesign,...
      'backgroundcolor','w',...
      'visible','off');
   ud.reps=xreguicontrol('parent',figh,...
      'style','checkbox',...
      'string','Allow replicated points in design',...
      'visible','off');
   udh=ud.txt1;
   set(ud.popup,'callback',{@i_algchng,udh});
   set(ud.reps,'callback',{@i_reps,udh});
   set(ud.unitsopt,'callback',{@i_units,udh});
   ud.callback='';
   ud.updatenow=1;
   if nargin>2
      for n=1:2:length(varargin)
         switch lower(varargin{n})
         case 'callback'
            ud.callback=varargin{n+1};
         end
      end
   end
   
   ud.crd=xregcardlayout(figh,...
      'visible','off',...
      'numcards',length(ud.funcs),...
      'packstatus','off');
   grd=xreggridlayout(figh,'correctalg','on','dimension',[2 1],'rowsizes',[20 -1],...
      'gapy',5,'elements',{ud.unitsopt,ud.crd});
   frm=xregframetitlelayout(figh,...
      'visible','off',...
      'title','Options',...
      'innerborder',[10 10 10 10],...
      'center',grd);
   lyt=xreggridbaglayout(figh,'correctalg','on',...
      'dimension',[7 3],...
      'rowsizes',[3 15 2 10 20 10 -1],...
      'colsizes',[105 150 -1],...
      'gapx',10,...
      'mergeblock',{[5 5],[1 2]},...
      'mergeblock',{[7 7],[1 3]},...
      'mergeblock',{[1 3],[2 2]},...
      'elements',{[],ud.txt1,[],[],ud.reps,[],frm,ud.popup},...
      'userdata',udh);
   ud.layout=lyt; 
else
   % update using given layout
   udh=get(figh,'userdata');
   ud=get(udh,'userdata');
   ud.pointer=ptr;
   if nargin>2
      for n=1:2:length(varargin)
         switch lower(varargin{n})
         case 'callback'
            ud.callback=varargin{n+1};
         end
      end
   end
   lyt=figh;
end
ud=i_setvalues(ud);
set(udh,'userdata',ud);
cptr=ud.cspointer;
return




function ud=i_setvalues(ud);
des=ud.pointer.info;
csI=csetinterface;
csI=set(csI,'typefilter',0);

% reps checkbox
set(ud.reps,'value',allowreps(des));

% decide alg type
popval=strmatch(class(des.candset),ud.funcs);
set(ud.popup,'value',popval);

if ~ud.lytsdone(popval)
   % create options and attach
   lyt=propertypage(ud.cspointer.info,'layout',ud.figure,'callback',{@i_csetchng,ud.txt1});
   lyt=propertypage(ud.cspointer.info,'update',lyt,ud.cspointer,ud.model);
   attach(ud.crd,lyt,popval);
   set(lyt,'packstatus','on');
   ud.lytsdone(popval)=1;
else
   % update current
   lyt=getcard(ud.crd,popval);
   lyt=propertypage(ud.cspointer.info,'update',lyt{1},ud.cspointer,ud.model);
end
% select popval page
set(ud.crd,'currentcard',popval);
return


function i_algchng(obj,nul,udh)
ud=get(udh,'userdata');
des=ud.pointer.info;
cs=ud.cspointer.info;
popval=get(ud.popup,'value');

if get(ud.crd,'currentcard')==popval
   return
end
set(ud.figure,'pointer','watch');

CS=toCandidateSet(cs);
cs=feval(ud.funcs{popval},CS);
ud.cspointer.info=cs;
des.candset=cs;
des.designindex(:)=0;
des.candstate=des.candstate+1;
ud.pointer.info=des;

if ~ud.lytsdone(popval)
   % create options and attach
   lyt=propertypage(cs,'layout',ud.figure,'callback',{@i_csetchng,ud.txt1});
   lyt=propertypage(cs,'update',lyt,ud.cspointer,ud.model);
   attach(ud.crd,lyt,popval);
   set(lyt,'packstatus','on');
   ud.lytsdone(popval)=1;
else
   % update current
   lyt=getcard(ud.crd,popval);
   lyt=propertypage(cs,'update',lyt{1},ud.cspointer,ud.model);
end
% select popval page
set(ud.crd,'currentcard',popval);
set(udh,'userdata',ud);
if ~isempty(ud.callback)
   i_firecb(ud);
end
set(ud.figure,'pointer','arrow');
return



function i_firecb(ud)
xregcallback(ud.callback,[],[]);
return



function i_reps(obj,nul,udh)
ud=get(udh,'userdata');
ud.pointer.info=allowreps(ud.pointer.info,get(ud.reps,'value'));
if ~isempty(ud.callback)
   i_firecb(ud);
end
return

function i_csetchng(obj,nul,udh)
% Candidate set property page has been altered
ud=get(udh,'userdata');
des=ud.pointer.info;
des.candset=ud.cspointer.info;
des.designindex(:)=0;
des.candstate=des.candstate+1;
ud.pointer.info=des;
if ~isempty(ud.callback)
   i_firecb(ud);
end
return


function i_units(obj,nul,udh)
ud=get(udh,'userdata');
% update layout with correct model
if get(ud.unitsopt,'value')
   % coded - set model limits to be same as target limits
   m=model(ud.pointer.info);
   [bnds,g,tgt]=getcode(m);
	tgt= gettarget(m);
   m=setcode(m,tgt,g,tgt);
   ud.model=m;
else
   % natural
   ud.model=model(ud.pointer.info);
end
set(udh,'userdata',ud);
lyt=getcard(ud.crd,get(ud.crd,'currentcard'));
propertypage(ud.cspointer.info,'update',lyt{1},ud.cspointer,ud.model);
return

function i_finalise(lyt)
% finalise the cset selection.
% get handle to ud
udh=get(lyt,'userdata');
ud=get(udh,'userdata');
crds=getcard(ud.crd,get(ud.crd,'currentcard'));
propertypage(ud.cspointer.info,'finalise',crds{1});
return
