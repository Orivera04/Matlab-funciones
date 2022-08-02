function OK = EXMdialog(mdtp)
%MDEVTESTPLAN/EXMdialog  Export child models to CAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $

OK = false;
child_models = children(mdtp);

% filter for exportable models
models = [];
for i=1:length(child_models)
    if child_models(i).isa('mdev_local') | child_models(i).status
        models = [models child_models(i)];
    end
end

% stop now if no models can be exported
if isempty(models)
    errordlg('No valid models available to export','No Valid Models');
    return;
end

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

[cgnames , ncginputs] = i_get_cage_models(proj);

rep = zeros(size(models));
mnames = cell(size(models));
for i=1:length(models)
    mptr = models(i);
    mbase= mptr.model;
    if isa(mbase,'localmod')
        mbase= peval('model',mptr.Parent);
    end
    % get name and number of inputs for this model
    mnames{i} = varname(mbase);
    mninputs(i) = nfactors(mbase);
    % find the best replacement model
    rep(i) = i_get_best_replacement(mnames{i},cgnames(ncginputs==mninputs(i)));
end
    

f= xregfigure('name','Export to CAGE',...
    'windowstyle','modal',...
    'handlevisibility','on',...
    'closerequestFcn','set(gcf,''tag'',''Cancel'')',...
    'visible','off',...
    'tag','cgmodelinfo');
xregcenterfigure(f,[400 300]);

colours = xregGui.SystemColorsDbl;

label = xreguicontrol(f,'style','text',...
    'string','Export models to CAGE (double click on a line to change the setting)');

list = xreguicontrol(f,'style','listbox',...
    'tag','modellist',...
    'fontname','fixedwidth',...
    'backgroundcolor',colours.WINDOW_BG,...
    'callback',{@i_list_click},...
    'string', i_make_strings(mnames,rep,mnames),...
    'userdata',struct('mnames',{mnames},'mninputs',mninputs,'rep',rep,'newnames',{mnames},...
                      'cgnames',{cgnames},'ncginputs',ncginputs));

buttons = xregGui.buttonbar('parent',f,'ButtonNames',{'OK','Cancel'});
h = handle.listener(buttons,'ButtonClick',@i_button_click);

elements = { label ;...
             list  ;...
             buttons };

lt = xreggridbaglayout(f,'dimension',[3 1],...
    'elements',elements,...
    'rowsizes',[ 22 -1 25 ],...
    'visible','on',...
    'packstatus','on',...
    'border',[5 5 5 5],...
    'gapx',5,'gapy',5);

f.LayoutManager = lt;
f.Visible = 'on';

waitfor(f,'tag');
if strcmp(get(f,'tag'),'OK')
    s = get(list,'userdata');
    msg = [];
    refresh = false;
    for i=1:length(models)
        if s.rep(i)>=0
            try
                OK = false;
                OK = models(i).Export2CAGE(proj,s.newnames{i},s.rep(i)>0);
            end
            if ~OK
                msg = sprintf([ msg '\n  ' mnames{i} ': ' lasterr]);
            else
                refresh = true;
            end
        end
    end
    % Report an error if any failed
    if ~isempty(msg)
        errordlg(['Export failed for the following models: ' msg],...
                 'Export Error');
    end
    % Refresh if any succeeded
    if refresh
        ch = cgbrowser;
        ch.doDrawList;
    end
end

delete(f)

%%%%%%%%%%%%%%%%%%%%%%
function i_button_click(src,evt)

if src.ClickIndex==1
    set(gcbf,'tag','OK');
else
    set(gcbf,'tag','Cancel');
end

%%%%%%%%%%%%%%%%%%%%%%
function best_index = i_get_best_replacement(mname,cgnames)

best_index = find ( strcmp(mname,cgnames) );
if isempty(best_index)
    best_index = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%
function [names , ninputs] = i_get_cage_models(cgproj)

% Get list of CAGE model nodes
cgnodes = cgproj.filterbytype(cgtypes.cgmodeltype);
% Filter out those which are not instances of xregStatsModel
mok = false(size(cgnodes));
ninputs = zeros(size(cgnodes));
names = cell(size(cgnodes));
for i=1:length(cgnodes)
    p = getdata(cgnodes{i});
    m = p.get('model');
    ninputs(i) = nfactors(m);
    names{i} = name(cgnodes{i});
    mok(i) = strcmp( type(m) ,type(xregstatsmodel) );
end
ninputs = ninputs(mok);
names = names(mok);


%%%%%%%%%%%%%%%%%%%%%%
function str = i_make_strings(mnames,rep,newnames)
% Creates formatted strings suitable for using in
% a list control with a fixed width font

str1 = cell(size(mnames));
str2 = cell(size(mnames));
for i=1:length(mnames)
    if rep(i)==0
        str1{i} = 'Create';
        str2{i} = newnames{i};
    elseif rep(i)>0
        str1{i} = 'Replace';
        str2{i} = newnames{i};
    else
        str1{i} = 'Skip   ';
        str2{i} = '';
    end
