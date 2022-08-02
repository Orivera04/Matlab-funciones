function tgtprefs = tic2000TgtPrefCallback (action,varargin)

% $RCSfile: tic2000TgtPrefCallback.m,v $
% $Revision: 1.4.6.4 $ $Date: 2004/04/08 20:59:02 $
% Copyright 2003-2004 The MathWorks, Inc.

persistent guiarr

switch lower (action)
    case 'openfcn'
        % block has been double-clicked, open gui        
        block = varargin{1};       
        guiarr = open_gui (block, guiarr);  
        % flush pending graphics events, and update the inspector GUI
        drawnow;
        
    case 'copyfcn'
        % block has been copied, invoke constructor
        block = varargin{1};
        update_data (block);

        % initialize model automatically if possible
        % Do not automatically initialize model if running tests by QE.
        if exist('qeBypassBoardCheck','file') && qeBypassBoardCheck,
            % Do nothing
        else
            h = get_param (gcs,'SimParamHandle');
            if (~ishandle(h) || strcmp (get(h,'Visible'), 'off'))
                rpl = questdlg (['A Target Preference block for Embedded Target for TI C2000 has been added ' ...
                    'to the model. Do you want to initialize the simulation parameters pertinent ' ...
                    'to this target to their default settings?'], 'Initialize', 'Yes','No','No');
                if strcmp(rpl,'Yes')
                    init_model (block);
                end
            end
        end
        
    case 'deletefcn'
        % block is being deleted, get rid of its gui and its handle        
        block = varargin{1};  
        if isguivisible (block, guiarr),
            h = warndlg('Close Target Preference GUI to prevent potential loss of data!','Warning');
            uiwait (h);
        end   
        block = varargin{1};         
        guiarr = close_gui (block, guiarr);
    case 'mdlclosefcn'
        % model is closing, get rid of all gui's and their handles        
        if isguivisible ('', guiarr)
            h = warndlg('Close Target Preference GUI to prevent potential loss of data!','Warning');
            uiwait (h);
        end         
        for i=1:length(guiarr), dispose(guiarr{i}.tggui); end     
        clear guiarr;
    case 'namechgfcn'
        block = varargin{1};
        guiarr = update_gui (block, guiarr);       
    case 'loaddata'
        % for now, return data for first block found (assume top level)
        tgtprefblocks = find_system (gcs,'FollowLinks','on','LookUnderMasks','on', ...
                                 'MaskType','c2000 Target Preferences');
        userdata = get_param(tgtprefblocks{1},'userdata');
        tgtprefs = userdata.tic2000TgtPrefs;                             
end


%-------------------------------------------------------------------------------
function update_data (block)
userdata = get_param(block,'userdata');
tgtprefs = userdata.tic2000TgtPrefs;
if isempty(tgtprefs),  % default constructor
    tgtprefs = DSPTgtPkg.tic2000TgtPrefs;
    % 
    buildOptions = DSPTgtPkg.BuildOptions;
    buildOptions.CompilerOptions = DSPTgtPkg.CompilerOptions;
    buildOptions.LinkerOptions = DSPTgtPkg.LinkerOptions;
    buildOptions.RunTimeOptions = DSPTgtPkg.RunTimeOptions;    
    tgtprefs.BuildOptions = buildOptions;           
    %    
    dspchip = DSPTgtPkg.DSPChip;
    dspchip.Memory = DSPTgtPkg.Memory;
    
    dspboard = DSPTgtPkg.DSPBoard;
    dspboard.DSPChip = dspchip;
    dspboard.Memory = DSPTgtPkg.Memory;
    tgtprefs.DSPBoard = dspboard;     
    %
    tgtprefs.CCSLink = DSPTgtPkg.CCSLink;
    userdata.tic2000TgtPrefs = tgtprefs;
    set_param(block,'userdata',userdata);     
else,                      % copy constructor
    newtgtprefs = copyobject (tgtprefs);
    userdata.tic2000TgtPrefs = newtgtprefs;
    set_param(block,'userdata', userdata);
end

