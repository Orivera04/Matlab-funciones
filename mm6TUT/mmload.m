function [D,hdr]=mmload
%MMLOAD Load Matrix and Header(s) from an ASCII File. (MM)
% [D,HDR]=MMLOAD opens an ASCII data file, reads numerical data into
% the matrix D, and any optional header text into the string matrix HDR.
% D has the same dimensions as the data in the file if each row read
% in has the same number of data points, otherwise D is a column vector.
%
% Header lines may be intermixed with data lines, but all header lines
% are returned in the character array HDR, and all data values are
% returned in the single matrix D.
%
% See also MMSAVE.

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/25/97, revised 4/17/98 to add support for NaN and Inf values.
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

% Initialize some variables.

ncols = 1;
D = [];
hdr = [];

% Select a data file.

[file, fpath]=uigetfile('*','Select an ASCII Data File:');
if file == 0
   return;          % Cancel button selected.
end



% Open the file.  If fopen returns -1, the open failed.
fid = fopen([fpath,file],'rt');
if fid == (-1)
   error('File Not Found or Permission Denied.');
end

% Process the first line of the file.
line = fgetl(fid);
if ~ischar(line)
   disp('Warning: Empty File or Invalid Data.')
end;

% Loop through the file one line at a time
while line ~= (-1)
   tmp = eval(['[' line ']'],'[]');
   if isempty(tmp)           % This is a header line
      if isempty(hdr)             % First header line
         hdr = {line};
      else                        % Another header line
         hdr(end+1) = {line};
      end
   else                        % This is a line of data
      if ncols == 1
         ncols = length(tmp);
      end
      D = [D tmp];
   end
   line = fgetl(fid);
end 

fclose(fid);
% Create a string array from the header cell array.

hdr = char(hdr);

% Reshape the output data unless the data is irregular. Base the array 
% dimensions on the number of columns in the input data line and the
% number of data elements.

if rem(length(D),ncols) == 0
   D = reshape(D, ncols, length(D)/ncols)';
end



