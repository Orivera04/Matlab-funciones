function [OK, msg, out] = xregreadcsv(filename, out)
%XREGREADCSV file input for csv files to MBC
%
%  [OK, MSG, OUT] = XREGREADCSV(FILENAME, OUT)
%  
% A CSV file is expected to be in the following format.
%
% <csv-file> = ({<data-line>} | <name-line> <CRLF> {<data-line>} 
%  | <name-line> <CRLF> <unit-line> <CLRF> {<data-line>})
%
% <name-line> = <string> ( ',' <string> ) ( ',' ) <CRLF>
% <unit-line> = <string> ( ',' <string> ) ( ',' ) <CRLF>
% <data-line> = <numeric-string> ( ',' <numeric-string> ) ( ',' ) <CRLF>

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:21:15 $ 

OK = 0;
msg = '';
% Check that the file being requested exists
if exist(filename) ~= 2
    error('mbc:mbctools:InvalidArgument', 'The file %s does not exist', filename);
end
% Set the read buffer size to be larger than 4k
bufferSize = 40000;
% Read the first line to find out how many variables are involved
firstLine = textread(filename, '%s', 1, 'delimiter','\n\r', 'bufsize', bufferSize);
firstLine = deblank(firstLine{1});
% How many commas since each variable is delimited by a comma
numVars = sum(firstLine == ',');
% Does the line end in a comma, if not them the number of variables needs
% to be incremented by one
if firstLine(end) ~= ','
    numVars = numVars + 1;
end
% Now read in the first two lines delimited by comma's
namesAndUnits = reshape(textread(filename, '%s', numVars*2, 'delimiter', ',', 'bufsize', bufferSize, 'emptyvalue', 0), numVars, 2)';
% Have we got any names or units - try converting to double and seeing if
% they return all NaN
dblNamesAndUnits = xregcellstr2real(namesAndUnits);
% Get the names and units bits out
names = namesAndUnits(1,:);
units = namesAndUnits(2,:);
dblNames = dblNamesAndUnits(1,:);
dblUnits = dblNamesAndUnits(2,:);
headerLines = 0;
% Indicate that there is a headerRow of names if any of the first row can't
% be converted to doubles
if any(isnan(dblNames))
    headerLines = headerLines + 1;
    % And the same for the second row if there are some units
    if any(isnan(dblUnits))
        headerLines = headerLines + 1;
    end
end
% Put sensible names and units where none exist
names(~isnan(dblNames)) = {'VAR'};
units(~isnan(dblUnits)) = {''};
% Read the rest of the file
data = textread(filename, '', 'delimiter', ',', 'bufsize', bufferSize, 'headerlines', headerLines, 'emptyvalue', NaN);
% Is it the right size
if size(data, 2) < numVars
	msg = 'Unable to reconcile shape of CSV file';
	return
elseif size(data, 2) > numVars
    data = data(:, 1:numVars);
end
% Fill in the output structure
out.varNames = names;
out.varUnits = units;
out.data     = data;
% Indicate success
OK = 1;
