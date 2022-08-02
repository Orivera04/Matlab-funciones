function dat = dftool(tickflag)
%DFTOOL Datafeed graphical user interface.
%   DAT = DFTOOL runs the Datafeed graphical user interface and callbacks.
%   The output variable DAT is only returned by the 'getdata' option.

%   Author(s): C.F.Garvin, 01-03-01
%   Copyright 1999-2003 The MathWorks, Inc.
%   $Revision: 1.35.2.3 $   $Date: 2004/04/06 01:06:14 $


%Check for any inputs, ticktypes action denoted by input arguments
if nargin > 0
  dat = ticktypes([],[],[]);
  return
end

%figure spacing
[dfp,mfp,bspc,bhgt,bwid,tabhgt] = spaceparams([],[],[]);
  
hidstat = get(0,'Showhiddenhandles');
set(0,'Showhiddenhandles','on')
fobj = findobj('Tag','DataFeedDlg');
if ~isempty(fobj)
  figure(fobj)
  set(0,'Showhiddenhandles',hidstat)
  return
end
set(0,'Showhiddenhandles',hidstat)

%Create the base dialog
f = figure('Name','Datafeed','Numbertitle','off','Menubar','none','Tag','DataFeedDlg','Resize','on');
set(f,'Closerequestfcn',{@closedfdialog,f},'Resizefcn',{@cleanupdialog,f});
pos = get(f,'Position');
rgt = pos(3);
top = pos(4);
setappdata(f,'basefigurehandle',f)

%Create tabs and frames
uicontrol('Enable','inactive','String','Connection','Tag','Connection','Userdata','tab',...
  'Buttondownfcn',{@tabs,f},...
  'Position',[bspc top-(.5*bspc+tabhgt) bwid tabhgt]);
uicontrol('Enable','inactive','String','Data','Tag','Current','Userdata','tab',...
  'Buttondownfcn',{@tabs,f},...
  'Position',[1.5*bspc+bwid top-(bspc+tabhgt) bwid tabhgt]);
uicontrol('Enable','off','Position',[bspc bspc rgt-2*bspc top-(bspc+tabhgt)]);
uicontrol('Style','text','Tag','tabhide',...
  'Position',[1.25*bspc top-(2*bspc+tabhgt) bwid-0.6*bspc 0.5*bhgt]);

%Connection tab

%Create connection tab uicontrols (default panel)
fhgt1 = 9.5*bspc+15*bhgt;
fwid1 = 12*bspc+6*bwid;
uicontrol('Style','frame','Userdata','Connection',...
  'Position',[2*bspc top-(1*bspc+tabhgt+fhgt1) fwid1 fhgt1]);

%Data Source uicontrols
datasources = {'Bloomberg';'Hyperfeed - History';'Hyperfeed - Price';'Hyperfeed - Profile';'IDC';'Yahoo'};
uicontrol('Style','text','String','Data Source:','Userdata','Connection',...
  'Position',[3*bspc top-(2.5*bspc+tabhgt+bhgt) bwid bhgt]);
ui.sources = uicontrol('Style','popupmenu','String',datasources,'Userdata','Connection','Tag','sources','Tooltip','Data Source list',...
  'Value',1,'Callback',{@selectsource,f},'Position',[3*bspc top-(2.5*bspc+tabhgt+2*bhgt) 2*bwid+2*bspc bhgt]);

%Connect uicontrol
uicontrol('String','Connect','Userdata','Connection','Callback',{@connect,f},...
  'Tooltip','Make connection','Position',[6*bspc+2*bwid top-(2.5*bspc+tabhgt+2*bhgt) bwid bhgt]);

%Port uicontrols
uicontrol('Style','text','String','Port Number:','Userdata','Connection',...
  'Position',[3*bspc top-(4.5*bspc+tabhgt+3*bhgt) bwid bhgt]);
ui.port = uicontrol('Style','edit','Tag','Port','Userdata','Connection','Tooltip','Data Source port number',...
  'String','Using default port','Position',[3*bspc top-(4.5*bspc+tabhgt+4*bhgt) 2*bwid+2*bspc bhgt]);

%IP Address uicontrols
uicontrol('Style','text','String','IP Address:','Userdata','Connection',...
  'Position',[3*bspc top-(6.5*bspc+tabhgt+5*bhgt) bwid bhgt]);
ui.ipaddress = uicontrol('Style','edit','Tag','IPAddress','Userdata','Connection','Tooltip','Data Source machine IP Address',...
  'String','Using default IP Address','Position',[3*bspc top-(6.5*bspc+tabhgt+6*bhgt) 2*bwid+2*bspc bhgt]);

%Current connections uicontrols
uicontrol('Style','frame','Userdata','Data','Visible','off',...
  'Position',[2*bspc top-(18.5*bspc+tabhgt+13*bhgt) 4*bspc+2*bwid 2*bspc+7*bhgt]);
uicontrol('Style','text','String','Current Connections:','Userdata','All',...
  'Position',[3*bspc top-(9.75*bspc+tabhgt+9*bhgt) bwid bhgt]);
ui.currentconnections = uicontrol('Style','listbox','Userdata','All','Tag','CurrentConnections','Max',2,'String',{},'Value',[],...  
  'Callback',{@updatestatus,f},'Tooltip','Active connections',...
  'Position',[3*bspc top-(11.75*bspc+tabhgt+12*bhgt) 2*bwid+2*bspc 2*bspc+3*bhgt]);

%Status uicontrols
uicontrol('Style','text','String','Status:','Userdata','All',...
  'Position',[3*bspc top-(13.5*bspc+tabhgt+13*bhgt) bwid bhgt]);
ui.connectionstatus = uicontrol('Style','edit','String','No Connection','Userdata','All','Tag','ConnectionStatus',...
  'Callback',{@updatestatus,f},'Tooltip','Connection status',...
  'Fontweight','bold','Foregroundcolor',[1 0 0],'Position',[3*bspc top-(13.25*bspc+tabhgt+14*bhgt) 2*bspc+2*bwid bhgt]);

%Message uicontrols
uicontrol('Style','text','String','Connection History:','Userdata','Connection',...
  'Position',[8*bspc+3*bwid top-(2.5*bspc+tabhgt+bhgt) bwid bhgt]);
ui.servermessages = uicontrol('Style','listbox','Tag','ServerMessages','Userdata','Connection','Max',2,'Value',[],...
  'Callback',{@copyhistory,f},'Tooltip','Connection history information',...
  'Position',[8*bspc+3*bwid top-(16.5*bspc+tabhgt+12*bhgt) 5*bspc+3*bwid 10*bspc+12*bhgt]);
uicontrol('String','Clear','Callback',{@clearhistory,f},...
  'Tooltip','Clear connection history','Position',[13*bspc+5*bwid top-(17.5*bspc+tabhgt+13*bhgt) bwid bhgt]);

%Disconnect, help uicontrols
uicontrol('String','Help','Userdata','All','Visible','on',...
  'Callback',{@dfdlghelp,f},...
  'Position',[3*bspc top-(15.5*bspc+tabhgt+15*bhgt) bwid bhgt]);
uicontrol('String','Disconnect','Userdata','Connection','Callback',{@disconnect,f},...
  'Tooltip','Close selected connections','Position',[6*bspc+2*bwid top-(11.5*bspc+tabhgt+12*bhgt) bwid bhgt]);

%Data tab

%Build security entry, list and lookup frame
uicontrol('Style','frame','Userdata','Data','Visible','off',...
  'Position',[2*bspc top-(7.5*bspc+tabhgt+8*bhgt) 4*bspc+2*bwid 6.5*bspc+8*bhgt]);
uicontrol('Style','text','String','Choose Market:','Userdata','Data','Visible','off',...
  'Position',[5*bspc+bwid top-(2.5*bspc+tabhgt+bhgt) bwid bhgt]);
ui.securitymarkettype = uicontrol('Style','popupmenu','Tag','SecurityMarketType','Userdata','Data','Visible','off',...
  'Position',[5*bspc+bwid top-(2.5*bspc+tabhgt+2*bhgt) bwid bhgt],'Value',4,'Tooltip','Market type',...
  'String',sort({'Equity';'Govt';'Corp';'Muni';'Index';'Mtge';'M-Mkt';'Pfd';'Comdty';'Curncy'}));
uicontrol('Style','text','String','Enter Security:','Userdata','Data','Visible','off',...
  'Position',[3*bspc top-(2.5*bspc+tabhgt+bhgt) bwid bhgt]);
ui.security = uicontrol('Style','edit','Tag','Security','Userdata','Data','Visible','off',...
  'Tooltip','Security ticker symbol','Position',[3*bspc top-(2.5*bspc+tabhgt+2*bhgt) bwid bhgt]);
uicontrol('String','Add','Userdata','Data','Callback',{@addsecurity,f},'Visible','off',...
  'Position',[3*bspc top-(3.5*bspc+tabhgt+3*bhgt) bwid bhgt]);
uicontrol('String','Load...','Userdata','Data','Visible','off','Callback',{@loadsec,f},...
  'Tooltip','Load security list from file','Position',[3*bspc top-(6.5*bspc+tabhgt+8*bhgt) 2/3*bwid bhgt]);
ui.lookup = uicontrol('String','Lookup...','Userdata','Data','Visible','off','Callback',{@lookup,f},...
  'Tooltip','Ticker symbol search','Position',[5*bspc+bwid top-(3.5*bspc+tabhgt+3*bhgt) bwid bhgt]);
uicontrol('Style','text','String','Selected Securities:','Userdata','Data','Visible','off',...
  'Position',[3*bspc top-(5*bspc+tabhgt+4*bhgt) bwid bhgt]);
ui.selectedsecurities = uicontrol('Style','listbox','Tag','SelectedSecurities','Userdata','Data','Visible','off','Max',1,...
  'Tooltip','Selected security list','Position',[3*bspc top-(5.5*bspc+tabhgt+7*bhgt) 2*bspc+2*bwid 3*bhgt+.5*bspc]);
uicontrol('String','Delete','Userdata','Data','Visible','off','Callback',{@deletesecurity,f},...
  'Tooltip','Delete selected securities','Position',[5*bspc+4/3*bwid top-(6.5*bspc+tabhgt+8*bhgt) 2/3*bwid bhgt]);
