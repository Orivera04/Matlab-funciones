function varargout = mv_ncenter_selector(action,p)
% MV_NumParamSelector number of parameters selection gui
%
%Function to create figure window enabling user to select the number of parameters to use. 
%Input arguments are the action to underake and p a pointer to a
%modeldev object
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 08:02:08 $


switch lower(action)
case 'create'   
   % Create new figure window and populate plots
   varargout{1}= i_Create(p);
case 'update'
   % Contents of the model have been changed elsewhere so update plots
   % accordingly
   i_Update(m);
case 'btok'
   % The OK button on the figure window was pressed. Close figure and update
   % the model
   i_btOK;
case 'resize'
   % Window resize event. Need to repack layouts in the GUI
   i_resize;
end


function fH = i_Create(p)

% Is there an object with tag mv_ncenter_selector?
fH = mvf('mv_ncenter_selector');

if ~isempty(fH)
   % If there is then make that the active figure and return
   figure(fH)
   % What if it isn't a figure handle??
   return
end

scr = get(0,'screensize');

% Create the figure window in the correct place, with windows backgound color
fsize= [600 700];
fpos= [min([(scr(3)/2 - 100) (scr(4)/2-300)],scr(3:4)-fsize-[0 20]) fsize];


fH = figure('Name',['Number of Centers Selector'],...
   'position',fpos,...
   'menubar','none',...
   'numbertitle','off',...
   'IntegerHandle','off',...
   'HandleVisibility','callback',...
   'doublebuffer','on',...
   'Tag','mv_ncenter_selector',...
   'visible','off',...
   'color',get(0,'DefaultUIControlBackgroundColor'));

% Set the resize function before a legend is created 
set(fH,'resizefcn',{@i_resize, fH});

% Create OK and CANCEL buttons
btOK = uicontrol('Parent',fH,...
   'style','push',...
   'units','pixels',...
   'position',[0 0 65 25],...
   'string','OK',...
    'callback',{@i_btOK, fH});

btCANCEL = uicontrol('Parent',fH,...
   'style','push',...
   'units','pixels',...
   'position',[0 0 65 25],...
   'string','Cancel',...
   'callback',{@i_close, fH});

refitCHECK = uicontrol('Parent',fH,...
   'style','checkbox',...
   'String','Refit widths on close',...
   'enable','on');

botToolbar = xreggridlayout(fH,...
    'dimension',[1,4],...
    'elements',{refitCHECK,[],btOK,btCANCEL},...
    'correctalg','on',...
    'colsizes',[150,-1,90,90],...
    'gapx',7,...
    'border',[10 10 10 10]);

%btHELP = mv_helpbutton(fH,21);
%botToolbar2 = flowLayout(fH,'elements',{btHELP},...
 %  'orientation','left/center');
%botToolbar = layerlayout(fH,'elements',{botToolbar botToolbar2});

% Create the GUI layout frame
LayoutObj = ncenter_selector(fH,p);

%lx = BorderLayout(fH,'center',LayoutObj,'border',[5 10 5 5]);
gui = xregborderlayout(fH,'center',LayoutObj,'south',botToolbar,'innerborder',[10 45 10 10],'container',fH);

% User data for the figure ... gui needed for repack
ud.gui = gui;
%ud.Parent = gcbf;					% needed to make parent the active figure on close
ud.LayoutObj = LayoutObj;		% needed to update GUI plots and extract selected lambda etc.
ud.refit = refitCHECK;

set(gui,'packstatus','on');

% Attach user data to the figure
set(fH,'userdata',ud);

% Now that GUI is packed correctly the plotting can occur. If this happens before
% the packstatus command the legend in the GUI will be incorrectly drawn
UpdatePlots(LayoutObj);	

% And finally make GUI visible
set(fH,'vis','on');

function i_resize(src, event, fH)

%Get the user data and repack the GUI
pos=get(fH,'position');
minsz=[350 450];
if any(pos(3:4)<minsz);
   pos(3:4)= max(pos(3:4),minsz);
   scpos= get(0,'ScreenSize');
   minP= [0 80];
   red= find( (pos(1:2)+pos(3:4)+minP)>scpos(3:4) );
   pos(red)= scpos(red+2)-pos(red+2)-minP(red);
   set(fH,'position',pos);
end
ud = get(fH,'UserData');
repack(ud.gui);
PlaceLegend(ud.LayoutObj,fH);

function i_btOK(src, event, fH)

% Get the user data and from that the layout object
ud = get(fH,'UserData');
LayoutObj = ud.LayoutObj;

% Get the current value of lambda and a pointer to the model 
% from the layout object
ChosenNcenters = GetNcenters(LayoutObj);
p = GetPointer(LayoutObj);
m = p.model;
X = p.getdata('X');
Y = p.getdata('Y');
[x,y] = checkdata(m,X,Y);

allcenters = get(m,'centers');
incenters = allcenters(Terms(m),:);
maxncenters = size(incenters,1);
TermsIn = Terms(m);
indices = fliplr(find(TermsIn)');%terms in the model, listed in increasing order of importance
[m,OK] = stepwise(m,indices(1:maxncenters-ChosenNcenters));% take out the unneeded terms
if(get(ud.refit,'Value')==1)
    [m, cost ,OK] = cheapwidthopt(m,x,y);
else
    cost = calcGCV(m);
end
setFitOpt(m,'cost',log10(cost));

p.model(m);% update model
if OK
   S= stats(p.model,'summary',x,y);
   p.info= statistics(p.info,S);
   %if ~MD.Status | (nargin>1 & ChangeModel)
   p.info= status(p.info,1);
   %end
else
   chead= colhead(m);
   p.info = statistics(p.info,S);
   p.info= status(p.info,0);
end

% and update the view in the parent window
ViewNode(MBrowser);

% Close Box-Cox Figure
close(fH);

function i_Update(fH)

% Get the user data and from the Box-Cox layout object
ud = get(fH,'userdata');
LayoutObj = ud.LayoutObj;
% Redraw plots because data used for the model has changed
UpdatePlots(LayoutObj);

function i_close(src, event, fH)

close(fH);
