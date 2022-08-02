function xreg_ExportTool(varargin)
%XREG_EXPORTTOOL Dialog for exporting models to workspace/file/simulink
%
%  XREG_EXPORTTOOL(P, VIEW)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.13.4.6 $  $Date: 2004/04/20 23:19:04 $

i_Create(varargin{:});
i_Init(varargin{:});


%------------------------------------------------------
% SUBFUNCTION  i_Create
%------------------------------------------------------
function i_Create(p,view)
% draws a figure, the controls and puts them in layouts.
% no data entered into the various controls - done by i_Init

% create the figure
hMain=xregfigure('name','Export Model',...
	'tag','expmodel',...
	'visible','off',...
	'windowstyle','modal');

hFig = double(hMain);
xregcenterfigure(hFig,[500,520]);
xregpersistfigpos(hMain);
% make sure it's left on screen
xregmoveonscreen(hMain);

% set up the layouts
mainLyt = xreggridlayout(hFig,...
	'visible','off',...
	'packstatus', 'off',...
	'container',hFig);

hMain.LayoutManager = mainLyt;
hMain.minimumSize = [420 500];
% north is file location
% center is export options grid
% south is notes
%  deep south is ok/cancel buttons


%----- destination/directory controls -----
txtDest = xreguicontrol(hFig,...
	'visible','off',...
	'style','text',...
	'horizontalalignment','left',...
	'string','Export to: ');
if get(cgbrowser,'GUIExists')
    dst= {'Workspace','File','Simulink','CAGE'};
else
    dst= {'Workspace','File','Simulink'};
end    

hnd.destination = xreguicontrol(hFig,...
	'visible','off',...
	'style','popupmenu',...
	'backgroundcolor','w',...
	'callback', {@i_chooseDestination},...
	'string',dst);

fileGrid = xreggridlayout(hFig,...
	'visible','off',...
	'correctalg','on',...
	'dimension',[1,2],...
	'gapx',10,...
	'elements',{txtDest, hnd.destination},...
	'colsizes',[90, -1],...
	'border',[10, 0, 10, 0]);

%----- model export options -----

hnd.txtFile = xreguicontrol(hFig,...
	'visible','off',...
	'style','text',...
	'horizontalalignment','left',...
	'string','Destination file: ');
hnd.fileLoc = xreguicontrol(hFig,...
	'visible','off',...
	'style','edit',...
	'enable','on',...
	'horizontalalignment','left',...
	'backgroundcolor','w',...
	'callback',{@i_editFileName},...
	'string',pwd);
hnd.changeLocButton = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'string','...',...
	'callback',{@i_chooseLocation});

% model name edit
txtModel = xreguicontrol(hFig,...
	'visible','off',...
	'style','text',...
	'string','Export as: ',...
	'horizontalalignment','left');
hnd.modelName = xreguicontrol(hFig,...
	'visible','off',...
	'style','edit',...
	'horizontalalignment','left',...
	'backgroundcolor','w',...
	'callback',{@i_ModelName},...
	'string','<empty>');

hnd.changeUnitsButton = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'string','...',...
	'fontweight','demi');

% export options global/datum/pev/constraints/units
hnd.globalModels = xreguicontrol(hFig,...
	'visible','off',...
	'style','check',...
	'string','Export global models');
hnd.localModels = xreguicontrol(hFig,...
	'visible','off',...
	'style','check',...
	'string','Export all local models');
hnd.datumModel = xreguicontrol(hFig,...
	'visible','off',...
	'style','check',...
	'string','Export datum models');
hnd.pev = xreguicontrol(hFig,...
	'visible','off',...
	'style','check',...
	'string','Export PEV blocks');
hnd.constraints = xreguicontrol(hFig,...
	'visible','off',...
	'style','check',...
	'string','Export constraints');


% trade-off export of local models - only available at testplan node
hnd.toTradeOffButton = xreguicontrol(hFig,...
	'visible','off',...
	'string','Tradeoff...',...
	'callback',{@i_ToTradeOff, p});


% have a look at what you've got
toExportButton = xreguicontrol(hFig,...
	'visible','off',...
	'string','Export Preview',...
	'callback',{@i_CreateExportList},...
	'fontweight','normal');

