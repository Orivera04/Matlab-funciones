function [mout,ok]=gui_inputsetup2(m,action,figh,varargin)
% MODEL/GUI_INPUTSETUP2   GUI for editing model input factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:52:06 $





if nargin<2
   action='figure';
elseif nargin<3
   figh=gcf;
end

switch lower(action)
   
case 'figure'
   % not defined
   if nargin>2
      varargin=[{figh} varargin];
   end
   [mout,ok]=i_createfig(m,varargin{:});
case 'layout'
   % not yet needed
case 'applylayout'
   % layout with apply
   p=xregpointer(m);
   cbstr='';
   tp=[];
   locksymb=0;
   if nargin>3
      % parse inputs
      for n=1:2:length(varargin)
         switch lower(varargin{n})
         case 'callback'
            cbstr=varargin{n+1};
         case 'testplan'
            tp=varargin{n+1};
         case 'locksymbols'
            % shouldn't ever need this option on the applylayout
            locksymb=1;
         end
      end
   end
   
   % one option is to give a layout instead of a figure
   create=1;
   if isa(figh,'xregcontainer')
      lyt=figh;
      figh=get(figh,'parent');
      create=0;
   end
   
   if create
      [lyt,objh,udh]=i_createlyt(figh,p,'%HOOK_INTERNAL%',tp,locksymb);
      
      objhtxt=sprintf('%20.15f',objh);
      udhtxt=sprintf('%20.15f',udh);
      
      ud=get(udh,'userdata');
      
      ud.applybutton=1;
      ud.topcallback=cbstr;
      ud.model=m;
      % add apply button
      applybtn=uicontrol('style','pushbutton',...
         'parent',figh,...
         'position',[0 0 65 25],...
         'string','Apply',...
         'userdata',m,...
         'visible','off',...
         'enable','off',...
         'interruptible','off');
      objh=sprintf('%20.15f',applybtn);
      revertbtn=uicontrol('style','pushbutton',...
         'parent',figh,...
         'position',[0 0 65 25],...
         'string','Revert',...
         'visible','off',...
         'enable','off',...
         'interruptible','off');
      viewbtn=uicontrol('style','pushbutton',...
         'parent',figh,...
         'position',[0 0 85 25],...
         'string','View Model...',...
         'visible','off',...
         'interruptible','off');   
      
      set(applybtn,'callback',['gui_modelsetup(get(' objhtxt ',''userdata''),''applychng'',' udhtxt ');']);
      set(revertbtn,'callback',['gui_modelsetup(get(' objhtxt ',''userdata''),''revert'',' udhtxt ');']);
      set(viewbtn,'callback',['gui_modelsetup(get(' objhtxt ',''userdata''),''viewmdl'',' udhtxt ');']);
      
      % layouts
      applyflw=xregflowlayout(figh,'elements',{applybtn,revertbtn},...
         'orientation','right','border',[0 10 -7 10],'gap',7);
      viewflow=xregflowlayout(figh,'elements',{viewbtn},...
         'orientation','left','border',[0 10 0 10]);
      ll=xreglayerlayout(figh,'elements',{applyflw,viewflow});
      bl=xregborderlayout(figh,'center',lyt,'south',ll,...
         'innerborder',[0 45 0 0]);   
      ud.mainlyt=xregframetitlelayout(figh,'center',bl,'border',[10 10 10 10],...
         'title','Global Model Definition','innerborder',[10 10 0 10]);
      
      mout=ud.mainlyt;
      set(udh,'userdata',ud);
      %set(ud.mainlyt,'packstatus','on');
      set(ud.mainlyt,'visible','on');
   else
      %update current layout with given model
      udh=get(get(get(get(lyt,'center'),'center'),'south'),'elements');
      udh=udh{2};
      ud=get(udh,'userdata');
      ud.model=m;
      ud.pointer.info=m;
      ud.changedmodel=0;
      
      set(udh,'userdata',ud);
      ud=i_redrawtable(ud);
      % set enable status
      i_applyenable(ud);     
   end
   
   
   
