function path2file(file, pathstr)
%PATH2FILE Write the Matlabpath to a file, one directory on each line.
%
%   PATH2FILE FILE writes Matlab's seach path to the file FILE with one
%   directory on each line.
%
%   PATH2FILE(FILE, MYPATH) writes the specified path rather than the search
%   path.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:06:17 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, 2, nargin));

   % Use Matlab's search path if no input path is given.
   if nargin < 2
      pathstr = path;
   end

   dirs = path2cell(pathstr);
   n = length(dirs);

   fid = fopen(file, 'wt');
   if fid < 0
      error([file ': Unable to open file "' file '" for writing.']);
   end
   for i = 1:n
      dir = pathstr( k(i)+1 : k(i+1)-1 );   % Get i'th directory.
      if ~isempty(dir)                      % If non-empty...
         fprintf(fid, dir);                 % ...append to list.
      end
   end
   fclose(fid);