modelOptionsGrid = xreggridbaglayout(hFig,...
    'visible','off',...
    'correctalg','on',...
    'dimension',[8,7],...
    'rowsizes',[20,20,20,20,20,20,-1,25],...
    'colsizes',[10,80,100,30,-1,60,25],...
    'elements',{...
        hnd.txtFile,txtModel,[],[],[],[],[],[],...
        [],[],[],[],[],[],[],hnd.toTradeOffButton,...
        hnd.fileLoc,hnd.modelName,[],[],[],[],[],[],...
        [],[],[],[],[],[],[],[],...
        [],hnd.globalModels,hnd.localModels,hnd.datumModel,hnd.pev,hnd.constraints,[],[],...
        [],[],[],[],[],[],[],toExportButton,...
        hnd.changeLocButton,[],[],[],[],[],[],[]},...
    'mergeblock',{[1 1],[3 6]},...
    'mergeblock',{[1 1],[1 2]},...
    'mergeblock',{[2 2],[1 2]},...
    'mergeblock',{[2 2],[5 7]},...
    'mergeblock',{[3 3],[5 7]},...
    'mergeblock',{[4 4],[5 7]},...
    'mergeblock',{[5 5],[5 7]},...
    'mergeblock',{[6 6],[5 7]},...
    'mergeblock',{[8 8],[6 7]},...
    'gapx',10,...
    'gapy',5);


OptionsFrame = xregframetitlelayout(hFig,...
	'title','Export options',...
	'innerborder',[20, 10, 10, 10],...
	'center', modelOptionsGrid);

% Notes field
hnd.notes = xreguicontrol(hFig,...
	'visible','off',...
	'style','listbox',...
	'callback',{@i_NotesSelected},...
	'string','<empty>');

hnd.addNotes = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'callback',{@i_CreateInfoGui},...
	'string','Add...');
hnd.editNotes = xreguicontrol(hFig,...
	'visible','off',...
	'callback',{@i_CreateInfoGui},...
	'style','push',...
	'string','Edit...');
hnd.deleteNotes = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'callback',{@i_Delete},...
	'string','Delete');
notesButtonsGrid = xreggridlayout(hFig,...
	'visible','off',...
	'correctalg','on',...
	'dimension', [5, 1],...
	'elements', {[], hnd.addNotes, hnd.editNotes, hnd.deleteNotes, []},...
	'rowsizes', [-1, 25, 25, 25,-1],...
	'gapy', 10);

notesGrid = xreggridlayout(hFig,...
	'visible','off',...
	'dimension', [1, 3],...
	'correctalg','on',...
	'elements', {hnd.notes, [], notesButtonsGrid},...
	'colsizes',[-1, 40, 65]);

NotesFrame = xregframetitlelayout(hFig,...
	'title','Export information',...
	'innerborder',[20, 10, 10, 10],...
	'center', notesGrid);

% okay cancel help buttons
hnd.ok = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'string','OK');
hnd.cancel = xreguicontrol(hFig,...
	'visible','off',...
	'style','push',...
	'callback',{@i_Cancel, hMain},...
	'string','Cancel');
hnd.help=mv_helpbutton(hFig,'xreg_modelExport');

okButtonsGrid = xreggridlayout(hFig,...
	'visible','off',...
	'correctalg','on',...
	'dimension', [1, 4],...
	'elements', {[], hnd.ok, hnd.cancel,hnd.help},...
	'colsizes', [-1, 65, 65, 65],...
	'border', [0 0 0 10],...
	'gapx', 7);


set(mainLyt,...
	'elements', {[], fileGrid, OptionsFrame, NotesFrame, okButtonsGrid},...
	'dimension',[5, 1],...
	'correctalg','on',...
   'border',[10 10 10 10],...
	'gapy',10,...
	'rowsizes', [10, 30, 230,  -1, 35],...
	'packstatus', 'on');

% save handles in userdata of figure
ud.hnd = hnd;
ud.dest = 1;
set(hFig,'visible','on',...
	'userdata',ud);
set(mainLyt,'visible', 'on');

%------------------------------------------------------
% SUBFUNCTION  i_Cancel
%------------------------------------------------------
function i_Cancel(source, null, hMain)
delete(hMain);


%------------------------------------------------------ 
%  SUBFUNCTION  i_Init
%------------------------------------------------------
function i_Init(p, view)

mbh= MBrowser;
mp= p.project;
mlist= p.exportmodel(view);
% if only one model it is not a cell array
if ~isa(mlist,'cell'), mlist = {mlist}; end;

