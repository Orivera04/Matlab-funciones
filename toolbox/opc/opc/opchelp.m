function varargout = opchelp(varargin)
%OPCHELP Return OPC Toolbox function and property help.
%   OPCHELP displays a complete listing of OPC Toolbox functions with a
%   brief description of each function.
%
%   OPCHELP('Name') displays on-line help for the function or property,
%   Name. If Name is an OPC Toolbox class, a complete listing of the
%   functions and properties for that class is displayed with a brief
%   description of each. The on-line help for the object constructor for
%   that class is also displayed. If Name is an OPC Toolbox class with a
%   .m extension, then only the on-line help for the object constructor is
%   displayed.
%
%   You can display object-specific function information by specifying
%   Name to be object/function. For example, to display the on-line help
%   for the data access object's CONNECT function, Name would be
%   'opcda/connect'.
%
%   You can display object-specific property information by specifying
%   NAME to be object.property. For example, to display the on-line help
%   for the data access object's Status property, Name would be
%   'opcda.Status'.
%
%   Out = OPCHELP('Name') returns the help text in string, Out.
%
%   OPCHELP(Obj) displays a complete listing of functions and properties
%   for the OPC Toolbox object Obj, along with the on-line help for the
%   object's constructor.
%
%   OPCHELP(Obj,'Name') displays the help for function or property, Name,
%   for the OPC Toolbox object, Obj.
%
%   Out = OPCHELP(Obj,'Name') returns the help text in string, Out.
%
%   When displaying property help, the names in the "See also" section
%   that contain all upper case letters are function names. The names that
%   contain a mixture of upper and lower case letters are property names.
%
%   When displaying function help, the "See also" section contains only
%   function names.
%
%   Examples
%       opchelp
%       daHelp = opchelp('opcda')
%       opchelp set
%       opchelp opcda/disconnect
%       da = opcda('localhost','Matrikon.OPC.Simulation');
%       opchelp(da)
%       timeoutHelp = opchelp(da, 'Timeout');
%       opchelp(da, 'Status');
%
%   See also OPCROOT/PROPINFO.

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.8 $  $Date: 2004/03/24 20:43:36 $

try
    opcmex version;
catch
    rethrow(lasterror);
end

error(nargchk(0,2,nargin))
if nargout > 1,
   rethrow(mkerrstruct('opc:opchelp:inputstoomany'))
end



% Find the directory where the toolbox is installed.
opcroot = which('opcmex.dll', '-all');
opcroot = fileparts(opcroot{1});

switch nargin
case 0
   help(opcroot);
   return
