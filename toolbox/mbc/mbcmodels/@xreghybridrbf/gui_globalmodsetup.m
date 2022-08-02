function [mout,ok]=gui_globalmodsetup(m,action,varargin);
%GUI_GLOBALMODSETUP GUI for altering xreghybridrbf settings
%
%   [M,OK] = GUI_GLOBALMODSETUP(M) creates a blocking GUI for choosing the
%   subclass of linearmodel and altering its settings.  OK indicates
%   whether the user pressed 'OK' or 'Cancel'.
%
%   LYT = GUI_GLOBALMODSETUP(M,'layout',FIG,P) creates a layout in figure
%   FIG, using the dynamic copy of a model in P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:30:02 $

if nargin<2
    action = 'figure';
end

switch lower(action)
    case 'figure'
        [mout,ok] = i_createfig(m, varargin{:});
    case 'layout'
        mout = i_createlyt(varargin{:});
        ok = 1;
    case 'getclasslevel'
        mout = mfilename('class');
    case 'finalise'
        mout = m;
end



function [mout, ok] = i_createfig(m, varargin)
figh = xregdialog('name','Hybrid RBF Model Settings');
figh.MinimumSize = [450 290];
xregcenterfigure(figh, [500, 350]);

p = xregGui.RunTimePointer(m);
p.LinkToObject(figh);
lyt = i_createlyt(figh, p, varargin{:});

% Add ok, cancel
okbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','OK',...
    'callback','set(gcbf,''visible'', ''off'', ''tag'',''ok'');');
cancbtn = uicontrol('style','pushbutton',...
    'parent',figh,...
    'string','Cancel',...
    'callback','set(gcbf,''visible'', ''off'', ''tag'',''cancel'');');

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [2 3], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65], ...
    'gapx', 7, ...
    'gapy', 7, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 3]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn});

figh.LayoutManager = lyt;
set(lyt, 'packstatus', 'on', 'visible', 'on');
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg, 'ok')
    mout = p.info;
    ok = 1;
else
    mout = m;
    ok = 0;
end
delete(figh);




function lyt = i_createlyt(figh,p)
m = p.info;

% Whenever the pane is re-entered, grab the correct model information
m.rbfpart = copymodel(m,m.rbfpart);
m.linearmodpart = copymodel(m,m.linearmodpart);

% Pass status info into linearmodpart
status = get(m,'status');
m.linearmodpart = set(m.linearmodpart,'status', status(1:size(m.linearmodpart,1)));
m.linearmodpart = IncludeAll(m.linearmodpart);
m = IncludeAll(m);
p.info = m; % so that the model info in submodels is remembered

% set up the xregoptmgr if it doesn't already exist
if ~isa(getFitOpt(m),'xregoptmgr')
    val= 1;
    alg = @widthstep;
    m = set(m,'fitalg','hybridrbffit');
    [om,OK] = feval(alg,m);
    m = setFitOpt(m,om);
    p.info = m;
end

if ~isa(figh,'xregcontainer')
    ud.pointer = p;
    ud.figure = figh;
       
    pUD = xregGui.RunTimePointer;
    pUD.LinkToObject(figh);

    % set up the alternative algorithms
    ud.options = uicontrol('parent',figh, ...
        'style','pushbutton',...
        'string','Set Up...',...
        'visible', 'off', ...
        'callback', {@i_setupalg, pUD});
    ud.algLabel = xregGui.labelcontrol('Parent', figh, ...
        'string', sprintf('Fit algorithm:  %s', getname(getFitOpt(m))), ...
        'ControlSize', 65, ...
        'Visible', 'off', ...
        'LabelSizeMode', 'absolute', ...
        'LabelSize', 150, ...
        'Control', ud.options);

    % Create pointers to the submodels. Use runtimepointers as these will
    % be destroyed with the gui
    ud.rbfp = xregGui.RunTimePointer(m.rbfpart);
    ud.rbfp.LinkToObject(figh);
    ud.lmp = xregGui.RunTimePointer(m.linearmodpart);
    ud.lmp.LinkToObject(figh);

    ud.rbflyt = gui_globalmodsetup(m.rbfpart,'layout',figh,ud.rbfp, ...
        'callback', {@i_rbfmodelupdate, pUD}, ...
        'training', false, ...
        'visible','off', 'packstatus','off');
    ud.linmodlyt = gui_globalmodsetup(m.linearmodpart,'layout',figh,ud.lmp, ...
        'stepwise', false, ...
        'callback', {@i_linmodelupdate, pUD});

    t = xregtablayout2(figh, ...
        'packstatus', 'off', ...
        'NumCards',2, ...
        'visible', 'off', ...
        'innerborder', [10 10 10 10], ...
        'tablabels',{'Radial Basis Function Part','Linear Part'});
    attach(t, ud.rbflyt, 1);
    attach(t, ud.linmodlyt, 2);
    lyt = xreggridbaglayout(figh, ...
        'dimension', [2 1], ...
        'rowsizes', [25, -1], ...
        'gapy', 10, ...
        'elements', {ud.algLabel, t}, ...
        'userdata', pUD);
    
else
    lyt = figh;
    pUD = get(lyt, 'userdata');
    ud = pUD.info;
    m = p.info;

    ud.rbfp.info = m.rbfpart;
    ud.lmp.info = m.linearmodpart;
    
    % Update submodel layouts
    rbflyt = gui_globalmodsetup(m.rbfpart, 'layout', ud.rbflyt, ud.rbfp);
    linmodlyt = gui_globalmodsetup(m.linearmodpart, 'layout', ud.linmodlyt, ud.lmp);
    
    % Update algorithm label
    ud.algLabel.String = sprintf('Fit algorithm:  %s', getname(getFitOpt(m)));
    
    % Update with new pointer
    ud.pointer = p;
end

pUD.info = ud;



function i_setupalg(src, evt, pUD)
ud = pUD.info;
m = ud.pointer.info;
PR = xregGui.PointerRepository;
ptrID = PR.stackSetPointer(ud.figure, 'watch');
[om, OK] = gui_setup(getFitOpt(m),'figure', ...
    {'expanded',1, 'title', 'Hybrid RBF Options','topname', 'Width selection algorithm'}, ...
    m);
if OK
    m = setFitOpt(m,om);

    ud.algLabel.String = sprintf('Fit algorithm:  %s', getname(om));

    % If anything is changed in the xregoptmgr gui, then change the
    % fitalg to the non-linear rbffit rather than the simpler 'leastsq'
    m = set(m,'fitalg','hybridrbffit');
    ud.pointer.info = m;
end
PR.stackRemovePointer(ud.figure, ptrID);


function i_rbfmodelupdate(src, evt, pUD)
% Update model due to changes in sub-pane
ud = pUD.info;
m = ud.pointer.info;
m = set(m, 'rbfpart', ud.rbfp.info);
m = set(m, 'fitalg', 'hybridrbffit');
ud.pointer.info = m;


function i_linmodelupdate(src, evt, pUD)
% Update model due to changes in sub-pane
ud = pUD.info;
m = ud.pointer.info;
m = set(m,'linearmodpart', ud.lmp.info);

% Change the status in the xreghybridrbf
newlmstatus = get(get(m,'linearmodpart'),'status');
m = setstatus(m,1:length(newlmstatus),newlmstatus);

% Sets the termsout to just be those with status == 2
m = IncludeAll(m);

% if the xreglinear part changes, need to revert to non-linear fit
m = set(m,'fitalg','hybridrbffit');
ud.pointer.info = m;
