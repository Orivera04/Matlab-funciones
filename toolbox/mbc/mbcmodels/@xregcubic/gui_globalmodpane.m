function lyt = gui_globalmodpane(m,action,figh,p,varargin)
%GUI_GLOBALMODPANE  Create part of GUI for linear model settings
%
%  LYT=GUI_GLOBALMODPANE(M,'layout',FIG,P) creates a layout object with
%  callbacks defined for updating the model pointed to by P. FIG is the
%  figure to create it in.
%   
%  LYT=GUI_GLOBALMODPANE(M,'layout',FIG,P,'callback,CBSTR) attaches a
%  callback string, CBSTR, which is fired when the model definition is
%  changed. 
%
%  FIG may also be a current copy of a layout in which case this existing
%  layout will be used instead of creating a new one.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.4 $  $Date: 2004/02/09 07:45:23 $

switch lower(action)
    case 'layout'
        if isa(figh,'xregcontainer')
            % update layout with new model info
            i_updatepointer(figh,p);
        else
            cbstr='';
            if nargin>4
                for n = 1:2:length(varargin)
                    switch lower(varargin{n})
                        case 'callback'
                            cbstr = varargin{n+1};
                    end
                end
            end
            lyt = i_createlyt(figh,p,cbstr);
        end
end


function lyt = i_createlyt(figh,p,cbstr)

ud.callback = cbstr;
ud.pointer = p;
m = p.info;
nf = nfactors(m);
pUD = xregGui.RunTimePointer;
pUD.LinkToObject(figh);

ud.table=xregtable(figh,...
   'visible','off',...
   'cols.size',50,...
   'cols.spacing',5,...
   'frame.visible','off',...
   'frame.hborder',[0 0],...
   'frame.vborder',[0 0],...
   'cells.defaultinterruptible','off',...
   'cells.colselection',[2 2],...
   'cells.rowselection',[2 nf+1],...
   'cells.type','uiedit',...
   'cells.backgroundcolor',[1 1 1],...
   'cells.format','%1.0f',...
   'cells.value',get(m,'order'),...
   'rows.fixed',1,...
   'cols.fixed',1,...
   'zeroindex',[2 2],...
   'cells.rowselection',[1 1],...
   'cells.colselection',[1 2],...
   'cells.type','text',...
   'cells.string',{'Symbol','Order'},...
   'cells.rowselection',[2 nf+1],...
   'cells.colselection',[1 1],...
   'cells.type','text',...
   'cells.string',detex(get(m,'symbol')),...
   'position',[0 0 130 50],...
   'cellchangedcallback',{@i_ordchange, pUD});
tablePanel = xregpanellayout(figh, ...
    'visible', 'off', ...
    'packstatus', 'off', ...
    'innerborder',[0 0 0 0], ...
    'center',ud.table);

if nf>1
    ud.MaxInt = xregGui.clickedit('Parent', figh, ...
        'visible', 'off', ...
        'rule', 'int', ...
        'min', 0, ...
        'max', get(m, 'maxallowedinteract'), ...
        'dragging', 'off', ...
        'Value', get(m, 'maxinteract'), ...
        'callback', {@i_interact, pUD});
    ud.MaxIntLabel = xregGui.labelcontrol('Parent', figh, ...
        'visible', 'off', ...
        'String', 'Interaction order:', ...
        'ControlSize', 60, ...
        'LabelSize', 90, ...
        'LabelSizeMode', 'absolute', ...
        'Control', ud.MaxInt);
    milyt = ud.MaxIntLabel;
else
    milyt=[];
end

ud.Tgt = uicontrol('parent',figh, ...
    'visible', 'off',...
    'style', 'checkbox',...
    'String', 'Transform input range to [-1, 1]', ...
    'callback', {@i_ChgCoding, pUD}, ...
    'value', isequal(recommendedTgt(m),[-1 1]));


lyt= xreggridbaglayout(figh,...
    'dimension',[3 1],...
    'gapy',10,...
    'rowsizes',[-1 20 20],...    
    'elements',{tablePanel,milyt,ud.Tgt},...
    'userdata', pUD);

pUD.info = ud;



function i_updatepointer(lyt, p)
pUD = get(lyt,'userdata');
ud = pUD.info;
m = p.info;
ud.pointer = p;

ud.table(:,0).string = detex(get(m,'symbol'));
ud.table(:,1).value = get(m,'order');

if nfactors(m)>1
    set(ud.MaxInt,'max', get(m, 'maxallowedinteract'), ...
        'value',get(m, 'maxinteract'));
end
set(ud.Tgt,'value',isequal(recommendedTgt(m),[-1 1]));

pUD.info = ud;



function i_ordchange(src, evt, pUD)
ud = pUD.info;
m = ud.pointer.info;
% gather new order's together and check them for ok values
ord = ud.table(:,1);
bad = (ord<0 | ord~=round(ord));
if any(bad)
   % replace bad value with old one
   oldord = get(m,'order');
   ord(bad) = oldord(bad);
   ud.table(:,1).value = ord;
else
    m = set(m,'order',ord);
    ud.pointer.info = m;
    
    % Check whether current interaction value needs changing
    if nfactors(m)>1
        if get(m, 'MaxInteract')>get(m, 'maxallowedinteract')
            m = set(m, 'maxinteract', get(m, 'maxallowedinteract'));
        end
        set(ud.MaxInt, 'max', get(m, 'maxallowedinteract'), ...
            'value', get(m, 'MaxInteract'));
    end

    ud.pointer.info = m;
    if ~isempty(ud.callback)
        i_firecb(ud.callback,ud.pointer);
    end
end


function i_interact(src, evt, pUD)
ud = pUD.info;
m = ud.pointer.info;
mint = get(ud.MaxInt,'value');

m = set(m,'maxinteract',mint);
ud.pointer.info = m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_ChgCoding(src, evt, pUD)
ud = pUD.info;
m = ud.pointer.info;
if isequal(recommendedTgt(m),[-1 1])
    % toggle to uncoded poly
    m = xreguncodedpoly(m);
else
    % xregcubic uses [-1 1] coding 
    m = xregcubic(m);
end
ud.pointer.info= m;
if ~isempty(ud.callback)
    i_firecb(ud.callback,ud.pointer);
end


function i_firecb(cbstr,ptr)
xregcallback(cbstr, [], struct('ModelPointer', ptr))
