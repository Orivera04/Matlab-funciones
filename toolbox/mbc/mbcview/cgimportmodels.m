function objp = cgimportmodels(filenames)
%CGIMPORTMODELS  Import models from files.
%
%  CGIMPORTMODELS(filenames) loads the files specified in the cell array
%  filenames and displays a wizard dialog to to guide the user through the
%  process of connecting the models into cage objects.  A vector of
%  xregpoitners to cgmodexprs is returned.
%
%  CGIMPORTMODELS first prompts the user to select files using a file
%  chooser dialog.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $  $Date: 2004/04/04 03:36:51 $

if nargin==0
    filenames = {};
elseif ischar(filenames)
    filenames = {filenames};
end

% Initialise output data so that early returns work correctly
objp = null(xregpointer, 0);

% construct the file type specification struct-array
filetypes.funstr  = 'cgLoadMBCModel';
filetypes.fileType = 'MBC model';
filetypes.filterSpec = {'*.exm' 'MBC model (*.exm)'};
filetypes.nextfcn = [];
ext = cgtools.extensions;
filetypes = [filetypes ext.ModelImportFunctions];

if isempty(filenames)
    % Prompt the user for files
    filenames = i_prompt_for_files(filetypes,ext);
else
    % Check the existence of the specified files
    msg = {};
    for i=1:length(filenames)
        if ~exist(filenames{i},'file')
            msg = [msg; {['   ' filenames{i}]}];
        end
    end
    if ~isempty(msg)
        msg = [msg; {'The following files could not be found:'}];
        h = errordlg(msg,'Files Not Found','modal');
        waitfor(h);
        filenames = {};
    end
end

if isempty(filenames)
    return
end


types = i_IdentifyFileTypes(filenames,filetypes);
for i=1:length(types)
    if types(i)<0
        % these files were not identified
        types(i) = i_prompt_for_type(filenames{i},filetypes);
        if types(i)<0
            % Cancel
            break
        end
    end
end

if any(types<0)
    return
end

% Filter out "Skipped" files
filenames = filenames(types~=0);
types = types(types~=0);

% Load xregexportmodel objects
models  = i_LoadModels(filenames,types,filetypes);
if isempty(models)
    return
end

% call the model wizard
wizard_data.models = models;
wizard_data.modptr = []; % new models don't yet have pointers
[OK, out] = xregwizard([], 'Model Import Wizard',...
                                 {@cg_model_wizard 'cardtwo'},...
                                 wizard_data);
if ~OK
    return
end

newmodels = out.CageModels;
objp = null(xregpointer, size(newmodels));
for i =1:numel(newmodels)
    objp(i) = xregpointer(newmodels{i});
end


%%%%%%%%%%%%%%%%%%%%%%%
function filenames = i_prompt_for_files(filetypes,ext)

% store the current directory for the purposes
% of restoring it later
curdir = pwd;

% if there is a preferred directory for CAGE data files,
% change to it
AP = mbcprefs('mbc');
FileDefaults = getpref(AP,'PathDefaults');
if ~isempty(FileDefaults.cagedatafiles) ...
        && exist(FileDefaults.cagedatafiles,'dir')
    cd(FileDefaults.cagedatafiles);
end

% prompt the user for files
[filename, pathname] = uigetfile(vertcat(filetypes.filterSpec,...
                                        {'*.*' 'All files (*.*)'}),...
                                        'Select Model Files',...
                                        'MultiSelect','on');
% change back to the original directory.
cd(curdir)

if isnumeric(filename) && filename == 0
    % cancelled
    filenames = {};
elseif ischar(filename)
    filename = fullfile(pathname, filename);
    filenames = {filename};
else
    filenames = cell(size(filename));
    for i=1:length(filename)
        filenames{i} = fullfile(pathname,filename{i});
    end
end

%%%%%%%%%%%%%%%%%%%
function type = i_prompt_for_type(filename, allfiletypes)

fh = xregdialog('name','Select File Format', ...
    'resize', 'off');
xregcenterfigure(fh,[380 140]);
SC = xregGui.SystemColorsDbl;

