function [mout,ok]=gui_modelsetup2(m,action,varargin)
% GUI_MODEL2SETUP   GUI for editing model variables
%
%   [mout, ok]=GUI_MODELSETUP2(m);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:52:05 $




if nargin<2
   action='figure';
end



switch lower(action)
case 'figure'
   [mout,ok]= i_createfig(m,varargin{:});
end



return




function [mout, ok]=i_createfig(m,varargin)
scr=get(0,'screensize');
pt= get(0,'PointerLocation');

fpos= [min(scr(3)-360,pt(1)+20) scr(4)*.5-175 370 350];
figh=figure('visible','off',...
   'menubar','none',...
   'toolbar','none',...
   'doublebuffer','on',...
   'numbertitle','off',...
   'name','Input Factor Setup',...
   'position',fpos,...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'resize','off',...
   'renderer','zbuffer');
%set(figh,'closerequestfcn','set(gcbf,''tag'',''cancel'');');

p=xregpointer(m);
[lyt, udh]=i_createlyt(figh,p,varargin{:});
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

flw=xregflowlayout(figh,'orientation','right/center',...
   'gap',7,'elements',{cancbtn,okbtn},'border',[0 0 3 0]);
grd=xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'rowsizes',[-1 25],'border',[0 10 0 0],'elements',{lyt, flw},...
   'container',figh,'packstatus','on');
set(lyt,'visible','on');

%while loop allows us to check the inputs for errors
badinput=1;
while badinput
   set(figh,'visible','on');
   drawnow;
   set(figh,'windowstyle','modal','tag','','closerequestfcn','set(gcbf,''tag'',''cancel'');');
   waitfor(figh,'tag');
   
   tg=get(figh,'tag');
   switch lower(tg)
   case 'ok'
      % check info
      ok=i_checkdata(udh);
      if ~ok
         % allow loop to end
         badinput=0;
         ok=1;
         mout=p.info;
      else
         % reselect appropriate index ready for alteration?
         i_selforcorrection(udh,ok); 
         ok=0;
      end
   case 'cancel'
      mout=m;
      ok=0;
      badinput=0;
   end
end

set(figh,'visible','off');
freeptr(p);
delete(figh);
return




function [lyt, udh]=i_createlyt(figh,p,ReadOnly)


if nargin==2
	ReadOnly=0;
end
ud.ReadOnly= ReadOnly;
ud.figure = figh;
ud.pointer=p;

str='This tells the user what to do....';
txt(1)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'string','');
div1= xregGui.dividerline(figh);
div2= xregGui.dividerline(figh,'orientation','vertical');

ud.list= xregGui.listeditor(figh,'backgroundcolor',[1 1 1],...
   'additemmode','unboundlist',...
   'newitemtemplate', 'X%d',...
   'visible','off',...
   'ListSelectionFcn',{@i_listsel, txt(1)},...
   'ListReorderFcn', {@i_listmove, txt(1)},...
   'AddItemFcn', {@i_listadd, txt(1)},...
   'DeleteItemFcn', {@i_listrem, txt(1)});
if ud.ReadOnly
	set(ud.list,'enable','off');
end

txt(2)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Symbol:');
txt(3)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Variable Range:');
txt(4)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Transformation:');
txt(5)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Target Range:');

txt(6)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Signal Name:');
txt(7)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'position', [0 0 80 15],...
   'string','Units:');


ud.info(1)= uicontrol('parent',figh,...
   'visible','off',...
   'style','text',...
   'horizontalalignment','left',...
   'string','n variables defined.');

ud.edit.symb= uicontrol('parent',figh,...
   'visible','off',...
   'style','edit',...
   'callback',{@i_editsymb, txt(1)},...
   'position',[0 0 80 20],...
   'backgroundcolor','w',...
   'horizontalalignment','left');
ud.edit.varmin= uicontrol('parent',figh,...
   'visible','off',...
   'style','edit',...
   'callback',{@i_editvarrange, txt(1)},...
   'position',[0 0 50 20],...
   'backgroundcolor','w',...
   'horizontalalignment','right');