case 'isdirty'
   % external API function for asking if the model definition is applied
   udh=get(get(get(get(figh,'center'),'center'),'south'),'elements');
   udh=udh{2};
   ud=get(udh,'userdata');
   mout=ud.changedmodel;
   ok=1;
   
case 'cleanmodel'
   % external API for checking model dirty status and offering apply for any changes
   udh=get(get(get(get(figh,'center'),'center'),'south'),'elements');
   udh=udh{2};
   ud=get(udh,'userdata');
   
   mout=1;
   ok=1;   
   if ud.changedmodel
      % tell user the model is different
      btn=questdlg(['The current model definition has not been applied.',...
            '  Do you wish to apply the changes made before viewing the model?'],...
         'Update Model','Yes','Cancel','Yes');
      if strcmp(btn,'Cancel')
         mout=0;
         ok=0;
         return
      elseif strcmp(btn,'Yes')
         % apply changes
         gui_ModelSetup(m,'applychng',udh);
      end     
   end
   
case 'applychng'
   if ~length(varargin)
      varargin{1}=1;
   end
   
   ud=get(figh,'userdata');
   m=ud.pointer.info;
   
   
   [mm,g,tgt]= i_getcode(m,ud.table);
   try 
      m= setcode(m,mm,g,tgt);
      ud.pointer.info= m;
      ok=i_checkdata(ud);
   catch
      errordlg(lasterr,'Coding Error','modal')
      return
   end
   
   ud.model=ud.pointer.info;
   
   if ud.applybutton
      % set apply, revert to disabled
      el=get(get(get(ud.mainlyt,'center'),'south'),'elements');
      set(el{1},'enable','off');
      ud.changedmodel=0;
      % fire global model setup gui if class has changed?
      if ud.changedclass & varargin{1}
         [m,ok]=gui_globalmodsetup(m);
         if ok
            % update our copy of model too
            ud.model=m;
            ud.pointer.info=m;
         end
      end
   end
   ud.changedmodel=0;
   set(ud.txt,'string',['Current model:  ' str_func(m,1)]);
   ud.changedclass=0;
   set(figh,'userdata',ud);
   set(ud.parent,'pointer',ptr);
   
   % fire top callback
   if ud.applybutton & ~isempty(ud.topcallback)
      i_firecb(ud.topcallback,ud);
   end
   
case 'revert'
   ud=get(figh,'userdata');
   % replace pointer with old model
   ud.pointer.info=ud.model;
   
   % repopolate table values
   ud=i_redrawtable(ud);
   
   % set apply, revert to disabled
   el=get(get(get(ud.mainlyt,'center'),'south'),'elements');
   set(el{1},'enable','off');
   ud.changedmodel=0;
   
   set(figh,'userdata',ud);
   
case 'viewmdl'
   
   VarName= 'Y';
   ud=get(figh,'userdata');
   if ud.changedmodel
      % tell user the model is different
      btn=questdlg(['The current model definition has not been applied.',...
            '  Do you wish to apply the changes made before viewing the model?'],...
         'Update Model');
      if strcmp(btn,'Cancel')
         return
      elseif strcmp(btn,'Yes')
         % apply changes
         gui_ModelSetup(m,'applychng',figh);
         ud=get(figh,'userdata');
      end     
   end
   
   hFig = details(ud.model,'view',VarName);
   
