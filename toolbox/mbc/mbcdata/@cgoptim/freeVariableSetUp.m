function [optim, x0, OK] = freeVariableSetUp(optim, dialogflag, canspecifyvec);
%[optim, x0, OK] = freeVariableSetUp(optim, dialogflag);
% set up the lower bounds, upper bounds and initial values for the freevariables
% %Inputs:	Optim	:	Optimisation object
% 	     Dialogflag	:	0 or 1 depending on whether the user should enter the lower, upper and initial values through a gui dialog, or if these should be automatically set from the data dictionaty. 
% 			
% Outputs:	Optim	:	Updated optimisation object
% 	          x0	:	Double. Row vector of initial values for free variables

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.2 $    $Date: 2004/04/04 03:26:09 $ 

if nargin <2
    dialogflag = 0;
end
OK = 1;

freevar = optim.values;
% get the optimmanager
om = get(optim, 'om');


% %% JUST FOR VECTOR OF START POS TESTING 
% dialogflag = 0;

% set up starting values for the optimization from the data dictionary set point values
% set up upper and lower bounds for the optimization from the data dictionary ranges
x0 = [];lb = []; ub = [];
for i =1:length(freevar)
    x0 = [x0 freevar(i).get('setpoint')];
    range = freevar(i).get('range');
    lb = [lb range(1)];
    ub = [ub range(2)];
end
X = [lb; ub];
pOps = get(optim, 'oppoints');
opvals = get(optim, 'oppointvalues');
pOp = pOps(1);
nrows = pOp.get('numpoints');
x0 = repmat(x0, nrows, 1);

if dialogflag & length(freevar)>0
    title = 'Free Variable Set Up';
    [X, x0, OK] = i_guiFreeVariableSetUp(freevar, X, x0, title, pOps, canspecifyvec);
    if ~OK
        return
    end
end

% determine linear constraints on free variables
A = [];
B = [];
for i = 1:length(optim.constraints)
    if optim.constraints(i).islinear
        params = optim.constraints(i).getparams;
        A = [A; params.A];
        B = [B; params.b];
    end
end

om= setConstraints(om,X(1,:),X(2,:),A,B,[]);
optim.om = om;

%-----------------------------------------------------------------
function [X, x0, OK] = i_guiFreeVariableSetUp(freevar, X, x0, title, pOps, canspecifyvec)
%-----------------------------------------------------------------

% create the figure to display the xregoptmgr results
fsize= [450 (length(freevar)+1)*25+55];
xFig= xregfigure('Name',title,...
	'menubar','none',...
	'color',get(0,'defaultuicontrolBackgroundcolor'),...
	'NumberTitle','off',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'visible','off',...
   'units','pixels',...
   'tag','SetConstants');
% hFig is a udd, need a figure handle so use double
hFig = double(xFig);

set(hFig,'pointer','watch');

%center the figure
xregcenterfigure(hFig, fsize);

parentlyt = [];
infop(1)=xregpointer(X);
infop(2)=xregpointer(x0);

lyt=i_createlyt(hFig, infop, freevar, pOps, canspecifyvec);

set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
   'parent',hFig,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
   'parent',hFig,...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'');');
helpbtn = cghelpbutton(hFig, 'CGOPTIMSETFREERANGES');

flw=xregflowlayout(hFig,'orientation','right',...
   'gap',7,'elements',{helpbtn,cancbtn,okbtn},'border',[0 10 3 10]);

ud.brd=xregborderlayout(hFig,'center',lyt,'south',flw,...
   'innerborder',[10 45 10 10],'packstatus','off');

ud.figure=hFig;

% top level LayoutManager
xFig.LayoutManager = ud.brd;
set(ud.brd,'packstatus','on');
set(hFig,'visible','on','userdata',ud);
set(hFig,'pointer','arrow');

drawnow;
set(hFig,'windowstyle','modal');
waitfor(hFig,'tag');

tg=get(hFig,'tag'); 
switch lower(tg)
case 'ok'
   X=infop(1).info;
   x0 = infop(2).info;
   OK=1;
case 'cancel'
   OK=0;
end
freeptr(infop);
delete(hFig);
return

%-----------------------------------------------------------------
function lyt=i_createlyt(hFig, infop, freevar, pOps, canspecifyvec)
%-----------------------------------------------------------------

% make the layout

ud.pointer = infop;
X = infop(1).info;
x0 = infop(2).info;

udh=xregGui.uicontrol(hFig,...
    'style', 'text',...
    'string', 'Lower Bound:',...
    'visible','off');
texth1=xregGui.uicontrol(hFig,...
    'style', 'text',...
    'string', 'Upper Bound:',...
    'visible','off');
texth2=xregGui.uicontrol(hFig,...
    'style', 'text',...
    'string', 'Initial Value:',...
    'visible','off');

