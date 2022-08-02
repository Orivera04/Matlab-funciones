function out=propertypage(obj,action,varargin);
% PROPERTYPAGE  Create a property gui for CandidateSet
%
%
%   This should be overloaded by child classes
%
%   Property pages 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:00:38 $


switch lower(action)
case 'layout'
   out=i_createlyt(varargin{:});
case 'update'
   out=i_update(varargin{:});
end
return



function lyt=i_createlyt(figh,varargin)
ud.pointer=[];
ud.figure=figh;
ud.model=[];
ud.callback='';
if nargin>1
   for n=1:2:length(varargin)
      switch lower(varargin{n})
      case 'callback'
         ud.callback=varargin{n+1};
      end
   end
end

ud.lstbox=uicontrol('parent',figh,...
   'visible','off',...
   'backgroundcolor','w',...
   'value',1,...
   'style','listbox',...
   'userdata',xregdesign);
ud.grltrb=xregGui.rbgroup(figh,'visible','off','position',[0 0 120 20],...
   'nx',2,'ny',1,...
   'string',{'Grid','Lattice'},'value',[0 1]);   
lattsztxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'string','Lattice size:',...
   'position',[0 0 70 15],...
   'horizontalalignment','left');
ud.lattszedt=xregGui.clickedit(figh,...
   'min',2,...
   'max',1e6,...
   'visible','off',...
   'clickincrement',10,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20]);
ud.mintxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 130 15]);
ud.maxtxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 130 15]);
ud.minedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.maxedt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'position',[0 0 70 20],...
   'interruptible','off');
ud.nlvltxt=uicontrol('parent',figh,...
   'style','text',...
   'visible','off',...
   'horizontalalignment','left',...
   'position',[0 0 130 15]);
ud.nlvledt=xregGui.clickedit(figh,...
   'visible','off',...
   'min',2,...
   'max',1000,...
   'clickincrement',1,...
   'dragincrement',1,...
   'rule','int',...
   'position',[0 0 70 20]);
ud.rbg=xregGui.rbgroup(figh,...
   'visible','off',...
   'nx',1,'ny',2,...
   'value',[1; 0],...
   'gapy',75);
txt1=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Equally spaced levels',...
   'visible','off',...
   'position',[0 0 120 15]);
txt2=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','User-specified levels',...
   'visible','off',...
   'position',[0 0 120 15]);
ud.lvledt=uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'visible','off',...
   'enable','off',...
   'horizontalalignment','left');

udh=ud.lstbox;
% callbacks
set(ud.lstbox,'callback',{@i_factchng,udh});
set(ud.lattszedt,'callback',{@i_Nchng,udh});
set(ud.minedt,'callback',{@i_minchng,udh});
set(ud.maxedt,'callback',{@i_maxchng,udh});
set(ud.nlvledt,'callback',{@i_nlvlchng,udh});
set(ud.lvledt,'callback',{@i_lvlchng,udh}); 
set(ud.rbg,'callback',{@i_gridmeth,udh});
set(ud.grltrb,'callback',{@i_grltchng,udh});

flw1=xregflowlayout(figh,'packstatus','off','orientation','left/center',...
   'elements',{txt1});
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.mintxt,ud.minedt});
flw3=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.maxtxt,ud.maxedt});
flw4=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.nlvltxt,ud.nlvledt});
flw5=xregflowlayout(figh,'orientation','left/center',...
   'elements',{txt2});
grd=xreggridlayout(figh,'dimension',[5 1],'correctalg','on',...
   'elements',{flw1,flw2,flw3,flw4,flw5});
brd1=xregborderlayout(figh,'center',grd,'west',ud.rbg,'innerborder',[20 0 0 0]);
layerl=xreglayerlayout(figh,'elements',{ud.lvledt},'border',[20 0 0 0]);
grlay=xreggridlayout(figh,'correctalg','on','dimension',[2 1],'rowsizes',[120 -1],'elements',{brd1,layerl});

flw1=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.mintxt,ud.minedt});
flw2=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.maxtxt,ud.maxedt});
flw3=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.nlvltxt,ud.nlvledt});
grd=xreggridlayout(figh,'dimension',[3 1],'correctalg','on','gapy',5,...
   'elements',{flw1,flw2,flw3});
ltlay=xregborderlayout(figh,'north',grd,'innerborder',[0 0 0 70]);