% case 'symbchng'
%    % get all symbols and insert into model
%    ud=get(figh,'userdata');
%    
%    % symbol changing interface??
%    symb=ud.table(:,1).string;
%    if ~iscell(symb)
%       symb={symb};
%    end
%    m=ud.pointer.info;
%    if ~isempty(gcbo);
%       si= get(gcbo,'string');
%       tstr = [findstr(si,'_') findstr(si,'\') findstr(si,'^') findstr(si,'{') findstr(si,'}')];
%       if  ~isempty(tstr) 
%          style= struct('WindowStyle','modal','Interpreter','TeX');
%          warndlg(['The symbol contains TeX expressions and will be displayed as "',si,...
%                '" in equation expressions.'],'Symbol Definition',style);
%       end
%    end
%    set(m,'symbol',symb);
%    ud.pointer.info=m;
%    ud.changedmodel=1;
%    
%    set(figh,'userdata',ud);
%    if ~isempty(ud.callback)
%       i_firecb(ud.callback,ud);
%    end
%    
% case 'codechng'
%    % grab min, max and transform data and insert into model
%    ud=get(figh,'userdata');
%    t=ud.table;
%    
%    m=ud.pointer.info;
%    
%    [mm,g,tgt]= i_getcode(m,t);
%    
%    % disable target ranges for now
%    t.redrawmode='normal';
%    t.redraw;
%    
%    ud.changedmodel=1;
%    set(figh,'userdata',ud);
%    if ~isempty(ud.callback)
%       i_firecb(ud.callback,ud);
%    end
   
case 'options'
   % force an apply first? (or ask user??)
   ud=get(figh,'userdata');
   if ud.changedmodel
      % tell user the model is different
      btn=questdlg(['The current model definition has not been applied.',...
            '  Do you wish to apply the changes made before changing the model options?'],...
         'Update Model','Yes','Cancel','Yes');
      if strcmp(btn,'Cancel')
         return
      elseif strcmp(btn,'Yes')
         % apply changes with no global setup figure
         gui_ModelSetup(m,'applychng',figh,0);
         ud=get(figh,'userdata');
      end     
   end
   
   m=ud.pointer.info;
   [m,ok] = gui_globalsetup(m);
   if ok
      ud.pointer.info=m;
      ud=i_redrawtable(ud);
      gui_ModelSetup(m,'applychng',figh);
   end
end
return





function [lyt,txt,txt2]=i_createlyt(figh,p,Enable)

ud.pointer=p;
ud.callback='';
mdl=p.info;
nf=nfactors(mdl);



% test for sym toolbox to see if ytrans are available
try
   % needed for log10 inversing
   maple('readlib(log10)');
   trans={'None','1./x','sqrt(x)','log10(x)','x.^2','log(x)'};
catch
   trans={'None'};
end   

bgcol=get(figh,'color');
% set up table look
t=xregtable(figh,...
   'visible','off',...
   'frame.visible','off',...
   'frame.hborder',[0 0],...
   'frame.vborder',[0 0],...
   'defaultcellformat','%g',...
   'defaultcelltype','uipushbutton',...
   'cols.size',80,...
   'cols.spacing',2,...
   'rows.spacing',2,...
   'cells.defaultinterruptible','off',...
   'cells.rowselection',[1 1],...
   'cells.colselection',[1 5],...
   'cells.type','uitext',...
   'cells.string',{'Symbol','Min','Max','Transform','Signal'},...
   'cells.fontweight','bold',...
   'cells.backgroundcolor',bgcol,...
   'rows.fixed',1,...
   'zeroindex',[2 1],...
   'cells.defaultbackgroundcolor',[1 1 1],...
   'cells.rowselection',[2 nf+1],...
   'cells.colselection',[1 3],...
   'cells.type','uiedit',...
   'cells.horizontalalignment','right',...
   'cells.colselection',[4 4],...
   'cells.type','uipopupmenu',...
   'cells.string',{trans},...
   'cells.value',1,...
   'cells.rowselection',[2 nf+1],...
   'cells.colselection',[5 5],...
   'cells.type','uiedit',...
   'cells.colselection',[1 5],...
   'cells.rowselection',[1 nf+1],...
   'cells.horizontalalignment','left',...
   'position',[0 0 300 70],...
   'redrawmode','basic');
t.redrawmode='normal';


txt= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'HorizontalAlignment','left',...
   'string','Number of factors:');
txt2= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'string','Number of Factors');
uh=xregGui.clickedit(figh,...
   'visible','off',...
   'callback',{@i_NumFactors,txt2},...
   'min',1,...
   'value',nf,...
   'rule','int');

