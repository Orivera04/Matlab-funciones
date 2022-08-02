function gui_fitsetup(m,action,varargin)
% GUI_FITSETUP  Gui for selecting and setting up the local model
%
%  [M,OK]=GUI_LOCALMODSETUP(M) creates a modal dialog for selecting the
%  local model type and setting up some options.  The file GUI_LOCALMODOPTS
%  is called for controlling model-dependent additional options such as
%  the spline orders.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 07:39:11 $




switch lower(action)
case 'create'
   i_createfig(varargin{:});   
case 'changefit'
   i_changefit(varargin{:});
case 'fit'
   i_Fit(varargin{:});
case 'onestep'
   i_OneStep(varargin{:});
case 'close'
   i_Close(varargin{:});
case 'stop'
   global STOP
   STOP=1;
end



function i_createfig(p)

scsz=get(0,'screensize');
figh=xregfigure('menubar','none',...
   'toolbar','none',...
   'numbertitle','off',...
   'name','Local Model Fit Tool',...
   'doublebuffer','on',...
   'renderer','zbuffer',...
   'position',[scsz(3).*0.5-125 scsz(4).*0.5-150 350 300],...
   'visible','off',...
   'color',get(0,'defaultuicontrolbackgroundcolor'),...
   'tag','LocalFitTool',...
   'resize','off');
figh= double(figh);

lyt=i_createlyt(figh,p.model,p);

brd=xregborderlayout(figh,'center',lyt,...
   'innerborder',[10 10 10 10],...
   'container',figh,...
   'packstatus','on');

set(figh,'visible','on','windowstyle','modal');
drawnow;




function lyt=i_createlyt(figh,L,p);

ud.figh=figh;
ud.p= p;
ud.Update= 0;

if isempty(L.covmodel)
   ud.gls=0;
   ud.fitmethod={'Ordinary least squares'};
   txtstr= {'Change in parameters:'};
   cstyle= {'edit'};
   ud.Costfuncs= {''};
else
   ud.gls=1;
   ud.fitmethod={'Pseudo-likelhood','REML','Absolute residuals'};
   txtstr= {'Fit method:','Max. iterations:',...
         'Change in sigma:','Change in parameters:','Change in covariance:'};
   cstyle= {'popup','edit','edit','edit','edit'};
   ud.Costfuncs= {'costW_PL','costW_REML','costW_AR'};
end   

   
for i=1:length(txtstr)
   hText(i)=uicontrol('parent',figh,...
      'style','text',...
      'string',txtstr{i},...
      'horizontalalignment','left',...
      'position',[0 0 120 20]);
   hCtrl(i)= uicontrol('parent',figh,...
      'style',cstyle{i},...
      'backgroundcolor','w',...
      'horizontalalignment','right',...
      'position',[0 0 100 20],...
      'userdata',i,...
      'interruptible','off');
   flw{i}=xregflowlayout(figh,'packstatus','off',...
      'orientation','left/center',...
      'elements',{hText(i),hCtrl(i)});
end
grd=xreggridlayout(figh,'dimension',[length(flw),1],...
   'correctalg','on',...
   'gap',2,...
   'elements',flw,...
   'border',[0 10 0 0]);
grd=xregframetitlelayout(figh,...
   'title','Fit parameters',...
   'innerborder',[10 5 5 5],...
   'center',grd);


objh=sprintf('%20.15f',hText(1));

% callbacks
for i=1:length(txtstr)
   set(hCtrl(i),'callback',['gui_fitsetup(localmod,''changefit'',',objh,');']);
end
ud.hText= hText;
ud.hCtrl= hCtrl;

ud.Prog= uicontrol('style','listbox',...
   'string',{},...
   'backgroundColor','w',...
   'fontname','Courier New',...
   'value',0);
frm=xregframetitlelayout(figh,...
   'title','Fit progess',...
   'innerborder',[10 5 5 5],...
   'center',ud.Prog);

if ud.gls
   set(hCtrl(1),'string',ud.fitmethod);
   txtstr= {'Fit','One Step','Stop','Close'};
else
   txtstr= {'Fit','Stop','Close'};
end