text = xregGui.uicontrol('parent', fh,...
    'style','text',...
    'horizontalalignment','left',...
    'string',['The format of file "' filename '" could not be uniquely determined.  '...
    'Please select the file type.']);
cbtype = xregGui.uicontrol('parent', fh,...
    'style', 'popupmenu',...
    'string', {allfiletypes.fileType},...
    'background', SC.WINDOW_BG);
label =  xregGui.labelcontrol('parent', fh,...
    'LabelAlignment','left',...
    'LabelSizeMode','absolute', ...
    'ControlSizeMode','absolute',...
    'LabelSize',50, ...
    'ControlSize',200,...
    'string', 'Open as:', ...
    'control',cbtype);

okcancel = xregGui.buttonbar('parent',fh, ...
    'ButtonSpacing', 7, ...
    'ButtonWidth', 65, ...
    'ButtonNames',{'OK','Cancel','Skip'});
h = handle.listener(okcancel,'ButtonClick',{@i_hide_figure,fh});

layout = xreggridbaglayout(fh,...
    'dimension', [4 1],...
    'rowsizes', [40 22 -1 25] ,...
    'gapy', 7,...
    'gapx', 5,...
    'border',[7 7 7 10], ...
    'elements', {text label [] okcancel});

fh.LayoutManager = layout;
fh.showDialog(okcancel.buttons(1));

if okcancel.ClickIndex==1
    type = get(cbtype,'Value'); % OK
elseif okcancel.ClickIndex==3
    type = 0; % Skip
else
    type = -1; % Cancel, or dialog closed
end
delete(fh);

%%%%%%%%%%%%%%%%%%
function i_hide_figure(src,evt,fh)
set(fh,'visible','off');

%%%%%%%%%%%%%%%%%%%%
function filetypes = i_IdentifyFileTypes(filenames,allfiletypes)
% Given a list of filenames and a list of available filetypes,
% this function attempts to identify the type of each file.

nfiles = length(filenames);
filterSpecs = vertcat(allfiletypes.filterSpec);
filters = filterSpecs(:,1);
filetypes = zeros(1,nfiles);
for k = 1:nfiles
    filename = filenames{k};
    [p, n, ext] = fileparts(filename);

    found = i_FileTypeIndex(ext,filters);
    if isempty(found)
        % first error condition: no matches
        filetypes(k) = -1;
    elseif length(found)>1
        % second error condition: multiple matches
        filetypes(k) = -2;
    else
        filetypes(k) = found;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds the filename extension "ext" in a list  of filetype filters.
function found = i_FileTypeIndex(ext,filters)

% Search for *.ext followed by either a ; or end of string.
pattern = ['\*\' ext '(;|$)'];

matches = regexpi(filters, pattern, 'once');
found = find(~cellfun('isempty', matches));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function models = i_LoadModels(filenames,types,allfiletypes)

models = {};
failed = false(length(filenames),1);
errormsg = {'The following files have failed to load correctly:';''};

for i=1:length(filenames)
    ft = allfiletypes( types(i) );
    file = filenames{i};
    tempdata.filename = file;
    try
        % try the file-type specific import routine
        [OK, msg, tempdata] = feval(ft.funstr, file, tempdata);
        if (OK==0)
            failed(i) = true;
            [p, f, e] = fileparts(file);
            errormsg = [errormsg; ...
                {['   \bullet ' detex([f e])]; ['        ' detex(msg)];''}];
        else
            if isfield(ft,'nextfcn') && ~isempty(ft.nextfcn)
                tempdata.models = feval(ft.nextfcn, tempdata.models, file);
            end
            models = [models tempdata.models];
        end
    catch
        failed(i) = true;
        errormsg = [errormsg; ...
                {['   \bullet ' detex(file)]; 'Unknown error'; ''}];
    end
end

if any(failed)
    % The import routine failed - inform user which fiels had problems
    uiwait(warndlg(errormsg, 'Model Import Errors', ...
        struct('WindowStyle', 'modal', 'Interpreter', 'tex')));
end