if ~Enable
   set(t,...
      'cells.rowselection',[2 nf+1],...
      'cells.colselection',[1 5],...
      'cells.enable','off');
   set(uh,'enable','off');
end

% builtin('set',txt,'userdata',mdl);

ud.trans= trans;
ud.parent=figh;
ud.table=t;
ud.callback='';
ud.changedmodel=0;
ud.changedclass=0;

% objh=sprintf('%20.15f',txt);
% udh=sprintf('%20.15f',txt2);

% callbacks
%set(optsbtn,'callback',['gui_modelsetup(get(' objh ',''userdata''),''options'',' udh ');']);
t.cellchangedcallback={@i_cellchng,txt2,mdl};

ud.grd=xreggridlayout(figh,'dimension',[1 2],'border',[0 0 0 5],...
   'correctalg','on','elements',{txt,uh},'gap',20,'colsizes',[100 65]);
lyt=xregpanellayout(figh,'innerborder',[5 0 0 0],'center',t);
lyt=xreggridlayout(figh,'dimension',[2 1],...
   'correctalg','on','elements',{ud.grd,lyt},'gapy',10,'rowsizes',[25 -1]);

ud=i_redrawtable(ud);
set(txt2,'userdata',ud);
return





function ud=i_redrawtable(ud)
% repopulate table with values from m
m=ud.pointer.info;
t=ud.table;

% factor names
dovars=1;

fnms= m.Xinfo.Names;


% symbols
symb=get(m,'symbol');
c= m.code;
ytr= {c.g}; % get(m,'ytrans');

% convert ytr to values
for n=1:length(ytr)
   ytr{n}=find(strcmp(char(ytr{n}),{'','1./x','sqrt(x)','log10(x)','x.^2','log(x)'}));
end
% convert any unrecognised transforms to no transform
ytr(cellfun('isempty',ytr)) = {1};
ytr=cat(1,ytr{:});

