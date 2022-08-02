function print(arg1,arg2,arg3,arg4,arg5)
%PRINT  Print graph or save graph to file.
%       PRINT <filename> saves the current Figure window as PostScript. If
%       a filename is specified, the output is written to the designated file,
%       overwriting it if it already exists. If the specified filename does not
%       include an extension, an appropriate one is appended.
%       If the filename is omitted, the Figure is sent directly to the
%       printer as specified in PRINTOPT.
%
%       PRINT <filename> -f<figure handle> prints the specified figure.
%       PRINT <filename> -s<system name> prints the specified SIMULINK
%       	system.
%
%       Syntax: PRINT [ -ddevice] <filename>
%
%       Available PostScript devices are:
%          -dps    - PostScript for black and white printers
%          -dpsc   - PostScript for color printers
%          -dps2   - Level 2 PostScript for black and white printers
%          -dpsc2  - Level 2 PostScript for color printers
%
%          -deps   - Encapsulated PostScript (EPSF)
%          -depsc  - Encapsulated Color PostScript (EPSF)
%          -deps2  - Encapsulated Level 2 PostScript (EPSF)
%          -depsc2 - Encapsulated Level 2 Color PostScript (EPSF)
%
%       Additional built-in devices are:
%          -dmfile - generate M-file that will re-create Figure
%
%       Available Windows device options are:
%          -dwin    - Send figure to currently installed printer in monochrome
%          -dwinc   - Send figure to currently installed printer in color
%          -dmeta   - Send figure to clipboard in Metafile format
%          -dbitmap - Send figure to clipboard in bitmap format
%          -dsetup  - Bring up Print Setup dialog box, but do not print
%
%       Other options are:
%          -v       - Verbose mode, bring up the Print dialog box
%                     which is normally suppressed.
%
%       See also PRINTOPT, ORIENT.

%       Modified 22-June-94
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%
% List of all supported devices used for input validation.
%
% The first column contains the device name, the second column contains the
% default filename extension, the third column indicates what type of output
% device is employed, and the fourth indicates Monochrome or Color device.
%
device_table = [
% Postscript device options
	'ps      '      'ps '   'PS'	'M' 
	'psc     '      'ps '   'PS'	'C'
	'ps2     '      'ps '   'PS'	'M'
	'ps2c    '      'ps '   'PS'	'C'
	'psc2    '      'ps '   'PS'	'C'
	'eps     '      'eps'   'EP'	'M'
	'epsc    '      'eps'   'EP'	'C'
	'eps2    '      'eps'   'EP'	'M'
	'eps2c   '      'eps'   'EP'	'C'
	'epsc2   '      'eps'   'EP'	'C'
% Other built-in device options
    'mfile   '      '   '   'BI'    'C'
% Microsoft Windows-specific options
	'win     '      '   '   'MW'	'M'
	'winc    '      '   '   'MW'	'C'
	'meta    '      'wmf'   'MW'	'C'
	'bitmap  '      'bmp'   'MW'	'C'
	'setup   '      '   '   'MW'	'M'
];

options = [
	'v'
];

devices = device_table(:, 1:8);
extensions = device_table(:, 9:11);
classes = device_table(:, 12:13);
colorDevs = device_table(:, 14 );

comp = computer;
printplot = 0;
num_opt_args = 0;
filename = [];
prtSim = 0;
verbose = 0;
dev = [];

% Get current figure, but don't create one, like gcf would, if none yet.
window = get( 0, 'Children' );
if ~isempty( window )
	window = window(1);
end

