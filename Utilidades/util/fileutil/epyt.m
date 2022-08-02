function epyt(file)
%EPYT   Display a file backwards line by line (opposite of TYPE).
%
%   EPYT foo.bar displays the text file called 'foo.bar'.
%   EPYT foo displays the text file called 'foo.m'.
%
%   If files called foo and foo.m both exist, then
%      EPYT foo displays the file 'foo', and
%      EPYT foo.m display the file 'foo.m'.
%
%   EPYT FILENAME displays the contents of the file given a full pathname or a
%   MATLABPATH relative partial pathname (see PARTIALPATH).
%
%   See also TYPE, WHICH.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-05 19:28:17 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   error(nargchk(1, 1, nargin));

   % check file name
   if isempty(file) | ~ischar(file)
      error('Filename must be a non-empty string.');
   end

   % see if file exists
   if ~exist(file, 'file')
      error([file ': No such file.']);
   end

   % open file for reading
   [fid, msg] = fopen(file, 'rt');
   if fid < 0
      error([file ': Can''t open the file for reading.']);
   end

   % seek to end of file
   status = fseek(fid, 0, 1);
   if status < 0
      error([file, ': Seek failed.']);
   end

   cr = 13;             % carriage return
   lf = 10;             % line feed

   bufsize = 256;
   buf = [];

   % TYPE prints a newline before the first line, so we do that too
   fprintf(1, '\n');

   fpos = ftell(fid);
   while fpos > 0

      % compute position to start reading from
      if fpos < bufsize
         bufsize = fpos;
         fpos = 0;
      else
         fpos = fpos - bufsize;
      end

      % seek to where we should start reading from
      status = fseek(fid, fpos, -1);
      if status < 0
         error([file, ': Seek failed.']);
      end

      % read a chunk of data
      data = fread(fid, bufsize, 'uchar');

      % insert data at beginning of buffer
      buf = [data buf];

      % Now convert all newline variants (CR+LF on DOS, CR on MAC, LF on
      % UNIX) to LF.  This must be done in a way so that CR+LF never gets
      % converted to LF+LF.  The boundary condition when a chunk of data
      % begins with the LF in a CR+LF newline must be handled correctly.

      % convert CR+LF to LF by removing all CR's that are followed by a LF
      k = buf(1:end-1) == cr & buf(2:end) == lf;
      buf(k) = [];

      % convert CR to LF
      k = buf == cr;
      buf(k) = lf;

      % length of buffer
      buflen = length(buf);

      % the only case when `buf' does not end in a line feed is when the
      % file does not end in a newline
      if buf(buflen) ~= lf
         buf = [buf lf];
      end

      % find positions of line feeds in buffer
      k = find(buf == lf);

      if length(k) > 1

         % print all lines after the first line feed char
         for i = length(k)-1 : -1 : 1
            lb = k(i) + 1;
            ub = k(i+1) - 1;
            if lb > ub
               fprintf(1, '\n');
            else
               fprintf(1, '%s\n', buf(lb:ub));
            end
         end

         % keep everything up until, and including, the first line feed char
         buf = buf(1:k(1));

      end

   end

   % print first line
   if length(k)
      fprintf(1, '%s\n', buf(1 : k(1)-1));
   else
      fprintf(1, '%s\n', buf);
   end

   % close the file
   status = fclose(fid);
   if status < 0
      error([file, ': Can''t close the file.']);
   end
   % TYPE prints a newline after the last line, so we do that too
   fprintf(1, '\n');