uicontrol('String','Save...','Userdata','Data','Visible','off','Callback',{@savesec,f},...
  'Tooltip','Save security list to file','Position',[4*bspc+2/3*bwid top-(6.5*bspc+tabhgt+8*bhgt) 2/3*bwid bhgt]);

%Create Data Selection type frame
uicontrol('Style','frame','Userdata','Data','Visible','off',...
  'Position',[7*bspc+2*bwid top-(18.5*bspc+tabhgt+13*bhgt) 7*bspc+4*bwid 13.5*bspc+14*bhgt]);
uicontrol('Style','text','String','Data Selection:','Userdata','Data',...
  'Visible','off','Position',[8*bspc+2*bwid top-(2.5*bspc+tabhgt+bhgt) bwid bhgt]);
ui.radio(1) = uicontrol('Style','radiobutton','String','Current','Userdata','Data','Tooltip','Field data',...
  'Callback',{@radio,f},'Tag','radio','Visible','off','Value',1,...
  'Position',[10*bspc+2*bwid top-(2*bspc+tabhgt+2*bhgt) bwid+bspc bhgt]);
ui.currentdatadate = uicontrol('Style','edit','Enable','off','String',datestr(floor(now),2),'Tag','currentdatadate',...
  'Userdata','Data','Visible','off','Position',[9*bspc+3*bwid top-(2*bspc+tabhgt+2*bhgt) bwid-bspc bhgt]);
ui.radio(2) = uicontrol('Style','radiobutton','String','Intraday Ticks','Userdata','Data','Tooltip','Timeseries data for given date',...
  'Callback',{@radio,f},'Tag','radio','Visible','off',...
  'Position',[10*bspc+2*bwid top-(3*bspc+tabhgt+3*bhgt) bwid+2*bspc bhgt]);
ui.datadatestring = uicontrol('Style','text','String','Data Date:','Userdata','Data','Visible','off',...
  'Position',[12*bspc+2*bwid top-(3.5*bspc+tabhgt+4*bhgt) bwid bhgt]);
ui.datadate = uicontrol('Style','edit','Tag','datadate','Userdata','Data','Visible','off','Tooltip','Timeseries data date',...
  'Callback',{@dateerrors,f},'String',datestr(floor(now),2),'Enable','off',...
  'Position',[9*bspc+3*bwid top-(3*bspc+tabhgt+4*bhgt) bwid-bspc bhgt]);
ui.intervalstring = uicontrol('Style','text','String','Interval (minutes):','Userdata','Data','Visible','off',...
  'Position',[12*bspc+2*bwid top-(4*bspc+tabhgt+5*bhgt) bwid bhgt]);
ui.interval = uicontrol('Style','edit','String','0','Userdata','Data','Visible','off','Enable','off','Tag','interval',...
  'Callback',{@intervalsetting,f},... 
  'Position',[8*bspc+3.5*bwid top-(3.5*bspc+tabhgt+5*bhgt) .5*bwid bhgt]);
ui.radio(3) = uicontrol('Style','radiobutton','String','History','Userdata','Data',...
  'Callback',{@radio,f},'Tag','radio','Visible','off','Tooltip','Historical data for given date interval and field',...
  'Position',[10*bspc+2*bwid top-(4.5*bspc+tabhgt+6*bhgt) bwid-bspc bhgt]);
ui.fromdatestring = uicontrol('Style','text','String','From Date:','Userdata','Data','Visible','off',...
  'Position',[12*bspc+2*bwid top-(5.5*bspc+tabhgt+7*bhgt) bwid bhgt]);
ui.fromdate = uicontrol('Style','edit','Tag','fromdate','Userdata','Data','Visible','off',...
  'Callback',{@dateerrors,f},'Enable','off','Tooltip','Historical data start date',...
  'Position',[9*bspc+3*bwid top-(5*bspc+tabhgt+7*bhgt) bwid-bspc bhgt]);
ui.todatestring = uicontrol('Style','text','String','To Date:','Userdata','Data','Visible','off',...
  'Position',[12*bspc+2*bwid top-(5.85*bspc+tabhgt+8*bhgt) bwid bhgt]);
ui.todate = uicontrol('Style','edit','Tag','todate','Userdata','Data','Visible','off',...
  'Callback',{@dateerrors,f},'Enable','off','Tooltip','Historical data end date',...
  'Position',[9*bspc+3*bwid top-(5.35*bspc+tabhgt+8*bhgt) bwid-bspc bhgt]);
ui.periodstring = uicontrol('Style','text','String','Period:','Userdata','Data','Visible','off',...
  'Position',[12*bspc+2*bwid top-(6.35*bspc+tabhgt+9*bhgt) bwid bhgt]);
ui.period = uicontrol('Style','popup','String',{'daily','weekly','monthly','quarterly','yearly'},...
  'Visible','off','Userdata','Data','Tag','period','Enable','off',...
  'Position',[9*bspc+3*bwid top-(5.85*bspc+tabhgt+9*bhgt) bwid-bspc bhgt]);
  
%Security fields frame, load bbfields.mat to get fieldnames
setappdata(f,'uidata',ui)
loadfields([],[],f)
global bbfieldnames headerfieldnames icdfieldnames datafieldnames defaultfieldnames bbcategories
 
ui.radiofields(1) = uicontrol('Style','radiobutton','String','Default Fields','Tag','radiofields','Value',1,...
  'Callback',{@radiofields,f},'Userdata','Data','Visible','off','Tooltip','Show default data fields',...
  'Position',[12*bspc+4*bwid top-(2*bspc+tabhgt+2*bhgt) bwid+bspc bhgt]);
ui.radiofields(2) = uicontrol('Style','radiobutton','String','All Fields','Tag','radiofields','Value',0,...
  'Callback',{@radiofields,f},'Userdata','Data','Visible','off','Tooltip','Show all data fields',...
  'Position',[15*bspc+5*bwid top-(2*bspc+tabhgt+2*bhgt) bwid-3*bspc bhgt]);
ui.fields = uicontrol('Style','listbox','Tag','Fields','Visible','off','Userdata','Data','Callback',{@expandfieldlist,f},...
  'String',defaultfieldnames,'Max',2,'Value',1,'Enable','on','Tooltip','Data field list',...
  'Position',[11*bspc+4*bwid top-(-1.5*bspc+tabhgt+11*bhgt) 2*bspc+2*bwid 9*bhgt-4*bspc]);
   
%Create data display panel
uicontrol('Style','text','String','MATLAB variable:','Userdata','Data','Visible','off',...
  'Position',[8*bspc+2*bwid top-(12.5*bspc+tabhgt+9*bhgt) bwid bhgt]);
ui.workspacevar = uicontrol('Style','edit','String','','Userdata','Data','Visible','off','Tooltip','Workspace variable name for retrieved data',...
  'Tag','workspacevar','Position',[11*bspc+3*bwid top-(11.5*bspc+tabhgt+9*bhgt) bwid-3*bspc bhgt]);
ui.displayeddata = uicontrol('Style','listbox','Userdata','Data','Tag','DisplayedData','Visible','off',...
  'Max',2,'Callback','set(gcbo,''Value'',[])','Fontname',get(0,'Fixedwidthfont'),'Tooltip','Retrieved data',...
  'Position',[8*bspc+2*bwid top-(13.5*bspc+tabhgt+14*bhgt) 5*bspc+4*bwid 5*bspc+4*bhgt]);

%Get data uicontrols
uicontrol('String','Get Data','Userdata','Data','Visible','off','Tag','GetData',...
  'Callback',{@getdata,f},'Tooltip','Get data from current connection',...
  'Position',[11*bspc+4*bwid top-(11.5*bspc+tabhgt+9*bhgt) bwid bhgt]);

%Override uicontrol
ui.override = uicontrol('String','Override...','Userdata','Data','Visible','off',...
  'Callback',{@overridedialog,f},'Tooltip','Set override field values',...
  'Position',[13*bspc+5*bwid top-(11.5*bspc+tabhgt+9*bhgt) bwid bhgt]);

%Close button
uicontrol('String','Close','Userdata','All','Callback',{@closedfdialog,f},'Tag','Close',...
  'Tooltip','Close all current connections and dialog','Position',[5*bspc+5.5*bwid top-(15.5*bspc+tabhgt+15*bhgt) bwid bhgt]);

cleanupdialog([],[],f)

set(f,'HandleVisibility','callback')

%Set application data
setappdata(f,'uidata',ui)

%%Subfunctions%%

function addsecurity(obj,evd,frame)
%ADDSECURITY Add security to selected securities list    

set(frame,'pointer','watch')

%Get entered security
ui = getappdata(frame,'uidata');
sstr = upper(get(ui.security,'String'));

%If empty do nothing
if isempty(sstr)
  set(findobj('Type','figure'),'Pointer','arrow')
  return
end

%Get market type
mval = get(ui.securitymarkettype,'Value');
mstr = get(ui.securitymarkettype,'String');
markstr = mstr{mval};

%Build security string
sstr = [sstr ' ' markstr];

%If valid, add to list

%Get connection information
cval = get(ui.currentconnections,'Value');
if isempty(cval)
  errordlg('No current connection for data retrieval.')
  set(frame,'Pointer','arrow')
  return
end
conn = getappdata(frame,'ConnectionData');

try
      
  %Try to get header data to validate security name
  concls = class(conn{cval});
  switch concls
    case 'bloomberg'
      dummy = fetch(conn{cval},sstr,'GETDATA','NAME');   %Get NAME to see if valid security
      if strmatch('SECURITY UNKNOWN',dummy.NAME)
        error('datafeed:dftool:securityError','%s',dummy.NAME{1})
      end
    case 'idc'
      dummy = fetch(conn{cval},sstr,'PRC');  %Get yesterday's price  
  end
        
  %Add to security list (if not already on list)
  lstr = get(ui.selectedsecurities,'String');
  i = find(strcmp(sstr,lstr));
  
  if isempty(i)
    lstr = [lstr;{sstr}];
    set(ui.selectedsecurities,'String',lstr,'Value',length(lstr))
  else
    set(ui.selectedsecurities,'Value',i)
  end
  set(ui.security,'String',[])

