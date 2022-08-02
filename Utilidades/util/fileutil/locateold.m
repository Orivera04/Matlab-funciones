function locations = locate(varargin)
%LOCATE Locate one or more files in the search path.
%
%   LOCATE FILEGLOB prints a list of all MATLAB files on the path that
%   match FILEGLOB. Private subdirectories are also searched.
%
%   LIST = LOCATE(FILEGLOB) returns a list (cell array) of the files.  The
%   list is not displayed.
%
%   Multiple filegobs may be given, e.g., LOCATE('*.m', '*.dll').
%
%   Note that the globbing is done by MATLAB and not by the operating
%   system.
%
%   Examples:
%
%     locate *plot.m    - Find all files ending with 'plot.m'.
%     locate im*        - Find all files starting with 'im'.
%
%   See also DIR, SYSGLOB.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-03-31 18:21:24 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, Inf, nargin));

   dirs = path2cell;                % Convert path to list.

   display = 1;
   if nargout                       % If there are output arguments...
      locations = {};               % ...initialize output list...
      display = 0;                  % ...and don't display results.
   end

   while length(dirs)               % While there are unprocessed dirs...

      directory = dirs{1};          % Get first directory...
      dirs = dirs(2:end);           % ...and remove it from the list.

      % Initialize the unique list of files matching in this directory.
      found_unique = {};
      for i = 1:nargin

         % Get the list of files matching this fileglob and keep only
         % the file name.
         found = dir(fullfile(directory, varargin{i}));
         found = { found.name };

         % Append only the file names that aren't already in the list.
         for j = 1:length(found)
            if ~any(strcmp(found_unique, found{j}))
               found_unique{end+1} = fullfile(directory, found{j});
            end
         end

      end

      % Append list of files found in this directory to the main list or
      % display the files if no output is wanted.
      if ~isempty(found_unique)
         if nargout
            locations = [ locations(:) ; found_unique(:) ];
         else
            fprintf('%s\n', found_unique{:});
         end
      end

      % If this directory has a private subdirectory, look there too.
      subdirectory = fullfile(directory, 'private');
      if exist(subdirectory, 'dir')
         dirs = { subdirectory , dirs{:} }';
      end

   end
