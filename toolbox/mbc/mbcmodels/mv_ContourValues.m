function mv_ContourVals(Action,varargin)
% MV_CONTOURVALUES GUI to set up contour plot properties

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.7.4.2 $  $Date: 2004/02/09 08:02:00 $

switch lower(Action)
case 'create'
   i_Create(varargin{:});
case 'ok'
   i_OK
case 'edit'
   i_Values
case 'type'
   i_Radio
end

function i_Create(ParFig,mfile)

oldunits=get(0,'units');
set(0,'units','pixels');
pos=get(0,'PointerLocation');
set(0,'units',oldunits);
hFig=xregfigure('units','pixels',...
   'Position',[pos(1) pos(2) 320 240],...
   'WindowStyle','modal',...
   'Number','off',...
   'Name','Contour Values',...
   'color',get(0,'DefaultUicontrolBackGroundColor'),...
   'resize','off',...
   'menubar','none');
hFig= double(hFig);

udv= get(gcbo,'userdata');
if isempty(udv)
   udv.V=[];
   udv.labels= 0;
   udv.fill= 1;
end
   
V= udv.V;
switch length(V)
case 0
   InitVal=[1 0 0];
case 1
   InitVal=[0 1 0];
otherwise
   InitVal=[0 0 1];
end   
   
cb(1)=uicontrol('parent',hFig,...
   'pos',[20 190 280 15],...
   'style','check',...
   'value',udv.labels,...
   'string','Contour Labels',...
   'horizontal','left');
cb(2)=uicontrol('parent',hFig,...
   'pos',[20 210 280 15],...
   'style','check',...
   'value',udv.fill,...
   'string','Fill Contour',...
   'horizontal','left');
   
   
labs= {'Auto';'N Contour Lines';'Specify values'};
% rh= radio('create',hFig,[20 180 280 10],labs,'Contour Values',InitVal);
% set(rh,'callback',[mfilename,'(''type'')']);
rh = xregGui.rbgroup(hFig,'nx',1,'ny',3,'value',InitVal',...
	'string',labs,...
   'position',[30 100 220 80],...
	'visible','on',...
   'callback',{@i_Radio});
fr=xregframetitlelayout(hFig,'position',[30 100 220 80],'center',rh);


eh=uicontrol('parent',hFig,...
   'pos',[20 70 280 20],...
   'style','edit',...
   'horizontal','left',...
   'BackGroundColor','w','visible','off',...
   'callback',[mfilename,'(''edit'')']);
if find(InitVal)>1
   set(eh,'string',prettify(V),'user',V,'vis','on');
end

okBtn = uicontrol('parent',hFig,...
   'pos',[20 20 65 25],...
   'style','push',...
   'string','OK',...
   'callback',[mfilename,'(''OK'')']);
cancelBtn = uicontrol('parent',hFig,...
   'pos',[120 20 65 25],...
   'style','push',...
   'string','Cancel',...
   'callback','close(gcbf)');
helpBtn = mv_helpbutton(hFig,'xreg_contourSettings');

btnGrid = xreggridlayout(hFig,...
   'dimension',[1,5],...
   'correctalg','on',...
   'colsizes',[-1,65,65,65,10],...
   'gapx',7,...
   'elements',{[],okBtn,cancelBtn,helpBtn,[]},...
   'position',[0 10 320 25]);


Lud.cb= cb;
Lud.udv= udv;
Lud.radio= rh;
Lud.values= eh;
Lud.store= gcbo;
Lud.ParFig= ParFig;
Lud.mfile= mfile;

set(hFig,'userdata',Lud);

function i_Radio(src, null)

ud=get(gcbf,'userdata');
newval= get(src,'value');
switch find(newval)
case 1
	set(ud.values,'visible','off');
case 2
	set(ud.values,'string',10,'userdata',10,'visible','on');
case 3
	set(ud.values,'string','1:10','userdata',1:10,'visible','on');
end

function i_Values

ud=get(gcbf,'userdata');

Type= get(ud.radio,'value');
switch find(Type)
case 2
   xregCheckIsNum('int','on','range',[1 100]);
case 3
   try 
      OldVals= get(ud.values,'userdata'); 
      NewVals= get(ud.values,'string');
      NewVals= eval(['[',NewVals,']']);
      NewVals= NewVals(:)';
      if ~isa(NewVals,'double') | isempty(NewVals)
         error('');
      end
      set(ud.values,'userdata',NewVals);
   catch 
      set(ud.values,'string',prettify(OldVals));
   end
end




function i_OK

ud=get(gcbf,'userdata');
Type= get(ud.radio,'value');
switch find(Type)
case 1
   Vals= [];
case 2
   Vals= get(ud.values,'userdata');
case 3
   Vals= get(ud.values,'userdata');
   if length(Vals)==1
      Vals = [Vals Vals];
   end
end
udv= ud.udv;
udv.V=Vals;
udv.labels= get(ud.cb(1),'value');
udv.fill= get(ud.cb(2),'value');

set(ud.store,'userdata',udv);
delete(gcbf)
feval(ud.mfile,'plot',ud.ParFig)