catch
  errordlg(lasterr)
end

set(frame,'pointer','arrow')


function cleanupdialog(obj,evd,frame)
%CLEANUPDIALOG Visual enhancement of dialog.

%Set colors and alignment
e = findobj(gcf,'Style','edit');
l = findobj(gcf,'Style','listbox');
p = findobj(gcf,'Style','popupmenu');
set([e;l;p],'Backgroundcolor','white','Horizontalalignment','left')
dbc = get(0,'Defaultuicontrolbackgroundcolor');
set(gcf,'Color',dbc)

%Make text boxes proper width
textuis = findobj(gcf,'Style','text');
notextui = findobj(gcf,'Tag','tabhide');  %Do not alter tab cover (which is a blank text ui)
if ~isempty(notextui);
  j = find(notextui == textuis);
  textuis(j) = [];
end
for i = 1:length(textuis)
  pos = get(textuis(i),'Position');
  ext = get(textuis(i),'Extent');
  set(textuis(i),'Position',[pos(1) pos(2) ext(3) pos(4)])
end
set(textuis,'Backgroundcolor',dbc)

%Normalize units
set(findobj(gcf,'Type','uicontrol'),'Units','normal')
set(findobj(gcf,'Type','axes'),'Units','normal')
set(notextui,'Units','pixels')

function cleardata(obj,evd,frame)
%CLEARDATA Remove visual display of fetched data.
    
ui = getappdata(frame,'uidata');
set(ui.displayeddata,'String','')


function clearhistory(obj,evd,frame)
%CLEARHISTORY Clear command history.

ui = getappdata(frame,'uidata');
set(ui.servermessages,'String',{})
refresh(frame)


function closedfdialog(obj,evd,frame)
%CLOSEDFDIALOG Exit from DFTOOL

ui = getappdata(frame,'uidata');

%Close all open connections
ccstr = get(ui.currentconnections,'String');
    
if isempty(ccstr)    %If no connections, just close window
  closereq
else                 %Connections found, close them
  set(ui.currentconnections,'Value',1:length(ccstr))
  disconnect([],[],frame)
  closereq
end
    
%Close lookup dialog if it is open
close(findobj('Tag','DatafeedLookupDlg'))
close(findobj('Tag','OverrideDlg'))
    
    
function connect(obj,evd,frame)
%CONNECT Make datafeed connection.
    
%Get ui data
ui = getappdata(frame,'uidata');

%Get datasource
dval = get(ui.sources,'Value');
dstr = get(ui.sources,'String');
datasource = dstr{dval};

