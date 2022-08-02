function OK = EXMdialog(mdev)
%MODELDEV/EXMdialog Export model to CAGE
%
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/04 03:31:41 $

OK= false;

% Get the base model out of this modeldev object, and count its inputs
mbase= model(mdev);
if isa(mbase,'localmod')
    mbase= peval('model',Parent(mdev));
end
num_inputs = nfactors(mbase);

% Get the current CAGE project, opening the CAGE browser if necessary.
cgb = cgbrowser;
proj = cgb.RootNode;
if isempty(proj)
    answer = questdlg(['The CAGE browser is not open.  It must be open before you can '...
               'export a model to it.  Open the CAGE browser now?'], 'Open CAGE Browser',...
               'Yes','No','Cancel','Yes');
    if strcmp(answer,'Yes')
        cage;
        cgb = cgbrowser;
        proj = cgb.RootNode;
    end
    if isempty(proj) % No, Cancel, failure to start CAGE browser
        return;
    end
end

% Get list of CAGE model nodes
cgnodes= proj.filterbytype(cgtypes.cgmodeltype);

% Identify CAGE model nodes which are instances of xregStatsModel and which have the
% right number of inputs.  These are the models which we have the option to replace.
cgok = false(size(cgnodes));
cgnames = cell(size(cgnodes));
for i=1:length(cgnodes)
    p= getdata(cgnodes{i});
    m= p.get('model');
    cgok(i)= strcmp( type(m) ,type(xregstatsmodel) ) && nfactors(m)==num_inputs;
    cgnames{i}= name(cgnodes{i});
end    

% Select just these models, and add the option to create a new one.
cgnames = cgnames(cgok);

% Find any existing model which has the same name as the one we are
% about to export.
mname = varname(mbase);
existing = find ( strcmp(mname, cgnames) ) ;
if isempty(existing)
    list_val = 1;
else
    list_val = existing;
end

f= xregfigure('name','Export to CAGE',...
    'windowstyle','modal',...
    'handlevisibility','on',...
    'closerequestFcn','set(gcf,''tag'',''Cancel'')',...
    'visible','off',...
    'tag','cgmodelinfo');
xregcenterfigure(f,[350 275]);

colours = xregGui.SystemColorsDbl;

create_edit = xreguicontrol(f,'style','edit',...
    'backgroundcolor',colours.WINDOW_BG,...
    'horizontalAlignment','left',...
    'string',mname);

create_text = xregGui.labelcontrol('parent',f,...
    'string','Name for new CAGE model:',...
    'LabelAlignment','left','gap',5,...
    'LabelSize',1,'ControlSize',1,...
    'LabelSizeMode','relative','ControlSizeMode','relative',...
    'control',create_edit);

create_rb = xreguicontrol(f,'style','radio',...
    'string','Create new CAGE model');

rep_rb = xreguicontrol(f,'style','radio',...
    'horizontalAlignment','left',...
    'string','Replace existing CAGE Model:');

rep_list = xreguicontrol(f,'style','listbox',...
    'tag','modellist',...
    'backgroundcolor',colours.WINDOW_BG,...
    'callback',{@i_listbox,cgnames,create_edit},...
    'value',list_val,...
    'string',cgnames);

set(rep_rb,'callback',{@i_radio_click,create_rb,rep_list,create_text});
set(create_rb,'callback',{@i_radio_click,rep_rb,create_text,rep_list});

buttons = xregGui.buttonbar('parent',f,'ButtonNames',{'OK','Cancel'});
handle.listener(buttons,'ButtonClick',@i_button_click);

elements = { create_rb  ;...
             create_text;...
             rep_rb     ;...
             rep_list   ;...
             buttons  };

lt = xreggridbaglayout(f,'dimension',[5 1],...
    'elements',elements,...
    'rowsizes',[ 22 22 22 -1 30 ],...
    'visible','on',...
    'packstatus','on',...
    'border',[5 5 5 5],...
    'gapx',5,'gapy',5);

f.LayoutManager = lt;

% enable and disable the appropriate controls
if isempty(existing)
    i_radio_click(create_rb,[],rep_rb,create_text,rep_list);
else
    i_radio_click(rep_rb,[],create_rb,rep_list,create_text);
end

if isempty(cgnames)
    set([rep_rb create_rb],'enable','off');
end

set(f,'visible','on')

waitfor(f,'tag');
if strcmp(get(f,'tag'),'OK')
    if get(create_rb,'value')
        model_name = get(create_edit,'string');
        replace = false;
    else
        model_name = cgnames{ get( rep_list, 'value' ) };
        replace = true;
    end
    try
        OK= Export2CAGE(mdev,proj,model_name,replace);
    catch
        errordlg(lasterr,'Export Error');
    end

    if OK
        ch= cgbrowser;
        ch.doDrawTree;
        ch.doDrawList;
    end
end

delete(f)

%%%%%%%%%%%%%%%%%%%
function i_listbox(list,evt,str,edit)
% Double click on list item closes dialog

val = get(list,'value');
set(edit,'string',str{val});
if strcmp(get(gcf,'SelectionType'),'open');
    set(gcbf,'tag','ok')
end


%%%%%%%%%%%%%%%%%%%%
function i_radio_click(rb1,evt,rb2,c1,c2)

set(rb1,'value',1);
set(rb2,'value',0);
set(c1,'enable','on');
set(c2,'enable','off');

%%%%%%%%%%%%%%%%%%%%
function i_button_click(src,evt)

if src.ClickIndex==1
    set(gcbf,'tag','OK');
else
    set(gcbf,'tag','Cancel');
end

