function helpOutput = imaqhelp(varargin)
%IMAQHELP Return image acquisition object function and property help.
%
%    IMAQHELP provides a complete listing of image acquisition object
%    functions.
%
%    IMAQHELP('NAME') provides on-line help for the function or property,
%    NAME. 
%
%    IMAQHELP(OBJ) displays a listing of functions and properties for 
%    the image acquisition object, OBJ, along with the on-line help for
%    the object's constructor. OBJ must be a 1-by-1 image acquisition object.
%
%    IMAQHELP(OBJ, 'NAME') displays the help for function or property, NAME,
%    for the image acquisition object, OBJ.
%
%    If NAME is a device-specific property name, OBJ must be provided.
%
%    OUT = IMAQHELP(...) returns the help text in string, OUT.
%
%    When displaying property help, the names in the "See also" section which
%    contain all upper case letters are function names. The names which
%    contain a mixture of upper and lower case letters are property names.
%
%    When displaying function help, the "See also" section contains only 
%    function names.
%
%    Example:
%       % General function and property help.
%       imaqhelp('videoinput')
%       out = imaqhelp('videoinput.m');
%       imaqhelp set
%       imaqhelp LoggingMode     
%
%       % Property help with device-specific information.
%       vid = videoinput('dt', 1);
%       src = getselectedsource(vid);
%       imaqhelp(vid, 'TriggerType')
%       imaqhelp(src, 'FrameRate')
% 
%    See also IMAQDEVICE/PROPINFO.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:58 $

if nargin > 2
    errID = 'imaq:imaqhelp:tooManyInputs';
    error(errID, privateMsgLookup(errID));
end

% Find the directory where the toolbox is installed.
imaqRoot = which('imaqmex.dll', '-all');
imaqRoot = fileparts(imaqRoot{1});

% Initialize variables.
pathname = '';
ext = '';
name = '';
path = '';
maybeProp = false;
objectType = '';
obj = [];

switch nargin
case 0
	% Return Contents help.
    if nargout==0,
        help(imaqRoot);
    else
        helpOutput = help(imaqRoot);
    end
	return;
case 1
	% Determine if the first input is an object or a string.
	name = varargin{1};
	
	if ischar(name)		
		% Need to determine if a path was specified to the name.
		% Ex. imaqhelp imaqdevice/set
		[path,name,ext] = fileparts(name);
		
		% Determine if M extension was provided.
        extcmp = ~localStrCmp(ext, '.m');
		
        % There's an extension, but it's not ".m"!
		if ~isempty(ext) && extcmp, 
			% Ex. imaqhelp videoinput.SelectedSource 
			path = name;
			name = ext(2:end);
			ext = '';
			maybeProp = true;
		end
		
		% Determine if just a name was provided.
		if isempty(path) && isempty(ext)
            % Ex. imaqhelp SelectedSource
            % Ex. imaqhelp set
			maybeProp = true;
		end          
		
		if isempty(path)
			% Get the location of all name files on the MATLAB path.
			allpaths = which(name, '-all');
			
			% Loop through and check if one of the paths begins with
			% the toolbox's root directory.
			for i = 1:length(allpaths)
				index = findstr(imaqRoot, allpaths{i});
				if ~isempty(index)
					% File found, store full pathname.
					pathname = allpaths{i};
					break;
				end
			end 			
		else
			% Path is not empty. 
			pathname = localFindPath(name, path, imaqRoot);
		end 
	else
		% Error checks.
        if ~(isa(name, 'imaqdevice') || isa(name, 'imaqchild'))
            % Verify that the first input is an image acquisition object.
            errID = 'imaq:imaqhelp:firstStrObj';
            error(errID, privateMsgLookup(errID));
        elseif (length(name) > 1)
            % Verify size of first input.
            errID = 'imaq:imaqhelp:OBJ1x1';
            error(errID, privateMsgLookup(errID));
        elseif ~isvalid(name)
            % Object is invalid.
            errID = 'imaq:imaqhelp:invalidOBJ';
            error(errID, privateMsgLookup(errID));
        else
            % Ex. imaqhelp(obj)
            % Ex. out = imaqhelp(obj)
            % Return the object's Contents file.
			% Create output - either to command line or to output variable.
			name = class(name);			
			switch nargout
			case 0
				help([imaqRoot filesep name filesep 'Contents.m']);
                help([imaqRoot filesep name filesep name]); 
			case 1
				helpOutput = [help([imaqRoot filesep name filesep 'Contents.m']),...
                        help([imaqRoot filesep name filesep name])];
			end
			return;
		end   
	end 
