function View = modeldisplay(node,action,fH,View)
%MODELDISPLAY  Create and update 2d/3d plots of model
%
%  VIEW = MODELDISPLAY(NODE,ACTION,FIG,VIEW)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:24:29 $


switch lower(action)
    case 'create'
        View = i_create(node,fH,View);
    case 'show'
        View = i_show(node,fH,View);
    case 'view'
        View = i_view(node,fH,View);
end


%----------------------------------------------
function d = i_create(node,fH,d)

d.Handles.MessageID =[];
d.GUIstate=0;  % 0/1/... => 0, 1 or >1 popups available for factors

d.Handles.Axes3D = xregaxes('units' , 'pixels' , ...
    'parent' , fH , ...
    'color' , [1 1 1] , ...
    'box' , 'on',...
    'visible','off',...
    'cameratarget',[.5 .5 .5],...
    'cameraposition',[.5 .5 10],...
    'cameraupvector',[0 1 0]);
set(d.Handles.Axes3D, 'view',[-37.5 30]);
set(get(d.Handles.Axes3D,'xlabel'),'interpreter','none');
set(get(d.Handles.Axes3D,'ylabel'),'interpreter','none');
mv_rotate3d(d.Handles.Axes3D,'ON');
d.Handles.Axes2D = xregaxes('units' , 'pixels' , ...
    'parent' , fH , ...
    'color' , [1 1 1] , ...
    'box' , 'on',...
    'visible','off');
set(get(d.Handles.Axes2D,'xlabel'),'interpreter','none');
set(get(d.Handles.Axes2D,'ylabel'),'interpreter','none');
d.Handles.surface= handle(surface('parent',d.Handles.Axes3D,...
    'visible','off',...
    'facelighting','gouraud',...
    'facecolor','interp',...
    'edgecolor','none',...
    'xdata',[],...
    'ydata',[],...
    'zdata',[],...
    'cdata',[]));
d.Handles.line= handle(line('parent',d.Handles.Axes2D,...
    'visible','off',...
    'xdata',[],...
    'ydata',[],...
    'zdata',[]));
d.Handles.light=handle(light('parent',d.Handles.Axes3D,...
    'visible','off'));
camlight(d.Handles.light,'headlight'); 

d.Handles.text(1)=xreguicontrol(fH,'style','text',...
    'position',[0 0 90 15],...
    'string','X-axis factor:',...
    'visible','off',...
    'userdata',{},...
    'enable','inactive');
d.Handles.factor(1) = xreguicontrol(fH,'style','popupmenu',...
    'string',' ',...
    'backgroundcolor','w',...
    'visible','off',...
    'value',1,...
    'tag','1',...
    'callback',{@i_FactorChange,1});
d.Handles.text(2)=xreguicontrol(fH,'style','text',...
    'position',[0 0 90 15],...
    'string','Y-axis factor:',...
    'visible','off',...
    'userdata',{},...
    'enable','inactive');
d.Handles.factor(2) = xreguicontrol(fH,'style','popupmenu',...
    'string',' ',...
    'backgroundcolor','w',...
    'visible','off',...
    'value',1,...
    'tag','2',...
    'callback',{@i_FactorChange,2});

d.Handles.axesPane = xregcardlayout(fH, ...
    'packstatus', 'off', ...
    'visible','off', ...
    'numcards', 3, ...
    'border', [50 40 30 10]); 
attach(d.Handles.axesPane,axiswrapper(d.Handles.Axes2D),1);
attach(d.Handles.axesPane,axiswrapper(d.Handles.Axes3D),2);

d.Handles.plotLYT=xreggridbaglayout(fH,'dimension',[4 5],...
    'visible','off',...
    'rowsizes',[-1 15 3 22],...
    'colsizes',[-1 90 20 90 -1 22],...
    'border',[10 10 10 10],...
    'mergeblock',{[1 1],[1 5]},...
    'elements',{d.Handles.axesPane,[],[],[],[];...
        [],d.Handles.text(1),[],d.Handles.text(2),[];...
        [],[],[],[],[];...
        [],d.Handles.factor(1),[],d.Handles.factor(2),[]});





function View = i_show(node,cgH,View)

cgmod = getdata(node);

if cgmod.isSwitchExpr;
    pInputs = null(xregpointer, 0);
    n = 0;
    s = {};
else
    pInputs = cgmod.getinports;
    n = cgnumindependentvars(pInputs);
    s = pveceval(pInputs, 'getname');
end

% enable/disable the factor pop-ups
switch n
    case 0
        set([View.Handles.factor(1); View.Handles.text(1); View.Handles.factor(2); View.Handles.text(2)],...
            {'enable'},{'off';'off';'off';'off'});
        set(View.Handles.factor(:),'string',{''},'value',1);
        set(View.Handles.axesPane,'currentcard',3);
    case 1
        set([View.Handles.factor(1); View.Handles.text(1); View.Handles.factor(2); View.Handles.text(2)],...
            {'enable'},{'on';'on';'off';'off'}); 
        set(View.Handles.factor(:),{'string'},{s; {''}},'value',1);
        set(View.Handles.axesPane,'currentcard',1);
    otherwise
        set([View.Handles.factor(1); View.Handles.text(1); View.Handles.factor(2); View.Handles.text(2)],...
            {'enable'},{'on';'on';'on';'on'});
        
        if ~cgisindependentvars(pInputs(1), pInputs(2))
            popval = 3;
        else
            popval = 2;
        end
        set(View.Handles.factor(:),'string',s,{'value'},{1; popval});
        set(View.Handles.axesPane,'currentcard',2);
