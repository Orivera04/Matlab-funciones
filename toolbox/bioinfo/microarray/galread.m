function output = galread(filename)
%GALREAD reads GenePix Array List format data files.
%
%   GALDATA = GALREAD(FILE) reads in a GenePix Array List format
%   from FILE and creates a structure GALDATA, containing these fields:
%       Header 
%       BlockData
%       IDs
%       Names
%
%   The BlockData field is an Nx3 array. The columns of this array are the
%   Block data, the Column data, and the Row data, respectively.
%
%   For more information on the GAL format, see
%   http://www.axon.com/GN_GenePix_File_Formats.html#gal.
%
%   Examples:
%
%       % Download a demo GAL file from www.axon.com.
%       urlwrite('http://www.axon.com/genomics/Demo.gal','Demo.gal')
%
%       % Then use GALREAD to load the data into a MATLAB structure.
%       galread('Demo.gal')
%
%   See also GPRREAD, MAIMAGE, SPTREAD.
%
%   GenePix is a registered trademark of Axon Instruments, Inc. 

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.3 $   $Date: 2004/01/24 09:18:16 $

try
    fid = fopen(filename,'rt');
catch
    fid = -1;
end

if fid == -1
    error('Bioinfo:CannotOpenGALFile','Problem opening file %s. %s',filename,lasterr);
end

% first line should be ATF versions
checkHeader = fgetl(fid);

if ~strncmp(checkHeader,'ATF',3)
    error('Bioinfo:BadGALFile','File does not appear to be a GAL file.')
end

fileSize = sscanf(fgetl(fid),'%d');

for count = 1:fileSize(1)
    line = strrep(fgetl(fid),'"','');
    [field,val] = strtok(line,'=');
    val = deblank(val(2:end));
    v = str2double(val);
    if ~isempty(v)
        blockNum = sscanf(field,'Block%d');
        if isempty(blockNum)
            header.(field) = v;
        else
            header.Block(blockNum,:) = v;
        end
        
    else
        header.(field) = val;
    end
end

% now deal with the data
colNames = strread(fgetl(fid),'%s','delimiter','\t');

% suck the data into memory
currPos = ftell(fid);
fseek(fid,0,1);
endPos = ftell(fid);
fseek(fid,currPos,-1);

data = strread(fread(fid,endPos-currPos,'uchar=>char'),'%s','delimiter','\t','emptyvalue',NaN);

fclose(fid);

% pull this apart

numRows = length(data)/fileSize(2);
if floor(numRows) ~= numRows
    error('Bioinfo:ProblemsReadingGAL','Cannot read %s. The file appears to be corrupt.',filename);
end
data = reshape(data,fileSize(2),numRows)';

% find the column ordering -- the format says that this is flexible
blockCol = find(strcmpi(colNames,'Block'));
columnCol = find(strcmpi(colNames,'Column'));
rowCol = find(strcmpi(colNames,'Row'));
idCol = find(strcmpi(colNames,'ID'));
nameCol = find(strcmpi(colNames,'Name'));
udCol = find(strncmpi(colNames,'User',4));

% let str2double deal with the unknown shape
% if this is slow then change it to sscanf
blocks = str2double(char(data(:,blockCol)));
columns = str2double(char(data(:,columnCol)));
rows = str2double(char(data(:,rowCol)));

blockdata = [blocks,columns,rows];

% deal with empty vals
if ~isempty(idCol)
    IDs = data(:,idCol);
else 
    IDs = [];
end
if ~isempty(nameCol)
    names = data(:,nameCol);
else
    names = [];
end

if ~isempty(idCol)
    userDefined = data(:,udCol);
else
    userDefined = [];
end

% create the output structure
output.Header = header;
output.BlockData = blockdata;
output.IDs =IDs;
output.Names = names;
if ~isempty(userDefined)
    output.UserDefined = userDefined;
end