case 2
	% Initialize variables.
	obj = varargin{1};
	name = varargin{2};
	maybeProp = true;
	
    % Error checks.
	if ~ischar(name)
        % Make sure second input is a string.
        errID = 'imaq:imaqhelp:invalidSecondArg';
        error(errID, privateMsgLookup(errID));
    elseif ~(isa(obj, 'imaqdevice') || isa(obj, 'imaqchild'))
        % Verify that the first input is an image acquisition object.
        errID = 'imaq:imaqhelp:firstObj';
        error(errID, privateMsgLookup(errID));
    elseif length(obj) > 1
        % Verify size of first input.
        errID = 'imaq:imaqhelp:OBJ1x1';
        error(errID, privateMsgLookup(errID));
    elseif ~isvalid(obj)
        % Object is invalid.
        errID = 'imaq:imaqhelp:invalidOBJ';
        error(errID, privateMsgLookup(errID));
    else
        % Ex. imaqhelp(obj, 'set')
        % Ex. out = imaqhelp(obj, 'VideoResolution')
        path = class(obj);
		objectType = lower(get(varargin{1}, 'Type'));
		pathname = localFindPath(name, path, imaqRoot);
	end      
end

% Return help.
if ~isempty(pathname)
	% Special case for imaqdevice.m - Only want to output the Contents 
	% and not the help since it's not a true constructor.
	if (strcmpi(name, 'imaqdevice') || strcmpi(name, 'imaqchild'))
		switch nargout
		case 0
			help([imaqRoot filesep name filesep 'Contents.m'])
		case 1
			helpOutput = help([imaqRoot filesep name filesep 'Contents.m']);
		end
		return;
	end

	% Check if name is a directory.  If yes, need to output Contents help.
    isdir = false;
	if (localIsDir(name, imaqRoot) && isempty(ext))
		isdir = true;
		switch nargout
		case 0
			help([imaqRoot filesep name filesep 'Contents.m'])
		case 1
			helpOutput = help([imaqRoot filesep name filesep 'Contents.m']);
		end
	end
	
	% Create output for the function name provided either to  
    % command line or to output variable.
	switch nargout
	case 0
		help(pathname);
	case 1
		if isdir
			helpOutput = [helpOutput help(pathname)];
		else
			helpOutput = help(pathname);
		end
	end