%-------------------------------------------------------------------------------
function newobject = copyobject (oldobject)
% copy constructor
% this copy method will fail for private properties
newobject = feval (class(oldobject));
fn = fieldnames (newobject);
for i=1:length(fn)
    obj = getfield (oldobject,fn{i});          
    if isobject (obj)
        newobject.(fn{i}) = copyobject (obj);
    else
        setfield (newobject,fn{i},getfield(oldobject,fn{i}));        
    end    
end

%-------------------------------------------------------------------------------
function guiarr = open_gui (block, guiarr)
target = get_param(block,'userdata');
tgtprefs = target.tic2000TgtPrefs;
% check if gui handle exist, if it does, check gui visibility
% if gui is not visible, make it visible using saved handle
% if gui does not exist, open it and save the handle
for i=1:length(guiarr),
   if isequal (guiarr{i}.block, gcb), 
       if ~guiarr{i}.tggui.Showing,
           show(guiarr{i}.tggui);
       end
       return;
   end
end;
% gui does not exist
tggui = tgtprefs.gui;
guiinfo.block = block;
guiinfo.tggui = tggui;
guiarr{length(guiarr)+1}= guiinfo;   

%-------------------------------------------------------------------------------
function guiarr = close_gui (block, guiarr)
% check if gui handle exist for the block being deleted
% if it does, dispose of the gui, remove the gui handle
for i=1:length(guiarr),
   if isequal (guiarr{i}.block, gcb), 
       dispose(guiarr{i}.tggui);
       guiarr = removeelement (guiarr, i);
       return;
   end
end;

%-------------------------------------------------------------------------------
function guiarr = update_gui (block, guiarr)
% a gui handle that does not match an existing Target Preference Block
% correspond to a blocks that just changed its name; update gui handle
% to point to the block's new name
tgtprefblocks = find_system (gcs,'FollowLinks','on','LookUnderMasks','on', ...
                                 'MaskType','c2000 Target Preferences');
for i=1:length(guiarr),
    flag = 1;
    for k=1:length (tgtprefblocks), 
        if isequal (guiarr{i}.block, tgtprefblocks{k}), 
            flag = 0; 
        end; 
    end;
    if flag, 
        guiarr{i}.block = block; 
    end
end;

%-------------------------------------------------------------------------------
function ret = isguivisible (block, guiarr)
% check if gui for the specified block is visible
% if gui is visible, return 1, else return 0
for i=1:length(guiarr),
   if isempty(block) || isequal (guiarr{i}.block, gcb), 
       if guiarr{i}.tggui.Showing,
           ret = 1; return;
       end
       ret = 0; return;
   end
end;
ret = 0;

%-------------------------------------------------------------------------------
function arr = removeelement (arr, k)
% remove element with index "k" rom cell array "arr"
len = length (arr);
if k<1 || k>len, 
    return;
elseif k==1, 
    arr = { arr{2:len} };
elseif k==len;
    arr = { arr{1:len-1}} ;
else
    arr = { arr{1:k-1} arr{k+1:len} };
end

%-------------------------------------------------------------------------------
function ret = isobject (obj)
c = class(obj);
switch c
    case {'struct', 'double', 'int8', 'uint8', 'int16', 'uint16', ...
                'int32', 'uint32', 'logical', 'char', 'cell' }
        ret = 0;
    otherwise
        ret = 1;
end

%-------------------------------------------------------------------------------
function init_model (block)
% initialize the model for Embedded Target for TI c2000 DSP
cs = getActiveConfigSet(gcs);
% basic characteristics and requirements
cs.switchTarget('ti_c2000_grt.tlc', []);
set_param(cs, 'TemplateMakefile', 'ti_c2000_grt.tmf');
set_param(cs, 'MakeCommand', 'make_rtw'); 
set_param(cs, 'Solver','FixedStepDiscrete');
% normally do not stop executing ever
set_param(cs, 'StopTime','inf');
% prefer not to save anything to workspace
set_param(cs, 'SaveOutput','off');
set_param(cs, 'SaveTime','off');
set_param(cs, 'SaveState','off');
set_param(cs, 'SaveFinalState','off');





