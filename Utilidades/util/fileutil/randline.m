function [line, linenum] = randline(file)
%RANDLINE Pick a random line from a file.
%
%   LINE = RANDLINE(FILE) returns a random line from the file FILE.  All lines
%   in FILE are equally likely to be returned.
%
%   [LINE, LINENUM] = RANDLINE(FILE) also returns the line number correspoding
%   to the line LINE.
%
%   See also RAND.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-05 19:11:34 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % see if the file exists
   if ~exist(file, 'file')
      error([file, ': No such file.']);
   end

   % open file for reading
   [fid, msg] = fopen(file, 'r');
   if fid < 0
      error([file ': Can''t open the file for reading.']);
   end

   % initialize line number counter
   thislinenum = 0;

   % initialize output arguments
   line    = '';
   linenum = 0;

   while 1

      % get next line; bail out if we have reached end of file
      thisline = fget(fid);
      if ~ischar(thisline)
         break
      end

      % increment line counter
      thislinenum = thislinenum + 1;

      % see if this line should be accepted
      if (rand * thislinenum) < 1
         line    = thisline;
         linenum = thislinenum;
      end

   end

   % close file
   status = fclose(fid);
   if status < 0
      error([file ': Can''t close the file.']);
   end