for i=1:nargin
	cur_arg = eval(['arg', num2str(i)]);

	% Filename
	if (cur_arg(1) ~= '-')
		if ~isstr( cur_arg )
			error( 'Filename argument is not a string.' )
		end
		if isempty(filename)
			filename = cur_arg;
		else
			error( [ 'Multiple inputs that look like filenames: ''' ...
					filename ''' and ''' cur_arg '''' ] );
		end

	% Device name
	elseif (cur_arg(2) == 'd')
		%
		% verify device given is supported, and only one given
		% device proper starts after '-d', if only '-d'
		% we echo out possible choices
		%
		if ~isempty( dev )
			error( [ 'Multiple inputs that look like device names: ''' ...
					dev ''' and ''' cur_arg ''''] );
		end

		wasError = 0;
		if ( size(cur_arg, 2) > 2 )
			wasError = 1;
			% Find index of device in table, used a lot later on.
			for devIndex = 1:size(devices,1)
				if strcmp( cur_arg(3:size(cur_arg,2)), ...
							deblank(devices(devIndex,:)) )
					dev = deblank( cur_arg );
					break;
				end
			end
			if isempty(dev)
				disp('Illegal device specified.');
			end
		end
		if isempty(dev)
			disp('Supported devices are:')
			if (comp(1:2) =='PC')
				disp(devices);
			else
				% Find first non PC specific device
				for i = size( classes, 1 ) : -1 : 1
					if ~strcmp( classes(i,:), 'MW' )
						break;
					end
				end
				% Now list only the non-PC-specific devices
				disp( devices( 1 : i, : ) )
			end
			if wasError
				error(' ');
			else
				return;
			end
		end

	% SIMULINK system name
	elseif (cur_arg(2) == 's')
		if ( exist('open_system') ~= 5 )
			error('SIMULINK is not available in this version of MATLAB.');
		end
		window = cur_arg( 3:length(cur_arg) );
		if isempty( window )
			% Print current system by default, if one is open.
			% Put inside eval so Windows and MAC MATLAB only can use this too.
			window = eval('get_param');
			slashIndices = find( '/' == window );
			if ~isempty( slashIndices )
				% Need just the window name, not the lineage of the composite block.
				window = window( slashIndices( length(slashIndices) )+1 : length( window ) );
			end
			
			if isempty( window )
				error('No SIMULINK system to print with -s option.');
			end
		end
		prtSim = 1;

	% Handle Graphics figure handle
	elseif (cur_arg(2) == 'f')
		window = cur_arg( 3:length(cur_arg) );
		if isempty( window )
			% Get current figure, but don't create one, like gcf would, if none yet.
			window = get( 0, 'Children' );
			if ~isempty( window )
				window = window(1);
			end
		else
			%Must be, or at least should be, a figure handle integer.
			window = eval( window );
		end

	% Other options
	else
		%
		% verify any given options are supported
		%
		if size(cur_arg,2) > 1
			op = cur_arg(2:size(cur_arg,2));

			if (strcmp(op, 'v'))
				verbose = 1;
				num_opt_args = num_opt_args + 1;
				eval(['opt_arg', num2str(num_opt_args), ' = cur_arg;']);
			else	
				error(['Illegal option ''' op ''' given.'])
			end
		end
	end
end

% If no window requested, and none to act as default, error out.
if isempty( window )
	error('No Figure to print.');
end

% If no device given, use default from PRINTOPT
if isempty( dev )

	% Find device name in list of devices to set the
	% appropriate filename extension.
	[lprcmd, defaultDevice] = printopt;
	% skip '-d'
	d = defaultDevice( 3 : size(defaultDevice,2) );
	for devIndex = 1 : size(devices,1)
		if strcmp( devices(devIndex, 1 : size(d,2)), d )
			dev = defaultDevice;
	   		break;
		end

	end
	if isempty( dev )
		error(['PRINTOPT specifies an unknown device type '''...
			defaultDevice ''''])
	end
end

devClass = classes(devIndex, :);
if strcmp(devClass, 'MW' )
	if ~strcmp( comp, 'PCWIN' )
		error( ['Can only use Windows device ''' dev ''' on a Windows machine.'])
	end
end

extension = deblank(extensions( devIndex, : ));

if ~prtSim
	% Create Handle Graphics objects on screen if not already there.
    drawnow
end

tellUserFilename = 0;
if isempty(filename)
	%EPS files shouldn't go to printer, but should generate file on disk
	if ( devClass == 'EP' )
		if prtSim
			filename = window;
		else
			filename = [ 'figure' int2str( window ) ];
		end
		tellUserFilename = 1;
	else
		% Generate a unique name for temporary file
		if (devClass ~= 'MW')
			filename = tempname;
			printplot = 1;
		end
	end
else
	% Hack, if user specifies a filename while device is -dwin
	% or -dwinc, either because the user gave that device or, more
	% likely, it's the default, and since the filename is useless
	% with Windows driver anyway, we'll assume the user really wants
	% a PostScript file. This is because 'print foo' is easier
	% to type then 'print -dps foo' and probably more commonly
	% meant if a filename is given.
	if (devClass == 'MW') & (strcmp( dev, '-dwin' ) | strcmp( dev, '-dwinc' ))
		if ( colorDevs(devIndex ) == 'C' )
			dev = '-dpsc';
		else
			dev = '-dps';
		end
		extension = 'ps';
	end
end

% Append appropriate extension to filename if it doesn't have
% one, and we've determined a good one.
if ~any(filename == '.') & ~isempty( extension ) & ~isempty( filename )
	filename = [ filename '.' extension ];
end

if tellUserFilename
	disp( 'Encapsulated PostScript files can not be sent to printer.' );
	disp( [ 'File saved to disk under name ''' filename '''.' ] );
end

if (strcmp('setup', dev(3:size(dev,2))))
	if isempty( filename )
		filename = 'Untitled';
	end
    hardcopy( window , filename, dev)
    return
end

if (comp(1:3) =='MAC')
	if (printplot & verbose)
		printplot = macprint(window, filename, prtSim, 0);
		if ~printplot
			return;
		end
	end

	if ((devClass == 'EP' | devClass == 'PS') & ~printplot)
		cur_arg = '-previewmac';
		num_opt_args = num_opt_args + 1;
		eval(['opt_arg', num2str(num_opt_args), ' = cur_arg;']);
	end
end

if ~( prtSim | strcmp( '-dmfile', dev ) )
	% Invert B&W color properties of Figure and child objects
	if strcmp( 'on', get(window,'InvertHardcopy') )
		invertedColor = 1;
		cinvert( window );
	else
		invertedColor = 0;
	end

	% if not color, set lines and text to a color contrasting background
    if ( colorDevs(devIndex ) == 'M' )
		lineTextColors = blt( window, get(window,'color') );
	else
		lineTextColors = [];
	end
end     % ~prtSim

if isempty(filename)
	filename = '';
end

if (num_opt_args == 0)
	hardcopy( window, filename, dev)
elseif (num_opt_args == 1)
	hardcopy( window, filename, dev, opt_arg1)
elseif (num_opt_args == 2)
	hardcopy( window, filename, dev, opt_arg1, opt_arg2)
elseif (num_opt_args == 3)
	hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3)
elseif (num_opt_args == 4)
	hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3, opt_arg4)
elseif (num_opt_args == 5)
	hardcopy( window, filename, dev, opt_arg1, opt_arg2, opt_arg3, opt_arg4, opt_arg5)
end


if ~prtSim
	% set color of lines and text back to what they were
	if ~isempty( lineTextColors )
		blt( window, get(window,'color'), lineTextColors);
	end

	% Invert back the W&B color properties of Figure and child objects
	if invertedColor
		cinvert( window );
	end

	% Reconstruct figure the way it was.
	if ((invertedColor | ~isempty( lineTextColors )) & ~strcmp(dev, '-dbitmap'))
		%
		% Discard all the object invalidations that occured as a result of
		% changing colors. All objects are back to their previous state,
		% but they don't know that.
		%
		drawnow('discard')
	end
end % ~prtSim

if (printplot)
	lprcmd = printopt;

	if (comp(1:2) == 'PC')
		cmd = sprintf(lprcmd, filename);
		dos(cmd);
		delete(filename);
	elseif (comp(1:3) =='MAC')
		macprint(window, filename, prtSim,1);
	else
		unix([lprcmd ' ' filename]);
	end
end


