function [lines, linenums] = randlines(file, n)
%RANDLINES Pick a number of random lines from a file.
%
%   LINES = RANDLINES(FILE, N) returns a list (cell array) with N random lines
%   from the file FILE.  All lines in FILE are equally likely to be returned.
%   If N is omitted, a single line is returned.  The lines in LINES may not be
%   in the same order as they appear in the file (see below).
%
%   [LINES, LINENUMS] = RANDLINES(FILE, N) also returns a numeric vector with
%   the line numbers corresponding to each line in LINES.  To ensure that the
%   lines in LINES are in the same order as they appear in the file, use
%
%     [lines, linenums] = randlines(file, n);   % pick lines at random
%     [linenums, idx] = sort(linenums);         % sort line numbers
%     lines = lines(idx);                       % reorder lines accordingly
%
%   See also RAND.

%   Author:      Peter J. Acklam
%   Time-stamp:  2004-02-05 19:11:34 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % check number of input arguments
   nargsin = nargin;
   error(nargchk(1, 2, nargsin));

   % if line number is not given, assign default value, or else check the
   % specified value
   if nargsin < 2
      n = 1;
   else

      % check array class
      if ~isnumeric(n)
         error('N must be a numeric array.');
      end

      % check array size
      if any(size(n) ~= 1)
         error('N must be a scalar.');
      end

      % check array values
      if ~isreal(n) | (n < 1) | (n ~= fix(n))
         error('N must be a a real positive integer.');
      end

   end

   % see if the file exists
   if ~exist(file, 'file')
      error([file, ': No such file.']);
   end

   % open file for reading
   [fid, msg] = fopen(file, 'r');
   if fid < 0
      error([file, ': Can''t open the file for reading.']);
   end

   % initialize line number counter and output variables
   linenum = 0;
   lines    = cell(n, 1);
   linenums = zeros(n, 1);

   % deterministic part; fill in the first `n' lines
   while linenum <= n

      % get next line; bail out if we have reached end of file
      thisline = fgetl(fid);
      if ~ischar(thisline)
         break
      end

      % increment line counter and fill line into output cell array
      linenum = linenum + 1;
      lines{linenum}    = thisline;
      linenums(linenum) = linenum;

   end

   % throw an error if there were not enough lines
   if linenum < n
      error('File doesn''t contain enough lines.');
   end

   % stochastic part
   while 1

      % get next line; bail out if we have reached end of file
      thisline = fgetl(fid);
      if ~ischar(thisline)
         break
      end

      % increment line counter
      linenum = linenum + 1;

      % see if this line should be accepted
      if rand * linenum < 1

         % replace one of the `n' current lines
         m = ceil(n*rand);
         lines{m}    = thisline;
         linenums(m) = linenum;

      end

   end

   % close file
   status = fclose(fid);
   if status < 0
      error([file ': Can''t close the file.']);
   end