for j =1:length(freevar)
    lbedith{j}=xregGui.uicontrol('parent',hFig,...
        'style', 'edit',...
        'string', num2str(X(1,j)), ...
        'Backgroundcolor','w',...
        'visible','off',...
        'callback',{@i_setValue,udh,1,j},...
        'position',[1 1 50 20]);   
    ubedith{j}=xregGui.uicontrol('parent',hFig,...
        'style', 'edit',...
        'string', num2str(X(2,j)), ...
        'Backgroundcolor','w',...
        'visible','off',...
        'callback',{@i_setValue,udh,2,j},...
        'position',[1 1 50 20]);   
    x0edith{j} = xregGui.uicontrol('parent',hFig,...
        'style', 'edit',...
        'string', num2str(x0(1, j)), ...
        'Backgroundcolor','w',...
        'visible','off',...
        'callback',{@i_setValue,udh,3,j},...
        'position',[1 1 50 20]);   
    varnameh{j} = xregGui.uicontrol('parent',hFig,...
        'style', 'text',...
        'visible','off',...
        'string', freevar(j).getname);
     if canspecifyvec
        en = 'on';
     else
        en = 'off';
     end
    x0btn{j} = xregGui.uicontrol('parent',hFig,...
        'style', 'pushbutton',...
        'string','Vector', ...
        'position',[1 1 50 20], ...
        'enable', en, ...
        'callback', {@i_setVectorStartPt, infop(2), pOps, freevar(j).getname, j, x0edith{j}});   
    lytinit{j} = xreggridbaglayout(hFig, ...
                    'elements', {x0edith{j}, [], x0btn{j}}, ...
                    'dimension', [1 3], ...
                    'colratios', [0.5 0.1 0.4]);
end

grdelts = cell(length(freevar)+1, 5);
grdelts(2:length(freevar)+1, 1) = varnameh(:);
grdelts{1, 2} = udh;
grdelts(2:length(freevar)+1, 2) = lbedith(:);
grdelts{1, 3} = texth1;
grdelts(2:length(freevar)+1, 3) = ubedith(:);
grdelts{1, 5} = texth2;
grdelts(2:length(freevar)+1, 5) = lytinit(:);
lyt = xreggridbaglayout(hFig, 'elements', grdelts, ...
                              'dimension', [length(freevar)+1 5], ...
                              'colratios', [0.2 0.2 0.2 0.02 0.38]);
set(udh, 'userdata', ud);

%-----------------------------------------------------------------
function i_setValue(h, junk, udh, i,j)
%-----------------------------------------------------------------

% edit box call back
ud=get(udh,'userdata');
infop = ud.pointer;
X = infop(1).info;

value = str2num(get(h, 'string'));
if isempty(value) | isinf(value) | isnan(value) 
   % if there is a problem, set it back again
   set(h,'string', num2str(X(i,j)));
elseif i < 3
    % Ensure that lower bound < upper bound
    switch i
        case 1
            % Lower bound
            if value < X(2, j)
                X(i,j) = value;
            else
                set(h,'string', num2str(X(i,j)));
            end
        case 2
            % Upper bound
            if value > X(1, j)
                X(i, j) = value;
            else
                set(h,'string', num2str(X(i,j)));
            end
    end
   infop(1).info = X;
else
   x0 = infop(2).info;
   x0(:, j) = value;
   infop(2).info =x0;
end

%-----------------------------------------------------------------
function i_setVectorStartPt(src, evt, q, pOps, freevarname, freevarind, x0edith)
%-----------------------------------------------------------------

% Get current values of x0
x0 = q.info;

% create the figure to display the xregoptmgr results
fsize= [400 250];
title = 'Set Vector of Initial Values';
xFig= xregfigure('Name',title,...
	'menubar','none',...
	'color',get(0,'defaultuicontrolBackgroundcolor'),...
	'NumberTitle','off',...
   'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
   'visible','off',...
   'units','pixels');

% hFig is a udd, need a figure handle so use double
hFig = double(xFig);

%center the figure
xregcenterfigure(hFig, fsize);

% Create vector editor for start positions
% Currently assumes the primary data set is the first d/set
hd = cgoptimgui.vectorEditor('parent', hFig, 'vector', x0(:, freevarind),...
            'tablelabel', 'Initial Value', ...
            'Dataset', pOps(1));
headstr = ['Specify initial values for ', freevarname];
texth2=xregGui.uicontrol(hFig,...
    'style', 'text',...
    'string', headstr,...
    'visible','off', ...
    'horizontalalignment', 'left', ...
    'fontweight', 'bold');
lyt = xreggridbaglayout(hFig, 'elements', {texth2, hd}, ...
                              'dimension', [2 1], ...
                              'rowsizes', [20 -1]);

set(lyt,'visible','on');
% add ok, cancel
okbtn=uicontrol('style','pushbutton',...
   'parent',hFig,...
   'string','OK',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''ok'');');
cancbtn=uicontrol('style','pushbutton',...
   'parent',hFig,...
   'string','Cancel',...
   'position',[0 0 65 25],...
   'callback','set(gcbf,''tag'',''cancel'');');

flw=xregflowlayout(hFig,'orientation','right',...
   'gap',7,'elements',{cancbtn,okbtn},'border',[0 10 3 10]);

ud.brd=xregborderlayout(hFig,'center',lyt,'south',flw,...
   'innerborder',[10 45 10 10],'packstatus','off');

% top level LayoutManager
xFig.LayoutManager = ud.brd;
set(ud.brd,'packstatus','on');
set(hFig,'visible','on');
set(hFig,'windowstyle','modal');
goforclose = 0;
while ~goforclose
   waitfor(hFig,'tag');
   tg=get(hFig,'tag'); 
   switch lower(tg)
   case 'ok'
      % Write values to pointer
      x0 = q.info;
      x0(:, freevarind) = hd.Vector;
      q.info = x0;
      goforclose = 1;
      % Fill the x0 edit handle control
      set(x0edith, 'string', 'User vector');
   case 'cancel'
      goforclose = 1;
   end
end
delete(hFig);

