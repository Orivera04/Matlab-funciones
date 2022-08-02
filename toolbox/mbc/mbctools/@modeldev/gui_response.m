function [mdout,ok]=gui_response(mdev,action,figh,p_mdev)
% GUI_RESPONSE  GUI for altering response model settings
%
%  [M,OK]=GUI_RESPONSE(TP,M) creates a modal dialog for selecting the
%  response model type.  TP is the testplan, M is the current model.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.4.6 $  $Date: 2004/04/04 03:31:53 $

if nargin<3
   action='figure';
end

switch lower(action)
case 'figure'
   [mdout,ok]=i_createfig(mdev);   
case 'layout'
   mdout=i_createlyt(figh,p_mdev);
case 'yvar'
   i_getdata(figh,'Y');
case 'datum'
   i_dtmmodel(figh);
end



function [mdout,ok]=i_createfig(md)
scsz=get(0,'screensize');
pt= get(0,'PointerLocation');
fpos= [pt(1)-280 pt(2)-320 270 300];
if fpos(1)<0
	fpos(1)= 20;
end
if fpos(2)<0
	fpos(2) = 20;
end

figh=xregfigure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Response Model Setup',...
   'doublebuffer','on',...
   'renderer','zbuffer',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',fpos,...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','ResponseModSetup',...
   'resize','off');
figh= double(figh);

xregcenterfigure(figh,fpos([3,4]));

p_md=address(md);
[lyt,ud]=i_createlyt(figh,p_md);


% ok and cancel buttons
okbtn = uicontrol('parent',figh,...
   'string','OK',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'position',[0 0 65 25]);
cancbtn = uicontrol('parent',figh,...
   'string','Cancel',...
   'style','pushbutton',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'position',[0 0 65 25]);
helpbtn = mv_helpbutton(figh,'xreg_responseSetup');
set(helpbtn,'position',[0 0 65 25]);

flw=xregflowlayout(figh,'orientation','right/bottom',...
   'elements',{helpbtn,cancbtn,okbtn},...
   'gap',7,...
   'border',[0 10 -7 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
   'innerborder',[10 45 10 10],...
   'container',figh,...
   'packstatus','on');

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');

tg=get(figh,'tag');
switch lower(tg)
case 'ok'
	
   mdout=p_md.info;
	
	Tp= Parent(mdout);
	
	VarNames= get(ud.ylist,'string');
	DataInd= get(ud.ylist,'value');
	YName= VarNames{DataInd};
	% update ydata for response node
	ssf= dataptr(mdout,'Y');
	Y= addVarsFilter(ssf,{YName});
	mdout= name(mdout,YName);
   mdout= AssignData(mdout,'Y',Y);
	
	py= Tp.dataptr('Y');
	YTP= py.info;
    
    if ~any( strcmp(YName,get(YTP,'Name')) );
        % add variable to testplan data
        YTP= addVarsFilter(YTP,[get(YTP,'Name'); {YName} ]);
        % update cache and assign back on heap
        py.info= updateCache(YTP);
    end
    
    
	
	% set yinfo field
	Y= getdata(mdout,'Y');
	
	yn= get(Y,'name');
	yu= get(Y,'units');
	yi= yinfo(mdout.Model);
	yi.Name   = yn{1};
	yi.Symbol = yn{1};
	yi.Units  = yu{1};
	
	mdout.Model= yinfo(mdout.Model,yi);
	pointer(mdout);
	
	
	
	
   ok=1;
	
case 'cancel'
   mdout=md;
   pointer(mdout);
   ok=0;
end
% don't free pointer - it's a dynamic copy that's shared by everyone!
delete(figh);
return




function [lyt,ud]=i_createlyt(figh,p_md);

ud.figh=figh;
ud.mdpointer=p_md;

bgcol=get(figh,'defaultuicontrolbackgroundcolor');


ytxt=uicontrol('style','text',...
   'parent',figh,...
   'horizontalalignment','left',...
   'string','Response:',...
	'fontweight','bold',...
   'position',[0 0 50 15]);

ud.ylist=uicontrol('style','listbox',...
   'parent',figh,...
   'position',[0 0 20 20],...
	'backgroundcolor','w',...
   'interruptible','off');

% data
udh=ytxt;


els= {ytxt;ud.ylist};
rsize= [15 -1];


m= p_md.model;

if isa(m,'xregtwostage') 
	
	L= get(m,'Local');
	
	%& nfactors(get(m,'local'))==1 & ...
	%	any(strcmp(class(get(m,'Local')),{'localpspline','localpoly'}))
	
	% twostage option layouts
	

	mtxt=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Local model:',...
		'position',[0 0 80 15]);
	ud.localMod=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','',...
		'position',[0 0 100 20],...
		'interruptible','off',...
		'userdata',1);

	btn =uicontrol('style','push',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Set Up...',...
		'position',[0 0 20 20],...
		'interruptible','off',...
		'userdata',1);


		gtxt=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Global model:',...
		'position',[0 0 80 15]);
	ud.globalMod=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','',...
		'position',[0 0 100 20],...
		'interruptible','off',...
		'userdata',1);

	gbtn =uicontrol('style','push',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Set Up...',...
		'position',[0 0 20 20],...
		'interruptible','off',...
		'userdata',1);

	

	
	dtmtxt=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Datum:',...
		'position',[0 0 40 15]);
	ud.dtmpop=uicontrol('style','popupmenu',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string',{'None','Maximum','Minimum','Link to R1 datum'},...
		'position',[0 0 100 20],...
		'backgroundcolor','w',...
		'interruptible','off',...
		'userdata',1);
	
	
	
	set(btn,'callback',{@i_setLocal,udh});
	set(gbtn,'callback',{@i_setGlobal,udh});
	set(ud.dtmpop,'callback',{@i_dtmmodel,udh});
	
	flocal=xreggridlayout(figh,'dimension',[3 3],...
		'elements',{mtxt,ud.localMod,btn;
		dtmtxt,ud.dtmpop,[];
		gtxt,ud.globalMod,gbtn},...
		'correctalg','on',...
		'rowsizes',[20 20 20],...
		'colsizes',[70 100 60],...
		'gap',5);

	flocal= xregframetitlelayout(figh,...
		'title','Model',...
		'center',flocal);
	els= [els;{[];flocal}];
	rsize= [rsize 10 100];
	