ud.edit.varmax= uicontrol('parent',figh,...
   'visible','off',...
   'style','edit',...
   'callback',{@i_editvarrange, txt(1)},...
   'position',[0 0 50 20],...
   'backgroundcolor','w',...
   'horizontalalignment','right');
ud.edit.trans= uicontrol('parent',figh,...
   'visible','off',...
   'style','popupmenu',...
   'string',{'None','1./x','sqrt(x)','log10(x)','x.^2','log(x)'},...
   'callback',{@i_edittrans, txt(1)},...
   'position',[0 0 105 20],...
   'backgroundcolor','w');


ud.edit.Signals= uicontrol('parent',figh,...
   'visible','off',...
   'style','edit',...
   'callback',{@i_editSignal, txt(1)},...
   'position',[0 0 80 20],...
   'backgroundcolor','w',...
   'horizontalalignment','left');

ud.edit.Units= uicontrol('parent',figh,...
   'visible','off',...
   'style','edit',...
   'callback',{@i_editUnits, txt(1)},...
   'position',[0 0 80 20],...
   'backgroundcolor','w',...
   'horizontalalignment','left');


% Layouts

grd= xreggridlayout(figh,'correctalg','on','dimension',[3 1],...
   'rowsizes',[20 20 20],'gap',5,...
   'elements',...
	{xregflowlayout(figh,'orientation','left/center','border',[-5 0 0 0],...
		'gap',5,'elements',{txt(2), ud.edit.symb}),...
		xregflowlayout(figh,'orientation','left/center','border',[-5 0 0 0],...
		'gap',5,'elements',{txt(3), ud.edit.varmin, ud.edit.varmax}),...
		xregflowlayout(figh,'orientation','left/center','border',[-5 0 0 0],...
		'gap',5,'elements',{txt(4), ud.edit.trans})} );

 frmReqd= xregframetitlelayout(figh,'title','Required Settings','innerborder',[20 5 5 5],...
    'center',grd);


grd= xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'rowsizes',[20 20],'gap',5,...
   'elements',...
	{xregflowlayout(figh,'orientation','left/center','border',[-5 0 0 0],...
	'gap',5,'elements',{txt(6), ud.edit.Signals}),...
	xregflowlayout(figh,'orientation','left/center','border',[-5 0 0 0],...
	'gap',5,'elements',{txt(7), ud.edit.Units})} );

 frmOpt= xregframetitlelayout(figh,'title','Optional Settings','innerborder',[20 5 5 5],...
    'center',grd);



grd= xreggridlayout(figh,'correctalg','on','dimension',[2 1],...
   'rowsizes',[120 80],'gap',10,...
   'elements',...
	{ frmReqd frmOpt }  );
lyt= xreggridlayout(figh,'correctalg','on',...
   'dimension',[2 1],'rowsizes',[10  -1],...
   'elements',{txt(1), ...
      xreggridlayout(figh,'correctalg','on','border',[10 0 10 10],...
      'dimension',[1 3],'colsizes',[120 25 -1],...
      'elements',{xreggridlayout(figh,'correctalg','on',...
         'dimension',[2 1],'rowsizes',[-1 15],...
         'gap',10,'elements',{ud.list,ud.info(1)}),...
         div2, grd})});
ud.main=lyt;
ud.valuesgrid=grd;

[ud.data.bnds, ud.data.g ud.data.tgt] = peval('getcode',p);
ud.data.xinfo= p.xinfo;
ud.data.xinfo.Symbols= ud.data.xinfo.Symbols(:);
ud.data.xinfo.Units= ud.data.xinfo.Units(:);
ud.data.xinfo.Names= ud.data.xinfo.Names(:);
ud.data.nvar= length(ud.data.xinfo.Symbols);
ud=i_setvalues(ud);
set(txt(1),'userdata',ud);
udh=txt(1);
return



