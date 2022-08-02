function [dout,ret]=gui_addpoints(des,action,varargin)
%GUI_ADDPOINTS Gui for adding design points
%
%  [D,RET]=GUI_ADDPOINTS(D) brings up a GUI for manually adding points to a
%  design.  The GUI blocks until OK/Cancel has been pressed RET is set to 0
%  if cancel was pressed, 1 otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.4 $  $Date: 2004/04/04 03:27:07 $


% Note: this dialog is unusual in that no changes are made until OK is pressed
% i.e. the dynamic design pointer is not used for on-the-fly updating


if nargin<2
   action='create';
end

switch lower(action)
case 'create'
   [dout,ret]=i_createfig(des,varargin{:});
case 'layout'
   % no support yet   
end




function [dout,ok]=i_createfig(des,varargin)
scrpos=get(0,'screensize');
figh=xregdialog('visible','off',...
   'name','Add Design Points',...
   'resize','off',...
   'tag','');
xregcenterfigure(figh,[350 300]);

p=xregpointer(des);
lyt=i_createlyt(figh,p,varargin{:});
set(lyt,'visible','on');
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
   'interruptible','off');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');',...
   'interruptible','off');
helpbtn=mv_helpbutton(figh,'xreg_desAddPoints');
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

%dialog blocks here

tg=get(figh,'tag');
if ~isempty(tg)
   i_finalise(lyt);
   dout=p.info;
   ok=1;
else
   dout=des;
   ok=0;
end
delete(figh);
freeptr(p);




function L=i_createlyt(F,p,varargin)

NP=1;
if nargin>2
   % parse additional options
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'npoints'
         NP=varargin{n+1};
      end
   end
end

ud.despointer=p;
[ud.optsinfo,ud.defopt]=gui_augmethods(ud.despointer.info);
ud.currentpopval=0;
ud.currentopt=ud.defopt(1);
ud.drawn=zeros(1,length(ud.optsinfo));

udh=xregGui.RunTimePointer;
udh.LinkToObject(F);

ud.algpop=xregGui.labelcontrol('parent',F,...
   'visible','off',...
   'string','Augment method:',...
   'labelsizemode','absolute',...
   'labelsize',100,...
   'controlsizemode','absolute',...
   'controlsize',150,...
   'gap',5,...
   'Control',uicontrol('parent',F,...
   'style','popupmenu',...
   'backgroundcolor','w',...
   'visible','off',...
   'callback',{@i_algpop,udh}));
   
ud.cards=xregcardlayout(F,...
   'numcards',length(ud.drawn),...
   'visible','off',...
   'packstatus','off');

frm=xregframetitlelayout(F,...
   'title','Options',...
   'center',ud.cards);

L=xreggridbaglayout(F,...
   'dimension',[2 1],...
   'gapy',10,...
   'rowsizes',[22 -1],...
   'elements',{ud.algpop,frm},...
   'userdata',udh);

ud=i_setvals(ud);

% select first option
lyt=feval(ud.optsinfo(ud.defopt(1)).CreateFcn,F,p);
attach(ud.cards,lyt,ud.defopt(1));
set(ud.cards,'currentcard',ud.defopt(1));
ud.currentpopval=ud.defopt(2);
ud.drawn(ud.defopt(1))=1;

if NP~=1
   % set default number of points 
   feval(ud.optsinfo(ud.defopt(1)).NPointsFcn,lyt,p,NP);
end

udh.info=ud;
return



function ud=i_setvals(ud)
% set correct string in alg popup
str={};
for n=1:length(ud.optsinfo)
   s2=ud.optsinfo(n).Name;
   if iscell(s2)
      str=[str s2];
      Nitems=length(s2);
   else
      str=[str {s2}];
      Nitems=1;
   end
   if n<ud.defopt(1)
      ud.defopt(2)=ud.defopt(2)+Nitems;
   end
end
set(ud.algpop.Control,'string',str,'value',ud.defopt(2));



function i_algpop(src,evt,udh)
newval=get(src,'value');
ud=udh.info;
if newval~=ud.currentpopval
   str=get(src,'string');
   str=str{newval};
   % find string in options
   viewind=0;
   for n=1:length(ud.drawn)
      if any(strcmp(str,ud.optsinfo(n).Name))
         viewind=n;
         break
      end
   end
   if viewind
      % synchronize number of points
      Lold=getcard(ud.cards,ud.currentopt);
      Lold=Lold{1};
      if ud.drawn(viewind)
         % set number of points
         Lnew=getcard(ud.cards,viewind);
         Lnew=Lnew{1};
         feval(ud.optsinfo(viewind).NPointsFcn,Lnew, ud.despointer, ...
            feval(ud.optsinfo(ud.currentopt).NPointsFcn, Lold, ud.despointer));
         % switch card
         set(ud.cards,'currentcard',viewind);
      else
         lyt=feval(ud.optsinfo(viewind).CreateFcn,get(src,'parent'),ud.despointer);
         attach(ud.cards,lyt,viewind);
         % set number of points
         feval(ud.optsinfo(viewind).NPointsFcn,lyt, ud.despointer, ...
            feval(ud.optsinfo(ud.currentopt).NPointsFcn, Lold, ud.despointer));
         % switch card
         set(ud.cards,'packstatus','on','currentcard',viewind);
         ud.drawn(viewind)=1;
      end
      ud.currentpopval=newval;
      ud.currentopt=viewind;
      udh.info=ud;
   end
end


function i_finalise(L)
udh=get(L,'userdata');
ud=udh.info;
newval=get(ud.algpop.Control,'value');

str=get(ud.algpop.Control,'string');
str=str{newval};
% find string in options
viewind=0;
optind=0;
for n=1:length(ud.drawn)
   mtch=strcmp(str,ud.optsinfo(n).Name);
   if any(mtch)
      viewind=n;
      optind=find(mtch);
      break
   end
end
if viewind
   L=getcard(ud.cards,viewind);
   L=L{1};
   feval(ud.optsinfo(n).FinaliseFcn,L,ud.despointer,optind);
end