end
str = i_column(mnames, 'Current Name');
str1 = i_column(str1,'Action');
str2 = i_column(str2,'CAGE Model Name');
str = strcat(str(:) ,         {'  |  '},...
             str1(:) ,         {'  |  '},...
             str2(:) );

%%%%%%%%%%%%%%%%%%%%
function column = i_column(entries,header)
% Utility function for the purposes of using an HG list control to display
% tabular data.
%   entries is a cell array of strings. New-lines are replaced with spaces.
%   header is a string
%   column is a cell array of strings ALL OF THE SAME LENGTH.
%     the first entry is the header, then a separator ('-----') and then
%     the entries, padded with trailing spaces to make them the same lengths
% Use a fixed width font and concatentate multiple columns to display the
% tabular data in a list control.

entries = strrep(entries,char(10),' '); % replace new-lines with spaces
column = [ { header ; '-' } ; entries(:) ];
column = i_equalise_lengths(column);
column{2} = strrep(column{2},' ','-');

%%%%%%%%%%%%%%%%%%%%%%%%
function c = i_equalise_lengths(s)
%  s is a cell array of strings of different lengths
%  c is a cell array of strings, all of the same length.
%  Shorter strings are padded with trailing spaces.
%  See CELLSTR.

s = char(s);

c = cell(size(s,1),1);
for i=1:size(s,1)
    c{i} = s(i,:);
end

%%%%%%%%%%%%%%%%%%%%%%%%%
function i_list_click(list,evt)

s = get(list,'userdata');
v = get(list,'value') - 2; % two header rows
p = get(list,'parent');

if v<1 | ~strcmp(get(p,'selectiontype'),'open')
    return;
end

mname = s.mnames{v};
mninputs = s.mninputs(v);

% select all CAGE models with the same number of inputs
cgind = find( s.ncginputs==mninputs );
cgnames = s.cgnames( cgind );
existing = find( s.rep(v)==cgind );

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
xregcenterfigure(f,[300 275],p);

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

ignore_rb = xreguicontrol(f,'style','radio',...
    'string','Do not export this model');

rep_rb = xreguicontrol(f,'style','radio',...
    'horizontalAlignment','left',...
    'string','Replace existing CAGE Model:');

rep_list = xreguicontrol(f,'style','listbox',...
    'tag','modellist',...
    'backgroundcolor',colours.WINDOW_BG,...
    'callback',{@i_listbox,cgnames,create_edit},...
    'value',list_val,...
    'string',cgnames);

rbs = [rep_rb,create_rb,ignore_rb];
controls = {rep_list,create_text};

set(rep_rb,'callback',{@i_radio_click,rbs,controls,1,{'on','off'}});
set(create_rb,'callback',{@i_radio_click,rbs,controls,2,{'off','on'}});
set(ignore_rb,'callback',{@i_radio_click,rbs,controls,3,{'off','off'}});

buttons = xregGui.buttonbar('parent',f,'ButtonNames',{'OK','Cancel'});
h = handle.listener(buttons,'ButtonClick',@i_button_click);

elements = { ignore_rb  ;...
             create_rb  ;...
             create_text;...
             rep_rb     ;...
             rep_list   ;...
             buttons    };

lt = xreggridbaglayout(f,'dimension',[6 1],...
    'elements',elements,...
    'rowsizes',[ 22 22 22 22 -1 25 ],...
    'visible','on',...
    'packstatus','on',...
    'border',[5 5 5 5],...
    'gapx',5,'gapy',5);

f.LayoutManager = lt;

% enable and disable the appropriate controls
if isempty(existing)
    i_radio_click([],[],rbs,controls,2,{'off','on'});
else
    i_radio_click([],[],rbs,controls,1,{'on','off'});
end

if isempty(cgnames)
    set(rep_rb,'enable','off');
end

set(f,'visible','on')

waitfor(f,'tag');
if strcmp(get(f,'tag'),'OK')
    val= get(rep_list,'value');
    if val>1
        old_name = cgnames{val};
    else
        old_name = [];
    end
    if get(create_rb,'value')
        s.newnames{v} = get(create_edit,'string');
        s.rep(v) = 0;
    elseif get(rep_rb,'value')
        r = get(rep_list,'value');
        s.newnames{v} = cgnames{r};
        s.rep(v) = cgind(r);
    else
        s.newnames{v} = '';
        s.rep(v) = -1;
    end
    set(list,'userdata',s,'string',i_make_strings(s.mnames,s.rep,s.newnames));
end

delete(f)

%%%%%%%%%%%%%%%%%%%
function i_listbox(list,evt,str,edit)
% Double click on list item closes dialog

val = get(list,'value');
set(edit,'string',str{val});
if strcmp(get(gcf,'SelectionType'),'open');
    set(gcbf,'tag','OK')
end


%%%%%%%%%%%%%%%%%%%%
function i_radio_click(src,evt,rbs,controls,index,states)

set(rbs,'value',0);
set(rbs(index),'value',1);
for i=1:length(controls)
    set(controls{i},'enable',states{i});
end