% Get modelName for export
info= mp.exportinfo(p,mlist);


% =========== set info for creating xregstatsmodels ============
hFig = mvf('expmodel');
ud = get(hFig,'userdata');

ud.p = p;
% the design constraints
tp= p.mdevtestplan;
cons= BoundaryModel(tp,mlist{1});

modelName= p.name;
ud.info = info;
ud.modelName = modelName;
ud.constraints = cons;

% set up controls
h = ud.hnd;
set(h.ok,'callback',{@i_okay,p, view});

% ==== file location ====
ud.file = fullfile(xregGetDefaultDir('Models'), [ ud.modelName, '.exm' ]);
i_chooseDestination(h.destination, []);

% model name edit
set(h.modelName,'string',modelName);

% ==== enable/disable check boxes ====

% global models - only relevant if we've got twostage models
ud.twostage = cellfun('isclass',mlist,'xregtwostage');
if any(ud.twostage)
	set(h.globalModels,'enable','on','value',0);
else
	set(h.globalModels,'enable','off','value',0);
end	

% export all local models - only available at local node AND testplan
if strcmp(mbh.CurrentNode.guid,'local')
	set(h.localModels,'enable','on','value',0);
else
	set(h.localModels,'enable','off','value',0);
end	
   
% datum model exported??
TSindex = cellfun('isclass', mlist,'xregtwostage');
% find out if there is a datum TS lurking somewhere & get(mlist{ind(1)},'datumtype')==1
datumFlag = 0;
if any(TSindex)
	TSlist = {mlist{find(TSindex)}};
	for i = 1:length(TSlist)
      % just need to get datumFlag>0 if ANY datum models
		datumFlag = datumFlag + get(TSlist{i},'datumtype');
	end
end
if datumFlag
	set(h.datumModel,'enable','on','value',0);
else
	set(h.datumModel,'enable','off','value',0);	
end

% check to see if PEV available
pev_supported =[];
for i=1:length(mlist)
	pev_supported = [pev_supported(:); pevSupported(mlist{i})];
end
ud.pev_supported = 	pev_supported;

% contraints - not up to user!
if isempty(cons)
	set(h.constraints,'enable','off','value',0);
else
	set(h.constraints,'enable','inactive','value',1);	
end


% trade off button - only on at testplan. Enabled if TS models
set(h.toTradeOffButton,'visible','off','enable','off');
if strcmp(p.guid,'testplan')
    set(h.toTradeOffButton,'visible','on');
end
if any(ud.twostage) && nfactors(p.model)==2
    set(h.toTradeOffButton,'enable','on');
end


% ==== notes listbox ====
Variables = info.Variables;
var = char(Variables{1});
for i = 2:length(Variables);
	var = [var ', ' char(Variables{i})];
end
str= cell(1,5);
str{1} = ['User: ' info.User];
str{2} = ['Date: ' info.Date];
str{3} = ['MBC Version: ' info.mvver];
str{4} = ['Parent File: ' info.Parent];
str{5} = ['Model: ' info.path];
str{6} = ['Variables: ' var];

set(h.notes,'string',str);
set(hFig,'userdata',ud);
i_NotesSelected(ud.hnd.notes, []);
i_ModelName(ud.hnd.modelName, []);

%------------------------------------------------------
%  SUBFUNCTION  i_Build
%------------------------------------------------------
function Xmodels = i_Build(p, view)

if ~nargin
	h= MBrowser;
	p= h.CurrentNode;
	view= h.GetViewData;
end

%======== setup Export Model Gui stuff ==================
hFig = mvf('expmodel');
ud = get(hFig,'userdata');
h = ud.hnd;

if get(h.constraints,'value') 
    constraints = ud.constraints;
else
    constraints = [];
end

% ---------- user selected options ----------
glob = get(h.globalModels,'value');
datum = get(h.datumModel,'value');
local = get(h.localModels,'value');

Types={};
if local
    Types= [Types {'switch'}];
end
if glob
    Types= [Types {'global'}];
end
if datum
    Types= [Types {'datum'}];
end

[m,mlist]= MakeEXM(p.info,Types);

if isempty(mlist)
    Xmodels= m;
else
    if iscell(m)
        Xmodels= [m,mlist];
    else
        Xmodels= [{m},mlist];
    end
end    
dest = get(h.destination,'value');




%------------------------------------------------------
% SUBFUNCTION  i_okay
%------------------------------------------------------