nf=nfactors(m);
if isempty(symb)
   symb=cellstr(char([65:64+nf]'));
end
[Xbnds,g,Xtgt]= getcode(m);

gmin= [c.min]';
gmax= [c.max]';

t.redrawmode='basic';
t(:,1).string=symb;
t(:,2:3).value= Xbnds;
t(:,4).value=ytr;
t(:,5).string= fnms(:);

t.redrawmode='normal';
t.redraw;

return





function i_firecb(cbstr,ud)
% parse callback string and execute it

if ~isempty(cbstr) 
   if ischar(cbstr)
      % parse for %MODEL% and %HOOK INTERNAL% and %POINTER%
      
      if strcmp(cbstr,'%HOOK_INTERNAL%');
         % execute internal function to do apply enable status
         i_applyenable(ud);
         return
      end
      
      ptr=ud.pointer;
      pcs=findstr(cbstr,'%');
      go=1;
      needobj=0;
      needval=0;
      while (go<=(length(pcs)-1))
         cmp=cbstr(pcs(go)+1:pcs(go+1)-1);
         if strcmp(cmp,'POINTER')
            needval=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_POINTER_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         elseif strcmp(cmp,'MODEL')
            needobj=1;
            cbstr=[cbstr(1:pcs(go)-1) 'XX_MODEL_XX' cbstr(pcs(go+1)+1:end)];
            go=go+2;
            pcs=pcs+6;
         else
            go=go+1;
         end
      end
      
      if needobj
         assignin('base','XX_MODEL_XX',ptr.info);
      end
      if needval
         assignin('base','XX_POINTER_XX',ptr);
      end
      evalin('base',cbstr);
      
      % clear up base workspace
      evalin('base','clear(''XX_MODEL_XX'',''XX_POINTER_XX'');');   
   else
      % Function handle
      if ~iscell(cbstr)
         cbstr={cbstr};
      end
      evt.NewModel=ud.pointer.info;
      if length(cbstr)>1
         feval(cbstr{1}, ud.mainlyt, evt, cbstr{2:end})
      else
         feval(cbstr{1}, ud.mainlyt, evt);
      end
   end
end
return




function i_applyenable(ud)

% decide enable status of apply/revert buttons
el=get(get(get(ud.mainlyt,'center'),'south'),'elements');
if ud.changedmodel
   set(el{1},'enable','on');
else
   set(el{1},'enable','off');
end
return




function [mout,ok]=i_createfig(m,Enable,Title);
if nargin<3
   Title= 'Factor Setup';
end
if nargin<2
   Enable= 1;
end

scr=get(0,'screensize');
figh=figure('visible','off',...
   'menubar','none',...
   'toolbar','none',...
   'doublebuffer','on',...
   'numbertitle','off',...
   'name',Title,...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',[scr(3)*.5-280 scr(4)*.5-175 470 300],...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'resize','off');

% parse varargin for options



p=xregpointer(m);
[lyt,objh,udh]=i_createlyt(figh,p,Enable);
% turn off apply button related actions
ud=get(udh,'userdata');
ud.applybutton=0;
set(udh,'userdata',ud);

frm=xregframetitlelayout(figh,'title','Factor settings','center',lyt);
% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
   'parent',figh,...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'');');
helpbtn = mv_helpbutton(figh,'xreg_modelInputSetup');
set(helpbtn,'position',[0 0 65 25]);

flw=xregflowlayout(figh,'orientation','right/center',...
   'gap',7,'elements',{helpbtn,cancbtn,okbtn},'border',[0 0 -7 0]);
brd=xregborderlayout(figh,'center',frm,'south',flw,'container',figh,...
   'innerborder',[10 45 10 10],'packstatus','on');
set(lyt,'visible','on');

% while loop allows us to check the inputs for errors
badinput=1;
while badinput
   set(figh,'visible','on');
   drawnow;
   set(figh,'windowstyle','modal','tag','');
   waitfor(figh,'tag');
   
   tg=get(figh,'tag');
   switch lower(tg)
   case 'ok'
      mout=p.info;
      % check info
      ud=get(udh,'userdata');
      ok=1;

      [mm,g,tgt]= i_getcode(mout,ud.table);
      try 
         mout= setcode(mout,mm,g,tgt);
         nms= ud.table(:,5).string;
         if ~iscell(nms)
            nms= {nms};
         end
         mout.Xinfo.Names= nms;
         ok=i_checkdata(ud);
      catch
         ok=0;
         hef=xregerror('Input Error');
         drawnow
         uiwait(hef)
      end
      
      if ok
         % allow loop to end
         badinput=0;
      end
   case 'cancel'
      mout=m;
      ok=0;
      badinput=0;
   end
end

freeptr(p);
delete(figh);
return



function i_NumFactors(h,evt,uh);

ud= get(uh,'userdata');
m=ud.pointer.info;
nf= h.Value;
nfold= nfactors(m);

if nf<nfold
   tstr= get(ud.table,'string');
   S= tstr(:,1);
   N= tstr(:,end);
   
   mn= xregcubic('nfactors',nf);
   
   mn.Xinfo.Names= N(1:nf);
   mn.Xinfo.Symbols= S(1:nf);
   
   ud.pointer.info= mn;
   % delete rows
   set(ud.table,'Rows.Number',nf+1)
   
elseif nf>nfold
   
   tstr= get(ud.table,'string');
   S= tstr(:,1);
   N= tstr(:,end);
   [bnds,g,tgt]= i_getcode(m,ud.table);
   % check bounds are ok (add 1 to minimum if not)
   ind= bnds(:,1)>=bnds(:,2);
   bnds(ind,2)= bnds(ind,1)+1;
   
   mn= xregcubic('nfactors',nf);
   
   % copy xinfo and coding to keep old factor settings the same
   mn.Xinfo.Names(1:nfold)= N;
   mn.Xinfo.Names(nfold+1:end)= {''};
   mn.Xinfo.Symbols(1:nfold)= S;
   mn.Xinfo.Units(1:nfold)= m.Xinfo.Units;
   
   % new coding ranges
   bnds(nfold+1:nf,1)= 0;
   bnds(nfold+1:nf,2)= 100;
   g(nfold+1:nf)= {''};
   tgt= repmat(recommendedTgt(m),nf,1);
   mn= setcode(mn,bnds,g,tgt);
   
   
   % create unique new factor settings to avoid conflicts in names
   %% symbol stem will be
   symb = cell(nf-nfold,1);
   [symb{:}] = deal(m.Xinfo.Symbols{end}(1));
   for i = nfold+1:nf
      symb{i-nfold} = [symb{i-nfold}, num2str(i)];
   end
   mn.Xinfo.Symbols(nfold+1:end)= symb;
   
   ud.pointer.info= mn;
   
   % add new rows to table
   t = ud.table;
   set(t,'rows.number',nf+1)
   set(t,...
      'cells.rowselection',[nfold+2 nf+1],...
      'cells.colselection',[1 3],...
      'cells.type','uiedit',...
      'cells.colselection',[4 4],...
      'cells.type','uipopupmenu',...
      'cells.string',{ud.trans},...
      'cells.value',1,...
      'cells.colselection',[5 5],...
      'cells.type','uiedit',...
      'cells.colselection',[1 5],...
      'cells.horizontalalignment','left')
   
   ud=i_redrawtable(ud);
   set(uh,'userdata',ud);
end	





function ok=i_checkdata(ud)

m=ud.pointer.info;
% check strings are valid and all different
str=get(m,'symbol');
strOK= true(size(str));
for n=1:length(str)
    strOK(n)= isvarname(str{n}) && (sum((strcmp(str{n},str)))==1);
end
if ~all(strOK)
   error(['Duplicate or invalid model symbols', sprintf(' %s',str{~strOK}),'. The model definition has not been updated.']);
   return
end    

ok=1;
return


function [mm,g,tgt]= i_getcode(m,t)

%minmax
mm=t(:,2:3).value;
%ytrans
ytr=t(:,4).value;
ytrstr=t(1,4).string;

t.redrawmode='basic';
for i=1:length(ytr)
   if ytr(i)==1
      % first item on popup menu is 'None' for no transformation
      g{i}= '';
   else
      % other items are the actual expressions for coding transformation
      g{i}= inline(ytrstr{ytr(i)});
   end
end

tgt= repmat(recommendedTgt(m),[nfactors(m),1]);


function i_cellchng(t,eventData,udh,m)

ud=get(udh,'userdata');
%% add/change callback depending on column number
if eventData.Column ==1
   % get all symbols and insert into model
   % symbol changing interface??
   symb=t(:,1).string;
   if ~iscell(symb)
      symb={symb};
   end
   m=ud.pointer.info;
   % check for empty strings - reject immediately
   if any(cellfun('isempty',symb))
      symb=get(m,'symbol');
      t(:,1).string=symb;      
   else
      if ~isempty(gcbo);
         si= get(gcbo,'string');
         tstr = [findstr(si,'_') findstr(si,'\') findstr(si,'^') findstr(si,'{') findstr(si,'}')];
         if  ~isempty(tstr) 
            style= struct('WindowStyle','modal','Interpreter','TeX');
            warndlg(['The symbol contains TeX expressions and will be displayed as "',si,...
                  '" in equation expressions.'],'Symbol Definition',style);
         end
      end
      set(m,'symbol',symb);
      ud.pointer.info=m;
      ud.changedmodel=1;
      
      set(udh,'userdata',ud);
      if ~isempty(ud.callback)
         i_firecb(ud.callback,ud);
      end
   end
   
else
   % grab min, max and transform data and insert into model
   m=ud.pointer.info;
   
   [mm,g,tgt]= i_getcode(m,t);
   
   % disable target ranges for now
   t.redrawmode='normal';
   t.redraw;
   
   ud.changedmodel=1;
   set(udh,'userdata',ud);
   if ~isempty(ud.callback)
      i_firecb(ud.callback,ud);
   end
end
