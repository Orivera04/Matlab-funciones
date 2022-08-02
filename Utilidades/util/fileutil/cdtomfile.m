function directory = cdtomfile(file)
%CDTOMFILE Change working directory to where a specified m-file is located.
%
%   CDTOMFILE FILE or CDTOMFILE(FILE) changes the current working directory to
%   the directory where FILE is located.  If FILE is a directory, CDTOMFILE
%   acts like CD and makes FILE the current working directory.  CDTOMFILE, by
%   itself, prints out the current directory.
%
%   WD = CDTOMFILE returns the current directory as a string.
%
%   See also CD, PWD.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 12:55:24 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   nargsin = nargin;
   error(nargchk(0, 1, nargsin));

   % if an input argument was specified
   if nargsin

      % if argument is a file on the path
      if exist(file, 'file')
         location = which(file);            % get full path to file
         if strcmp(location, 'built-in')    % if built-in
            location = which([file '.m']);  %   append '.m' and retry
         end
         dir = fileparts(location);         % extract path

      % if argument is a directory
      elseif exist(file, 'dir')
         dir = file;

      % otherwise
      else
         error([file ': No such file or directory.']);
      end

   % if no input argument was specified
   else
      dir = cd;
   end

   % if output argument specified, return directory
   if nargout
      directory = dir;

   % if no output argument specified, change working directory
   else
      cd(dir);
   end