function i_okay(source, null, p, view)

Xmodels = i_Build(p, view);

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

dest = get(h.destination,'value');
switch dest
    case 1 
        % workspace
        assignin('base',ud.modelName,Xmodels);
        if isa(Xmodels,'cell'),	
            msgbox('Multiple models exported as a cell array','Export Model','modal'); 
        end;
        delete(hFig);

    case 2
        % do the eval'ing and saving in a subfunction to protect variables
        savedOK = i_safesavetofile(ud.file, ud.modelName, Xmodels);
        % if savedOk isn't numeric (ie modelname = 'tHeFiLeWaSsAvEdOk')
        % OR savedOK=0 we error, otherwise carry on.
        if savedOK
            delete(hFig);
        else
            uiwait(errordlg('Error saving file - Please export your models as a different name.','Save Error','modal'));
        end

    case 3
        i_Export2Simulink(hFig, p, Xmodels);
    case 4
        p.EXMdialog;
        delete(hFig);
end

%------------------------------------------------------
% SUBFUNCTION  i_safesavetofile
%------------------------------------------------------
function tHeFiLeWaSsAvEdOk = i_safesavetofile(tHiS_iS_tHe_FiLeNaMe, tHiS_iS_tHe_MoDeLnAmE, models)
% do the evaling and saving in a subfunction with unlikely variable names

% it doesn't matter if modelnames = 'models' as then the eval line is models=models, not a problem

% could this error - unlikely - we'll try catch it anyway...
try
    eval([tHiS_iS_tHe_MoDeLnAmE,'=models;']);
catch
    tHeFiLeWaSsAvEdOk=0;
    return;
end

% if filename isn't a str we error
if ~ischar(tHiS_iS_tHe_FiLeNaMe)
    tHeFiLeWaSsAvEdOk=0;
    return;
end

try
    save(tHiS_iS_tHe_FiLeNaMe,tHiS_iS_tHe_MoDeLnAmE);
    if isa(models,'cell'),	
        msgbox('Multiple models exported as a cell array','Export Model','modal'); 
    end;
    tHeFiLeWaSsAvEdOk=1;
catch
    tHeFiLeWaSsAvEdOk=0;
end

return;

%------------------------------------------------------
% SUBFUNCTION  i_Export2Simulink
%------------------------------------------------------
function i_Export2Simulink(hFig, p, Xmodels)

ud = get(hFig,'userdata');
h = ud.hnd;
DO_PEV = get(h.pev,'value');
delete(hFig);

if ~iscell( Xmodels )
    Xmodels = {Xmodels};
end

for i=1:length(Xmodels)
    % require xregmodel not xregstatsmodel
    Xmodels{i}= model(Xmodels{i});
end
p.mv2sl(Xmodels, ud.file, ud.modelName, DO_PEV);

return	




%---------------------------------------------------------
% SUBFUNCTION i_ToTradeOff
%---------------------------------------------------------
function i_ToTradeOff(source,null,p)

hFig = get(source,'parent');
ud = get(hFig,'userdata');

[path, name, type]=fileparts(ud.file);
fspec= fullfile(path, name, '.mat');
[filename,pathname]=uiputfile(fspec, 'Save all local models for Tradeoff');

if isnumeric(filename) && filename==0
	return
end

% ensure file extension is .mat
[null, filename, ext] = fileparts(filename);
file = [pathname, filename, '.mat'];

set(hFig,'pointer','watch');
AllLocalModels(p.info,file);
set(hFig,'pointer',get(0,'defaultfigurepointer'));


%---------------------------------------------------------
% SUBFUNCTION i_ModelName
%---------------------------------------------------------
function i_ModelName(source, null)
% check model name entered is valid for MATLAB
ud = get( get(source,'parent'), 'userdata');
ud.modelName = validmlname(get(source,'string'));
set(source, 'string', ud.modelName);
set( get(source,'parent'), 'userdata', ud);
return

%---------------------------------------------------------
% SUBFUNCTION i_NotesSelected
%---------------------------------------------------------
function i_NotesSelected(lb, null)