function ud=i_setvalues(ud)
% set list
ud.list.ItemList=ud.data.xinfo.Symbols(:)';
if ~isempty(ud.data.xinfo.Symbols)
   set(ud.valuesgrid,'enable','on');
   ind= ud.list.SelectedItem;
   ud.Viewind=ind;
   % symbol
   set(ud.edit.symb,'string',ud.data.xinfo.Symbols{ind});
	
	set(ud.edit.Signals,'string',ud.data.xinfo.Names{ind})
	set(ud.edit.Units,'string',char(ud.data.xinfo.Units{ind}))
	
   % var range
   set([ud.edit.varmin;ud.edit.varmax], {'string'},{ud.data.bnds(ind,1);ud.data.bnds(ind,2)});
   % transform
   gind=strmatch(char(ud.data.g{ind}), get(ud.edit.trans,'string'), 'exact');
   if isempty(gind)
      gind=1;
   end
   set(ud.edit.trans,'value',gind);
else
   set(ud.valuesgrid,'enable','off');
   set([ud.edit.symb; ud.edit.varmin;ud.edit.varmax],'string','');
   set([ud.edit.trans],'value',1);
end
% info strings
set(ud.info(1), 'string', sprintf('%d variables defined', ud.data.nvar));
if ud.ReadOnly
	set([ud.edit.symb; ud.edit.varmin;ud.edit.varmax;ud.edit.trans;ud.edit.Signals;ud.edit.Units],'enable','off');
end

return



function i_editsymb(obj,nul,figh)
% update the list
ud=get(figh,'userdata');
ud.data.xinfo.Symbols{ud.Viewind}=get(obj,'string');
ud.list.ItemList= ud.data.xinfo.Symbols;
set(figh,'userdata',ud);



function i_editvarrange(obj,nul,figh)
ud=get(figh,'userdata');
% check bounds for non-numeric values
newbnds=[str2double(get(ud.edit.varmin,'string')), str2double(get(ud.edit.varmax,'string'))];
if any(isnan(newbnds))
   % reject change
   set([ud.edit.varmin;ud.edit.varmax], {'string'},{ud.data.bnds(ud.Viewind,1);ud.data.bnds(ud.Viewind,2)});
else
   % accept change (provisionally)
   ud.data.bnds(ud.Viewind,:)=newbnds;
	m= ud.pointer.info;
	Tgt= recommendedTgt(m);
   if any(~isfinite(Tgt))
      % use these values for target too
      ud.data.tgt(ud.Viewind,:)=newbnds;
   end
   set(figh,'userdata',ud);
end



function i_edittrans(obj,nul,figh)
ud=get(figh,'userdata');

val=get(obj,'value');
trans_str=get(obj,'string');
if val==1
   ud.data.g{ud.Viewind}='';
else
   ud.data.g{ud.Viewind}= inline(trans_str{val});
end
set(figh,'userdata',ud);

   
   
function i_listmove(obj,evt, udh)
ud=get(udh,'userdata');
% get reordered indices
ord=ud.list.Value;
% reorder model
ud.pointer.info=ud.pointer.reorderx(ord);
% reorder my stored data
ud.data.g=ud.data.g(ord);
ud.data.bnds=ud.data.bnds(ord,:);
ud.data.tgt=ud.data.tgt(ord,:);
ud.data.xinfo.Names=ud.data.xinfo.Names(ord);
ud.data.xinfo.Symbols=ud.data.xinfo.Symbols(ord);
ud.data.xinfo.Units=ud.data.xinfo.Units(ord);

% set new, reordered list into listeditor
ud.list.ItemList=ud.data.xinfo.Symbols(:)';
ud.Viewind=ud.list.SelectedItem;

set(udh,'userdata',ud);
return



function i_listadd(obj,evt, udh)
ud=get(udh,'userdata');

symb=ud.list.ItemList(ud.list.Value);
ud.list.ItemList=symb;
ind=ud.list.SelectedItem;
if ind==0
   ind=1;
end
m = ud.pointer.addfactors(ind);
ud.pointer.info= m;
% add data
 
xi= ud.data.xinfo;

i=1;
while any(strcmp(sprintf('X%1d',i),xi.Symbols))
	i=i+1;
