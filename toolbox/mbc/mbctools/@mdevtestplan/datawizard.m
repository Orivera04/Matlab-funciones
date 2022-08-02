function [T,OK] = datawizard(T)
%DATAWIZARD GUI wizard for setting up a data in testplan
%
%   [T,OK] = DATAWIZARD(T) displays a wizard GUI for setting up options
%   and selecting data for the testplan.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.4 $  $Date: 2004/02/09 08:07:39 $

OldTP   = T;
if IsMatched(T)
	[OldData{1:2}]= getdata(T,'FIT');
    oldTSSF = T.DataLink.info;
else
	OldData=[];
    oldTSSF= [];
end


if T.DataLink == 0
    % try and select some data
	[T,OK]= InitData(T);
end
	
p= address(T);

ud.titles={'Data Wizard - Select Data';...
      'Data Wizard - Select Input Signals';...
      'Data Wizard - Select Response Models';...
      'Data Wizard - Set Tolerances'};


ud.drawn=zeros(1,4);
ud.fns={'SelectDataGui','matchnames','gui_response','matchsettings'};
ud.pointer= p;



% Create figure and set up userdata structure to track form completion
% and creation status (ie is tab made yet) and an array of handles that
% aer being used as userdata holders for each view

scrsz=get(0,'screensize');
fpos= [scrsz(3)/2-340 scrsz(4)/2-220 600 325];

fig=figure('position',fpos,...
   'tag','DesignWizard',...
   'visible','off',...
   'units','pixels',...
   'toolbar','none',...
   'menubar','none',...
   'numbertitle','off',...
   'name',ud.titles{1},...
   'resize','off',...
   'doublebuffer','on',...
   'pointer','watch',...
   'WindowStyle','modal',...
   'color',get(0,'defaultuicontrolbackgroundcolor'));

% set up position control buttons
ud.cancel=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[1 7 65 25],...
   'string','Cancel',...
   'callback','set(gcbf,''tag'',''cancel'');',...
   'interruptible','off');
ud.back=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[1 7 65 25],...
   'string','< Back',...
   'interruptible','off');
ud.next=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[1 7 65 25],...
   'string','Next >',...
   'interruptible','off');
ud.finish=uicontrol('parent',fig,...
   'style','pushbutton',...
   'position',[1 7 65 25],...
   'string','Finish',...
   'callback','set(gcbf,''tag'',''ok'');',...
   'interruptible','off');


set(ud.back,'callback',{@i_Back,fig});
set(ud.next,'callback',{@i_Next,fig});

% set button enable status
set([ud.cancel;ud.back;ud.next;ud.finish],{'enable'},{'on';'off';'on';'off'});



ud.figure=fig;


% create first screen
lyt=feval(ud.fns{1},p.info,'layout',fig,p);

ud.drawn(1)=1;

hAutoMatch = findobj(allchild(0),'flat','tag','automatch','visible','on');
if ~isempty(hAutoMatch)
	set(ud.DataSelGui,'visible','off','value',0);
end


ud.crd=xregcardlayout(fig,'numcards',4,'packstatus','off');

grd=xreggridlayout(fig,'correctalg','on','dimension',[1, 9],...
   'elements',{[],[],ud.cancel,[],ud.back,ud.next,[],ud.finish},...
	'colsizes',[200,-1,80,5,80,80,5,80,5],...
   'gap',5,'border',[10 10 0 10]);

attach(ud.crd,lyt,1);
set(lyt,'visible','on');
brd=xregborderlayout(fig,...
   'container',fig,...
   'south',grd,...
   'center',ud.crd,...
   'innerborder',[5 45 5 10]);

set(fig,'visible','on','pointer','arrow','userdata',ud);
drawnow;

set(brd,'packstatus','on');
set(fig,'userdata',ud);
set([ud.cancel;ud.back;ud.next;ud.finish],{'enable'},{'on';'off';'on';'off'});

% block until Finish or Cancel is pressed
waitfor(fig,'tag');
if ishandle(fig)
	tg=get(fig,'tag');
	n=get(ud.crd,'currentcard');
	T = feval(ud.fns{n},p.info,'update');
	OpenData= true;
	delete(fig);
else
	tg= 'cancel';
end

drawnow

if strcmp(tg,'cancel')
    % cancel flag has been set
    OK=0;
    T= Restore(info(T),OldTP,oldTSSF);
else
    % assume no cancel state
    OK=1;
    T= p.info;
    T= checkMonitor(T);
    if OpenData
        h = sendObjectToDataEditor(T, T.DataLink,oldTSSF);
    else
        [T,res,msg]= SelectData(T);
        RedrawNode(MBrowser);
        if ~res
            h = errordlg(msg,'MBC Toolbox','modal');
            drawnow;waitfor(h);
        end
    end
end

return

   
   
function i_Next(h,evt,udh)


ud=get(udh,'userdata');

n=get(ud.crd,'currentcard');
% check that you can leave the current card
[T,OK] = feval(ud.fns{n},ud.pointer.info,'update');



n= n+1;
if ~OK || n>length(ud.drawn)
	return
end

set(ud.figure,'pointer','watch');
drawnow
if ~ud.drawn(n)
    
    lyt=feval(ud.fns{n},ud.pointer.info,'layout',ud.figure,ud.pointer);
    attach(ud.crd,lyt,n);
    set(lyt,'packstatus','on');
    ud.drawn(n)=1;
else
	lyt=getcard(ud.crd,n);
	lyt=feval(ud.fns{n},ud.pointer.info,'layout',lyt{1},ud.pointer);
end


set(ud.crd,'currentcard',n);

set(ud.figure,'pointer','arrow','name',ud.titles{n});
drawnow;


set(udh,'userdata',ud);

if n==length(ud.fns)
	set(ud.finish,'enable','on');
	set(ud.next,'enable','off');
end
if n>=2
	set(ud.back,'enable','on');
end



function i_Back(h,evt,udh)

% flip to last view
ud=get(udh,'userdata');

n=get(ud.crd,'currentcard');
[T,OK] = feval(ud.fns{n},ud.pointer.info,'update');
n= n-1;
if ~OK || n<1
	return
end

set(ud.figure,'pointer','watch');

% get layout and update
lyt=getcard(ud.crd,n);
lyt=feval(ud.fns{n},ud.pointer.info,'layout',lyt{1},ud.pointer);
% switch cards
set(ud.crd,'currentcard',n);
set(udh,'userdata',ud); 
if n==(length(ud.fns)-1);
	set(ud.finish,'enable','off');
end
if n==1
	set(ud.back,'enable','off');
end
set(ud.next,'enable','on');
set(ud.figure,'pointer','arrow','name',ud.titles{n});
