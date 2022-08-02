function [lookup, changed] = cgtableoperationgui( lookup,  region )
%CGTABLEOPERATIONGUI GUI for applying simple arithemtical ops to a table
%
%  CGTABLEOPERATIONGUI(TBL, REGION) enables some simple mathematical
%  operations to be applied to a table.  You can use the whole table, or a
%  selected region of a table.  You can link to an mfile the user specifies
%  which can do anything.  REGION is a logical mask.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/20 23:18:48 $

error( nargchk( 1, 2, nargin, 'struct' ) );

fig = xregdialog( 'Name', 'Adjust Cell Values',...
    'Position', [10, 10, 450, 230],...
    'Resize', 'off');
figh = double( fig );
xregcenterfigure( figh );

[lyt, ud] = i_createlyt( figh );

if nargin==1
    values = get( lookup, 'values' );
    region = true( size( values ) );
end

% dependent on region we don't allow some choices and have different
% defaults?
if nargin==1 || all( ~region(:) )
    % no region specified, or the region is all false
    % Don't allow that radio to be used
    set( ud.radios, 'EnableArray', [true; false] );
else
    % we have a region - make that the default
    set( ud.radios, 'selected', 2 );
end

% ok and cancel buttons
okbtn = uicontrol('parent',figh,...
    'string','OK',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''ok'', ''visible'',''off'');');
cancbtn = uicontrol('parent',figh,...
    'string','Cancel',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''cancel'', ''visible'',''off'');');
helpbtn = cghelpbutton(figh, 'CGADJUSTCELLVALUE');

brd = xreggridbaglayout(figh, ...
    'dimension', [2 4], ...
    'rowsizes', [-1 25], ...
    'colsizes', [-1 65 65 65], ...
    'gap', 7, ...
    'border', [7 7 7 7], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'elements', {lyt, [], [], okbtn, [], cancbtn, [], helpbtn});

% this begins blocking
set( fig, 'LayoutManager', brd );
set(brd, 'packstatus', 'on');
try
    fig.showDialog(okbtn);
catch
    fig.set('Visible','on')
end

tg = get(fig, 'tag');
changed = false;
if strcmp(tg, 'ok')
    [lookup, changed, msg] = i_processFinish( lookup, region, ud );
    if ~isempty( msg )
        uiwait(errordlg(msg, 'MBC Toolbox', 'modal'));
    end
end
delete(fig)


% ---------------------------------------------------
function [lookup, changed, msg] = i_processFinish( lookup, region, ud )
% ---------------------------------------------------
% deal with ok

msg = '';
changed = false;

values = get( lookup, 'values' );
applyto = get( ud.radios, 'Selected' );
% make whole table look like a region
if applyto==1
    region = true( size( values ) );
end
chosen_op = get( ud.operation, 'Value' );
ops = get( ud.operation, 'Userdata' );
% use the browse button to signal the custom op
if ops.browse(chosen_op)
    [lookup, changed, msg] = i_processCustom( lookup, ud, region );
else
    [lookup, changed, msg] = i_processStandard( lookup, ud, region );
end


% ---------------------------------------------------
function [lookup, changed, msg] = i_processCustom( lookup, ud, region )
% ---------------------------------------------------
% deals with a custom operation

tablevalues = get( lookup, 'values' );

user_function = get( ud.argument, 'String' );
msg = '';

if ~isempty( user_function )
    try
        tablevalues = feval( user_function, tablevalues, region );
        if all( region )
            region_desc = 'whole table';
        else
            region_desc = 'selected region';
        end
        info = sprintf( 'Applied user function ''%s'' to %s', user_function, region_desc );
        lookup = set( lookup, 'values', {tablevalues, info} );
        changed = true;
    catch
        changed = false;
        msg = sprintf( 'Error calling user function %s\n%s', user_function, lasterr );
    end
else
    % no file specified - this will be a no-op
    changed = false;
    msg = sprintf( 'No user function specified' );
end


% ---------------------------------------------------
function [lookup, changed, msg] = i_processStandard( lookup, ud, region )
% ---------------------------------------------------
% deals with one of the builtin operations

tablevalues = get( lookup, 'values' );
msg = '';
% do the standard operations
ops = get( ud.operation, 'userdata' );
needs_arg = ops.needsarg( get( ud.operation, 'value' ) );
stringarg = get( ud.argument, 'string' );

numericarg = str2double( stringarg );

if isnan( numericarg )
    % try to pick out percents from arg - returns NaN if not a percent
    % argument
    value = i_parsefor_percent( stringarg );
    if ~isnan( value )
        numericarg = value * ( tablevalues( region ) *  0.01 );
    end