ud.crd=xregcardlayout(figh,'visible','off','numcards',2,'currentcard',2);
attach(ud.crd,grlay,1);
attach(ud.crd,ltlay,2);
flwbtm=xregflowlayout(figh,'orientation','left/center','gap',5,'border',[-5 10 0 0],...
   'elements',{lattsztxt,ud.lattszedt});
tpflw=xregflowlayout(figh,'orientation','left/center','elements',{ud.grltrb});

frm=xregframetitlelayout(figh,'visible','off','center',ud.crd,...
   'innerborder',[5 5 5 5]);
tplay=xregborderlayout(figh,'center',frm,...
   'north',tpflw,...
   'innerborder',[0 0 0 20]);
spl=xregsplitlayout(figh,...
   'left',ud.lstbox,...
   'right',tplay,...
   'split',[.25 .75],...
   'leftinnerborder',[0 5 0 0],...
   'rightinnerborder',[0 0 0 5],...
   'resizable','off');
lyt=xregborderlayout(figh,...
   'center',spl,...
   'north',flwbtm,...
   'innerborder',[0 0 0 30]);

ud.layout=lyt;
set(udh,'userdata',ud);
return




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% External update function.  Finds udh the dirty way %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function lyt=i_update(lyt,p,m)
el=get(get(lyt,'center'),'left');
ud=get(el,'userdata');
ud.pointer=p;
ud.model=m;
ud=i_setvalues(ud);
set(ud.lstbox,'userdata',ud);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set all strings, values etc from data in udh %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function ud=i_setvalues(ud)
cs=ud.pointer.info;

fact=get(ud.model,'symbol');
set(ud.lstbox,'string',fact);
factnum=get(ud.lstbox,'value');
fact=fact{factnum};

% set lattice size
set(ud.lattszedt,'value',get(cs,'N'));

grddims=get(cs,'griddims');
ltdims=get(cs,'latticedims');
vis= get(ud.crd,'visible');  set(ud.crd,'visible','off');
% decide which option to show for this factor
if ismember(factnum,grddims)
   % grid
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt],{'string'},...
      {['Minimum ' fact ' value:'];['Maximum ' fact ' value:'];['Number of levels for ' fact ':']});
   gridnum=find(grddims==factnum);
   lvls=get(cs,'levels');
   lvl=invcode(ud.model,lvls{gridnum}(:),factnum)';
   set([ud.minedt;ud.maxedt],{'string'},...
      {min(lvl);max(lvl)});
   set(ud.nlvledt,'rule','int','value',length(lvl),'max',1000);
   str=prettify(lvl);
   set(ud.lvledt,'string',str);
   % decide if the str represents a number of equal levels
   if (length(findstr(str,':'))<=2 & isempty(findstr(str,' '))) | length(lvl)==2
      % use set levels
      set(ud.rbg,'value',[1; 0]);
      % set enable statuses
      set(ud.lvledt,'enable','off');
      set([ud.mintxt;ud.maxtxt;ud.nlvltxt;ud.minedt;ud.maxedt],'enable','on');
      set(ud.nlvledt,'enable','on');
   else
      set(ud.rbg,'value',[0; 1]);
      set(ud.lvledt,'enable','on');
      set([ud.mintxt;ud.maxtxt;ud.nlvltxt;ud.minedt;ud.maxedt],'enable','off');
      set(ud.nlvledt,'enable','off');
   end
   set(ud.crd,'currentcard',1);
   lyt=getcard(ud.crd,1);
   repack(lyt{1});   % Need to force redraw of min,max etc - shared with lattice view
   set(ud.grltrb,'value',[1 0]);
else
   % lattice
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt],{'string'},...
      {['Minimum ' fact ' value:'];['Maximum ' fact ' value'];['Prime number for ' fact ':']});
   latnum=find(ltdims==factnum);
   lims=get(cs,'limits');
   lims=invcode(ud.model,lims{latnum}(:),factnum);
   set([ud.minedt;ud.maxedt],{'string'},...
      {lims(1);lims(2)});
   set(ud.lattszedt,'value',get(cs,'n'));
   maxg=primes(get(cs,'n'));
   maxg=maxg(end);
   g=get(cs,'g');
   set(ud.nlvledt,'rule','prime','value',g(latnum),'max',maxg);
   set(ud.crd,'currentcard',2);
   lyt=getcard(ud.crd,2);
   repack(lyt{1});   % Need to force redraw of min,max etc - shared with grid view
   set(ud.grltrb,'value',[0 1]);
