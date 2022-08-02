function  optim =cg_constraintgui(optim,index)
%cg_constraintgui  Graphically edit a constraint
%
%  optim =cg_CONSTRAINTGUI(optim,INDEX)
%  INDEX	:	Index into the optim.constraints field to give the constraint to be edited

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.2 $    $Date: 2004/04/04 03:26:04 $


fig = xregfigure('name','Constraint Editor',...
    'WindowStyle', 'modal', ...
    'visible','off',...
    'closerequestfcn','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
xregcenterfigure(fig,[600 360]);
fig.minimumsize = [590 260];
opts = getconstrainttypes(optim);    % return list of constraint options
nf = length(optim.values);

% Should not offer the CAGE model and sum model options if there aren't 
% any models in the session
CGBH = cgbrowser;
proj = CGBH.RootNode;
allmodelnodes = filterbytype(proj.info,cgtypes.cgmodeltype);
if isempty(allmodelnodes)
   opts = opts(1:4);
else
   % Use all options
end

% need a dummy model to be able to call methods on the conXXX objects
ud.model = xregmodel('nfactors',length(optim.values));
if ~isempty(optim.values)
    rng = pveceval(optim.values, 'getrange');
    rng = cat(1, rng{:});
    ud.model = setcode(ud.model, rng, cell(size(rng,1),1), rng);
end

ptr = [];
for n = 1:length(opts)
    obj = feval(opts{n},length(optim.values),'model',ud.model);
    rng = nfactorsallowed(obj);
    if (nf>=rng(1)) && (nf<=rng(2))
        ptr = [ptr xregGui.RunTimePointer(obj)];
    end
end
ud.objects = ptr;
ud.created = zeros(1,length(ptr));
ud.showing = 0;
ud.Factors = pveceval(optim.values, 'getname');
infoptr = xregGui.RunTimePointer;
infoptr.LinkToObject(fig);

% Find the current constraint type
str = pveceval(ptr, 'typename');
startcon = optim.constraints(index);
startobj = startcon.get('conobj');
if ~isempty(startobj)
    ind = find(strcmp(str,typename(startobj)));
    ud.objects(ind).info=startobj;
else
    ind = 1;
end

tptxt = uicontrol('parent',fig,...
    'style','text',...
    'HorizontalAlignment','left',...
    'string','Constraint type:');
ud.tppop = uicontrol('parent',fig,...
    'style','popup',...
    'BackGroundColor','w',...
    'string',str,...
    'callback',{@i_typeselect,infoptr},...
    'value',ind);
ud.descriptxt = axestext(fig,'verticalalignment','top');
ud.descripim = xregGui.axesimage('parent',fig);

okbut = uicontrol('parent',fig,...
    'style','pushbutton',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'');');
cancbut = uicontrol('parent',fig,...
    'style','pushbutton',...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
helpbtn = cghelpbutton(fig,'CGCONSTRAINTGUI');

grd2 = xreggridbaglayout(fig,...
    'packstaus', 'off', ...
    'dimension',[5 5],...
    'rowsizes',[10 3 15 2 10],...
    'colsizes',[85 -1 20 330 40],...
    'mergeblock',{[2 4],[2 2]},...
    'mergeblock',{[1 5],[4 4]},...
    'mergeblock',{[1 5],[5 5]},...
    'elements',{[],[],tptxt,[],[],...
        [],ud.tppop,[],[],[],...
        [],[],[],[],[],...
        ud.descriptxt,[],[],[],[],...
        ud.descripim});
frmtop = xregframetitlelayout(fig,'title','Available constraints',...
    'center',grd2);
ud.crd = xregcardlayout(fig,'numcards',length(ud.objects));
frmmid = xregframetitlelayout(fig,'title','Constraint options',...
    'center',ud.crd);
lyt = xreggridlayout(fig,'correctalg','on',...
    'dimension',[3 4],...
    'colsizes', [-1 65 65 65], 'gapx', 7, ...
    'rowsizes',[66 -1 25],'gapy',10,...
    'border',[7 7 7 7],...
    'mergeblock', {[1 1], [1 4]}, ...
    'mergeblock', {[2 2], [1 4]}, ...
    'elements',{frmtop,frmmid,[],[],[],okbut,[],[],cancbut,[],[],helpbtn});

infoptr.info = ud;

fig.LayoutManager = lyt;
set(lyt,'packstatus','on');

% trigger creation of first options layout
i_typeselect(ud.tppop,[],infoptr);

set(fig,'visible','on');
goforclose = 0;
while ~goforclose
    set(fig,'tag','');
    waitfor(fig,'tag');
    % code blocks and waits here
    tg=get(fig,'tag');
    if strcmp(tg,'ok')
        ud=infoptr.info;
        val=ud.showing;
        % call finalise on this object
        lyt=getcard(ud.crd,val);
        [ok,msg]=propertypage(ud.objects(val).info,'finalise',lyt{1});
        if ok
            optim.constraints(index).info= optim.constraints(index).set('conobj',ud.objects(val).info);
            goforclose=1;
        else
            % reshow figure?
            h=errordlg(msg(:),'Constraint error','modal');
            waitfor(h);
        end  
    else
        goforclose=1;  %cancel
    end
end
delete(fig);
return


function i_typeselect(src,evt,ptr)
ud=ptr.info;
val=get(src,'value');
if val~=ud.showing
    fig=get(src,'parent');
    set(fig,'pointer','watch');
    set(ud.descriptxt,'string',texdescription(ud.objects(val).info));
    set(ud.descripim,'image',imread(largeicon(ud.objects(val).info),'bmp'));
    drawnow;
    if ~ud.created(val)
        % create and attach layout
        lyt=propertypage(ud.objects(val).info,'create',fig,ud.objects(val),ud.model,ud.Factors);
        attach(ud.crd,lyt,val);
        set(ud.crd,'packstatus','on');
        ud.created(val)=1;
    end
    set(ud.crd,'currentcard',val);
    ud.showing=val;
    ptr.info=ud;
    set(fig,'pointer','arrow');
end

return



