function [lm,ok]=gui_respfeat(lm,rfno,action,varargin)
% GUI_RESPFEAT   Dialog for altering response feature settings
%
%   [LM,OK]=GUI_RESPFEAT(LM,RFNO) creates a modal dialog box for choosing
%   a response feature from LM and using it as the feature with index RFNO.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:39:14 $




if nargin<3
   action='figure';
end
if nargin<2
   rfno=1;
end

switch lower(action)
case 'figure'
   [lm,ok]=i_createfig(lm,rfno);
case 'layout'
   lyt=i_createlyt(varargin{:}, rfno);
   ok=1;
case 'chngrf'
   i_changerf(varargin{:});
case 'chngvalue'
   i_changevals(varargin{:});
case 'chnglimits'
   i_changevals(varargin{:});
end




function [lmout,ok]=i_createfig(lm,rfno);

scsz=get(0,'screensize');

wid= 230+max(0,nfactors(lm)-2)*55;
figh=xregfigure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Response Features',...
   'doublebuffer','on',...
   'renderer','zbuffer',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'position',[scsz(3).*0.5-125 scsz(4).*0.5-150 wid 300],...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','RespFeat',...
   'resize','off');
figh= double(figh);

p=xregpointer(lm);
lyt=i_createlyt(figh,p,rfno);


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
helpbtn = mv_helpbutton(figh,'xreg_rfSetup');
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
   lmout=p.info;
   ok=1;
case 'cancel'
   lmout=lm;
   ok=0;
end
freeptr(p);
delete(figh);
return


function lyt=i_createlyt(figh,p,rfno);

L= p.info;
if ~isa(figh,'xregcontainer')
   ud.pointer=p;
   ud.rfno=rfno;
   txt=uicontrol('style','text',...
      'parent',figh,...
      'string','Select the response feature you wish to model:',...
      'horizontalalignment','left');
   ud.resplist=uicontrol('style','listbox',...
      'backgroundcolor','w',...
      'parent',figh);
   noopts=uicontrol('style','text',...
      'parent',figh,...
      'string','No options are available for this response feature.',...
      'horizontalalignment','left');
	for i= 1:nfactors(L) 
		ud.value(i)=uicontrol('style','edit',...
			'parent',figh,...
			'backgroundcolor','w',...
			'position',[0 0 50 20]);
	end
	ud.lims(1)=uicontrol('style','edit',...
      'parent',figh,...
      'backgroundcolor','w',...
      'position',[0 0 50 20]);
   ud.lims(2)=uicontrol('style','edit',...
      'parent',figh,...
      'backgroundcolor','w',...
      'position',[0 0 50 20]);
   text1=uicontrol('style','text',...
      'parent',figh,...
      'string','Value:',...
      'position',[0 0 35 15],...
      'horizontalalignment','left');
   text2=uicontrol('style','text',...
      'parent',figh,...
      'string','Limits:',...
      'position',[0 0 35 15],...
      'horizontalalignment','left');   
   
   % set up data
   udh= txt;
   
   % callbacks 
   set(ud.resplist,'callback',{@i_changerf,udh});
   set(ud.value,'callback',{@i_changevals,udh});
   set(ud.lims,'callback',{@i_changevals,udh});
   
   flw1=xregflowlayout(figh,'orientation','left/center',...
      'elements',[{text1},num2cell(ud.value)],...
      'gap',5,...
      'border',[-5 0 0 0],...
      'packstatus','off');
   flw2=xregflowlayout(figh,'orientation','left/center',...
      'elements',{text2,ud.lims(1),ud.lims(2)},...
      'gap',5,...
      'border',[-5 0 0 0]);
   grd=xreggridlayout(figh,'correctalg','on',...
      'dimension',[2 1],...
      'elements',{flw1,flw2},...
      'gapy',5);
   ud.crd=xregcardlayout(figh,'numcards',2);
   attach(ud.crd,noopts,1);
   attach(ud.crd,grd,2);
   brd=xregborderlayout(figh,'center',ud.resplist,...
      'north',txt,...
      'innerborder',[0 0 0 30]);
   frm=xregframetitlelayout(figh,'title','Options',...
      'center',ud.crd,...
      'innerborder',[15 10 10 10],...
      'border',[0 0 0 5]);
   frm2=xregframetitlelayout(figh,'title','Feature',...
      'center',brd,...
      'innerborder',[15 10 10 10],...
      'border',[0 5 0 0]);
   lyt=xregborderlayout(figh,'center',frm2,'south',frm,...
      'innerborder',[0 80 0 0]);
   
   set(txt,'userdata',ud); 
else
   lyt=figh;
   udh=get(get(get(lyt,'center'),'center'),'north');
   ud=get(udh,'userdata');
   ud.pointer=p;
   set(udh,'userdata',ud);
end

i_setvalues(ud,p,rfno);
return



function i_setvalues(ud,p,rfno)
% set up control values from object

L=p.info;

flist=DatumDisplay(L,features(L));
LFeats= get(L,'features');

if rfno>length(LFeats)
   rfno=length(LFeats);
end

Nind= strmatch(lower(LFeats(rfno).Display),lower({flist.Display}),'exact');
top= max(1,Nind-5);
set(ud.resplist,'string',{flist.Display},'value',Nind,'listboxtop',top)

if ~isempty(findstr(flist(Nind).Function,'Value'));
   % value used in this rf
   
   % Value
   Value= get(L,'values');
   Value= num2cell(Value(rfno,:));
   set(ud.value(:),{'string'},Value(:));
   
   % Limits
   Limits= get(L,'limits');
   Limits= Limits(:,rfno);
   set(ud.lims,...
      {'string'},{Limits(1);Limits(2)});

   set(ud.crd,'currentcard',2);
else
   % no value used for rf
   set(ud.value,'string',0);
   set(ud.lims,...
      {'string'},{-10000;10000});
   set(ud.crd,'currentcard',1);
end

return



function i_changerf(h,EventData,udh)
% swap to new response feature type
ud=get(udh,'userdata');
[lm,vals]=i_change(ud.pointer.info,ud);
ud.pointer.info=lm;
set(ud.crd,'currentcard',vals+1);
return


function i_changevals(h,EventData,udh)
% swap to new response feature type
ud=get(udh,'userdata');
ud.pointer.info=i_change(ud.pointer.info,ud);
return


function [lm,vals] = i_change(lm,ud)

% response feature number
RFno= ud.rfno;

Type= get(ud.resplist,'value');

% get values and limits
vals= get(ud.value,{'string'});
vals= sprintf('%10s ',vals{:});
Value= str2num(vals);
Limmin= str2num(get(ud.lims(1),'string'));
Limmax= str2num(get(ud.lims(2),'string'));


% check values 
if isempty(Value) | length(Value)>nfactors(lm) ...
      | isempty(Limmin) | length(Limmin)>1 ...
      | isempty(Limmax) | length(Limmax)>1
   % reset ui values and exit
   p=xregpointer(lm);
   i_setvalues(ud,p,RFno);
   freeptr(p);
   return
end

Limits= [Limmin;Limmax]; 
lm= EditFeat(lm,RFno,Value,Type,Limits);

if nargout>1
   flist=DatumDisplay(lm,features(lm));
   LFeats= get(lm,'features');
   if ~isempty(findstr(flist(Type).Function,'Value'));
      vals=1;
   else
      vals=0;
   end
end
return