case 1
   % Initialize variables.
   str = varargin{1};
   fullpath = {''};
   isdir = [];
   parent = '';
   
   % Check first argument to see if it is a OPC object. 
   if ~ischar(str)
      if isa(str, 'opcroot')
         path = '';
         name = class(str);
         ext = '';
         isdir = 1;
      else
         rethrow(mkerrstruct('opc:opchelp:firstarg', 'The first input argument must be a string or an OPC object.'));
      end
   else
      % Determine if user specified an extension and/or a path.
      [path,name,ext] = fileparts(str);
   end
   
   % Determine if the name specified is a directory.
   if isempty(isdir)
      isdir = localIsDir(lower(name),opcroot);
   end
   
   % If the name is a directory, fullpath contains the full path to the
   % contents help and constructor help (if it is not opc).
   % Ex. "opchelp opcda" or "opchelp dagroup"
   if isdir && isempty(ext)
      if strcmpi(name, 'opc')
         fullpath = {opcroot};
      elseif strcmp(name(1), '@')
         fullpath = {[opcroot filesep name]};
      else
         fullpath = {[opcroot filesep name]};
         fullpath = {fullpath{:}, [opcroot filesep '@' name filesep name '.m']};
      end
   end
   
   % If the extension is not a .m, a property was provided and privatePropDesc
   % is called.  If privatePropDesc fails, property was invalid.
   % Ex. "opchelp opcda.Logging"
   if ~isempty(ext) && ~strcmp(ext, '.m') 
      try
         [errflag, out] = privatePropDesc(ext(2:end),name);
      catch
         rethrow(mkerrstruct('opc:opchelp:invalidarg', ['Invalid OPC function or property: ''' varargin{1} '''.']));
      end
      % Error if privatePropDesc errored expectedly.
      if errflag
         rethrow(mkerrstruct('opc:opchelp:properror', lasterr))
      elseif nargout == 0
         fprintf('\n');
         fprintf('%s', out);
         fprintf('\n');
      else
         varargout{1} = out;
      end
      return
   end
   
   % Determine the full path, if one was not provided.
   if isempty(fullpath{1})
      % Get all the locations of the file.
      temppath = which(name, '-all');
      % Determine the parent directory - path:analoginput, parent:daqdevice.
      if ~isempty(path)
         parent = localFindParent(path);
      end
      % Loop through temppath and find the requested path.
      for i = 1:length(temppath)
         % Ex. daqhelp analoginput/getsample.  opcda/connect
         if ~isempty(path) && any(findstr([opcroot '\@' path], temppath{i}))
            fullpath = temppath(i);
            break;
         elseif any(findstr([opcroot '\' name], temppath{i}))
            fullpath = temppath(i);
            break;
         end
         
         % Ex. daqhelp analoginput/set opcda/set
         if ~isempty(parent) && any(findstr([opcroot '\@' parent], temppath{i}))
            fullpath = temppath(i);
            break;
         elseif any(findstr([opcroot '\' name], temppath{i}))
            fullpath = temppath(i);
            break;
         end

         % Ex. opchelp isvalid
         if isempty(path) && (any(findstr([opcroot '\@opcda\' name], temppath{i})) ||...
               (any(findstr([opcroot '\@dagroup\' name], temppath{i}))) || ...
               (any(findstr([opcroot '\@daitem\' name], temppath{i}))) || ...
               (any(findstr([opcroot '\private\' name], temppath{i}))))
            fullpath = temppath(i);
            break;
         end
         
         % Ex. opc private\save
         if any(findstr('private', path))
            if (any(findstr([opcroot '\private\' name], temppath{i})))
               fullpath = temppath(i);
               break;
            end
         end
         
         % Ex. daqhelp daqdemos\daqscope
         if any(findstr('opcdemos', path))
            if (any(findstr([opcroot '\opcdemos\' name], temppath{i})))
               fullpath = temppath(i);
               break;
            end
         end

         % Ex. daqhelp daq\@daqdevice\isvalid
         if any(findstr('opc\', path))
            if (any(findstr([opcroot(1:end-3) path '\' name], temppath{i})))
               fullpath = temppath(i);
               break;
            end
         end
         
         % Ex. daqhelp analoginput.m opcda.m?
         if isempty(path) && isempty(parent)
            if (any(findstr(opcroot, temppath{i})))
               fullpath = temppath(i);
               break;
            end
         end
      end
   end
case 2
   % Error if the first input is not an abstract opc object.
   if ~isa(varargin{1}, 'opcroot') 
      % If the input is not a string, error with the class name.
      if ~ischar(varargin{1})
         varargin{1} = class(varargin{1});
      end
      if ~ischar(varargin{2})
         varargin{2} = class(varargin{2});
      end
      rethrow(mkerrstruct('opc:opchelp:invalidarg', ['Invalid OPC function or property: ''' varargin{1} '',...
            ' ' varargin{2} '''.']));
   end
   
   if ~ischar(varargin{2})
      rethrow(mkerrstruct('opc:opchelp:secondarg', 'The second input argument must be a string.'));
   end

   
   % Initialize variables.
   path = class(varargin{1});
   name = varargin{2};
   
   % Find the fullpath.  First assume the name is not inherited.  If that
   % fails, assume the name is inherited.
   % Ex. "daqhelp(ai, 'Peekdata')",  "daqhelp(ai, 'set')"
   fullpath = {which([path '\' name])};
   if isempty(fullpath{1})
      parent = localFindParent(path);
      fullpath = {which([parent '\' name])};
   end
   
   % Determine if function is in the daq directory.
   % Ex. "daqhelp(ai, 'daqread')"
   if isempty(fullpath{1})
      fullpath = {which([opcroot filesep name])};
   end
end

% If path is empty either NAME is a property or NAME is invalid.
if isempty(fullpath{1}) && (nargin == 2 || (nargin == 1 && isempty(path)))
    % Ex. "daqhelp Logging", "daqhelp(ai, 'Logging')"
    try
        % TO DO [errflag, out] = daqgate('privatePropDesc',name,path);
        [errflag, out] = privatePropDesc(name,path);
        %try to determine if the propertiy is a valid member of input
    catch
        if isempty(path)
            rethrow(mkerrstruct('opc:opchelp:invalidarg', ['Invalid OPC function or property: ''' name '''.']));
        else
            rethrow(mkerrstruct('opc:opchelp:invalidarg', ['Invalid OPC function or property: ''' path '.' name '''.']));
        end
    end
    % Error if privatePropDesc errored expectedly.
    if errflag
        rethrow(mkerrstruct('opc:opchelp:properror', lasterr));
    elseif nargout == 0
        fprintf('\n');
        fprintf('%s', out);
        fprintf('\n');
    else
        varargout{1} = out;
    end
    return
elseif isempty(fullpath{1}) && nargin == 1
    % Ex. "daqhelp analoginput/Logging"
   rethrow(mkerrstruct('opc:opchelp:invalidarg', ['Invalid OPC function or property: ''' varargin{1} '''.']));
else
   % If the name is opcmex, the fullpath may be to the .dll.  Therefore
   % need to replace the .dll with a .m so the correct help is called.
   if strcmp(name, 'opcmex')
      fullpath = strrep(fullpath, '.dll', '.m');
   end
   % Call help on each fullpath string.
   outTemp = [];
   for i = 1:length(fullpath)
      out = help(fullpath{i});
      if nargout == 0
         fprintf('\n');
         fprintf('%s', out);
         fprintf('\n');
      else
         outTemp = [outTemp out];
      end
   end
   if nargout == 1
      varargout{1} = outTemp;
   end
end

% ********************************************************************
% Determine if the name specified is a directory.
function out = localIsDir(name,opcroot)

% If the name is opc return 1.
if strcmp(name, 'opc')
   out = 1;
   return
end

% Add the @ to the name if it isn't included.
if ~strcmp(name(1), '@')
   name = ['@' name];
end

% Get all the directory names in the OPC toolbox.
d = dir(opcroot);
dirnames = {d([d.isdir]).name};

% Determine if name is one of the directories in the toolbox.
out = any(strcmp(name, dirnames));

% ********************************************************************
% Determine the parent of the pathname specified.
function out = localFindParent(name)

% Initialize variables.
out = '';

% If the name is opc return nothing.
if strcmp(name, 'opc') || isempty(name)
   out = '';
   return;
end

%  Remove the @ to the name if its included.
if strcmp(name(1), '@')
   name = name(2:end);
end

if any(strcmpi(name, {'opcda','dagroup','daitem'}))
   out = 'opcroot';
end


      
   
         

   
   

