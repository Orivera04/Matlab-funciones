function lyt=gui_globalmodpane(m,action,figh,p,varargin)
% GUI_GLOBALMODPANE  Create part of GUI for linear model settings
%
%   LYT=GUI_GLOBALMODPANE(M,'layout',FIG,P) creates a layout object
%   with callbacks defined for updating the model pointed to by P.
%   FIG is the figure to create it in.
%   
%   LYT=GUI_GLOBALMODPANE(M,'layout',FIG,P,'callback,CBSTR) attaches a
%   callback string, CBSTR, which is fired when the model definition
%   is changed.  The string may contain the tokens %MODEL% and %POINTER%
%   which will be replaced with the current model and the pointer before
%   the callback is executed.
%
%   FIG may also be a current copy of a layout in which case this
%   existing layout will be used instead of creating a new one.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:43:27 $


switch lower(action)
case 'layout'
   if isa(figh,'xregcontainer')
      % update layout with new model info
      i_updatepointer(figh,p);
   else
      cbstr='';
      if nargin>4
         for n=1:2:length(varargin)
            switch lower(varargin{n})
            case 'callback'
               cbstr=varargin{n+1};
            end
         end
      end
      lyt=i_createlyt(figh,p,cbstr);
   end
      
   
case 'knotvalues'
   % get knot values and try to insert them
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   
   knts=get(ud.knots,'value');
   nat=~get(ud.knotunits,'value');
   try
      if nat
         set(m,'naturalknots',knts);
      else
         set(m,'knots',knts);
      end
   catch
      %Bad Knots!
      if nat
         knts=get(m,'naturalknots');
      else
         knts=get(m,'knots');
      end
      ud.knots.value=knts;
      errfig=errordlg(['Invalid knot specification.  Check that the' ...
         ' values are in the interval [min max] for the spline factor.'],'Error');
      waitfor(errfig);
      return
   end
   % change coefficients from zeros to default 1:n
   t=termorder(m);
   t=max(t);
   m=update(m,(1:t)');
   ud.pointer.info=m;
   % fire callback
   if ~isempty(ud.callback)
      i_firecb(ud.callback,ud.pointer)
   end
   
case 'numknots'
   % get number of knots and alter knot table accordingly
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   p=ud.numknots.value;
   nat=~get(ud.knotunits,'value');
   if nat
      knts=get(m,'naturalknots');
   else
      knts=get(m,'knots');
   end
   
   nknts=length(knts);
   if p>nknts
      % add more knots
      knts(end+1:p)=knts(end);
      ud.knots.cols.number=p;
      ud.knots.value=knts;
   elseif p<nknts
      % destroy some
      knts=knts(1:p);
      ud.knots.cols.number=p;
   else
      % what are we doing here anyway?
      return
   end
   
   if nat
      set(m,'naturalknots',knts);
   else
      set(m,'knots',knts);
   end
   % change coefficients from zeros to default 1:n
   t=termorder(m);
   t=max(t);
   m=update(m,(1:t)');   
   ud.pointer.info=m;
   % fire callback
   if ~isempty(ud.callback)
      i_firecb(ud.callback,ud.pointer)
   end
   
case 'orderchange'
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   ord=ud.table(:,1).value;
   bad=(ord<0 | ord>3 | ord~=round(ord));
   if any(bad)
      % replace bad values with old ones
      oldord=get(m,'order');
      ord(bad)=oldord(bad);
      ud.table(:,1).value=ord;
      return
   end
   m=set(m,'order',ord);
   % change coefficients from zeros to default 1:n
   t=termorder(m);
   t=max(t);
   m=update(m,(1:t)');   
   ud.pointer.info=m;
   % fire callback
   if ~isempty(ud.callback)
      i_firecb(ud.callback,ud.pointer)
   end
case 'splinefactor'
   % need to have exclusive rb's
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   splfact=get(m,'spline');
   val=ud.table(:,2).value;
   val(splfact)=0;
   if sum(val)>1
      % oh dear! problem.
      ind=find(val);
      ind=ind(1);
      val(:)=0;
      val(ind)=1;
      ud.table(:,2).value=val;
      set(m,'spline',ind);
   elseif sum(val)==0
      % put val back on
      val(splfact)=1;
      ud.table(:,2).value=val;
      return
   else
      % normal case
      ind=find(val);
      set(m,'spline',ind); 
      ud.table(:,2).value=val;
      % update knot values to be the same values when coded
      nat=~get(ud.knotunits,'value');
      if nat
         ud.knots.value=get(m,'naturalknots');
      else
         ud.knots.value=get(m,'knots');
      end      
   end
   
   % change coefficients from zeros to default 1:n
   t=termorder(m);
   t=max(t);
   m=update(m,(1:t)');   
   ud.pointer.info=m;
   % fire callback
   if ~isempty(ud.callback)
      i_firecb(ud.callback,ud.pointer)
   end
case 'interact'
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   p=ud.interact.value;
   intlvl=get(m,'interact');
   if p~=intlvl
      set(m,'interact',p);
      % change coefficients from zeros to default 1:n
      t=termorder(m);
      t=max(t);
      m=update(m,(1:t)');   
      ud.pointer.info=m;
      % fire callback
      if ~isempty(ud.callback)
         i_firecb(ud.callback,ud.pointer)
      end
   end 
case 'knotunits'
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   if get(ud.knotunits,'value')
      % coded
      ud.knots.value=get(m,'knots');
   else
      % natural
      ud.knots.value=get(m,'naturalknots');
   end
end
return





function lyt=i_createlyt(figh,p,cbstr)

ud.callback=cbstr;
ud.pointer=p;
m=p.info;
nf=nfactors(m);

spl=get(m,'spline');
ord=get(m,'order');


vals=zeros(1,nf);
vals(spl)=1;
bgcol=get(figh,'color');
ud.table=xregtable(figh,...
   'visible','off',...
   'cols.size',50,...
   'cols.spacing',5,...
   'frame.visible','off',...
   'frame.hborder',[0 0],...
   'frame.vborder',[0 0],...
   'cells.defaultinterruptible','off',...
   'cells.colselection',[2 2],...
   'cells.rowselection',[2 nf+1],...
   'cells.type','uiedit',...
   'cells.backgroundcolor',[1 1 1],...
   'cells.format','%1.0f',...
   'cells.value',ord,...
   'rows.fixed',1,...
   'cols.fixed',1,...
   'zeroindex',[2 2],...
   'cells.rowselection',[1 1],...
   'cells.colselection',[1 3],...
   'cells.type','text',...
   'cells.string',{'Symbol','Order','Spline'},...
   'cells.rowselection',[2 nf+1],...
   'cells.colselection',[1 1],...
   'cells.type','text',...
   'cells.string',detex(get(m,'symbol')),...
   'cells.colselection',[3 3],...
   'cells.type','uiradiobutton',...
   'cells.backgroundcolor',bgcol,...
   'cells.value',vals,...
   'position',[0 0 135 65],...
   'redrawmode','basic');
set(ud.table,'redrawmode','normal');
%knot handling bits
ud.txt(1)=uicontrol('style','text',...
   'parent',figh,...
   'backgroundcolor',bgcol,...
   'string','Number of knots:',...
   'position',[0 0 100 15],...
   'horizontalalignment','left',...
   'visible','off');
ud.txt(2)=uicontrol('style','text',...
   'parent',figh,...
   'backgroundcolor',bgcol,...
   'string','Knot positions:',...
   'position',[0 0 100 15],...
   'userdata',xreg3xspline('nfactors',1),...
   'horizontalalignment','left',...
   'visible','off');

% use text objects as data holders
udh=sprintf('%20.15f',ud.txt(1));
objh=sprintf('%20.15f',ud.txt(2));

ud.table(:,1).callback=['gui_globalmodpane(get(' objh ',''userdata''),''orderchange'',' udh ');'];
ud.table(:,2).callback=['gui_globalmodpane(get(' objh ',''userdata''),''splinefactor'',' udh ');'];

knts=get(m,'naturalknots');
nknts=length(knts);
ud.numknots=xregGui.clickedit(figh,'min',1,...
   'max',50,...
   'rule','int',...
   'value',nknts,...
   'position',[0 0 60 20],...
   'clickincrement',1,...
   'dragging', 'off', ...
   'callback',['gui_globalmodpane(get(' objh ',''userdata''),''numknots'',' udh ');'],...
   'visible','off');

ud.knots=xregtable(figh,...
   'frame.visible','off',...
   'frame.vborder',[0 0],...
   'frame.hborder',[0 0],...
   'hslider.width',15,...
   'cells.defaultbackgroundcolor',[1 1 1],...
   'cells.defaulthorizontalalignment','right',...
   'cells.defaultinterruptible','off',...
   'defaultcellformat','%5.3f',...
   'cells.defaultcallback',['gui_globalmodpane(get(' objh ',''userdata''),''knotvalues'',' udh ');'],...
   'cols.size',50,...
   'cols.spacing',3,...
   'rows.number',1,...
   'cols.number',nknts,...
   'cells.rowselection',[1 1],...
   'cells.colselection',[1 nknts],...
   'cells.value',knts,...
   'position',[0 0 150 40],...
   'redrawmode','basic',...
   'visible','off');
set(ud.knots,'redrawmode','normal');
intlvl=get(m,'interact');
% interaction level
txt(3)=uicontrol('style','text',...
   'parent',figh,...
   'backgroundcolor',bgcol,...
   'string','Interaction level:',...
   'position',[0 0 100 15],...
   'horizontalalignment','left',...
   'visible','off');
ud.interact=xregGui.clickedit(figh,...
   'min',0,'max',2,...
   'rule','int',...
   'clickincrement',1,...
   'dragging', 'off',...
   'position',[0 0 60 20],...
   'callback',['gui_globalmodpane(get(' objh ',''userdata''),''interact'',' udh ');'],...
   'value',intlvl,...
   'visible','off');
ud.knotunits=uicontrol('parent',figh,...
   'style','checkbox',...
   'visible','off',...
   'string','Coded units',...
   'value',0,...
   'callback',['gui_globalmodpane(get(' objh ',''userdata''),''knotunits'',' udh ');'],...
   'interruptible','off');

set(ud.txt(1),'userdata',ud);

pnl=xregpanellayout(figh,'innerborder',[0 0 0 0],...
   'center',ud.table,'packstatus','off');
flw1=xregflowlayout(figh,'orientation','left/center',...
   'elements',{ud.txt(1) ud.numknots},'packstatus','off');
flw3=xregflowlayout(figh,'orientation','left/center',...
   'elements',{txt(3),ud.interact});
lyt=xreggridbaglayout(figh,'dimension',[6,2],'rowsizes',[-1 20 20 15 0 15],'colsizes',[95 -1],'gap',5,...
   'mergeblock',{[1 1],[1 2]},'mergeblock',{[2 2],[1 2]},'mergeblock',{[3 3],[1 2]},...
   'mergeblock',{[4 6],[2 2]},...
   'elements',{pnl,flw3,flw1,ud.txt(2),[],ud.knotunits,[],[],[],ud.knots});
return




function i_updatepointer(lyt,p)

m=p.info;
nf=nfactors(m);
% update order, spline rb's, knots
el=get(lyt,'elements');
el=get(el{3},'elements');
el=el{1};
ud=get(el,'userdata');

tbl=ud.table;
tbl(:,1).value=get(m,'order');
vals=zeros(nf,1);
vals(get(m,'spline'))=1;
tbl(:,2).value=vals;


tbl=ud.knots;
nat=~get(ud.knotunits,'value');
if nat
   knts=get(m,'naturalknots');
else
   knts=get(m,'knots');
end
nknts=get(m,'numknots');
set(ud.numknots,'value',nknts);
set(tbl,'cols.number',nknts);
tbl(:,:).value=knts;

% update data storage
ud.pointer=p;
set(el,'userdata',ud);
return


function i_firecb(cbstr,ptr)
xregcallback(cbstr, [], struct('ModelPointer', ptr))
