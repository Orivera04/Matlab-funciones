function fname=mmsave(D,H,F)
%MMSAVE Save Array and Header to an ASCII File. (MM)
% MMSAVE(D,STR) saves a numerical array D to an ASCII file
% with an optional string header, STR.
%
% The first TWO dimensions of D are saved. Higher dimensions are ignored.
% If given, STR must be a string, a string matrix, or a string cell array.
% FNAME=MMSAVE(D,STR) returns filename where the data was stored.
%
% MMSAVE(D,STR,FSTR) in addition uses the format string FSTR to format
% the data. The default FSTR is '12.5g'.
%
% See also MMLOAD.

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/25/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

% Check input arguments.
hdr=[];
if nargin < 1
   error('Not Enough Input Arguments.')
   return
end
if nargin >= 1
   if ~isa(D,'double')
      error([inputname(1),' is a ', class(D),...
            ', not a Double Array.']);
   end
end
if nargin > 3
   error('Too Many Input Arguments.');
end

if nargin == 2 
   F='%12.5g';
   if iscellstr(H)
      hdr = char(H);
   elseif ischar(H)
      hdr = H;
   else
      error([inputname(2),' Must be a String, ',...
            'String Array, or Cell Array of Strings.']);
   end
end
if isempty(D)
   error('Must Supply a Numerical Array.');
end

% Select a filename and path.
[file, fpath]=uiputfile('mmdata.asc','Save As:');
if file == 0
   return        % user selected the cancel button
end

% Open the file (writable, text). 
% If fopen returns -1, an error ocurred.
fid = fopen([fpath,file],'wt');
if fid==-1
   error('File Not Created; Permission Denied.');
end

% Write out the header line(s).
[r,c]=size(hdr);
if ~isempty(hdr)
   for i=1:r
      fprintf(fid,'%s\n',hdr(i,:));
   end
end

% Build a format string for fprintf based on the number of rows.
if isempty(sprintf(F,pi))
   error('FSTR Must be A Valid Format String.')
end
fstr=F;
[r,c]=size(D);
for i=2:c
   fstr=[fstr ' ' F];
end
fstr=[fstr,'\n'];

% Print the data to the file
fprintf(fid,fstr,D');

% Close the data file
fclose(fid);

% Return the filename if requested
if nargout == 1
   fname=[fpath,file];
end