end

if needs_arg && all( isnan( numericarg ) )
    % must supply an argument to this function - a no-op
    changed = false;
    msg = sprintf( 'Missing argument to operation' );
else
    % go ahead with the operation
    func = ops.func{ get( ud.operation, 'value' ) };
    op_description = ops.description{ get( ud.operation, 'value' ) };
    if all( region )
        region_description = 'whole table';
    else
        region_description = 'selected region';
    end

    try
        if needs_arg
            tablevalues( region ) = feval(func, tablevalues( region ), numericarg );
            if strcmp(op_description, 'set')
                % set to value - special case
                info = sprintf( '%s %s to %s', op_description, region_description, stringarg );
            else
                info = sprintf( '%s %s to %s', op_description, stringarg, region_description );
            end
        else
            tablevalues( region ) = feval(func, tablevalues( region ) );
            info = sprintf( 'set %s to %s', region_description, op_description );
        end
        lookup = set( lookup, 'values', {tablevalues, info} );
        changed = true;
    catch
        msg = sprintf( 'Error performing operation' );
        changed = false;
    end
end

% ---------------------------------------------------
function [lyt, ud] = i_createlyt( figh )
% ---------------------------------------------------

SC = xregGui.SystemColorsDbl;

descriptionStr = ['Select how you want to adjust the table values, and ' ...
    'what region of the table should be changed.  ',...
    'All operations accept a numeric argument ("plus 10"); the "plus", "minus", ' ...
    '"set to value" and "custom operation" options also accept percentages ("minus 5%").  ' ...
    'The custom operation option lets you provide your own function for ' ...
    'adjusting the table values.'];

descrip = uicontrol('Parent', figh,...
    'string', descriptionStr,...
    'horiz', 'left',...
    'style', 'text');

ud.radios = xregGui.rbgroup('Parent', figh,...
    'nx', 1,...
    'ny', 2,...
    'value', [1; 0],...
    'String', {'Apply to entire table'; 'Apply to selected table cells'});

operations  = i_defineOperations;

ud.operation = uicontrol( 'Parent', figh,...
    'background', SC.WINDOW_BG,...
    'style', 'popupmenu',...
    'tooltip', 'Choose operation to apply',...
    'string', operations.label,...
    'userdata', operations);
ud.operationlabel = uicontrol('parent', figh, ...
    'style', 'text', ...
    'enable', 'inactive', ...
    'string', 'Operation:', ...
    'HorizontalAlignment', 'left');
ud.argument = uicontrol( 'Parent', figh,...
    'background', SC.WINDOW_BG,...
    'horizontalalignment', 'right',...
    'tooltip', 'Argument for operation',...
    'style', 'edit');
ud.argumentlabel = uicontrol('parent', figh, ...
    'style', 'text', ...
    'enable', 'inactive', ...
    'string', 'Value:', ...
    'HorizontalAlignment', 'left');
ud.browse = uicontrol('Parent', figh,...
    'style', 'pushbutton',...
    'enable', 'off',...
    'tooltip', 'Browse for custom operation file',...
    'string', '...');

elements = {...
    descrip, [],                [], [],               [], [],        []; ...
    [],      ud.operationlabel, [], ud.argumentlabel, [], [],        []; ...
    [],      [],                [], [],               [], [],        []; ...
    [],      ud.operation,      [], ud.argument,      [], ud.browse, [];...
    [],      [],                [], [],               [], [],        []; ...
    [],      ud.radios,         [], [],               [], [],        []};

lyt = xreggridbaglayout(figh,...
    'packstatus', 'off', ...
    'dimension', [6 7], ...
    'rowsizes', [80 15 2 20 15 40], ...
    'colsizes', [8 120 10 -1 5 20 8], ...
    'mergeblock', {[1 1], [1 7]}, ...
    'mergeblock', {[6 6], [2 4]}, ...
    'elements', elements);


% set up the callback
set( ud.browse,    'Callback', { @i_browse,    ud } );
set( ud.operation, 'Callback', { @i_operation, ud } );
set( ud.argument,  'Callback', { @i_argument,  ud } );

% ---------------------------------------------------
function i_custom( src, evt, ud )
% ---------------------------------------------------
% check custom function is available

newFunc = get( ud.argument, 'string' );
if ~isempty( newFunc )
    % will this function be the one picked up at runtime?
    % we call the function like func( double_array )
    runtimefile = which( sprintf('%s(%d)', newFunc, 1 ) );
    if isempty( runtimefile )
        % not on path!
        set( ud.argument, 'string', get( ud.argument, 'userdata' ) );
        return;
    end