elseif maybeProp
    % A property may have been provided. Check to see if it is.
    try
        out = localSearchProp(obj, name, imaqRoot);
    catch
        rethrow(lasterror);
    end
    if isempty(out)
        switch nargin
            case 1
                % No help, return a suggestion.
                out = sprintf('%s\n%s ''%s''.\n',...
                    'Use IMAQHELP(OBJ, ''Name'') for properties containing device specific attributes.',...
                    'No help for image acquisition function or property:', ...
                    varargin{1});
            case 2
                % OBJ already provided, we have to error.
                errID = 'imaq:imaqhelp:invalidFcnProp';
                errStr = privateMsgLookup(errID);
                error(errID, [errStr '''' objectType '.' name '''.']);
        end
    end
    
    % Create output - either to command line or to output variable.
    switch nargout
        case 0
            fprintf(['\n' out '\n'])
        case 1
            helpOutput = out;
    end   
else
    % Not a function - error.
    errID = 'imaq:imaqhelp:invalidFcn';
    errStr = privateMsgLookup(errID);
	switch nargin
	case 1
        error(errID, [errStr '''' varargin{1} '''.']);
	case 2
        error(errID, [errStr '''' path filesep name '''.']);
	end   
end

% ********************************************************************
% Search for a property and return help for it if found.
function helpTxt = localSearchProp(obj, name, imaqRoot)

% Just query the object for it's help.
helpTxt = '';
if ~isempty(obj),
    uddobj = imaqgate('privateGetField', obj, 'uddobject');
    helpTxt = uddobj.prophelp(name);
    return;
end

% Otherwise make sure package and core classes have been registered.
packageName = 'imaq';
imdf = fullfile(imaqRoot, 'private', 'imaqmex.imdf');
imaqmex('imaqregister', imdf);
package = findpackage(packageName);

% Use the core classes as the search context.
classes = get(package, 'Classes');
desc = get(classes, 'Name');
uddClass = classes( find(strcmp(desc, 'imaqparent')) );

% Search parent level first, then child level.
ithClass = 1;
while isempty(helpTxt) && (ithClass<=length(uddClass)),
    % Evaluate our p.class.method(...)
    udClassName = uddClass(ithClass).Name;
    fcnCall = sprintf('%s.%s.prophelp(name)', packageName, udClassName);
    helpTxt = eval(fcnCall);
    ithClass = ithClass + 1;
end

% Final try...check to see if this is a special prop (i.e.
% a common prop with adaptor specific defaults).
if isempty(helpTxt),
    [helpTxt, errStruct] = localGetH1Line(name, imdf);
    if ~isempty(errStruct),
        rethrow(errStruct);
    end
end

% ********************************************************************
% Compare two strings case insensitively if on the PC, case 
% sensitive otherwise.
function out = localStrCmp(str1, str2)

% Case insensitive file/dir comparison for Windows 95/98.
if ispc,
	out = strcmpi(str1, str2);
else
	out = strcmp(str1, str2);
end

% ********************************************************************
% Determine if the name specified is a directory.
function out = localIsDir(name, imaqRoot)

% Initialize.
out = true;
tlbxcmp = localStrCmp(name, 'imaq');
ampcmp = ~localStrCmp(name(1), '@');

% If the name is not the toolbox check some more.
if ~tlbxcmp,
    % Add the @ to the name if it isn't included.
    if ampcmp,
        name = ['@' name];
    end
    
    % Get all the directory names in the toolbox.
    d = dir(imaqRoot);
    names = {d.name};
    dirnames = {names{find([d.isdir])}};
    
    % Determine if name is one of the directories in the toolbox.
    if ~any(localStrCmp(name, dirnames))
        out = false;
    end
end

% ********************************************************************
% Find the pathname when the object directory and method are given.
function pathname = localFindPath(name, path, imaqRoot)

% Path is not empty.  The file can be in one of four locations.
% imaqRoot
% imaqRoot\@imaqdevice, imaqRoot\@imaqchild
% imaqRoot\@videoinput
% imaqRoot\private

% Initialize variables.
pathname = '';
allpaths = which(name, '-all');

% Case insensitive file/dir comparison for Windows 95/98.
if ispc,
	name = lower(name);
end

% Loop through and check if one of the paths begins with the
% toolbox's root directory + specified path.
for i = 1:length(allpaths)	
	% Check imaqRoot
	% Check imaqRoot\@imaqdevice, imaqRoot\@imaqchild
	% Check imaqRoot\@videoinput
	% Check imaqRoot\private
	rootIndex = findstr([imaqRoot filesep name], allpaths{i});
	parentIndex = findstr([imaqRoot filesep '@imaqdevice'], allpaths{i});
	childIndex = findstr([imaqRoot filesep '@imaqchild'], allpaths{i});
	objDirIndex = findstr([imaqRoot filesep '@' path], allpaths{i});
	privIndex = findstr([imaqRoot filesep 'private' filesep name], ...
        allpaths{i});
    
    % If it exists in any of these directories, add the path.
	if ~isempty([rootIndex parentIndex childIndex objDirIndex privIndex])
		pathname = allpaths{i};
	end
end   

% ********************************************************************
% Find the pathname when the object directory and method are given.
function [helpText, errStruct] = localGetH1Line(name, imdf)
% By the time this function is called, the property name provided
% will be pretty unique (i.e. a few characters will have been provided).
% Don't need to worry about name completion, just case sensitivity.

% List of properties that are common to all
% objects, but are not present in the root schemas
% because they must be initialized to adaptor specific 
% defaults.
helpText = '';
errStruct = [];
specialProps = {
    'Source',               '    %s  videosource  (Read-only: always)\n\n%s';
    'VideoResolution',      '    %s  double  (Read-only: always)\n\n%s';
    'DeviceID',             '    %s  [0  2147483647]  (Read-only: always)\n\n%s';
    'NumberOfBands',        '    %s  [0  2147483647]  (Read-only: always)\n\n%s';
    'ROIPosition',          '    %s  double  (Read-only: whileRunning)\n\n%s';
    'ReturnedColorSpace',   '    %s  string  (Read-only: always)\n\n%s';
    'VideoFormat',          '    %s  string  (Read-only: always)\n\n%s';
    'Name',                 '    %s  string  (Read-only: never)\n\n%s'};

% Find the property of interest.
ind = strmatch(lower(name), lower(specialProps(:, 1)));
nFound = length(ind);

% Make sure there was a match.
if nFound==0,
    return;    
elseif nFound>1,
    errStruct.message = sprintf('Ambiguous property: ''%s''.', name);
    errStruct.identifier = 'imaq:imaqhelp:ambiguousProperty';
    return;
end

% Return help text.
propmatch = specialProps{ind, 1};
body = imaqmex('imaqhelp', propmatch, imdf);
helpText = sprintf(specialProps{ind, 2}, upper(propmatch), body);