end
symb= sprintf('X%1d',i);
Tgt= recommendedTgt(m);
ud.data.bnds= [ud.data.bnds(1:ind-1,:); Tgt; ud.data.bnds(ind:end,:)];
ud.data.tgt= [ud.data.tgt(1:ind-1,:); Tgt ; ud.data.tgt(ind:end,:)];
ud.data.g= [ud.data.g(1:ind-1) {''} ud.data.g(ind:end)];
ud.data.xinfo.Symbols= [xi.Symbols(1:ind-1) ; {symb};  xi.Symbols(ind:end)];
ud.data.xinfo.Names= [xi.Names(1:ind-1) ; {''};  xi.Names(ind:end)];
ud.data.xinfo.Units= [xi.Units(1:ind-1) ; {junit};  xi.Units(ind:end)]; 


ud.data.nvar= length(ud.data.xinfo.Names);

% redisplay data
ud.Viewind=0;
ud=i_setvalues(ud);
set(udh,'userdata',ud);
return



function i_listrem(obj,evt, udh)
ud=get(udh,'userdata');

ind=ud.Viewind;
% remove factor from model
ud.pointer.info=ud.pointer.rmfactors(ind);
% remove data
ud.data.g(ind)=[];
ud.data.bnds(ind,:)=[];
ud.data.tgt(ind,:)=[];
ud.data.xinfo.Symbols(ind)=[];
ud.data.xinfo.Names(ind)= [];
ud.data.xinfo.Units(ind)= []; 

ud.data.nvar= length(ud.data.xinfo.Names);

% redisplay
ud.Viewind=0;
ud=i_setvalues(ud)';
set(udh,'userdata',ud);
return



function i_listsel(obj,evt, udh)
ud=get(udh,'userdata');
if ud.Viewind~=ud.list.SelectedItem
   ud=i_setvalues(ud);
   set(udh,'userdata',ud);
end
return





function ok=i_checkdata(udh)
% check the gui data into the model object
ud=get(udh,'userdata');

m=ud.pointer.info;

if nfactors(m)==0
	h=errordlg('Models must have at least one input.','Error','modal');
	ok=1;
	return
end

% check strings are valid and all different
str=ud.data.xinfo.Symbols;
N=length(str);
strOK=ones(N,1);
strdup=ones(N,1);
for n=1:N
   strOK(n)= isvarname(str{n});
   strdupOK(n)= length(strmatch(str{n}, str, 'exact'))<2;
end


if ~all(strOK)
   ind=find(~strOK);
   ind=ind(1);
   h=errordlg(sprintf('Invalid symbol: %s.  Please enter a valid MATLAB variable name.',str{ind}),'Error','modal');
   ok=ind;
   return
end    
if ~all(strdupOK)
   ind=find(~strdupOK);
   ind=ind(2);
   h=errordlg(sprintf('Duplicate symbol: %s.  Please enter a new symbol for this variable.', str{ind}),'Error','modal');
   ok=ind;
   return
end 


% passed all tests: put data into model
m= ud.pointer.info;

try 
	m= setcode(m, ud.data.bnds, ud.data.g, ud.data.tgt);
	m= xinfo(m,ud.data.xinfo);
	ud.pointer.info= m;
	ok=0;
catch
	xregerror;
	ok= 1;
end

return


function i_selforcorrection(udh,ind)
ud=get(udh,'userdata');
ud.list.SelectedItem=ind;
i_listsel([],[],udh);
return


function i_editSignal(h,evt,udh);

ud= get(udh,'userdata');
ind= ud.list.SelectedItem;
ud.data.xinfo.Names{ind}= get(h,'string');
set(udh,'userdata',ud);


function i_editUnits(h,evt,udh);

ud= get(udh,'userdata');
ind= ud.list.SelectedItem;
try
	uc= get(h,'string');
	ud.data.xinfo.Units{ind}= junit(uc);
	set(udh,'userdata',ud);
catch
	xregerror('Invalid Units',['Unrecognised units: ',uc]);
	set(h,'string',char(ud.data.xinfo.Units{ind}));
end
