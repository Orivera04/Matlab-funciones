function pathlist = path2cell(pathstr)
%PATH2CELL Convert search path to cell array.
%
%   PATH2CELL returns a cell array where each element is a directory
%   in the search path.
%
%   PATH2CELL(MYPATH) converts MYPATH rather than the search path.
%
%   Empty directories are removed, so under UNIX, PATH2CELL('foo::bar')
%   returns {'foo', 'bar'} rather than {'foo', '', 'bar'}.

%   Author:      Peter J. Acklam
%   Time-stamp:  2001-10-18 21:23:19 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(0, 1, nargin));

   % use MATLAB's search path if no input path is given
   if ~nargin
      pathstr = path;
   end

   k = find(pathstr == pathsep);            % find path separators
   k = [0 k length(pathstr)+1];             % find directory boundaries
   ndirs = length(k)-1;                     % number of directories
   pathlist = cell(0);                      % initialize output argument
   for i = 1 : ndirs
      dir = pathstr(k(i)+1 : k(i+1)-1);     % get i'th directory
      if ~isempty(dir)                      % if non-empty...
         pathlist{end+1,1} = dir;           % ...append to list
      end
   end