%Make connection
try

  %Get Port Number
  portnumber = get(ui.port,'String');
  
  %Get IP Address
  ipaddress = get(ui.ipaddress,'String');
  
  switch datasource(1:3)

    case 'Blo'

      %Try different Bloomberg command syntax'
      if isempty(portnumber) | ~isempty(findstr(portnumber,'default'))
        connectstring = ['conn = ' lower(datasource) ';'];
      elseif isempty(ipaddress) | ~isempty(findstr(ipaddress,'default'))
        connectstring = ['conn = ' lower(datasource) '(' portnumber ');'];
      else
        connectstring = ['conn = ' lower(datasource) '(' portnumber ',''' ipaddress ''');'];
      end
    
    case 'Hyp'
        
      %Determine which table to use
      i = findstr('-',datasource);
          
      %Connect to hyperfeed table
      connectstring = ['conn = hyperfeed(''' datasource(i+2:end) ''');'];
      
    case 'IDC'
      
      connectstring = ['conn = idc;'];
      
    case 'Yah'
      %Try different Yahoo command syntax
      if isempty(portnumber) | ~isempty(findstr(portnumber,'default'))
        connectstring = ['conn = yahoo;'];
      elseif isempty(ipaddress) | ~isempty(findstr(ipaddress,'default'))
        connectstring = ['conn = yahoo(''http://quote.yahoo.com:' portnumber ''');'];
      else
        connectstring = ['conn = yahoo(''http://quote.yahoo.com'',''' ipaddress ''','  portnumber ');'];
      end
        
  end
    
  %Evaluate connection command
  eval(connectstring)
      
catch
  errordlg(lasterr)
  set(findobj('Type','figure'),'Pointer','arrow')
  return
end
    
%Update current connection window if success
cstr = get(ui.currentconnections,'String');
switch datasource(1:3)
  case 'Blo'
    set(ui.currentconnections,'String',[cstr;{[datasource '-' portnumber '-' ipaddress]}],'Value',length(cstr)+1)
  case {'Hyp';'IDC';'Yah'}
    set(ui.currentconnections,'String',[cstr;{datasource}],'Value',length(cstr)+1)
    if strcmp(datasource,'Hyperfeed - History')
      set(ui.fields,'Max',1)   %Make sure only one historical field can be requested
    end
end   
        
%Get current connections
udat = getappdata(frame,'ConnectionData');
setappdata(frame,'ConnectionData',[udat;{conn}])

%Show correct field list
loadfields([],[],frame)
 
%Update status information
updatestatus([],[],frame)

%update connection history
smstr = get(ui.servermessages,'String');
smstr = [smstr;{[timestamp ' - Connect to ' datasource '.']}];
smstr = [smstr;{connectstring;' '}];
set(ui.servermessages,'String',smstr,'Value',[])


function copyhistory(obj,evd,frame)
%COPYHISTORY Command history to clipboard.

%Get ui data
ui = getappdata(frame,'uidata');

%Copy command history string to clipboard
commstr = get(ui.servermessages,'String');
commval = get(ui.servermessages,'Value');
clipboard('copy',sprintf('%s\n',commstr{commval}))


function dateerrors(obj,evd,frame)
%DATEERRORS Date input verification.
    
%Trap bad dates for date entry uicontrols
tag = get(gcbo,'Tag');
datetags = {'datadate','fromdate','todate'};
if any(strcmp(tag,datetags))
  dstr = get(gcbo,'String');
else
  for i = 1:length(datetags)
     dstr{i} = get(ui.(datetags{i}),'String');
  end  
end
try
  for i = 1:length(dstr)
    datenum(dstr);
  end    
catch
  errordlg('Please enter a valid date.')
end
    
    
function deletesecurity(obj,evd,frame)
%DELETESECURITY Delete selected securities from list
    
ui = getappdata(frame,'uidata');
sval = get(ui.selectedsecurities,'Value');
sstr = get(ui.selectedsecurities,'String');
if ~isempty(sstr)
  sstr(sval) = [];
  %Determine value of listbox
  lstr = length(sstr);
  if sval <= lstr 
    lval = sval;
  else
    lval = max(sval-1,1);
  end
  set(ui.selectedsecurities,'String',sstr,'Value',lval)
end
    
 
function dfdlghelp(obj,evd,frame)
%DFDLGHELP DFTOOL help.

%Determine which help is being requested
if ~isempty(findobj(gcf,'Userdata','Data','Visible','on'))
  hstr = 'csh2.html';    %Data tab help
elseif ~isempty(findobj(gcf,'String','Select'))
  hstr = 'csh3.html';    %Lookup dialog help
else
  hstr = 'csh1.html';    %Connection tab help
end
helpview([docroot '/toolbox/datafeed/' hstr])


function disconnect(obj,evd,frame)
%DISCONNECT Close selected connection object
    
ui = getappdata(frame,'uidata');

%Get current list of connections and connection objects
cval = get(ui.currentconnections,'Value');
cstr = get(ui.currentconnections,'String');
udat = getappdata(frame,'ConnectionData');
    
%Close connection
for i = 1:length(cval)
  close(udat{cval(i)})
end
    
%Remove selected connection information
tmp = cstr(cval);
cstr(cval) = [];
set(ui.currentconnections,'String',cstr,'Value',[])
udat(cval) = [];
setappdata(frame,'ConnectionData',udat);
    
%Update status information
updatestatus(obj,evd,frame)
    
%Display disconnect message
smstr = get(ui.servermessages,'String');
for i = 1:length(tmp)
  smstr = [smstr;{[timestamp ' - Disconnect from ' tmp{i}];'close(conn)';' '}];
end
set(ui.servermessages,'String',smstr)
    
    
function s = dispstruct(d)
%DISPSTRUCT Parse structure to display as string.

%Get fieldnames
flds = fieldnames(d);

%Get size of each elements
eval(['els = size(d.' flds{1} ',1);'])
numflds = length(flds);
s = cell(numflds,1);

%Build output string
tmpflds = char(flds);
i = find(tmpflds == ' ');
tmpflds(i) = '.';
pad = '   ';

for i = 1:numflds
  s{i} = [tmpflds(i,:) ' = '];  
  for j = 1:els

    try  %Extract field value
      x = d.(flds{i})(j);
    catch
      x = d.(flds{i});
    end
    if strcmp(x,'!')                    %IDC error value
      x = d.(flds{i});      %Get entire value
    end
    %Convert MATLAB date numbers to date and time strings
    if ~isempty(findstr('_DT',flds{i}(end-2:end)))
      x = datestr(x,2);
    end
    
    try
      if ischar(x)
        s{i} = [s{i} x pad];
      elseif x == floor(x)
        s{i} = [s{i} sprintf('%0.0f',x) pad];    %Display as integer
      else  
        s{i} = [s{i} sprintf('%0.2f',x) pad];    %Display as float
      end  
    catch
      try
        s{i} = [s{i} char(x) pad];     %Store as string
      catch
        s{i} = [s{i} 'Refer to workspace variable for field value.' pad];
      end
    end
  end
end


function enableselect(obj,evd,frame)
%ENABLESELECT  Enable select button if lookup called from main dialog.

if ~isempty(frame)
  set(findobj(gcf,'String','Select'),'Enable','on')
end
    
    
function expandfieldlist(obj,evd,frame)
%EXPANDFIELDLIST Field list selection.
      
%Get connection information
ui = getappdata(frame,'uidata');
cval = get(ui.currentconnections,'Value');
conn = getappdata(frame,'ConnectionData');
    
%Do nothing if no valid connection is selected
if isempty(conn) || isempty(cval)
  return
end
    
%Determine if categories are displayed or exit, ui.radiofields(2) is the All Fields selection
if ~strcmp('bloomberg',class(conn{cval})) || ~get(ui.radiofields(2),'Value')
  return
end
    
%Expand/Compress selected categories
fval = get(ui.fields,'Value');
fstr = get(ui.fields,'String');
listboxtop = get(ui.fields,'Listboxtop');

%Change + to - and - to +
catsel = 0;
for i = 1:length(fval)
  j = strmatch('+ ',fstr{fval(i)});
  if ~isempty(j)
    fstr{fval(i)}(1) = '-';
    catsel = 1;
  end
  k = strmatch('- ',fstr{fval(i)});
  if isempty(j) && ~isempty(k)
    fstr{fval(i)}(1) = '+';
    catsel = 1;
  end
end

%If any categories highlighted, remove selection display
if catsel
  fval = [];
end

%Remove all displayed field names
z = [];
for i = 1:length(fstr)
  j = strmatch('+',fstr{i});
  k = strmatch('-',fstr{i});
  if isempty(j) && isempty(k)
    z = [z;i];
  end
end
fstr(z) = [];

loadfields([],[],frame)
global bbfieldnames bbcategories bbuniquecategories bboverrides
   
%Save current state of list
bbuniquecategories = fstr;

%Expand categories that have been selected
catlist = fstr;
fieldlist = [];

for i = 1:length(catlist)
  if strmatch('-',catlist{i})
    j = find(strcmp(catlist{i}(3:end),bbcategories));
    fieldlist = [fieldlist;fstr(i);sort(bbfieldnames(j))];
  else
    fieldlist = [fieldlist;fstr(i)];
  end
end  
if get(ui.radio(3),'Value')
  set(ui.fields,'String',fieldlist,'Listboxtop',listboxtop)
else
  set(ui.fields,'Value',fval,'String',fieldlist,'Listboxtop',listboxtop)
end

    
function getdata(obj,evd,frame)
%GETDATA Data retrieval.
    
try
      
  %Clear currently displayed data
  cleardata(obj,evd,frame)
  set(frame,'Pointer','watch')
  
  %Get connection information
  ui = getappdata(frame,'uidata');
  cval = get(ui.currentconnections,'Value');
  if isempty(cval)
    error('datafeed:dftool:connectionError','No current connection for data retrieval.')
  end
  conn = getappdata(frame,'ConnectionData');
      
  %Get connection type
  concls = class(conn{cval});
      
  %Get the list of securities
  secs = get(ui.selectedsecurities,'String');
  secval = get(ui.selectedsecurities,'Value');
  if isempty(secs) | isempty(secval)
    error('datafeed:dftool:securityError','No security selected for data retrieval.')
  else
    secstr = ['{'];         %Build security list for display purposes
    for i = 1:length(secs(secval))
       if any(strcmp(concls,{'yahoo','idc','hyperfeed'}))
         j = findstr(secs{secval(i)},' ');
         secs{secval(i)} = secs{secval(i)}(1:j-1);
       end  
       secstr = [secstr '''' secs{secval(i)} ''';'];
    end
    secstr(end) = '}';
  end
      
  %Build field list
  [flds,fval] = getfields(obj,evd,frame);
  numflds = length(fval);
  fldstr = '{';
  for i = 1:length(flds)
     fldstr = [fldstr '''' flds{i} ''';'];
  end
  fldstr(end) = '}';
  
  %Get display data uicontrol handle
  dstr = get(ui.displayeddata,'String');
         
  %Determine fetch type from selected radio button string
  datstr = get(findobj(ui.radio,'Value',1),'String');
      
  %Get the workspace variable name for data
  wstr = get(ui.workspacevar,'String');
  if isempty(wstr)
    error('datafeed:dftool:missingWorkspaceVariable','Please specify a workspace variable for data.')
  end

  %Fetch data
  switch datstr
        
    case 'Current'
          
      global headerfieldnames
          
      %Determine which methods to use
      switch concls
              
        case 'bloomberg'
             
            %Get header data fields
            if get(ui.radiofields(1),'Value')
              %header data call
              tmpdat = fetch(conn{cval},secs(secval));
              dat = [];
              %Find differences in field value vectors and get data from header structure
              hdflds = intersect(flds,headerfieldnames);
              for i = 1:length(hdflds)
                 dat.(hdflds{i}) = tmpdat.(hdflds{i});
              end
              fetchstr = [wstr ' = fetch(conn,' secstr ');'];
                  
            else %Use GETDATA switch
              
              %Get override list
              overrides = getappdata(gcf,'overrides');
              if ~isempty(overrides)
                ofstr = '{';
                ovstr = '{';
                for i = 1:size(overrides,1)
                  ofstr = [ofstr '''' overrides{i,1} ''';'];
                  ovstr = [ovstr '''' overrides{i,2} ''';'];
                end
                ofstr(end) = '}';
                ovstr(end) = '}';
                fetchstr = [wstr ' = fetch(conn,' secstr ',''GETDATA'',' fldstr ',' ofstr ',' ovstr ');']; 
                dat = fetch(conn{cval},secs(secval),'GETDATA',flds,overrides(:,1),overrides(:,2));
              else
                fetchstr = [wstr ' = fetch(conn,' secstr ',''GETDATA'',' fldstr ');']; 
                dat = fetch(conn{cval},secs(secval),'GETDATA',flds);
              end
            end
                  
        case {'idc'}
                
            dat = [];
            tmpdat = fetch(conn{cval},secs(secval),flds);
                
            %Build fetch string command for display purposes
            for i = 1:length(flds)
              j = find(flds{i} == ':');
              flds{i}(j) = '_';
              dat.(flds{i}) = tmpdat{i};
            end
            fetchstr = [wstr ' = fetch(conn,' secstr ',' fldstr ');'];

        case {'yahoo'}
                  
            dat = [];
            tmpdat = fetch(conn{cval},secs(secval));
                
            %Build fetch string command for display purposes
            for i = 1:length(flds)
              dat.(flds{i}) = tmpdat.(flds{i});
            end
                
            if (length(flds) == length(get(findobj(gcf,'Tag','Fields'),'String')))
              fetchstr = [wstr ' = fetch(conn,' secstr ');'];   %All fields chosen, use default fetch
            else
              fetchstr = [wstr ' = fetch(conn,' secstr ',' fldstr ');'];  %Choose specific fields
            end
                
        case {'hyperfeed'}
            
            %Request data
            dat = fetch(conn{cval},secs{secval},flds);
            
            %Build fetch string command for display purposes
            if (length(flds) == length(get(findobj(gcf,'Tag','Fields'),'String')))
              fetchstr = [wstr ' = fetch(conn,' secstr ');'];   %All fields chosen, use default fetch
            else
              fetchstr = [wstr ' = fetch(conn,' secstr ',' fldstr ');'];  %Choose specific fields
            end
            
            %Remove S&PCode field
            try
              dat = rmfield(dat,'S&PCode');
            catch
            end
              
        %Sort fields for display purposes
        strflds = sort(fieldnames(dat));
        for i = 1:length(strflds)
          tmp.(strflds{i}) = dat.(strflds{i});
        end
              
        dat = tmp;
            
      end
          
      %Build display string
      s = dispstruct(dat);
      set(ui.displayeddata,'String',s)
            
    case 'Intraday Ticks'
      
      %Get the data date and validate
      try
        datadate = datenum(get(ui.datadate,'String'));
        if isempty(datadate)
          error('datafeed:dftool:missingTimeseriesDate','Please enter a valid date for timeseries data retrieval.')
        elseif datadate > floor(now)
          error('datafeed:dftool:invalidTimeseriesDate','Please enter current or past date for timeseries data retrieval.')
        end
      catch
        [m,mid] = lasterr;
        error(mid,'%s',m)
      end
        
      %Get interval value
      intstr = get(ui.interval,'String');
      interval = str2double(intstr);
      if isnan(interval)
        error('datafeed:dftool:invervalError','Please enter numeric interval value.')
      end
      switch concls
          
        case 'bloomberg'
     
          %Get selected field information
          fstr = get(ui.fields,'String');
          fval = get(ui.fields,'Value');
          ttval = getappdata(ui.fields,'tickflags');
          tickflags = ttval(fval);
        
          %Get time series data for given date and no interval
          if interval
         
            dat = fetch(conn{cval},secs(secval),'TIMESERIES',datadate,interval,tickflags);
            fetchstr = [wstr ' = fetch(conn,' secstr ',''TIMESERIES'',''' get(ui.datadate,'String') ''',' intstr ','');'];
            tstr = [];
            %Column that has date/time
            colval = 1;
            
          else
          
            dat = fetch(conn{cval},secs(secval),'TIMESERIES',datadate);
            fetchstr = [wstr ' = fetch(conn,' secstr ',''TIMESERIES'',''' get(ui.datadate,'String') ''');'];
               
            %Remove unselected tick types
            j = [];
            for i = 1:length(tickflags)
              j = [j;(find(dat(:,1) == tickflags(i)))];
            end
            dat = dat(sort(j),:);
      
            %Change large negative values (invalid data) to zeros
            k = find(dat < -1e9);
            dat(k) = 0;
      
            %Convert type values to type strings
            tstr = tickflag2string(dat(:,1))';
      
            %Column that has date/time
            colval = 2;
                
          end
          
      end
      
      %Create string padding for visual spacing of dates and values
      tmp = '  ';
      pad = tmp(ones(size(dat,1),1),:);

      %Display data
      if isempty(dat)
        set(ui.displayeddata,'String','No tick data for selected fields.')
      else
        numdat = [];
        r = size(dat,1);
        for i = colval:size(dat,2)
          switch i 
            case colval
              numdat = [numdat pad datestr(dat(:,i),0)];
            otherwise
              tmpdat = sprintf('%0.2f\n',dat(:,i));
              j = find(tmpdat == 10);
              tmpout = cell(r,1);
              tmpout{1} = tmpdat(1:j(1)-1);
              for i = 2:r-1
                tmpout{i} = tmpdat(j(i-1)+1:j(i)-1);
              end
              tmpout{end} = tmpdat(j(r-1)+1:j(r)-1);
              numdat = [numdat pad str2mat(tmpout)];
          end
        end
        set(ui.displayeddata,'String',[char(tstr) numdat])
      end
            
    case 'History'
      
      %Get the start and end dates
      fstr = get(ui.fromdate,'String');
      fd = datenum(fstr);
      if isempty(fd)
        error('datafeed:dftool:historicalDateError','Please enter valid From Date.')
      end
      tstr = get(ui.todate,'String');
      td = datenum(tstr);
      if isempty(td)
        error('datafeed:dftool:historicalDateError','Please enter valid To Date.')
      end
          
      %From Date must be less than To Date
      if (td - fd) < 1
        error('datefeed:dftool:historicalDateError','From Date must be date before To Date.')
      end
      
      %Get period
      perstr = get(ui.period,'String');
      perval = get(ui.period,'Value');
      prd = perstr{perval};
         
      %Get historical data for given period
      try
        switch concls
        
          case 'bloomberg'
        
            dat = fetch(conn{cval},secs(secval),'HISTORY',flds,fd,td,prd);
            fetchstr = [wstr ' = fetch(conn,' secstr ',''HISTORY'',' fldstr ',''' fstr ''',''' tstr ''',''' prd(1) ''');'];
        
          case {'idc','yahoo','hyperfeed'}  
        
            newsecstr = secs{secval};    %Remove market from securities for idc and yahoo
            i = find(secstr == ' ');
            if ~isempty(i)
              newsecstr = secstr(1:i-1);
            end
        
            switch concls
            
              case 'yahoo'
        
                dat = fetch(conn{cval},newsecstr,flds,fd,td,prd(1));
                fetchstr = [wstr ' = fetch(conn,' secstr ',' fldstr ',''' fstr ''',''' tstr ''',''' prd(1) ''');'];
           
              otherwise
               
                dat = fetch(conn{cval},newsecstr,flds,fd,td);
                fetchstr = [wstr ' = fetch(conn,' secstr ',' fldstr ',''' fstr ''',''' tstr ''');'];
            
            end 
             
            %IDC data does not have dates in it, return whatever comes back
            if strcmp(concls,'idc')
              set(ui.displayeddata,'String',dat)
              set(frame,'Pointer','arrow')
              return
            end
        end
        
        %Format data for display
        if size(dat,2) < 2
          error('datafeed:dftool:noData','No data returned.')
        end
        
        %Convert date numbers to date strings
        dts = datestr(dat(:,1),2);
      
        %Create string padding for visual spacing of dates and values
        tmp = '   ';
        pad = tmp(ones(size(dat,1),1),:);
      
        %Display data
        set(ui.displayeddata,'String',[dts pad num2str(dat(:,2))])
        
      catch
        error('datafeed:dftool:noData','No data returned.')
      end
     
  end      
      
  %Update server messages
  smstr = get(ui.servermessages,'String');
  smstr = [smstr;{[timestamp ' - ' datstr ' data requested.'];fetchstr;' '}];
  set(ui.servermessages,'String',smstr)
  
  %Do not highlight row of data
  set(ui.displayeddata,'Value',[])
  
  %Store data in GUI
  setappdata(frame,'fetchdata',dat)
  
  %Get the workspace variable name for data
  wstr = get(ui.workspacevar,'String');  
  if isempty(wstr)
    error('datafeed:dftool:missingWorkspaceVariable','Please specify a workspace variable for data.')
  else
    %Replace blank spaces with underscores
    i = find(wstr == ' ');
    wstr(i) = '_';
    evalin('base',[wstr ' = getappdata(gcf,''fetchdata'');'],'error(''datafeed:dftool:workspaceVariableCreateFailure'',''Unable to create workspace variable.'')')
  end    
catch
  errordlg(lasterr)
  %Update server messages
  smstr = get(ui.servermessages,'String');
  smstr = [smstr;{[timestamp ' - data requested.  ' lasterr]}];
  set(ui.servermessages,'String',smstr)
end
set(frame,'Pointer','arrow')   
    
function [f,fval] = getfields(obj,evd,frame)
%GETFIELDS Determine selected fields for data fetch.

%Get the selected fields from the Fields listbox
ui = getappdata(frame,'uidata');
fval = get(ui.fields,'Value');

if isempty(fval)    %Trap null field selection
  error('datafeed:dftool:noFieldsSelected','No data fields currently selected.')
end
fstr = get(ui.fields,'String');
f = fstr(fval);


function intervalsetting(obj,evd,frame)
%INTERVALSETTING Time series bar interval setting
    
%Get interval value
ui = getappdata(frame,'uidata');
interval = str2double(get(ui.interval,'String'));
if isnan(interval)
  errordlg('Please enter numeric interval value')
end
  
%Make field list single select if non-zero interval is given
fstr = get(ui.fields,'String');
fmax = get(ui.fields,'Max');
if interval && fmax > 1
  set(ui.fields,'Value',1,'Max',1)
else
  set(ui.fields,'Value',1:length(fstr),'Max',2)
end


function loadsec(obj,evd,frame)
%LOADSEC Open securities file.

ui = getappdata(frame,'uidata');

%Load securities file
[f,p] = uigetfile('*.mat','Load Securities File...');

if f     %Valid file specified
  try
    eval(['load ' p f])
    set(ui.selectedsecurities,'String',securities)
    set(ui.radio,{'Value'},rvals)
    set([ui.datadate;ui.fromdate;ui.todate],{'String'},dates)
    set(ui.radiofields,{'Value'},rfvals)
    set(ui.fields,'String',fieldata{1},'Value',fieldata{2})
        
    %Enable/Disable uicontrols based on data selection mode
    mstr = get(findobj(gcf,'Tag','radio','Value',1),'String');
    switch mstr
      case 'Current'
        set([ui.datadate;ui.fromdate;ui.todate],'Enable','off')
        set(ui.radiofields,'Enable','on')
      case 'Intraday Ticks'
        set(ui.radiofields,'Enable','off')
        set([ui.fromdate;ui.todate],'Enable','off')
        set(ui.datadate,'Enable','on')
      case 'History'
        set(ui.radiofields,'Enable','on')
        set([ui.fromdate;ui.todate],'Enable','on')
        set(ui.datadate,'Enable','off')
    end
    
    %Create workspace variable if empty
    wstr = get(ui.workspacevar,'String');
    if isempty(wstr)
      lstr = get(ui.selectedsecurities,'String');
      lval = get(ui.selectedsecurities,'Value');
      wkstr = lstr{lval};
      i = find(wkstr == ' ');
      wkstr(i) = '_';
      set(ui.workspacevar,'String',wkstr)
    end
  catch
    errordlg(['Unable to load ' p f ' or invalid Securities file.'])
  end
end


function loadfields(obj,evd,frame)
%LOADFIELDS Bloomberg field information
    
%Get connection information to determine which fields should be loaded
ui = getappdata(frame,'uidata');
cval = get(ui.currentconnections,'Value');
if isempty(cval)
  concls = 'bloomberg';
else
  conn = getappdata(frame,'ConnectionData');
  try
    concls = class(conn{cval});
  catch
    return
  end
end

global datafieldnames defaultfieldnames

switch concls(1:3)

  case 'blo'
    %Load bloomberg/bbfields if not already loaded
    global bbfieldnames headerfieldnames bbcategories bbuniquecategories bboverrides
    if isempty(bbfieldnames) | isempty(headerfieldnames) | isempty(bbcategories) | isempty(bbuniquecategories) | isempty(bboverrides)
      load bloomberg/bbfields
      %Add +'s to bbcategories
      bbuniquecategories = unique(bbcategories);
      for i = 1:length(bbuniquecategories)
        bbuniquecategories{i} = ['+ ' bbuniquecategories{i}];
      end
    end
    datafieldnames = bbuniquecategories;
    defaultfieldnames = headerfieldnames;
        
  case 'idc'
    %Load idc/idcfields if not already loaded
    global idcfieldnames
    if isempty(idcfieldnames)
      load idc/idcfields
    end
    datafieldnames = idcfieldnames;
    defaultfieldnames = idcfieldnames;
    
  case 'yah'  
    %Load yahoo/yhfields if not already loaded
    global yahoofieldnames histyhfieldnames
    if isempty(yahoofieldnames)
      load yahoo/yhfields
    end
    if ~isempty(findobj(gcf,'Style','radiobutton','String','Current','Value',1))
      datafieldnames = sort(yahoofieldnames);
      defaultfieldnames = datafieldnames;
    else
      datafieldnames = sort(histyhfieldnames);
      defaultfieldnames = datafieldnames;
    end
        
  case 'hyp'
    %Load hyperfeed/hpfields if not already loaded  
    global hphistoryfields hppricefields hpprofilefields hptickfields
    if isempty(hphistoryfields)
      load hyperfeed/hpfields
    end
    %Determine which fields to load
    conobj = findobj(gcf,'Tag','CurrentConnections');
    constr = get(conobj,'String');
    conval = get(conobj,'Value');
    dselstr = constr{conval};
        
        
    switch dselstr
           
      case 'Hyperfeed - History'
        datafieldnames = hphistoryfields;
        defaultfieldnames = datafieldnames;
            
      case 'Hyperfeed - Price'
        datafieldnames = hppricefields;
        defaultfieldnames = datafieldnames; 
            
      case 'Hyperfeed - Profile'
        datafieldnames = hpprofilefields;
        defaultfieldnames = datafieldnames;
            
    end
    
end


function lookup(obj,evd,frame)
%LOOKUP Securities lookup dialogs. 

[dfp,mfp,bspc,bhgt,bwid,tabhgt] = spaceparams(obj,evd,frame);

%Get connection data
ui = getappdata(frame,'uidata');
cval = get(ui.currentconnections,'Value');
cons = getappdata(frame,'ConnectionData');
try
  ccon = cons{cval};
  concls = class(ccon);
catch
  errordlg('Please make a valid Datafeed connection from the Connection tab.')
  return
end
    
switch concls
  
  case 'bloomberg'
  
    %Securities lookup dialog and size
    lkobj = findobj('Tag','DatafeedLookupDlg');

    if ~isempty(lkobj)    %Dialog already open, focus on it
      figure(lkobj)
    else
  
      %Build lookup dialog
      h = figure('NumberTitle','off','Name','Datafeed Securities Lookup','Windowstyle','normal',...
        'Tag','DatafeedLookupDlg','Menubar','none');
      p = get(h,'Position');
      set(gcf,'Position',[p(1) p(2) 14*bspc+5*bwid 11*bspc+8*bhgt]);
      p = get(h,'Position');
      rgt = p(3);
      top = p(4);

      %Base frame
      uicontrol('Enable','off','Position',[bspc bspc rgt-2*bspc top-2*bspc]);
  
      %Get entered security in main dialog
      sstr = get(ui.security,'String');
  
      %Get current market type from main dialog
      mval = get(ui.securitymarkettype,'Value');
            
      %Build security search frame
      uicontrol('Style','frame','Position',[2*bspc 5*bspc+bhgt 2*bspc+1.5*bwid 8*bspc+6*bhgt]);
      uicontrol('Style','text','String','Lookup:','Position',[3*bspc 12*bspc+6*bhgt bwid bhgt]);
      ui.findsecurity = uicontrol('Style','edit','Tag','FindSecurity','Tooltip','Security search string',...
        'String',sstr,'Position',[3*bspc 12*bspc+5*bhgt 1.5*bwid bhgt]);
      uicontrol('Style','text','String','[e.g., Intl, Ford, AT&T, ...]',...
        'Position',[3*bspc 10*bspc+4*bhgt bwid bhgt]);
      uicontrol('Style','text','String','Choose Market:','Position',[3*bspc 7*bspc+3*bhgt bwid bhgt]);
      ui.markettype = uicontrol('Style','popupmenu','Tag','MarketType','Value',mval,'Tooltip','Market type',...
        'String',sort({'Equity';'Govt';'Corp';'Muni';'Index';'Mtge';'M-Mkt';'Pfd';'Comdty';'Curncy'}),...
        'Position',[3*bspc 7*bspc+2*bhgt 1.5*bwid bhgt]);
      uicontrol('String','Submit','Callback',{@submit,h},'Tooltip','Start ticker symbol search',...
        'Position',[0.75*bwid-bspc 6*bspc+bhgt bwid bhgt]);
      
      %Build looked up securities frame
      uicontrol('Style','frame','Position',[5*bspc+1.5*bwid 5*bspc+bhgt 4*bwid-bspc 8*bspc+6*bhgt]);
      uicontrol('Style','text','String','Security','Position',[6*bspc+1.5*bwid 12*bspc+6*bhgt bwid bhgt]);
      uicontrol('Style','text','String','Symbol','Position',[4*bspc+4*bwid 12*bspc+6*bhgt bwid bhgt]);
      ui.foundsecurities = uicontrol('Style','listbox','Max',2,'Value',[],'Tag','FoundSecurities','Tooltip','Ticker symbol search results',...
        'Callback',{@enableselect,h},...
        'Fontname',get(0,'Fixedwidthfont'),'Position',[6*bspc+1.5*bwid 7*bspc+2*bhgt 4*bwid-3*bspc 5*bhgt+bspc]);
      ui.select = uicontrol('String','Select','Callback',{@select,h},'Tooltip','Add securities to Selected Securities list',...
        'Enable','off','Position',[3*bspc+4.5*bwid 6*bspc+bhgt bwid bhgt]);
      
      %Close, help uicontrols
      uicontrol('String','Close','Callback','close','Tooltip','Close security lookup dialog',...
        'Position',[rgt-(3*bspc+bwid) 3*bspc bwid bhgt]);    
      uicontrol('String','Help','Callback',{@dfdlghelp,h},'Position',[0.75*bwid-bspc 3*bspc bwid bhgt]);
   
      cleanupdialog([],[],h)
      set(h,'handlevisibility','callback')
      setappdata(h,'uidata',ui)
      setappdata(h,'basefigurehandle',frame)
      
    end
    
  case 'idc'
      
    idccallbacks('nsw')
         
end


function overrideadd(obj,evd,frame)
%OVERRIDEADD Set override field/value pair.
     
%Check override box for value
ovobj = findobj(frame,'Tag','overridevalue');
ovrval = get(ovobj,'String');
set(ovobj,'String',[])
   
if ~isempty(ovrval)
       
  %Get selected field
  ofobj = findobj(gcf,'Tag','ovrfields');
  ofval = get(ofobj,'Value');
  ofstr = get(ofobj,'String');
  ovrstr = ofstr{ofval};
  
  %Build display value
  stobj = findobj(gcf,'Tag','ovrsettings');
  ststr = get(stobj,'String');
  stdsp = sort([ststr;{[ovrstr ' = ' ovrval]}]);
  
  %Set display
  set(stobj,'String',stdsp)

end

%Save new value in override cell array
overrides = getappdata(gcf,'overrides');
overrides = [overrides;{ovrstr ovrval}];
setappdata(gcf,'overrides',overrides);

%Check for multiple override settings for the same field
ovrfields = overrides(:,1);
if length(unique(ovrfields)) ~= length(ovrfields)
  warndlg('Multiple override values assigned to a single field.','Override fields warning')
end
 

function overrideapply(obj,evd,frame)
%OVERRIDEAPPLY Apply override settings.
  
%Get base figure handle
fobj = getappdata(frame,'basefigurehandle');
setappdata(fobj,'overrides',getappdata(frame,'overrides'))


function overrideclose(obj,evd,frame)
%OVERRIDECLOSE Close override dialog.

closereq


function overridedialog(obj,evd,frame)
%OVERRIDEDIALOG Open override settings dialog.

[dfp,mfp,bspc,bhgt,bwid,tabhgt] = spaceparams(obj,evd,frame);

%Set up to open dialog  
hidstat = get(0,'Showhiddenhandles');
set(0,'Showhiddenhandles','on')
fobj = findobj('Tag','OverrideDlg');
if ~isempty(fobj)
  figure(fobj)
  set(0,'Showhiddenhandles',hidstat)
  set(findobj('Type','figure'),'Pointer','arrow')
  return
end
set(0,'Showhiddenhandles',hidstat)

%Create the base dialog
f = figure('Name','Override values','Numbertitle','off','Menubar','none','Tag','OverrideDlg',...
  'Resize','on');
set(f,'Closerequestfcn',{@overrideclose,f},'Resizefcn',{@cleanupdialog,f});
pos = get(f,'Position');
rgt = 9*bspc+6.25*bwid;
top = 5*bspc+17*bhgt;
set(f,'Position',[pos(1) pos(2) rgt top]) 
setappdata(f,'basefigurehandle',frame)

uicontrol('Style','frame','Position',[bspc 2*bspc+bhgt 7*bspc+6.25*bwid 2*bspc+16*bhgt]);
 
%Dialog action buttons
uicontrol('String','OK','Callback',{@overrideok,f},'Tooltip','Apply settings and close dialog',...
    'Position',[7*bspc+.875*bwid bspc bwid bhgt]);
uicontrol('String','Cancel','Callback',{@overrideclose,f},'Tooltip','Cancel settings changes and close dialog',...
    'Position',[8*bspc+1.875*bwid bspc bwid bhgt]);
uicontrol('String','Apply','Callback',{@overrideapply,f},'Tooltip','Apply settings',...
    'Position',[9*bspc+2.875*bwid bspc bwid bhgt]);
uicontrol('String','Help','Callback',{@overridehelp,f},'Tooltip','Override settings dialog help',...
    'Position',[10*bspc+3.875*bwid bspc bwid bhgt]);
 
%Override field list
loadfields(obj,evd,frame)
global bbfieldnames bbcategories bbuniquecategories bboverrides
ui.ovrfields = uicontrol('Style','listbox','String',bboverrides,'Tag','ovrfields','Tooltip','List of overridable fields',...
     'Position',[2*bspc 3*bspc+bhgt 3.25*bwid 15*bhgt]);
uicontrol('Style','text','String','Override fields:',...
     'Position',[2*bspc 3*bspc+16*bhgt bwid bhgt]);
    
%Override value box
ui.overridevalue = uicontrol('Style','edit','Tag','overridevalue','Tooltip','Override field value',...
     'Position',[4*bspc+3.25*bwid 3*bspc+9*bhgt bwid bhgt]);
uicontrol('Style','text','String','Override value:',...
     'Position',[4*bspc+3.25*bwid 3*bspc+10*bhgt bwid bhgt]);
uicontrol('String','Add >>','Callback',{@overrideadd,f},'Tooltip','Add override field/value setting to list',...
    'Position',[4*bspc+3.25*bwid 2*bspc+8*bhgt bwid bhgt]);
 
%Override field actions
uicontrol('String','Load...','Callback',{@overrideload,f},'Tooltip','Load previously saved override settings from file',...
     'Position',[6*bspc+4.25*bwid 3*bspc+bhgt .63*bwid bhgt]);
uicontrol('String','Save...','Callback',{@overridesave,f},'Tooltip','Save override settings to file',...
     'Position',[7*bspc+4.88*bwid 3*bspc+bhgt .63*bwid bhgt]);
uicontrol('String','Delete','Callback',{@overrideremove,f},'Tooltip','Remove selected override settings from list',...
     'Position',[8*bspc+5.54*bwid 3*bspc+bhgt .63*bwid bhgt]);
 
%Override field settings
overrides = getappdata(frame,'overrides');
stdsp = [];
for i = 1:size(overrides,1)
  stdsp{i} = [overrides{i,1} ' = ' overrides{i,2}];
end
ui.ovrsettings = uicontrol('Style','listbox','Max',2,'Value',[],'Tag','ovrsettings',...
     'String',stdsp,'Tooltip','Override field/value settings',...
     'Position',[6*bspc+4.25*bwid 4*bspc+2*bhgt bspc+2*bwid 14*bhgt-bspc]);
uicontrol('Style','text','String','Override field settings:',...
     'Position',[6*bspc+4.25*bwid 3*bspc+16*bhgt bwid bhgt]);
 
cleanupdialog([],[],f)
set(f,'Handlevisibility','callback')
setappdata(f,'uidata',ui)
setappdata(f,'overrides',overrides)
   
   
function overridehelp(obj,evd,frame)
%OVERRIDEHELP Override dialog help.

helpview([docroot '/toolbox/datafeed/csh4.html'])

   
function overrideload(obj,evd,frame)
%OVERRIDELOAD Load override settings file.

%Load override setting info 
[f p] = uigetfile('*.ovs','Load override settings file...');
 
if f
  load([p f],'-mat')
else
  return
end

%Store data
setappdata(gcf,'overrides',overrides)

%Display data
stobj = findobj(gcf,'Tag','ovrsettings');
stdsp = [];
for i = 1:size(overrides,1)
  stdsp{i} = [overrides{i,1} ' = ' overrides{i,2}];
end
  
%Set display
set(stobj,'String',stdsp)


function overrideok(obj,evd,frame)
%OVERRIDEOK Apply override settings and close dialog.
 
%Apply override data and close window
overrideapply(obj,evd,frame)
overrideclose(obj,evd,frame)
  

function overrideremove(obj,evd,frame)
%OVERRIDEREMOVE Delete override pair from settings.

ui = getappdata(frame,'uidata');

%Get current override setting info 
osval = get(ui.ovrsettings,'Value');
osstr = get(ui.ovrsettings,'String');
 
%Remove selected settings
osstr(osval) = [];
set(ui.ovrsettings,'String',osstr,'Value',[])
 
%Save new value in override cell array
overrides = getappdata(frame,'overrides');
overrides(osval,:) = [];
setappdata(frame,'overrides',overrides);


function overridesave(obj,evd,frame)
%OVERRIDESAVE Save override settings to file.

%Get current override setting info 
overrides = getappdata(frame,'overrides');
[f p] = uiputfile('*.ovs','Save override settings file...');
 
if f
  save([p f],'overrides','-mat')
end


function  radio(obj,evd,frame)
%RADIO Data retrieval radio buttons.
    
%Toggle radio buttons
ui = getappdata(frame,'uidata');
set(ui.radio,'Value',0)
set(gcbo,'Value',1)

%Get selected securities object to set selection value
L = length(get(ui.selectedsecurities,'Value'));

%Load @bloomberg/bbfields
loadfields(obj,evd,frame)
global bbfieldnames headerfieldnames icdfieldnames datafieldnames defaultfieldnames

%Fields selection string
rfstr = get(findobj(ui.radiofields,'Value',1),'String');
switch rfstr
  case 'Default Fields'
    fstr = defaultfieldnames;
  case 'All Fields'
    fstr = datafieldnames;
end

%Make uicontrol settings based on selected radio button
switch get(gcbo,'String')
  
  case 'Current'

    %Make fields and securities list multiselect
    set(ui.selectedsecurities,'Max',1)
    set(ui.fields,'Max',2)    
    %Set field display options
    set(ui.fields,'String',fstr,'Value',1)
    set(ui.radiofields,'Enable','on')  
    %Disable date boxes and interval/period boxes
    set([ui.datadate;ui.fromdate;ui.todate;ui.interval;ui.period],'Enable','off')

  case 'Intraday Ticks'

    %Date (timeseries) allows for one security at a time only
    set(ui.selectedsecurities,'Max',1)
    if L > 1 | L == 0
      set(ui.selectedsecurities,'Value',1)
    end
    %Get tick type strings
    ttstr = ticktypes(obj,evd,frame);
    [ttstr,si] = sort(ttstr);
    i = find(strcmp('NoTickType',ttstr));
    ttstr(i) = [];
    si(i) = []; 
    
    %Disable Fields selection, disable fields radio buttons
    set(ui.fields,'String',ttstr,'Value',1:length(si),'Max',2)
    setappdata(ui.fields,'tickflags',si)
    set(ui.radiofields,'Enable','off')  
    set(ui.radiofields,'Value',0)
    set(ui.radiofields(1),'Value',1)
    
    %Disable history date boxes, enable timeseries date box
    set([ui.fromdate;ui.todate;ui.period],'Enable','off')
    set([ui.datadate;ui.interval],'Enable','on')
    
    %If non-zero value in interval, make fields list single select
    interval = str2double(get(ui.interval,'String'));
    if interval
      set(ui.fields,'Value',1,'Max',1)
    end

  case 'History'

    %History allows for one security at a time only
    set(ui.selectedsecurities,'Max',1)
    if L > 1 | L == 0
      set(ui.selectedsecurities,'Value',1)
    end
    %And one field at a time only
    fval = get(ui.fields,'Value');
    if length(fval) == 0
      set(ui.fields,'Value',1)
    end
    if length(fval) > 1
      set(ui.fields,'Value',min(fval))
    end
    %Set Fields selection, Disable multi field select
    set(ui.fields,'String',fstr,'Value',1,'Max',2)
    set(ui.radiofields,'Enable','off')
    set(ui.radiofields,'Value',0)
    set(ui.radiofields(2),'Value',1)
    %Enable history date boxes, disable timeseries date box
    set([ui.fromdate;ui.todate;ui.period],'Enable','on')
    set([ui.datadate;ui.interval],'Enable','off')

    %Make data field names are displayed (Bloomberg default don't work with History)
    set(ui.fields,'String',datafieldnames)
    
end


function radiofields(obj,evd,frame)
%RADIOFIELDS Field selection radio buttons.
        
%Set values of radio buttons
ui = getappdata(frame,'uidata');
set(ui.radiofields,'Value',0)
set(gcbo,'Value',1)
    
%Load @bloomberg/bbfields
loadfields(obj,evd,frame)
global bbfieldnames headerfieldnames icdfieldnames datafieldnames defaultfieldnames bbcategories bbuniquecategories
    
%Determine which field list to display
rstr = get(gcbo,'String');
    
%Get connection information
cval = get(ui.currentconnections,'Value');
conn = getappdata(frame,'ConnectionData');
try
  concls = class(conn{cval});
catch
  concls = [];
  errordlg('Please make a valid Datafeed connection from the Connection tab.')
end
  
switch rstr
  case 'Default Fields' %Show header fields only
    set(ui.fields,'String',defaultfieldnames,'Value',1)
  case 'All Fields'    %Show full list
    if strcmp(concls,'bloomberg')
      for i = 1:length(datafieldnames)
        datafieldnames{i} = ['+' datafieldnames{i}(2:end)];
      end
      set(ui.fields,'String',datafieldnames,'Value',[],'Max',2)
    end
end
  

function savesec(obj,evd,frame)
%SAVESEC Save security list.
    
%Save list of securities to file
ui = getappdata(frame,'uidata');
securities = get(findobj(gcf,'Tag','SelectedSecurities'),'String');
[f p] = uiputfile('*.mat','Save Securities file...');

%Save data selection settings
rvals = get(ui.radio,'Value');
dates = get([ui.datadate;ui.fromdate;ui.todate],'String');

%Save field selection data
rfvals = get(ui.radiofields,'Value');
fieldata = get(ui.fields,{'String';'Value'});

if f
  eval(['save ' p f ' securities rvals dates rfvals fieldata'])
end
    

function select(obj,evd,frame)
%SELECT Choose securities from lookup list.  

%Get selected securities from found security list
ui = getappdata(frame,'uidata');
seval = get(ui.foundsecurities,'Value');
    
if ~isempty(seval)   %Do nothing is no securities selected
      
  %Determine selected descriptions
  sestr = get(ui.foundsecurities,'String');
  selsec = sestr(seval);
  
  %Get market type
  mtval = get(ui.markettype,'Value');
  mtstr = get(ui.markettype,'String');
  mkstr = mtstr{mtval};
  
  %Parse out security symbol
  for i = 1:length(selsec)
    
    tmpstr = selsec{i};
    
    switch mkstr   %Parse ticker symbol depdending market type
      case {'Curncy','Equity','Index'} 
        j = find(tmpstr == '(');
        k = find(tmpstr == ')');
        symstr{i} = [tmpstr(j+1:k-1) ' ' mkstr]; 
      case 'Govt'
        j = find(tmpstr == ' ');
        symstr{i} = [tmpstr(1:j-1) ' ' mkstr];
      otherwise 
        symstr{i} = tmpstr; 
    end
    
    %Make multispacing into single space for better visuals
    while 1
      x = findstr(symstr{i},'  ');
      if isempty(x)
        break
      else
        symstr{i}(min(x)) = [];
      end
    end
    
  end
  
  %Get current list of selected securities
  bfig = getappdata(frame,'basefigurehandle');
  bui = getappdata(bfig,'uidata');
  cursym = get(bui.selectedsecurities,'String');
  %Append new securities to list
  allsym = [cursym;symstr(:)];
  [newselsym,ind] = unique(allsym);
  %Display new list
  set(ui.selectedsecurities,'String',allsym(sort(ind)))
  %Bring main dialog into focus
  figure(bfig);
  
end
    

function [dfp,mfp,bspc,bhgt,bwid,tabhgt] = spaceparams(obj,evd,frame)
%SPACEPARAMS Figure spacing.

dfp = get(0,'DefaultFigurePosition');
mfp = [560 420];    %Reference width and height
bspc = mean([5/mfp(2)*dfp(4) 5/mfp(1)*dfp(3)]);
bhgt = 20/mfp(2) * dfp(4);
bwid = 80/mfp(1) * dfp(3);
tabhgt = 30/mfp(2) * dfp(4);


function submit(obj,evd,frame)
%SUBMIT Security lookup.

set(frame,'Pointer','watch')
ui = getappdata(frame,'uidata');

try
      
  %Get search string
  lkstr = get(ui.findsecurity,'String');
  if isempty(lkstr)
    error('datafeed:dftool:lookupError','Please enter search string.')
  end
  
  %Get market type
  mtobj = findobj(gcf,'Tag','MarketType');
  mtval = get(ui.markettype,'Value');
  mtstr = get(ui.markettype,'String');
  mkstr = mtstr{mtval};
  
  %Get connection information
  bfig = getappdata(frame,'basefigurehandle');
  bui = getappdata(bfig,'uidata');
  cval = get(bui.currentconnections,'Value');
  if isempty(cval)
    error('datafeed:dftool:lookupError','No current connection for security lookup.')
  end
  conn = getappdata(bfig,'ConnectionData');

  %Perform lookup
  fnstr = fetch(conn{cval},lkstr,'LOOKUP',mkstr);
  
  %Trap bad output
  if ~iscell(fnstr) | isempty(fnstr)
    fnstr = {'No matches found.'};
  end
  
  %Display matching security descriptions
  set(ui.foundsecurities,'String',fnstr,'Value',[])
  
catch
  errordlg(lasterr)
end

set(frame,'Pointer','arrow')


function tabs(obj,evd,frame)
%TABS Tabbed dialog action.
       
[dfp,mfp,bspc,bhgt,bwid,tabhgt] = spaceparams(obj,evd,frame);

%Determine selected and nonselected tab
tobj = sort(findobj(gcf,'Userdata','tab'));
pos = zeros(length(tobj),4);
for i = 1:length(tobj)
  pos(i,:) = get(tobj(i),'Position');
end
tpos = get(gcbo,'Position');
if tpos(2) == max(pos(:,2))
  return
end    
    
%New tab selected, change positions and move tab hide object
tflag = find(tobj == gcbo);
tobj(tflag) = [];
tflag = tflag-1;
npos = zeros(1,4);
for i = 1:length(tobj)
  npos(1,:) = get(tobj(i),'Position');
  set(tobj(i),'Position',[npos(1) min(pos(:,2)) npos(3) npos(4)])
end
thobj = findobj(gcf,'Tag','tabhide');
pos3 = get(thobj,'Position');
set(thobj,'Position',[1.25*bspc+tflag*(bwid+.5*bspc) pos3(2) pos3(3) pos3(4)]) 
set(gcbo,'Position',[tpos(1) max(pos(:,2)) tpos(3) tpos(4)])

%Set the visibility of uicontrols based on tab selection
tag = get(gcbo,'Tag');
tstr = {'Connection','Current','Historical'};
j = find(strcmp(tag,tstr));
tstr(j) = [];
for i = 1:length(tstr)
  set(findobj(gcf,'Userdata',tstr{i}),'Visible','off')
end
set(findobj(gcf,'Userdata',tag),'Visible','on')
switch j 
  case 1   %Connection panel
    set(findobj(gcf,'Userdata','Data'),'Visible','off') 
  case 2   %Data panel
    set(findobj(gcf,'Userdata','Data'),'Visible','on')
end
    

function dat = ticktypes(obj,evd,frame,tickflag)
%TICKTYPES Valid tick type strings

%Build vector of tick type flags
if nargin < 4
  x = [1:75]';
else
  x = tickflag(:);
end
%Make flag 2 string
dat = tickflag2string(x);

    
function selectsource(obj,evd,frame)
%SELECTSOURCE Data source select action.
    
%Get ui data
ui = getappdata(frame,'uidata');

%Determine which datasource has been chosen
dsval = get(ui.sources,'Value');
dsstr = get(ui.sources,'String');
dsrc = dsstr{dsval};

%Enable/disable port,ipaddress uicontrols accordingly
switch dsrc(1:3)
  case {'Blo','Yah'}
    set([ui.port ui.ipaddress],'Enable','on')
  case {'Hyp','IDC'}
    set([ui.port ui.ipaddress],'Enable','off')
end


function s = tickflag2string(x)
%TRADEFLAG2STRING Convert tick flag to string value.

ticktypes = {
'Trade',...                 '1
'Bid',...                   '2
'Ask',...                   '3
'Hit',...                   '4
'Take',...                  '5
'Settle',...                '6
'Volume',...                '7
'Open Interest',...         '8
'High',...                  '9
'Low',...                   '10
'Bid Yield',...             '11
'Ask Yield',...             '12
'NoTickType',...             '13   
'Bt Last Recap',...         '14
'NoTickType',...             '15   
'NoTickType',...             '16   
'NoTickType',...             '17   
'NoTickType',...             '18   
'NoTickType',...             '19   
'NoTickType',...             '20   
'NoTickType',...             '21   
'NoTickType',...             '22   
'NoTickType',...             '23   
'NoTickType',...             '24   
'NoTickType',...             '25   
'NoTickType',...             '26   
'News Story',...            '27
'NoTickType',...             '28   
'Bid Mkt Maker',...         '29
'Ask Mkt Maker',...         '30
'Bid Best',...              '31
'Ask Best',...              '32
'NoTickType',...             '33   
'NoTickType',...             '34   
'Bt Mid Price',...          '35
'NoTickType',...             '36   
'NoTickType',...             '37   
'NoTickType',...             '38   
'Bt LSE Last',...           '39
'NoTickType',...             '40   
'NoTickType',...             '41   
'NoTickType',...             '42   
'New Mkt Day',...           '43
'Cancel Correct',...        '44
'Open',...                  '45
'Bt Bid Recap',...          '46
'Bt Ask Recap',...          '47
'Mkt Indicator',...         '48
'Bt Mkt Turn',...           '49
'Volume Update',...         '50
'Bt Sec Bid',...            '51
'Bt Sec Ask',...            '52
'Yest Last Trade',...       '53
'NoTickType',...             '54   
'NoTickType',...             '55   
'NoTickType',...             '56   
'NoTickType',...             '57   
'NoTickType',...             '58   
'NoTickType',...             '59   
'NoTickType',...             '60   
'NoTickType',...             '61   
'NoTickType',...             '62   
'NoTickType',...             '63   
'NoTickType',...             '64   
'NoTickType',...             '65   
'Tick Num',...              '66
'NoTickType',...             '67   
'NoTickType',...             '68   
'NoTickType',...             '69   
'NoTickType',...             '70   
'NoTickType',...             '71   
'NoTickType',...             '72   
'NoTickType',...             '73   
'Bid Lift',...              '74
'Ask Lift',...              '75
};

%Get tick type strings from indices
s = ticktypes(x)';


function t = timestamp()
%TIMESTAMP Build time stamp for server messages.

t = [datestr(now,13)];


function updatestatus(obj,evd,frame)
%UPDATESTATUS Connection status and corresponding datasource fields

%Get ui data
ui = getappdata(frame,'uidata');

%Get connection status data
cval = get(ui.currentconnections,'Value');
cstr = get(ui.currentconnections,'String');
if isempty(cval) 
  set(ui.connectionstatus,'String','No Connection','Foregroundcolor',[1 0 0],'Fontweight','bold')
else
      
  %Get connection type
  ccon = cstr{min(cval)};
      
  %Get data selection uicontrol info
  cuval = get(ui.radio(1),'Value');
  trval = get(ui.radio(2),'Value');
  hival = get(ui.radio(3),'Value');
  
  switch ccon(1:3)
          
    case 'Blo' 
      
      i = find(ccon == '-');      
      connstr = {['Connected: ' ccon(1:i(1)-1)]};
      set([ui.datadatestring;ui.override;ui.radio';ui.intervalstring],'Enable','on')
      set([ui.radio(3);ui.fromdatestring;ui.todatestring;ui.periodstring],'Enable','on')
            
      %Set Default/All fields radio buttons
      if get(ui.radio(1),'Value')
        set(ui.radiofields,'Enable','on')
      else
        set(ui.radiofields,'Enable','off')
        set(ui.radiofields(1),'Value',0)
        set(ui.radiofields(2),'Value',1)
      end
          
      case {'IDC','Yah'}            %IDC, Yahoo connection
      
        set(ui.radiofields,'Enable','off')
        connstr = {['Connected: ' ccon(1:end)]};
        set(ui.radio(2),'Value',0,'Enable','off')
        set([ui.datadate;ui.datadatestring;ui.intervalstring;ui.interval;ui.override],'Enable','off')
        set([ui.radio(3);ui.fromdatestring;ui.todatestring;ui.periodstring],'Enable','on')
        if trval   %Select Fields if Intraday Ticks option was selected
          set(ui.radio(1),'Value',1)
          set(ui.fields,'Value',1)
          set(ui.radiofields,'Enable','on')
        end
          
      case 'Hyp'
          
        %Get table
        i = findstr(ccon,'-');
        connstr = {['Connected: ' ccon(1:end)]};
          
        %Disable everyone to start
        set([ui.radio';ui.datadate;ui.datadatestring;ui.interval;ui.fromdatestring;ui.todatestring;ui.fromdate;ui.todate;ui.periodstring;ui.period;ui.radiofields';ui.override;ui.intervalstring],'Enable','off')
        set(ui.radio,'Value',0)
          
        %Enable field selection radio buttons
        set(ui.radiofields,'Enable','off')
          
        %Update gui based on table
        switch ccon
            
          case 'Hyperfeed - History'
          
            set([ui.radio(3),ui.fromdatestring,ui.todatestring,ui.fromdate,ui.todate,ui.period,ui.periodstring],'Enable','on')
            set(ui.radio(3),'Value',1)
            set(ui.fields,'Max',1)
              
          case {'Hyperfeed - Price','Hyperfeed - Profile'}
              
            set(ui.radio(1),'Enable','on','Value',1)
            set(ui.fields,'Max',2)
          
        end
    end     
              
    set(ui.connectionstatus,'String',connstr,'Foregroundcolor',[0 .55 0],'Fontweight','bold')
      
    %If changing connection object, reset field list value to 1
    if strcmp(get(gcbo,'Tag'),'CurrentConnections')
      set(ui.fields,'Value',1)
    end
      
    %Show appropriate field list
    loadfields([],[],frame)
    global datafieldnames defaultfieldnames
    
    rstr = get(findobj(ui.radiofields,'Value',1),'String');
    switch rstr
      case 'Default Fields'
        set(ui.fields,'String',defaultfieldnames)
      case 'All Fields'
        set(ui.fields,'String',datafieldnames)
    end
       
    %Disable/Enable lookup
    switch ccon(1:3)
      case {'Hyp','Yah'}
        set(ui.lookup,'Enable','off')
      otherwise
        set(ui.lookup,'Enable','on')
    end
        
  end
    
  cleanupdialog(obj,evd,frame) 
