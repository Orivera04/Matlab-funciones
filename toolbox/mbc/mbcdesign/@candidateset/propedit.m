function [csout,ok]=propedit(cs,varargin)
% PROPEDIT  Edit the properties for a CandidateSet object
%
%  [CSOUT, OK]= PROPEDIT(CS,'prop','value,..)
%
%  Valid properties are - 'Name' : string to use for dialog title
%                         'Model': model object to use for coding
%                         'Help' : string to use as a help button tag
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:26:23 $

[csout,ok]=i_createfig(cs,varargin{:});


function [csout,ok]=i_createfig(cs,varargin);

nm=[];
mdl=[];
help='';
if nargin>1
   for n=1:2:nargin-1
      switch lower(varargin{n})
      case 'name'
         nm=varargin{n+1};
      case 'model'
         mdl=varargin{n+1};
      case 'help'
         help=varargin{n+1};
      end
   end
end

if isempty(nm)
   nm=[CandidateSetInformation(cs) ' Design Properties'];
end

scr=get(0,'screensize');
figh=xregdialog('position',[scr(3)*0.5-185 scr(4)*0.5-145 370 350],...
   'Name',nm,'tag','cancel');

figh.MinimumSize=[335 300];
fig=double(figh);

ptr=xregpointer(cs);
lyt=i_createlyt(fig,ptr,mdl);
set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('parent',fig,...
   'style','pushbutton',...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancbtn=uicontrol('parent',fig,...
   'style','pushbutton',...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'',''visible'',''off'');');
helpbtn=[];
if ~isempty(help)
   helpbtn=mv_helpbutton(fig,help);
end

if isempty(help)
   mainlay=xreggridbaglayout(fig,...
      'packstatus','off',...
      'dimension',[2 3],...
      'colsizes',[-1 65 65],...
      'rowsizes',[-1 25],...
      'gapy',10,'gapx',7,...
      'border',[7 7 7 7],...
      'mergeblock',{[1 1],[1 3]},...
      'elements',{lyt,[],[],okbtn,[],cancbtn});
else
   mainlay=xreggridbaglayout(fig,...
      'packstatus','off',...
      'dimension',[2 4],...
      'colsizes',[-1 65 65 65],...
      'rowsizes',[-1 25],...
      'gapy',10,'gapx',7,...
      'border',[7 7 7 7],...
      'mergeblock',{[1 1],[1 4]},...
      'elements',{lyt,[],[],okbtn,[],cancbtn,[],helpbtn});
end

figh.LayoutManager=mainlay;
set(mainlay,'packstatus','on');
figh.showDialog(okbtn);
% The xregDialog handles the blocking of this function

tg=get(figh,'tag');
if strcmp(tg,'ok')
   ok=1;
   i_finalise(lyt);
   csout=ptr.info;
else
   ok=0;
   csout=cs;
end
freeptr(ptr);
delete(figh);
return




function lyt=i_createlyt(figh,ptr,mdl)
ud.cspointer=ptr;
ud.figure=figh;
if isempty(mdl)
   ud.model=xregmodel('nfactors',ptr.nfactors);
   ud.NOMODEL=1;
else
   ud.model=mdl;          % used for coding/invcoding, not changed
   ud.NOMODEL=0;
end

ud.unitsopt=uicontrol('parent',figh,...
   'string','View coded values',...
   'style','checkbox',...
   'value',0);
divl=xregGui.dividerline(figh);
udh=ud.unitsopt;
set(ud.unitsopt,'callback',{@i_units,udh});

proplyt=propertypage(ptr.info,'layout',figh);
propertypage(ptr.info,'update',proplyt,ptr,ud.model);
grd=xreggridlayout(figh,'correctalg','on','dimension',[3 1],'rowsizes',[20 20 -1],'elements',{ud.unitsopt,divl, proplyt});
ud.layout=xregcardlayout(figh,'numcards',2,'drawonselect','on','visible','off');
attach(ud.layout,grd,1);
attach(ud.layout,proplyt,2);

ud.proplyt=proplyt;

ud=i_setvalues(ud);
set(udh,'userdata',ud);
lyt=ud.layout;
return



function ud=i_setvalues(ud);
if ud.NOMODEL
   % hide the model options choices
   set(ud.layout,'currentcard',2);
else
   set(ud.layout,'currentcard',1);
end
return


function i_units(obj,nul,udh)
ud=get(udh,'userdata');
% update layout with correct model
if get(ud.unitsopt,'value')
   % coded - set model limits to be same as target limits
   m=ud.model;
   [bnds,g,tgt]=getcode(m);
   m=setcode(m,tgt,g,tgt);
else
   % natural
   m=ud.model;
end
set(udh,'userdata',ud);
propertypage(ud.cspointer.info,'update',ud.proplyt,ud.cspointer,m);
return


function i_finalise(lyt)
% finalise the cset selection.
% get handle to ud
udh=lyt2udh(lyt);
ud=get(udh,'userdata');
propertypage(ud.cspointer.info,'finalise',ud.proplyt);
return


function h=lyt2udh(lyt)
% return udh for a lyt
el=get(lyt,'elements');        
el=get(el{1},'elements');       
h=el{1};
return