end
set(ud.crd,'visible',vis);
return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Callbacks from each object %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_factchng(obj,nul,udh)
ud=get(udh,'userdata');
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return


function i_Nchng(obj,nul,udh)
ud=get(udh,'userdata');
val=get(ud.lattszedt,'value');
cs= set(ud.pointer.info,'n',val);
p=primes(val);
p=p(end);
set(ud.nlvledt,'max',p);
% check the g values are all below Nmax
g=get(cs,'g');
if any(g>p)
   % uh-oh
   g(g>p)=p;
   cs=set(cs,'g',g);
   factnum=get(ud.lstbox,'value');
   ltnum=find(factnum==get(cs,'latticedims'));
   set(ud.nlvledt,'value',g(ltnum));
end
ud.pointer.info=cs;
set(udh,'userdata',ud);
i_firecb(ud);
return


function i_minchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mnval=str2double(get(ud.minedt,'string'));
mnval=code(ud.model,mnval,factnum);
cs=ud.pointer.info;
if (get(ud.grltrb,'selected')-1);
   % Lattice view
   ltnum=find(get(cs,'latticedims')==factnum);
   lims=get(cs,'limits');
   mxval=lims{ltnum}(2);
   if isempty(mnval) | length(mnval)~=1 | mnval>=mxval | isnan(mnval)
      % reset display
      lims=invcode(ud.model,lims{ltnum}(1),factnum);
      set(ud.minedt,'string',lims);
   else
      lims{ltnum}(1)=mnval;
      cs=set(cs,'limits',lims);
      ud.pointer.info=cs;
      set(udh,'userdata',ud);
      i_firecb(ud);
   end
else
   % Grid View
   grnum=find(get(cs,'griddims')==factnum);
   lvls=get(cs,'levels');
   lims=lvls{grnum};
   mxval=max(lims);
   if isempty(mnval) | length(mnval)~=1 | mnval>=mxval | isnan(mnval)
      % reset display
      lims=invcode(ud.model,min(lims(:)),factnum);
      set(ud.minedt,'string',lims);
   else
      % recreate levels vector
      nlvls=get(ud.nlvledt,'value');
      lvls{grnum}=linspace(mnval,mxval,nlvls);
      cs=set(cs,'levels',lvls);
      set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{grnum}', factnum)'));
      ud.pointer.info=cs;
      set(udh,'userdata',ud);
      i_firecb(ud);
   end  
end
return


function i_maxchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
mxval=str2double(get(ud.maxedt,'string'));
mxval=code(ud.model,mxval,factnum);
cs=ud.pointer.info;
if (get(ud.grltrb,'selected')-1);
   % Lattice view
   ltnum=find(get(cs,'latticedims')==factnum);
   lims=get(cs,'limits');
   mnval=lims{ltnum}(1);
   if isempty(mxval) | length(mxval)~=1 | mnval>=mxval | isnan(mxval)
      % reset display
      lims=invcode(ud.model,lims{ltnum}(2),factnum);
      set(ud.maxedt,'string',lims);
   else
      lims{ltnum}(2)=mxval;
      cs=set(cs,'limits',lims);
      ud.pointer.info=cs;
      set(udh,'userdata',ud);
      i_firecb(ud);
   end
else
   % Grid View
   grnum=find(get(cs,'griddims')==factnum);
   lvls=get(cs,'levels');
   lims=lvls{grnum};
   mnval=min(lims);
   if isempty(mxval) | length(mxval)~=1 | mnval>=mxval | isnan(mxval)
      % reset display
      lims=invcode(ud.model,max(lims(:)),factnum);
      set(ud.minedt,'string',lims);
   else
      % recreate levels vector
      nlvls=get(ud.nlvledt,'value');
      lvls{grnum}=linspace(mnval,mxval,nlvls);
      cs=set(cs,'levels',lvls);
      set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{grnum}', factnum)'));
      ud.pointer.info=cs;
      set(udh,'userdata',ud);
      i_firecb(ud);
   end  
end
return



function i_nlvlchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');

cs=ud.pointer.info;
if (get(ud.grltrb,'selected')-1);
   % Lattice View
   ltnum=find(get(cs,'latticedims')==factnum);
   val=get(ud.nlvledt,'value');
   g=get(cs,'g');
   g(ltnum)=val;
   cs=set(cs,'g',g);
   ud.pointer.info=cs;
