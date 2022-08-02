function optim = cg_objectivegui(optim,index, pPROJ)
%CG_OBJECTIVEGUI Graphically edit an objective function
% 
%  OPTIM = CG_OBJECTIVEGUI(OPTIM, INDEX, PPROJ)
%
%  You should ensure that the project contains one or more model nodes
%  before calling this function.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.6.2 $    $Date: 2004/04/04 03:26:05 $


% Creation routine
fig=xregfigure('name','Objective Editor',...
    'WindowStyle', 'modal', ...
    'visible','off',...
    'closerequestfcn','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
xregcenterfigure(fig,[600 360]);
fig.minimumsize=[590 260];
opts=getobjectivetypes(optim);    % return list of objective options

% Create temporary objectives and pointers to them
ptr=[];
sw = get(optim.objectiveFuncs(index).info, 'canswitchminmax');
for n=1:length(opts)
    obj=feval(opts{n});
    obj = set(obj, 'canswitchminmax', sw);
    ptr=[ptr xregGui.RunTimePointer(obj)];
end
ud.objects=ptr;
ud.created=zeros(1,length(ptr));
infoptr=xregGui.RunTimePointer;
infoptr.LinkToObject(fig);

% String for drop down ctrl in upper layout
str={};
for n=1:length(ptr)
    str(n)={typename(ptr(n).info)};
end

% Find the selected objective, and find out what it currently is 
% Set the drop down ctrl in the upper layout to reflect this
startobj = optim.objectiveFuncs(index);
startobj = startobj.info;

% find the current one 
ind = find(strcmp(str,typename(startobj)));
ud.objects(ind).info = startobj;
ud.showing = 0;
ud.project = pPROJ;

tptxt=uicontrol('parent',fig,...
    'style','text',...
    'HorizontalAlignment','left',...
    'string','Objective type:');
ud.tppop=uicontrol('parent',fig,...
    'style','popup',...
    'BackGroundColor','w',...
    'string',str,...
    'value',ind, ...
    'callback',{@i_typeselect,infoptr, optim, index});
ud.descriptxt = axestext(fig,'verticalalignment','top');
ud.descripim = xregGui.axesimage('parent',fig);

% Create the buttons at the bottom of the dialog
okbut=uicontrol('parent',fig,...
    'style','push',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'');');
cancbut=uicontrol('parent',fig,...
    'style','push',...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'',''tag'',''cancel'');');
helpbtn=cghelpbutton(fig,'CGOBJECTIVEGUI');

% Upper Layout Manager
grd = xreggridbaglayout(fig,'packstatus', 'off', ...
    'dimension',[5 5],...
    'rowsizes',[10 3 15 2 10],...
    'colsizes',[85 -1 20 300 40],...
    'mergeblock',{[2 4],[2 2]},...
    'mergeblock',{[1 5],[4 4]},...
    'mergeblock',{[1 5],[5 5]},...
    'elements',{[],[],tptxt,[],[],...
        [],ud.tppop,[],[],[],...
        [],[],[],[],[],...
        ud.descriptxt,[],[],[],[],...
        ud.descripim});
frmtop=xregframetitlelayout(fig,'title','Available objectives',...
    'center',grd);

ud.crd=xregcardlayout(fig,'numcards',length(ud.objects));
frmmid=xregframetitlelayout(fig,'title','Objective options',...
    'center',ud.crd);

lyt=xreggridlayout(fig,'correctalg','on',...
    'dimension',[3 4],...
    'rowsizes',[66 -1 25], ...
    'colsizes', [-1 65 65 65], ...
    'gapx', 7, ...
    'gapy',10,...
    'border',[7 7 7 7],...
    'mergeblock', {[1 1], [1 4]}, ...
    'mergeblock', {[2 2], [1 4]}, ...
    'elements',{frmtop,frmmid,[], [], [], okbut, [], [], cancbut, [], [], helpbtn});

infoptr.info=ud;

fig.LayoutManager=lyt;
set(lyt,'packstatus','on');

% trigger creation of first options layout
i_typeselect(ud.tppop,[],infoptr, optim, index);


%%%%%%%%%%%%%% LAUNCH FIGURE %%%%%%%%%%%%%%%
set(fig,'visible','on');
goforclose=0;
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
            optim.objectiveFuncs(index).info= ud.objects(val).info;
            goforclose=1;
        else
            % reshow figure?
            h = errordlg(msg(:),'Objective Editor','modal');
            waitfor(h);
        end  
    else
        goforclose=1;  %cancel
    end
end
delete(fig);
return


%---------------------------------------------------------------------
function i_typeselect(src,evt,ptr, optim, index)
%---------------------------------------------------------------------
ud=ptr.info;
val=get(src,'value');
if val~=ud.showing
    fig=get(src,'parent');
    set(fig,'pointer','watch');
    set(ud.descriptxt,'string',texdescription(ud.objects(val).info));
    set(ud.descripim,'image',cgresload(largeicon(ud.objects(val).info),'bmp'));
    drawnow('expose');
    if ~ud.created(val)
        % create and attach layout
        lyt=propertypage(ud.objects(val).info,'create',fig,ud.objects(val), optim, ud.project);
        attach(ud.crd,lyt,val);
        set(ud.crd,'packstatus','on');
        ud.created(val)=1;
    end
    set(ud.crd,'currentcard',val);
    ud.showing = val;
    ptr.info = ud;
    set(fig,'pointer','arrow');
end