function output = gprread(filename,varargin)
%GPRREAD reads GenePix Results Format (GPR) files.
%
%   GPRDATA = GPRREAD(FILE) reads in GenePix results format data from FILE
%   and creates a structure GPRDATA, containing these fields:
%           Header
%           Data
%           Blocks
%           Columns
%           Rows
%           Names
%           IDs
%           ColumnNames
%           Indices
%           Shape
%
%   GPRREAD(...,'CLEANCOLNAMES',true) returns ColumnNames that are valid
%   MATLAB variable names. By default, the ColumnNames in the GPR file may
%   contain spaces and some characters that cannot be used in MATLAB
%   variable names. This option should be used if you plan to use the
%   column names as variables names in a function.
%
%   The Indices field of the structure contains MATLAB indices that can be
%   used for plotting heat maps of the data with the image or imagesc
%   commands. 
%
%   The function supports versions 3, 4, and 5, of the GenePix Results
%   Format.
%
%   For more details on the GPR format, see
%   http://www.axon.com/GN_GenePix_File_Formats.html#ResultsFormat
%   http://www.axon.com/gn_GPR_Format_History.html
%
%   Example:
%
%       % Read in a sample GPR file and plot the median foreground
%       % intensity for the 635 nm channel. 
%       gprStruct = gprread('mouse_a1pd.gpr')
%       maimage(gprStruct,'F635 Median');
%
%       % Alternatively you can create a similar plot using 
%       % more basic graphics commands.
%       f635Col = find(strcmp(gprStruct.ColumnNames,'F635 Median'));
%       F635Median = gprStruct.Data(:,f635Col);
%       imagesc(F635Median(gprStruct.Indices));
%       colorbar;
%
%   See also GALREAD, IMAGENEREAD, MABOXPLOT, MAIMAGE, SPTREAD.
%
%   GenePix is a registered trademark of Axon Instruments, Inc. 

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.18.6.7 $   $Date: 2004/03/09 16:15:32 $ 

try
    fid = fopen(filename,'rt');
catch
    fid = -1;
end

if fid == -1
    error('Bioinfo:CannotOpenGPRFile',...
        'Problem opening file %s. %s',filename,lasterr);
end

cleancolnames = false;
% deal with the various inputs
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'cleancolnames',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % cleancolnames
                    cleancolnames = opttf(pval);
                    if isempty(cleancolnames)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end
            end
        end
    end
end 

% first line should be ATF versions
checkHeader = fgetl(fid);

if ~strncmp(checkHeader,'ATF',3)
    error('Bioinfo:BadGPRFile','File does not appear to be a GPR file.')
end

fileSize = sscanf(fgetl(fid),'%d');

for count = 1:fileSize(1)
    line = strrep(fgetl(fid),'"','');
    [field,val] = strtok(line,'=');
    field = strrep(field,':','_');
    val = deblank(val(2:end));
    v = str2num(val); %#ok
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

% clean up colNames so that they can be used as MATLAB variables

colNames = strrep(colNames,'"','');
if cleancolnames
    colNames = strrep(colNames,' ','_');
    colNames = strrep(colNames,'%','pct');
    colNames = strrep(colNames,'>','gt');
    colNames = strrep(colNames,'+','_plus_');
    colNames = strrep(colNames,'.','_dot_');
end

nameCol = find(strncmpi(colNames,'Name',4));
IDCol = find(strncmpi(colNames,'ID',2));
if nameCol ~=4 && IDCol ~=5
error('Bioinfo:ProblemsReadingGPR','Cannot read %s. The file appears to be corrupt.',filename);
end

% count how much space we need for the data
currPos = ftell(fid);
fseek(fid,0,1);
endPos = ftell(fid);
fseek(fid,currPos,-1);

% Read all the data into lines
lines = strread(fread(fid,endPos-currPos,'uchar=>char'),'%s','delimiter','\n');

fclose(fid);

% Allocate some memory
numRows = length(lines);
numCols = fileSize(2);
blocks = zeros(numRows,1);
columns = blocks;
rows = blocks;
data = zeros(numRows,numCols-5);
names = cell(numRows,1);
IDs = names;

tabChar = sprintf('\t');
% parse the lines 
for count = 1:numRows
    line = lines{count};
    try
        % replace Error with missing values
        line = strrep(line,'Error','NaN');
        % First pull out the blocks, columns, rows, names and IDs
        [blocks(count),columns(count),rows(count),names(count),IDs(count)]...
            = strread(line,'%d%d%d%s%s%*[^\n]','delimiter','\t');
        % Now read in the 'data'
        tabs = strfind(line,tabChar);
        data(count,:) = strread(line(tabs(5)+1:end),'%f','delimiter','\t')';
    catch
        warning('Bioinfo:GPRBadLine','Problem readling line: %s',line);
    end
end

% Put data into structure for output
output.Header = header;
output.Data = data;
output.Blocks = blocks;
output.Columns = columns;
output.Rows = rows;
output.Names = names;
output.IDs = IDs;
output.ColumnNames = colNames(6:end);
try
    [output.Indices, output.Shape] = block_ind(output);
catch
    output.Indices  = [];
end

function [fullIndices, blockStruct] = block_ind(gprStruct)
% BLOCK_IND maps from block, row,column to MATLAB style indexing
% Blocks are numbered along the columns first.


blocks = gprStruct.Blocks;
rows = gprStruct.Rows;
columns = gprStruct.Columns;
theData = gprStruct.Data;

numBlocks = max(blocks);
numRows = max(rows);
numCols = max(columns);

Xdata = find(strcmpi(gprStruct.ColumnNames,'X'));
Ydata = find(strcmpi(gprStruct.ColumnNames,'Y'));

% convert file indexing into MATLAB ordering -- row major
indices = zeros(numRows,numCols,numBlocks);

dataRows = size(blocks,1);
for index = 1:dataRows
    indices(rows(index),columns(index),blocks(index)) = index;
end

% figure out orientation of blocks
topLeft = [theData(indices(1,1,:),Xdata), theData(indices(1,1,:),Ydata)];
bottomRight = [theData(indices(numRows,numCols,:),Xdata), theData(indices(numRows,numCols,:),Ydata)];

% decide if each block is orientated top left to bottom right

if (topLeft(1,1) < bottomRight(1,1)) && (topLeft(1,2) < bottomRight(1,2))
%    normalSpotOrientation = true;
else
    warning('Bioinfo:CannotDetermineGPROrientation',...
        'Cannot determine orientation of the blocks.');
    fullIndices = [];
    return;
end

% Assume that block 1 is in top left and that blocks are column major
% figure out if there is more than one column

% rows change when there is a negative difference in the x coords 
dRow = diff(topLeft(:,1));

numBlockRows = 1 + sum(dRow<0);
numBlockCols =  numBlocks/numBlockRows;

fullIndices = repmat(indices(:,:,1),numBlockRows,numBlockCols);
blockStruct.NumBlocks = numBlocks;
blockStruct.BlockRange = ones(numBlocks,2);

for count = 2:numBlocks
    [col,row] = ind2sub([numBlockCols,numBlockRows],count);
    rowStart = ((row-1)*numRows)+1;
    colStart = ((col-1)*numCols)+1;
    blockStruct.BlockRange(count,:) = [colStart, rowStart];
    fullIndices(rowStart:rowStart+numRows-1,colStart:colStart+numCols-1) = indices(:,:,count);
end


