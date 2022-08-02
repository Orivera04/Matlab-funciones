function swapprev( filename, filenamei )
%SWAPPREV Merge EPSI and EPS files.
%	Used to extract the preview bitmap from an EPSI file and
%	mate it with the Setup and script from an EPS file. Needed to
%	fix a bug with MATLAB v4.0 and v4.0a.
%
%	See also 8 Febuary 93 version of PRINT

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin < 2
	error('Filenames required.')
end

% Need to read information from the EPSI version.
fepsi = fopen( filenamei, 'r' );

%
% Read till beginning of preview, keep track of how many lines read.
%
s = [];
lineNo = 0;

while ~strcmp( s, '%%EndComments' ) & s ~= -1
	s = fgetl( fepsi );
	lineNo = lineNo + 1;
end	

%
% If reached end of file, error out.
%
if s == -1
	fclose( fepsi );
	error(['Unexpected End of File condition, line ' int2str( lineNo )])
end

%
% Every MATLAB EPS file, with or without preview, has the same size header.
%
headCount = lineNo;

%
% Get the BeginPreview line, find out how many lines of 
% preview data there are.
%
s = fgetl( fepsi );
lineNo = lineNo + 1;
blanks = find( s == ' ' );
numDataLines = str2num( s( blanks(length(blanks)) : length(s) ) );

%
% Total lines we want from EPSI file includes header, Preview comments,
% and data.
%
linesFromI = lineNo + numDataLines + 1;

%
% Put header and preview in temporary file
%
headerFile = tempname;
fclose( fepsi );
[s,r] = unix(['head -' int2str(linesFromI) ' ' filenamei ' > ' headerFile]);
if s ~= 0
	error('Problem with head command.')
end

%
% Skip the header and store just the script from the EPS file temporarily.
%
[s,r] = unix( [ '\tail +' int2str(headCount+1) ' ' filename ' >> ' headerFile ] );
if s ~= 0
	error('Problem with tail command.')
end

%
% Finally, move it back to the original filename.
%
[s,r] = unix( [ '\mv ' headerFile ' ' filename ] );
if s ~= 0
	error('Problem with mv command.')
end

