function x = qnan
%QNAN   Return a quiet (non-trapping) NaN.
%
%   QNAN is the IEEE arithmetic representation of a quiet (non-trapping) NaN
%   (Not-a-Number).
%
%   See also NAN, INF.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:18:26 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % bit pattern for quiet NaN
   bitpat = 'fff7ffffffffffff';
   u8     = sscanf(bitpat, '%2x');

   % name of temporary file
   file = tempname;

   % write bit pattern to file as eight uint8 values
   fid = fopen(file, 'wb');
   if fid < 0
      error([file ': can''t open file for writing.']);
   end
   fwrite(fid, u8, 'uint8');
   fclose(fid);

   % read bit pattern from file as one double value
   fid = fopen(file, 'rb', 'ieee-be');
   if fid < 0
      delete(file);
      error([file ': can''t open file for reading.']);
   end
   x = fread(fid, 1, 'double');
   fclose(fid);

   % delete temporary file
   delete(file);
