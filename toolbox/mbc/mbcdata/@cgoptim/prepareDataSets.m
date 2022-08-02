function OK = prepareDataSets(optim, guiflag)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.3 $    $Date: 2004/04/04 03:26:12 $

% cgoptim/prepareDataSets
% fixedvalueptrs = prepareDataSets(optim)
% adds the free variables, constraints, objectives, and variables needed to be 
% able to evaluate the constraints and objectives (fixed value ptrs) to the data sets
% sets the grid flags appropriately

OK = 1;
if nargin < 2
    guiflag = 0;
end

datasets = optim.oppoints; 
constraints = optim.constraints;
objectives = optim.objectiveFuncs;
objectivemodels = [];
for i =1:length(objectives)
    objectivemodels = [objectivemodels objectives(i).get('modptr')];
end
for i =1:length(constraints)
   if constraints(i).issum
      conpar = constraints(i).getparams;
      constraints(i) = conpar.modptr;
   end
end

freevar = optim.values;

% add the new factors to the data set
for i=1:length(datasets)    
    data = datasets(i).get('data');
    nrows = size(data,1);
    if ~isempty(data)
        % block the existing data in the data set 
        gridflags = datasets(i).get('grid_flag');
        gridflags(:) = 7;
        datasets(i).info = datasets(i).set('grid_flag', gridflags);
    end
    

    % add free variables to data set if they aren't there already (e.g. 
    % in an operating point dset)
    datasetptrs = datasets(i).get('ptrlist');
    myind = [];
    for j = 1:length(freevar)
        thisind = find(double(freevar(j)) == double(datasetptrs));
        if isempty(thisind)
            myind = [myind 0];
        else
            myind = [myind thisind(1)];
        end
    end
    addfreeind = find(myind == 0);
    if length(addfreeind > 0)
        addfreevar = freevar(addfreeind);
        addfreevardata = zeros(nrows, length(addfreevar));
        datasets(i).info = datasets(i).addfactor(addfreevar, addfreevardata);
    end

    %make a vector of constraint funcs & objectivemodels
    expressions = [objectivemodels constraints];
    
    [ok,all_need_ptrs] = check_eval(datasets(i).info, expressions);
    % get the fixed values ptrs - variables that are not free, not in the original data set
    % but needed for evaluation of the models
    tmp = [];
    if any(~ok)
        for count = find(~ok)
            tmp = [tmp all_need_ptrs{count}];
        end        
    end
    tmp = unique(tmp);
    [junk, ind] = setdiff(double(tmp), double(expressions));
    fixedvalueptrs{i} = tmp(ind);
    
    % add fixed values to the to the data set
    fixedvardata = zeros(nrows, length(fixedvalueptrs{i}));
    datasets(i).info = datasets(i).addfactor(fixedvalueptrs{i}, fixedvardata);

    
    % add all expressions to the data set
    ws = warning;
    warning('off');
    datasets(i).info = datasets(i).AddExpr(expressions);
    warning(ws);
  
    gridflags = datasets(i).get('grid_flag');
    % set the free variables to be gridded over (unless already blocked above)
    for j = 1:length(freevar)
        freevarind = datasets(i).getFactorIndex(freevar(j));
        if ~isequal(gridflags(freevarind),7)
            gridflags(freevarind) = 1; 
        end
    end
    
    datasets(i).info = datasets(i).set('grid_flag', gridflags);
   
end

% put the fixed value chosen into the datasets
for i =1:length(datasets)       
    fixedvalues = [];
    for j =1:length(fixedvalueptrs{i})
        fixedvalues = [fixedvalues fixedvalueptrs{i}(j).get('setpoint')];
    end
    
    if guiflag & length(fixedvalueptrs{i})>0
        if length(datasets)>1
            title = ['Set Constant Values in ' datasets(i).getname];
        else
            title = 'Set Constant Values';
        end
        [fixedvalues, OK] = i_guisetconstants(datasets(i), fixedvalueptrs{i}, fixedvalues, title);
        if ~OK
            return
        end
    end

    if length(fixedvalueptrs{i})>0
        i_setconstants(datasets(i), fixedvalueptrs{i}, fixedvalues); 
    end

    % grid and evaluate
    datasets(i).info = datasets(i).range_grid;
    datasets(i).info = datasets(i).eval_fill;
end


function i_setconstants(dataset, fixedvalueptrs, fixedvalues)

%set the fixed values in the data set to given fixedvalues
indices = dataset.getFactorIndex(fixedvalueptrs);
constants = dataset.get('constant');
constants(:,indices) = fixedvalues;
dataset.info = dataset.set('constant',constants);


function [fixedvalues, OK] = i_guisetconstants(dataset, fixedvalueptrs, fixedvalues, title);

% create the figure to display the xregoptmgr results
fsize= [300 (length(fixedvalueptrs)+1)*25+55];
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
p=xregpointer(fixedvalues);
lyt=i_createlyt(hFig, p, dataset,fixedvalueptrs);

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
helpbtn = cghelpbutton(hFig, 'CGOPTIMSETCONSTANTVALS', 'position', [0 0 65 25]);

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
   fixedvalues=p.info;
   OK=1;
case 'cancel'
   OK=0;
end
freeptr(p);
delete(hFig);
return

function lyt=i_createlyt(hFig, p, dataset,fixedvalueptrs);

% make the layout

ud.pointer = p;
fixedvalues = p.info; 
udh=xregGui.uicontrol(hFig,...
    'style', 'text',...
    'string', 'Please supply values for the following:',...
    'visible','off');

for i =1:length(fixedvalueptrs)
    edith{i}=xregGui.uicontrol('parent',hFig,...
        'style', 'edit',...
        'string', num2str(fixedvalues(i)), ...
        'Backgroundcolor','w',...
        'visible','off',...
        'callback',{@i_setConstant,udh,i},...
        'position',[1 1 50 20]);    
    labelcontrols{i} = xregGui.labelcontrol('parent',hFig,...
        'LabelSizeMode','absolute',...
        'LabelSize',100,...
        'ControlSize',50,...
        'visible','off',...
        'Control',edith{i},...
        'string', fixedvalueptrs(i).getname,...
        'border',[0 2 0 2]);
end

lyt = xreggridbaglayout(hFig, 'elements', {udh, labelcontrols{:}}, 'dimension', [length(fixedvalueptrs)+1 1]);
set(udh, 'userdata', ud);

function i_setConstant(h, junk, udh, i)

% edit box call back
ud=get(udh,'userdata');
p = ud.pointer;
fixedvalues = p.info;

value = str2num(get(h, 'string'));
if isempty(value) | isinf(value) | isnan(value) 
    % if there is a problem, set it back again
    set(h,'string', num2str(fixedvalues(i)));
else
    fixedvalues(i) = value;
    p.info = fixedvalues;
end