end

set( ud.argument, 'Userdata', newFunc );

% ---------------------------------------------------
function i_argument( src, evt, ud )
% ---------------------------------------------------
% check user input for argument is valid

newArg = get( ud.argument, 'string' );
val = get(ud.operation, 'value');
ops = get(ud.operation, 'userdata');

% first do str2double
numericVal = str2double( newArg );
if isnan( numericVal ) && ops.supportspercent(val)
    % check for XX%
    value = i_parsefor_percent( newArg );
    if isnan( value )
        set( ud.argument, 'string', get( ud.argument, 'userdata' ) );
        return
    end
elseif ~isreal( numericVal ) ...
        || (isnan( numericVal ) && ~ops.supportspercent(val))
    set( ud.argument, 'string', get( ud.argument, 'userdata' ) );
    return
end
set( ud.argument, 'Userdata', newArg );

% ---------------------------------------------------
function i_browse( src, evt, ud )
% ---------------------------------------------------
% Deal with a click on the browser button

[filename, pathname] = uigetfile( '*.m', 'Pick an M-file' );
if ~isnumeric( filename )
    chosenfile = fullfile( pathname, filename );
    [pathname_notused, filename] = fileparts( chosenfile );
    % will this function be the one picked up at runtime?
    % we call the function like func( double_array )
    runtimefile = which( sprintf('%s(%d)', filename, 1 ) );
    if isempty( runtimefile )
        % not on path!
        wd = warndlg( sprintf( 'Function %s does not have correct signature.', chosenfile), 'Missing Function', 'modal' );
        waitfor( wd );
        return;
    else
        if ~strcmpi( chosenfile, runtimefile )
            % we won't run the correct file
            wd = warndlg( sprintf( '%s is before %s on path and will be run instead', runtimefile, chosenfile), 'Missing Function', 'modal' );
            waitfor( wd );
            return;
        end
    end
    set( ud.argument, 'String', filename );
end

% ---------------------------------------------------
function i_operation( src, evt, ud )
% ---------------------------------------------------
% Deal with change in operation

SC = xregGui.SystemColorsDbl;
val = get(ud.operation, 'value');
ops = get(ud.operation, 'userdata');
if ops.needsarg(val)
    set(ud.argument, 'enable', 'on', 'BackgroundColor', SC.WINDOW_BG);
    set(ud.argumentlabel, 'enable', 'on');
else
    set(ud.argument, 'enable', 'off', 'BackgroundColor', SC.CTRL_BG);
    set(ud.argumentlabel, 'enable', 'off');
end

if ops.browse(val)
    set( ud.browse,   'enable',   'on'  );
    set( ud.argument, 'Callback', { @i_custom,  ud } );
    set( ud.argument, 'Userdata', '' );
else
    set( ud.browse,   'enable',   'off' );
    set( ud.argument, 'Callback', { @i_argument,  ud } );
    set( ud.argument, 'Userdata', '' );
end

i_argument( src, evt, ud );

% ---------------------------------------------------
function value = i_parsefor_percent( string )
% ---------------------------------------------------
% looks through a string for a percentage
% returns NaN if not a percentage, and the percentage value if it is

value = NaN;
RE = '(.*)%\s*$';
tokens = regexp( string, RE, 'tokens', 'once' );

if ~isempty( tokens )
    value = str2double( tokens{1} );
end

% ---------------------------------------------------
function out = i_equals( table,  arg )
% ---------------------------------------------------
% do the 'equals' operation

% set the mask cells to arg
out =  arg;

% ---------------------------------------------------
function operations  = i_defineOperations
% ---------------------------------------------------
% here is where we define the 'builtin' operations

labels   = {'plus',  'minus', 'times',         'divide',     'set to value', 'set to mean',   'custom operation...'};
descrip  = {'added', 'minus', 'multiplied by', 'divided by', 'set',          'mean',          ''         };
func_h   = {@plus,   @minus,  @times,          @rdivide,     @i_equals,      @mean,           []         };
needsarg = [true,    true,    true,            true,         true,           false,           true       ];
browse =   [false    false,   false,           false,        false,          false,           true       ];
percent =  [true,    true,    false,           false,        true,           false,           true       ];
operations = struct('label', {labels}, ...
    'description', {descrip}, ...
    'func', {func_h}, ...
    'needsarg', needsarg, ...
    'browse', browse,...
    'supportspercent', percent);
