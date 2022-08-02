function tpObj = load(varargin)
%LOAD  Load the stored preferences value. return stored prefs if they exist
% otherwise do nothing. 

% Load method accepts folowing cases:
%     load('i960.i960prefs', ['structure'])
%     load('i960', ['structure'])


%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/19 01:16:41 $

if (nargin < 1)
    usage;
    return;
end

fullName = varargin{1};
[packageName, className] = local_translate(fullName);
validatePackageandClass(packageName, className);

% License checking                                                         
MpcObj = 1;                                                                
if needLicense(packageName, className)
    try                                                                        
        MpcObj = slprivate('slchecklicense',['Embedded_Target_' packageName],'quiet');      
    end                                                                        
    if MpcObj == 1                                                             
        error(['Unable to locate a license for Embedded Target for ' packageName]);
    end                                   
end

try
    fullName = [packageName, '.', className];
    groupName = 'TargetPrefs';
    prefName = [packageName, '_', className];
    if ispref(groupName, prefName)
        tpObj = getpref(groupName, prefName);
        if ~isa(tpObj, fullName)
            disp(['Error occurs when trying to access stored preferences.']);
            disp(['This is normally caused if a preference named ' prefName ' already exists in ' groupName ' group']);
            disp(' but it doesn''t match class structure.');
            disp('You can fix the problem using follow command: ');
            disp(['      rmpref(''' groupName ''', ''' prefName ''')']);
            disp(' which will clear existing preference value.');
            error('Class structure mismatch with stored preferences.');
        end
    else 
        disp('No stored preferences exist. Use default value.');
        str = ['tpObj = ', fullName, ';'];
        eval(str);
    end
catch
    usage;
    error(lasterr);
end

switch nargin
    case 1
        return;
    case 2
        try 
            arg2 = varargin{2};
            if strcmp(arg2,'structure')
                % Return a struct taken from this object. 
                % This is needed by TLC.
                tpObj = deepstruct(tpObj);
                %
            else
                error('Second argument must be the string: ''structure'' ');
            end
        catch
            usage;
            error(lasterr);
        end
    otherwise
        usage;
        error('Failure retrieving target preferences');
end  

% depends on input argument, get the correct package and class name.
function [packageName, className] = local_translate(fullName)
if ~ischar(fullName)
    error('First input argument must be a string')
elseif ~isempty(findstr(fullName, '.'))
    [packageName className] = strtok(fullName, '.');
    className = className(2:end);
else
    % no "." exists, we assume class="prefs"
    packageName = fullName;
    className = 'prefs';
end


% validate existence of package.class
function validatePackageandClass(packageName, className)
tpP = findpackage(packageName);
if isempty(tpP)
    error(['Specified target object Package: ', packageName, ' could not be found']);
elseif isempty(tpP.findclass(className))
    error(['Specified target object class: ', className, ', could not be found']);
else
end

% This function will deep convert a UDD object to a struct. It recursively
% decends the UDD field structure attempting to struct each field. Note that
% it uses the new dynamic structure array indexing technique.
function str = deepstruct(obj)
% Empty objects should be turned into
% empty strings or arrays
if isempty(obj)
    if ischar(obj)
        str = obj;
    else
        str = [];
    end
    return;
end
try
    % Attempt to execute the struct command.
    % It will fail if the object is not a UDD
    % object and will fall through to the catch
    str = struct(obj);
    f = fields(str);
    for i=1:length(f)
        str.(f{i}) = deepstruct(str.(f{i}));
    end
catch
    str = obj;
end

% ----------------------------------------------------------
% Abstract: Generate an error message describing correct
% syntax.
function usage
  str1 = ['Usage:  tpObj = RTW.TargetPrefs.load(''<TARGET>'')'];
  str2 = ['        tpObj = RTW.TargetPrefs.load(''<TARGET>'',''structure'')'];
  msg = sprintf([str1,'\n',str2]);
  disp(msg);
  
% check whether this package located inside MATLAB root so it need license
% note: package inside work/test/common directory don't need license.
function answer = needLicense(packageName, className)
answer = 1; % need license by default
% Look for packages on the MATLAB path
w=what(['@' packageName]); % "what" command can't directly find @package/@class path
% in case find more than one class in path
if length(w)>1
    w=w(1);
end
if isempty(w)
    return;
else
    if ~ismember(className, w.classes)
        return;   % "what" command can't directly find @package/@class path
    end
    packagePath = w.path;
    workDir = [matlabroot, filesep, 'work'];
    testDir = [matlabroot, filesep, 'test'];
    commonDir = [matlabroot, filesep, 'toolbox', filesep, 'rtw', filesep, 'targets', filesep, 'common'];
    if strncmp(packagePath, workDir, length(workDir))
        % This package is in MATLABROOT/work
        % ==> Treat it as a user-defined package
        answer = 0; 
        return
    elseif strncmp(packagePath, commonDir, length(commonDir))
        % This package is in MATLABROOT/toolbox/rtw/targets/common
        % ==> Don't check license for common area class
        answer = 0;
        return        
    elseif strncmp(packagePath, testDir, length(testDir))
        % This package is in MATLABROOT/test
        % ==> Don't check license for test area class
        answer = 0;
        return                
    elseif strncmp(packagePath, matlabroot, length(matlabroot))
        % This package is in MATLABROOT
        % ==> Treat it as a built-in package
        answer = 1;
        return
    else  % outside MATLAB
        answer = 0;
        return
    end
end
  