end

View.GUIstate = n;

% set figure colormap
set(cgH.Figure,'Colormap',hot(64));



function View = i_view(node,cgH,View)

cgmod=getdata(node);
pInput = cgmod.getinports;

PlotStyle = min(View.GUIstate,2);
if PlotStyle == 0
    % no plots available
    if cgmod.isSwitchExpr
        View.Handles.MessageID = cgH.addStatusMsg('Cannot display output: unable to display switching models');
    else
        View.Handles.MessageID = cgH.addStatusMsg('Cannot display output: all the model inputs are constant');
    end
else
    popvals = get(View.Handles.factor, {'value'});
    popvals = [popvals{:}];
    popvals = popvals(1:PlotStyle);
    popstr = get(View.Handles.factor(1),'string');
    
    pGrid = pInput(popvals);
    pScalar = pInput(cgisindependentvars(pInput, pGrid));
    pveceval(pGrid, 'linspace', 21);
    pveceval(pScalar, 'setpoint');
    gridrange = pveceval(pGrid, 'getrange');
    
    % evaluate the model
    data = cgmod.evaluategrid(pGrid);
    if numel(data) == 1
        if isnan(data)
            View.Handles.MessageID = cgH.addStatusMsg('Cannot display output: the model returns NaN');  
        else
            View.Handles.MessageID = cgH.addStatusMsg('Cannot display output: all the model inputs are constant');
        end
        PlotStyle = 0;
    elseif all(~isfinite(data(:)))
        View.Handles.MessageID = cgH.addStatusMsg('Cannot display output: the model returns non-finite values'); 
        PlotStyle = 0;
    end 
    % convert all non-finite to NaN - avoids troubles with rotating inf graphs
    data(~isfinite(data)) = NaN;
    % deal with complex data
    data(imag(data)~=0) = NaN;
end

switch PlotStyle
    case 0
        % blank axes
    case 1
        % 2D plot
        xl = gridrange{1};
        yl = [min(data(:)) max(data(:))];
        if any(isnan(xl))
            xl=[0 1];
        end
        if any(isnan(yl))
            yl=[0 1];
        end  
        if ~diff(xl)
            xl=xl+[-1 1];
        end
        if ~diff(yl)
            yl=yl+[-1 1];
        end
        set(View.Handles.line,'xdata',pGrid(1).getvalue,...
            'ydata',data);
        mbcxlabel(View.Handles.Axes3D, popstr{popvals(1)});
        set(View.Handles.Axes2D,'xlim',xl,'ylim',yl);
    case 2
        % 3D plot
        [X,Y] = ndgrid(pGrid(1).getvalue, pGrid(2).getvalue);
        
        xl = gridrange{1};
        yl = gridrange{2};
        zl = [min(data(:)) max(data(:))];
        if any(isnan(xl))
            xl=[0 1];
        end
        if any(isnan(yl))
            yl=[0 1];
        end
        if any(isnan(zl))| all(isinf(zl))
            zl=[0 1];
        end
        if ~diff(xl)
            xl=xl+[-1 1];
        end
        if ~diff(yl)
            yl=yl+[-1 1];
        end
        if ~diff(zl) 
            zl=zl+[-1 1];
        end
        set(View.Handles.surface,'xdata',X,...
            'ydata',Y,...
            'zdata',data,...
            'cdata',data);
        mbcxlabel(View.Handles.Axes3D, popstr{popvals(1)});
        mbcylabel(View.Handles.Axes3D, popstr{popvals(2)});
        set(View.Handles.Axes3D,'xlim',xl,...
            'ylim',yl,...
            'zlim',zl);
end

if View.GUIstate
    % Set all inputs to nominal values
    pveceval(pGrid, 'setpoint');
end



%-------------------------------------------------------------------------
% Callback from the popupmenus on the axes which allow you to change the
% inputs against which the model is plotted.
function i_FactorChange(src,evt,factor_index)
CGBH = cgbrowser;
d = CGBH.getViewData;
M = CGBH.CurrentNode.getdata;

if d.GUIstate >1
    f1 = d.Handles.factor(1); % shorthands
    f2 = d.Handles.factor(2);
    pInputs = M.getinports;
    
    xfactor = get(f1,'value');
    yfactor = get(f2,'value');
    
    if (xfactor==yfactor) || ~cgisindependentvars(pInputs(xfactor), pInputs(yfactor));
        if factor_index==1 % we are changing the first factor
            newsetting = i_findfirstunlinkedvar(pInputs, pInputs(xfactor));
            set(f2, 'value', newsetting);
        else % we are changing the second factor
            newsetting = i_findfirstunlinkedvar(pInputs, pInputs(yfactor));
            set(f1, 'value', newsetting);
        end
    end
end

d = modeldisplay(CGBH.CurrentNode.info,'view',CGBH,d);


function newvarindex = i_findfirstunlinkedvar(allvars, takenvar)

allowed = find(cgisindependentvars(allvars, takenvar));
if ~isempty(allowed)
    newvarindex = allowed(1);
else
    newvarindex = [];
end