else
   % Grid View
   grnum=find(get(cs,'griddims')==factnum);
   nlvls=get(ud.nlvledt,'value');
   lvls=get(cs,'levels');
   mnval=min(lvls{grnum}(:));
   mxval=max(lvls{grnum}(:));
   lvls{grnum}= linspace(mnval,mxval,nlvls);
   cs=set(cs,'levels',lvls);
   ud.pointer.info=cs;
   % update levels edit box
   set(ud.lvledt,'string',prettify(invcode(ud.model, lvls{grnum}', factnum)'));
end
set(udh,'userdata',ud);
i_firecb(ud);
return



function i_gridmeth(obj,nul,udh)
ud=get(udh,'userdata');
% switch enable status of bits
val=get(obj,'selected');
switch val
case 1
   set(ud.lvledt,'enable','off');
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt;ud.minedt;ud.maxedt],'enable','on');
   set(ud.nlvledt,'enable','on');
   % reset levels edit box using min/max/nlevels
   i_nlvlchng(ud.nlvledt,[],udh);
case 2
   set([ud.mintxt;ud.maxtxt;ud.nlvltxt;ud.minedt;ud.maxedt],'enable','off');
   set(ud.nlvledt,'enable','off');
   set(ud.lvledt,'enable','on'); 
end
return



function i_lvlchng(obj,nul,udh)
ud=get(udh,'userdata');
cs=ud.pointer.info;
lvl=str2num(get(ud.lvledt,'string'));
factnum=get(ud.lstbox,'value');
grnum=find(factnum==get(cs,'griddims'));
lvls=get(cs,'levels');
if ~isempty(lvl) & isnumeric(lvl) & length(unique(lvl))>1
   lvls{grnum}=code(ud.model,lvl(:),factnum)';
   set([ud.minedt;ud.maxedt],{'string'},{min(lvl(:));max(lvl(:))});
   set(ud.nlvledt,'value',length(lvl));
   cs=set(cs,'levels',lvls);
   ud.pointer.info=cs;
   set(udh,'userdata',ud);
   i_firecb(ud);
else
   lvl=(invcode(ud.model,lvls{grnum}(:),factnum))';
end
set(ud.lvledt,'string',prettify(lvl));
return



function i_grltchng(obj,nul,udh)
ud=get(udh,'userdata');
factnum=get(ud.lstbox,'value');
isgr=get(ud.grltrb,'selected')-1;
cs=ud.pointer.info;
if isgr
   % convert to lattice
   % remove from grid
   gdims=get(cs,'griddims'); glvls=get(cs,'levels');
   gval=find(gdims==factnum);
   gdims(gval)=[];
   glvls(gval)=[];
   % add to lattice
   ldims=get(cs,'latticedims'); g=get(cs,'g'); llims=get(cs,'limits');
   [ldims i]=sort([ldims factnum]);
   lms=limits(cs);
   llims=num2cell(lms(ldims,:),2);
   p=primes(max(get(cs,'n')/50,30));
   p=p(5:end);
   p=p(floor(length(p).*rand));
   
   g=[g p(end)];
   g=g(i); 
else
   % convert to grid
   % remove from lattice
   ldims=get(cs,'latticedims'); g=get(cs,'g'); llims=get(cs,'limits');
   lval=find(ldims==factnum);
   ldims(lval)=[];
   llims(lval)=[];
   g(lval)=[];
   % add to grid
   lms=limits(cs);
   gdims=get(cs,'griddims'); glvls=get(cs,'levels');
   [gdims i]=sort([gdims factnum]);
   glvls(end+1)={linspace(lms(factnum,1),lms(factnum,2),3)};
   glvls=glvls(i);
end
% set new values
cs=set(set(cs,'griddims',gdims),'levels',glvls); 
cs=set(set(cs,'limits',llims),'g',g);
ud.pointer.info=cs;
% need to update half of view anyway so use full update fcn.
ud=i_setvalues(ud);
set(udh,'userdata',ud);
i_firecb(ud);
return

function i_firecb(ud)
if ischar(ud.callback)
   evalin('base',ud.callback);
else
   str=[ud.callback(1) {ud.layout,[]} ud.callback(2:end)];
   feval(str{:});
end
return