for i=1:length(txtstr)
   hBtns{i}=uicontrol('parent',figh,...
      'style','push',...
      'string',txtstr{i},...
      'callback',['gui_fitsetup(localmod,''',strrep(txtstr{i},' ',''),''',',objh,');'],...
      'position',[0 0 60 25]);
end
%% add a help button at the right
btnHELP = mv_helpbutton(figh,'xreg_localModelFit');
hBtns = {hBtns{:},btnHELP};

set(figh,'closerequestfcn',get(hBtns{end-1},'callback'))
set(hBtns{end-2},'enable','off')

numB= length(hBtns);
flw=xreggridlayout(figh,...
   'correctalg','on',...
   'elements',{[],hBtns{:}},...
   'dimension',[1,numB+1],...
   'colsizes',[-1,repmat(65,[1,numB])],...
   'gapx',10,...
   'border',[5 5 5 10]);

lyt=xregborderlayout(figh,'north',grd,...
   'center',frm,...
   'south',flw,...
   'innerborder',[0 40 0 140]);
ud.hBtns=hBtns;
ud.model= L;
ud=i_setvalues(ud,L);
% model browser figure
ud.hmb=gcbf;
set(hText(1),'userdata',ud);
return


function ud=i_setvalues(ud,L)


if ud.gls
   cfv= find(strcmp(costFunc(L.covmodel),ud.Costfuncs));
   set(ud.hCtrl(1),'value',cfv)
   set(ud.hCtrl(2),'string',L.FitOptions.MaxIter)
   set(ud.hCtrl(3),'string',sprintf('%2.2e',L.FitOptions.TolSigma))
   set(ud.hCtrl(4),'string',sprintf('%2.2e',L.FitOptions.TolParams))
   set(ud.hCtrl(5),'string',sprintf('%2.2e',L.FitOptions.TolCov))
else
   set(ud.hCtrl(1),'string',L.FitOptions.TolParams)
end
return





function i_changefit(udh)

ud=get(udh,'userdata');
L= ud.model;

ind= get(gcbo,'userdata');
if ud.gls
   switch ind
   case 1
      L.covmodel= costFunc(L.covmodel,ud.Costfuncs{get(gcbo,'value')});
   case 2
      L.FitOptions.MaxIter= i_checknum(gcbo,L.FitOptions.MaxIter,2);
   case 3
      L.FitOptions.TolSigma= i_checknum(gcbo,L.FitOptions.TolSigma,1);
   case 4
      L.FitOptions.TolParams= i_checknum(gcbo,L.FitOptions.TolParams,1);
   case 5
      L.FitOptions.TolCov= i_checknum(gcbo,L.FitOptions.TolCov,1);
   end
else
   L.FitOptions.TolParams= i_checknum(gcbo,L.FitOptions.TolParams,1);
end

ud.model= L;
set(udh,'userdata',ud);


function NewNum= i_checknum(h,OldValue,opts);
      
NewNum=  str2double(get(h,'string'));
Valid= isfinite(NewNum);
if nargin>2 
   switch opts
   case 1
      Valid = NewNum>0;
   case 2
      Valid = NewNum>1 & NewNum==fix(NewNum);
   end
end
   
if ~Valid 
   set(h,'string',OldValue);
   NewNum= OldValue;
end


function i_Fit(udh);

global STOP
STOP=0;

figh= get(udh,'parent');
ud=get(udh,'userdata');
L= ud.model;

L.FitOptions.DispHndl= ud.Prog;
p= ud.p;
oldmdev= p.info;

creq= get(figh,'closerequestFcn');
set(figh,'closerequestFcn','')

p.model(L);
set(ud.Prog,'string',{},'value',0);
set([ud.hBtns{:}]','enable','off')
set(ud.hBtns{end-2},'enable','on')
drawnow;
try
   p.fitmodel;
   L= p.model;
   ViewNode(MBrowser);
   ud.Update= 1;
catch
   L= model(oldmdev);
   ud=i_setvalues(ud,L);   
   % go back to previous
   pointer(oldmdev);
   errordlg('Local Fit Model failed - returning to previous fit',...
      'Local Fit Error','modal');
   disp(lasterr)
end
set(figh,'closerequestFcn',creq)

set([ud.hBtns{:}]','enable','on')
set(ud.hBtns{end-2},'enable','off')

L.FitOptions.DispHndl= [];
ud.model= L;
set(udh,'userdata',ud);

function i_OneStep(udh);

global STOP
STOP=0;

figh= get(udh,'parent');
ud=get(udh,'userdata');
L= ud.model;

L.FitOptions.DispHndl= ud.Prog;
OldMaxIter= L.FitOptions.MaxIter;
L.FitOptions.MaxIter= 1;
p= ud.p;
p.model(L);
oldmdev= p.info;

creq= get(figh,'closerequestFcn');
set(figh,'closerequestFcn','')
set([ud.hBtns{:}]','enable','off')
set(ud.hBtns{end-2},'enable','on')
drawnow;
try
   p.fitmodel;
   L= p.model;
   ViewNode(MBrowser)
   ud.Update= 1;
catch
   L= model(oldmdev);
   ud=i_setvalues(ud,L);   
   % go back to previous
   pointer(oldmdev);
   errordlg('Local Fit Model failed - returning to previous fit',...
      'Local Fit Error','modal');
   disp(lasterr)
end
set(figh,'closerequestFcn',creq)

L= p.model;
L.FitOptions.MaxIter= OldMaxIter;
L.FitOptions.DispHndl= [];
ud.model= L;
set([ud.hBtns{:}]','enable','on')
set(ud.hBtns{end-2},'enable','off')
set(udh,'userdata',ud);

function i_Close(udh);

ud=get(udh,'userdata');
L= ud.model;
L.FitOptions.DispHndl= [];
p= ud.p;
p.model(L);
if ud.Update
	mbH= MBrowser;
   % update view structure - this forces an update of global models later
	View= GetViewData(mbH);
   View.Update= 2;
	SetViewData(mbH,View);
	mbH.ViewNode;
end

figh= get(udh,'parent');
delete(figh);
