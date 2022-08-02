function utildirs = addutils(varargin);
%ADDUTILS Add utility directories to MATLAB's search path.
%
%   ADDUTILS adds the utility directories to MATLAB's search path.  By
%   default, the directories are appended to the search path.  Any input
%   arguments will be passed to ADDPATH so, for instance, ADDUTILS('-BEGIN')
%   will prepend the directories rather than append them.
%
%   DIRS = ADDUTILS will return the list of directories.  In this case the
%   directories are not added to the path.
%
%   This program might be run in several ways.  One ways is to use
%
%      run /path/to/this/file/addutils
%
%   Another way is to use the following, which allows input arguments to be
%   passed to ADDUTILS,
%
%      cwd = cd;
%      cd /path/to/this/file
%      addutils;
%      cd(cwd);

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-03-31 18:21:45 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % default is to append directories
   if ~nargin
      varargin = {'-end'};
   end

   % get location of this mfile
   [path, name, ext, ver] = fileparts(which([mfilename '.m']));

   % get list of files in directory
   files = dir(path);

   % get full path of each utility directory
   dirs  = {};
   for i = 1:length(files)
      if files(i).isdir & length(files(i).name) > 4  ...
            & strcmp(files(i).name(end-3:end), 'util')
         dirs{end+1} = fullfile(path, files(i).name);
      end
   end

   if nargout
      % return list of directories
      utildirs = dirs;
   else
      % append directories to MATLAB's search path
      addpath(dirs{:}, varargin{:});
   end