hFig = get(lb, 'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

delete = h.deleteNotes;
edit = h.editNotes;

if get(lb,'value') <= 6 % the number of fixed fields in the notes
	set([delete, edit],'enable','off');
else
	set([delete, edit],'enable','on');
end 

%------------------------------------------------------
% SUBFUNCTION  i_chooseLocation
%------------------------------------------------------
function i_chooseLocation(source, null)

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;
[path, name, type]=fileparts(ud.file);

[filename,pathname]=uiputfile(ud.file, 'Save models to file');

if isnumeric(filename) && filename==0
	return
end

[nul,filename] = fileparts(filename);
ud.file = [pathname, filename, type];
set(h.fileLoc,'string', [pathname, filename, type]);
set(hFig, 'userdata', ud);


%------------------------------------------------------
% SUBFUNCTION  i_fileName
%------------------------------------------------------
function i_editFileName(source, null)

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

newFile = get(source,'string');
[path, name, type]=fileparts(newFile);
% make the name nice and friendly and not too long
% name = validmlname(name); % disabled - we will accept names starting with numbers
if length(name)>31
   name= name(1:31);
end

% make the right extension happen
dest = get(h.destination,'value');
ext = {'', '.exm','.mdl'};
ext = ext{dest};

if exist(path, 'dir')
	ud.file = fullfile(path, [name, ext]);
else
	ud.file = fullfile(pwd, [name, ext]);
end
set(source,'string', ud.file);

set(hFig, 'userdata', ud);



%------------------------------------------------------
% SUBFUNCTION   i_chooseDestination
%------------------------------------------------------
function i_chooseDestination(source, null)
% simply puts ud.file into the 'destination file' edit box with the right extension
% or disables this edit box
% also enables the pev checkbox if necessary

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

dest = get(source,'value');



if ud.dest==4 && dest~=4
    % reinitialise settings if switching from CAGE
    mbh= MBrowser;
    view= mbh.GetViewData;
    p= mbh.CurrentNode;
    ud.dest= dest;
    set(hFig, 'userdata', ud);
    i_Init(p,view);
    return
end

switch dest
    case 1 % workspace
        set(h.pev,'enable','off','value',0);
        set(h.fileLoc,...
            'enable','off',...
            'string','to Workspace');
        set([h.txtFile,	h.changeLocButton],'enable','off');

    case 2
        set(h.pev,'enable','off','value',0);
        set([h.txtFile,	h.changeLocButton],'enable','on');
        [path, name, type]=fileparts(ud.file);
        ud.file = fullfile(path, [name, '.exm']);
        set(h.fileLoc,...
            'enable','on',...
            'string',ud.file);
    case 3

        % ============ check for 'simulink' licences =============
        % Assume there won't be stateflow modules in SL file - too invasive to check one out
        if ~mbcchecklicenses(0)
            str = get(h.destination,'string');
            set(h.destination,'string',str(1:2),'value',1);
            errordlg('No Simulink licenses available. Export to Simulink is therefore not available');
            return
        end

        set([h.txtFile,	h.changeLocButton],'enable','on');
        [path, name, type]=fileparts(ud.file);
        ud.file = fullfile(path, [name, '.mdl']);
        set(h.fileLoc,...
            'enable','on',...
            'string',ud.file);
        % export pev??
        if all(ud.pev_supported)
            set(h.pev,'enable','on','value',1);
        end

    case 4
        % CAGE
        set(h.pev,'enable','off','value',0);
        set(h.globalModels,'enable','off','value',0);       
        set(h.datumModel,'enable','off','value',0);        
        if strcmp(ud.p.guid,'local')
            set(h.localModels,'enable','inactive','value',1);
        end
        if isempty(ud.constraints)
            set(h.constraints,'enable','off','value',0);
        else
            set(h.constraints,'enable','inactive','value',1);
        end

        set(h.fileLoc,...
            'enable','off',...
            'string','to CAGE');
        set([h.txtFile,	h.changeLocButton],'enable','off');
        
end

ud.dest = dest;
% extension may have changed in ud.file
set(hFig, 'userdata', ud);

%------------------------------------------------------
% SUBFUNCTION  i_add  % add to notes field
%------------------------------------------------------
function i_Add(ok, null, title, infoTxt, hFig)
% add info fields to listbox and to exportmodel info.new cell array

ud = get(hFig,'userdata');
h = ud.hnd;

newTitle = get(title,'string');
newInfo = get(infoTxt,'string');

if isempty(newTitle) && isempty(newInfo)
	return
end

% add new field to info listbox
str = get(h.notes,'string');
n = length(str);
str{n+1} = [newTitle ': ' newInfo];
set(h.notes,'string',str);

% % add new info to all 'info' structs of models
info = ud.info;
i = length(info.new) + 1;
% start with info.new = {[]} 	gives length=1 place for engine data
info.new{i}.Title = newTitle;
info.new{i}.Description = newInfo;
ud.info = info;

set(hFig,'userdata',ud);

i_CancelInfoGui(ok, [],  handle(get(ok,'parent')));

%------------------------------------------------------
% SUBFUNCTION  i_Edit  % edit notes field
%------------------------------------------------------
function i_Edit(ok, null, title, infoTxt, hFig)
% add info fields to listbox and to exportmodel info.new cell array

ud = get(hFig,'userdata');
h = ud.hnd;

newTitle = get(title,'string');
newInfo = get(infoTxt,'string');

if isempty(newTitle) && isempty(newInfo)
	return
end

% add new field to info listbox
str = get(h.notes,'string');
value = get(h.notes,'value');
str{value} = [newTitle ': ' newInfo];
set(h.notes,'string',str);

% add new info to all 'info' structs of models
info = ud.info;
% need to subtract the 5 fixed fields: user, date, version, file, path
info.new{value-5}.Title = newTitle;
info.new{value-5}.Description = newInfo;
ud.info = info;

set(hFig,'userdata',ud);

i_CancelInfoGui(ok, [],  handle(get(ok,'parent')));

%---------------------------------------------------------
% SUBFUNCTION i_Delete  % delete item from notes field
%---------------------------------------------------------
function i_Delete(source, null)

hFig = get(source, 'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

str = get(h.notes,'string');
val = get(h.notes,'value');
str(val)=[];
set(h.notes,'string',str,'value',max(1,val-1));
% disable edit/delete if we're now in the top bit of the listbox
i_NotesSelected(h.notes, []);

% remove this field from info
% need to subtract the 5 fixed fields: user, date, version, file, path
ud.info.new(val-5)=[];

set(hFig,'userdata',ud);



%---------------------------------------------------------
% SUBFUNCTION i_CreateExportList
%---------------------------------------------------------
function i_CreateExportList(source, null)

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

%========create dialog to enter new info================
pos = get(hFig,'position');

modelsFig = xregfigure(...
	'position',[pos(1)+50, pos(2)+pos(4)-500, 300, 400],...
	'name','Models Export List',...
	'tag','allmodels',...
	'visible','off',...
	'windowstyle','modal');
f = double(modelsFig);

mainLyt = xreggridlayout(f,...
	'visible','off',...
	'packstatus', 'off',...
	'container',f);

modelsFig.LayoutManager = mainLyt;
modelsFig.minimumSize = [300 300];


%----- the list -----
txtTitle = xreguicontrol(f,...
	'visible','off',...
	'style','text',...
	'string','Models currently selected for export: ',...
	'fontweight','demi');
modelList = xreguicontrol(f,...
	'visible','off',...
	'horizontalalignment','left',...
	'style','listbox',...
	'enable','inactive',...
	'backgroundcolor','w');

listGrid = xreggridlayout(f,...
	'visible','off',...
	'correctalg','on',...
	'dimension',[2,1],...
	'gapy',10,...
	'elements',{txtTitle, modelList},...
	'rowsizes', [20, -1]);

% okay button
ok = xreguicontrol(f,...
	'visible','off',...
	'style','push',...
	'callback',{@i_CancelExportList, modelsFig},...
	'string','OK');
okButtonsGrid = xreggridlayout(f,...
	'visible','off',...
	'correctalg','on',...
	'dimension', [1, 3],...
	'elements', {[], ok,  []},...
	'colsizes', [-1, 80, 5],...
	'rowsizes', 30);

% ----------- fill the list with info --------------
listStr = {};

% i_Build looks at destination - we need xregstatsmodels, so need dest~=3
% NOTE: could write another fcn i_BuildName that returns just names...
tmpDest = get(h.destination,'value');
set(h.destination,'value',1);
Xmodels = i_Build;
set(h.destination,'value',tmpDest);

if ~iscell(Xmodels), Xmodels = {Xmodels}; end;

for i = 1:length(Xmodels)
	name = getname(Xmodels{i});
	tmpstr = name;
	
	info = getinfo(Xmodels{i});
	if isfield(info, 'DatumOf')
		datum = info.DatumOf;
		if strcmp(datum, 'datum link')
			tmpstr = [name, ': datum link'];
		else
			tmpstr = [name, ': datum of ', datum];
		end
	elseif isfield(info, 'ResponseOf')
		rf = info.ResponseOf;
		tmpstr = [name, ': response feature of ', rf];
	end
	listStr{i} = tmpstr;
end
set(modelList,'string',listStr);

set(mainLyt,...
	'dimension',[2, 1],...
	'correctalg','on',...
	'elements',{listGrid, okButtonsGrid},...
	'border',[20, 20, 20, 20],...
	'gapy',20,...
	'rowsizes', [-1,30]);

set(mainLyt,'packstatus','on');
set(mainLyt,'visible','on');
set(f,'visible','on');

%------------------------------------------------------
% SUBFUNCTION   i_CancelExportList
%------------------------------------------------------
function i_CancelExportList(source, null, modelsFig)

delete(modelsFig);

%------------------------------------------------------
% SUBFUNCTION   i_CreateInfoGui
%------------------------------------------------------
function i_CreateInfoGui(source, null)

hFig = get(source,'parent');
ud = get(hFig,'userdata');
h = ud.hnd;

%========create dialog to enter new info================
pos = get(hFig,'position');

infoFig = xregfigure(...
	'position',[pos(1)+50, pos(2)+pos(4)-300, 400, 150],...
	'name','New Export Model Information',...
	'tag','expmodelinfo',...
	'visible','on',...
	'windowstyle','modal');
f = double(infoFig);

mainLyt = xreggridlayout(f,...
	'visible','off',...
	'packstatus', 'off',...
	'container',f);

infoFig.LayoutManager = mainLyt;
infoFig.minimumSize = [100 80];


%----- edit boxes -----
txtTitle = xreguicontrol(f,...
	'visible','off',...
	'style','text',...
	'string','Field name: ',...
	'fontweight','demi');
editTitle = xreguicontrol(f,...
	'visible','off',...
	'horizontalalignment','left',...
	'style','edit',...
	'backgroundcolor','w');

txtInfo = xreguicontrol(f,...
	'visible','off',...
	'style','text',...
	'string','Information: ',...
	'fontweight','demi');
editInfo = xreguicontrol(f,...
	'visible','off',...
	'horizontalalignment','left',...
	'style','edit',...
	'backgroundcolor','w');

editGrid = xreggridlayout(f,...
	'visible','off',...
	'correctalg','on',...
	'dimension',[2,4],...
	'gapx',10,...
	'gapy',15,...
	'elements',{[], [], txtTitle, txtInfo, editTitle, editInfo, [], []},...
	'colsizes',[-1, 80, 250,  -1],...
	'rowsizes', [20 20]);

% okay cancel buttons
ok = xreguicontrol(f,...
	'visible','off',...
	'style','push',...
	'callback',{@i_Add, editTitle, editInfo, hFig},...
	'string','OK');
% callback set to i_Edit later if called by edit

cancel = xreguicontrol(f,...
	'visible','off',...
	'style','push',...
	'callback',{@i_CancelInfoGui, infoFig},...
	'string','Cancel');
okButtonsGrid = xreggridlayout(f,...
	'visible','off',...
	'correctalg','on',...
	'dimension', [1, 4],...
	'elements', {[], ok, cancel, []},...
	'colsizes', [-1, 80, 80, 5],...
	'rowsizes', 30,...
	'gapx', 25);

set(mainLyt,...
	'dimension',[2, 1],...
	'gapy',20,...
	'correctalg','on',...
	'elements',{editGrid, okButtonsGrid},...
	'border',[0, 20, 0, 20],...
	'rowsizes', [60,30]);

set(mainLyt,'packstatus','on');
set(mainLyt,'visible','on');

% ----- if called by 'Edit, need to put text in place -----
%%need to know if called by edit or add
if source == h.editNotes
	value = get(h.notes,'value');
	info = ud.info;
   % need to subtract the 5 fixed fields: user, date, version, file, path
	set(editTitle, 'string', info.new{value-5}.Title);
	set(editInfo, 'string', info.new{value-5}.Description);
	set(ok,'callback',{@i_Edit, editTitle, editInfo, hFig});
end

%------------------------------------------------------
% SUBFUNCTION  i_CancelInfoGui
%------------------------------------------------------
function i_CancelInfoGui(source, null,  hInfoGui)
delete(hInfoGui);
