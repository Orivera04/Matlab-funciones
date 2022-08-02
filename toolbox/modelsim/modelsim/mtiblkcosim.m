function varargout = mtiblkcosim(varargin)
% MTIBLKCOSIM Mask helper function for Simulink ModelSim Cosim block

% Copyright 2003-2004 The MathWorks, Inc.
  % $Revision: 1.1.6.4 $ $Date: 2004/04/08 20:54:42 $

if nargout,
    [varargout{1:nargout}] = feval(varargin{:});
else
    feval(varargin{:});
end

% -------------------------------------------------------------------------
function [inCArray, outCArray, fclkCArray, rclkCArray, tclCommand, iconstr] = ...
    initializationCommands(cellArrayToParse, tclBefore, tclAfter)

% Error messages:
invalid_cell = 'Invalid input cell array : each signal must be either IN, OUT, FCLK or RCLK';

% Default outputs
inCArray    = {};
outCArray   = {};
fclkCArray  = {};
rclkCArray  = {};
tclCommand  = {};
iconstr     = [];
fullSigNames = {};

% First arrange each cell (vector) into separate rows
cellArrayToParse = cellArrayToParse(:);
numEntries       = size(cellArrayToParse,1);

% Error checking
if mod(numEntries,2) ~= 0, error(invalid_cell); end
legalporttypes = strvcat('in', 'out', 'fclk', 'rclk');
for k = 1 : 2 : numEntries
    porttype = lower(cellArrayToParse(k+1));
    if isempty(strmatch(porttype, legalporttypes))
        error(invalid_cell);
    end
end

inportidx  = 0;
outportidx = 0;
numSignals = numEntries/2;

iconstr.inport = [];
iconstr.outport = [];
iconstr.instr = {};
iconstr.outstr = {};
for k = 1 : 2 : numEntries

    porttype = lower(cellArrayToParse(k+1));

    if strcmp(porttype, 'in')
        inCArray = [inCArray, cellArrayToParse(k)];
        inportidx = inportidx+1;
        iconstr.inport(inportidx) = inportidx;
        str = cellArrayToParse{k};
        lastslash = findslash(str);
        iconstr.instr{inportidx}  = [str((lastslash+1): length(str)) ];
        signalNames{(k+1)/2} = iconstr.instr{inportidx};

    elseif strcmp(porttype, 'out')
        outCArray = [outCArray, cellArrayToParse(k)];
        outportidx = outportidx + 1;
        iconstr.outport(outportidx) = outportidx;
        str = cellArrayToParse{k};
        lastslash = findslash(str);
        iconstr.outstr{outportidx} = [str((lastslash+1): length(str)) ];
        signalNames{(k+1)/2} = iconstr.outstr{outportidx};

    elseif (strcmp(porttype, 'fclk'))
        fclkCArray = [fclkCArray, cellArrayToParse(k)];

    elseif (strcmp(porttype, 'rclk'))
        rclkCArray = [rclkCArray, cellArrayToParse(k)];
        
    else
        error(invalid_cell);

    end

    fullSigNames = [fullSigNames cellArrayToParse(k)];
    
end

% Form tclCommand cell array
tclCommand = [tclCommand, {tclBefore}, {tclAfter}];

% hack - hard code number of input/output ports to 6
% for k = (inportidx+1) : 6
%     iconstr.inport(k) = inportidx;
%     iconstr.instr{k}  = '';
% end
% 
% for k = (outportidx+1) : 6
%     iconstr.outport(k) = outportidx;
%     iconstr.outstr{k}  = '';
% end

uniqueNames = unique(fullSigNames);
if length(uniqueNames) ~= length(fullSigNames)
    warning('Signal names listed  across the Ports and Clocks panels must be unique from each other.');
end


% ------------------------------------------------------------------------
function OpenFcn(hBlk, eventData, constructor, varargin)

islocked = islockedModel(hBlk);

if islocked,
    hfig = findall(0, 'tag', 'modelsim_cosimdlg');

    if isempty(hfig),
        h = [];
    else

        % Get all the GUI handles and look for the one that matches hBlk.
        for indx = 1:length(hfig)
            h(indx) = getappdata(hfig(indx), 'handle');
        end
        h    = find(h, 'BlockHandle', hBlk);
    end
    enab = 'Off';
else
    h    = get_param(hBlk, 'UserData');
    enab = 'On';
end

if isempty(h),
    h = feval(constructor, hBlk, varargin{:});
    
    if ~islocked,
        set_param(hBlk, 'UserData', h);
    end
end

% Check if the GUI is already rendered.
if ~isrendered(h)
    render(h);
    l = handle.listener(h, 'Notification', @notification_listener);
    movegui(h.FigureHandle, 'center');
    if ~isempty(l),
        setappdata(h.FigureHandle, 'notification_listener', l);
    end
end

set(h, 'Enable', enab, 'Visible', 'On');
figure(h.FigureHandle);

% ------------------------------------------------------------------------
function NameChangeFcn(hBlk, eventData)

h = get_param(hBlk, 'UserData');

if ~isempty(h), updatename(h); end

% ------------------------------------------------------------------------
function DeleteFcn(hBlk, eventData);

h = get_param(hBlk, 'UserData');

if ~isempty(h), delete(h); end

% ------------------------------------------------------------------------
function CopyFcn(hBlk, eventData, constructor, varargin)

% Make sure that the user data is empty so that we don't have two blocks
% pointing to the same dialog.
set_param(hBlk, 'UserData', []);

% ----------------------------------------------------------
% local helper function
% ----------------------------------------------------------

% ------------------------------------------------------------------------
function notification_listener(h, eventData)

if strcmpi(eventData.NotificationType, 'erroroccurred')
    error(h, 'ModelSim Dialog Error', eventData.Data.ErrorString);
end

% -------------------------------------------------------------------------
function boolflag = islockedModel(hBlk)
%ISLOCKEDMODEL returns 1 for a locked model and 0 for an unlocked model

% Get the handle to the model and get its locked status.
hModel = bdroot(hBlk);
status = get_param(hModel,'lock');

% Convert the locked status to a boolean.
if strcmpi(status,'on'), boolflag = 1;
else,                    boolflag = 0; end

% -------------------------------------------------------------------------
function lastslash = findslash(str)

v1 = findstr(str, '\');
v2 = findstr(str, '/');
if ~isempty(v1)
    lastslash = max(v1);
    if lastslash == length(str)
        lastslash = v1(length(v1)-1);
    end
elseif ~isempty(v2)
    lastslash = max(v2);
    if lastslash == length(str)
        lastslash = v2(length(v2)-1);
    end
else
    lastslash = 0;
end

% [EOF] mtiblkcosim.m