else
			gtxt=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','Model:',...
		'position',[0 0 80 15]);
	ud.globalMod=uicontrol('style','text',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','',...
		'position',[0 0 100 20],...
		'interruptible','off',...
		'userdata',1);

	gbtn =uicontrol('style','push',...
		'parent',figh,...
		'horizontalalignment','left',...
		'string','...',...
		'position',[0 0 20 20],...
		'interruptible','off',...
		'userdata',1);

	fm=xreggridlayout(figh,'dimension',[1 3],...
		'elements',{gtxt,ud.globalMod,gbtn},...
		'correctalg','on',...
		'rowsizes',20,...
		'colsizes',[80 100 20],...
		'gapy',5);

	set(gbtn,'callback',{@i_setModel,udh});

	
	els= [els;{[];fm}];
	rsize= [rsize 10 20];


end

ud.gsetup= gbtn;
lyt= xreggridlayout(figh,...
	'dimension',size(els),...
	'elements',els,...
	'correctalg','on',...
	'rowsizes',rsize);


% initialise values
i_setvalues(ud);

set(ytxt,'userdata',ud);
return




function i_setvalues(ud)

[X,Y]= dataptr(ud.mdpointer.info);
m=ud.mdpointer.model;

if isfield(ud,'dtmpop');
	% set up string in Datum popupmenu
	DatumTypes= {'None','Maximum','Minimum','R1 datum'};
	proot= ud.mdpointer.Parent;
	R1= proot.children(1);
	if ud.mdpointer.childindex==1
		% can't have link to R1 for R1!
		DatumTypes=DatumTypes(1:end-1);
	elseif R1.dataptr('DATA')==0
		% No datum defined for R1 so can't have link;
		DatumTypes=DatumTypes(1:end-1);
	else
		DatumTypes{end}= sprintf('%s datum',R1.name);
	end
	set(ud.dtmpop,'string',DatumTypes);
	% stages
	if isa(m,'xregtwostage')
		L= get(m,'local');
		% datum model
		if permitsDatum(L)
			set(ud.dtmpop,'enable','on');
		else
			set(L,'DatumType',0);
			set(ud.dtmpop,'value',1,'enable','off');
		end
		set(ud.localMod,'string',name(L))
        set(ud.gsetup,'enable','on');

        G= get(m,'global');
        if length(G)>0
            n1= name(G{1});
            isSame= 1;
            for i=2:length(G)
                isSame= isSame & strcmp(n1,name(G{i}));
            end
            if isSame
                set(ud.globalMod,'string',n1)
            else
                set(ud.globalMod,'string','')
            end
        else
            set(ud.globalMod,'string','')
            set(ud.gsetup,'enable','off');
        end
		set(ud.dtmpop,'value',get(m,'DatumType')+1,'userdata',get(m,'DatumType')+1);
	end
else
	set(ud.globalMod,'string',name(m))
end

Tp=  ud.mdpointer.Parent; 
m= ud.mdpointer.model;

TestData=  DataLink(Tp.info);
VarNames= get(TestData,'name');

Xnames= Tp.factors;
% remove X variables
VarNames=setdiff(VarNames,Xnames);

n= get(Y,'keepvariables');
VarInd= find(strcmp(n,VarNames));
set(ud.ylist,'string',VarNames,...
	'ListBoxTop',max(1,VarInd-5),...
	'value',VarInd);
return


function i_dtmmodel(h,evt,udh)
ud = get(udh,'userdata');
newval=get(ud.dtmpop,'value');
oldval=get(ud.dtmpop,'userdata');
if newval==oldval
   return
end
set(ud.dtmpop,'userdata',newval);
Tp = ud.mdpointer.Parent;
DatumType = newval - 1;
switch DatumType
case {1,2}
   DatumModel = Tp.model;
   ud.mdpointer.AssignData('Data',xregpointer);
case 3
   R1= Tp.children(1);
   ud.mdpointer.AssignData('Data',R1.dataptr('data'));
   DatumModel = Tp.model;
otherwise
   DatumModel = 0;
   ud.mdpointer.AssignData('Data',xregpointer);
end

m=ud.mdpointer.model;
L= get(m,'local');
if DatumType & ~(isa(L,'localpoly') | isa(L,'localpspline'))
	L= localpoly;
end
if get(L,'DatumType') ~= DatumType
   set(L,'DatumType',DatumType);
   set(m,'Local',L);
   set(m,'Datum',DatumModel);
end
ud.mdpointer.model(m);
return


function i_setLocal(h,evt,udh)
ud = get(udh,'userdata');

p= ud.mdpointer;
TS= p.model;
OldModel= TS;
xL= p.dataptr('X');
xL= xL.info;

L= get(TS,'local');
GM= get(TS,'global');

[L,OK]= gui_localmodsetup(L,'figure',isEquiSpaced(xL(:,1)),nfactors(L));
if OK
	set(TS,'Local',L);
	
	if any(strcmp(class(L),{'localpspline','localpoly'}))
		set(ud.dtmpop,'enable','on');
	else
		set(L,'DatumType',0);
		set(ud.dtmpop,'value',1,'enable','off');
 	end

	if numfeats(L)>0
        set(ud.gsetup,'enable','on');
    else
        set(ud.gsetup,'enable','off');
    end
        

	set(ud.localMod,'string',name(L))
	if OK==3
		% get default global model from testplan
		GM= model(p.mdevtestplan);
		% model type or num response features have changed
		TS= xregtwostage(L,GM);
	end
	p.model(TS);

	
end





function i_setGlobal(h,evt,udh)

ud = get(udh,'userdata');

p= ud.mdpointer;
TS= p.model;
L= get(TS,'local');
GM= get(TS,'global');

[m,OK]= gui_ModelSetup(GM{1});
if OK
	TS= xregtwostage(L,m);
	p.model(TS);
	set(ud.globalMod,'string',name(m));
end
	

function i_setModel(h,evt,udh)

ud = get(udh,'userdata');

p= ud.mdpointer;
m= p.model;

[m,OK]= gui_ModelSetup(m);
if OK
	p.model(m);
	set(ud.globalMod,'string',name(m));
end
