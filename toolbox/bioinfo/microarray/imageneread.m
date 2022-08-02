function output = imageneread(filename,varargin)
%IMAGENEREAD reads ImaGene Results Format files.
%
%   IMAGENEDATA = IMAGENEREAD(FILE) reads in ImaGene results format data
%   from FILE and creates a structure IMAGENEDATA, containing these fields:
%           Header
%           Data
%           Blocks
%           Rows
%           Columns
%           Fields
%           IDs
%           ColumnNames
%           Indices
%           Shape
%
%   IMAGENEREAD(...,'CLEANCOLNAMES',true) returns ColumnNames that are
%   valid MATLAB variable names. By default, the ColumnNames in the IMAGENE
%   file may contain spaces and some characters that cannot be used in
%   MATLAB variable names. This option should be used if you plan to use
%   the column names as variables names in a function.
%
%   The Indices field of the structure contains MATLAB indices that can be
%   used for plotting heat maps of the data with the image or imagesc
%   commands.
%
%   Example:
%
%       % Read in a sample ImaGene file and plot the Signal Mean
%       cy3Data = imageneread('cy3.txt');
%       maimage(cy3Data,'Signal Mean');
%
%       % Read in the Cy5 channel and create a loglog plot of Signal Median
%       cy5Data = imageneread('cy5.txt');
%       sigMedianCol = find(strcmp('Signal Median',cy3Data.ColumnNames));
% 		cy3Median = cy3Data.Data(:,sigMedianCol);
% 		cy5Median = cy5Data.Data(:,sigMedianCol);
%       maloglog(cy3Median,cy5Median,'title','Signal Median');
%
%   For more details on the ImaGene format and example data, see the
%   ImaGene User Manual.
%
%   See also GPRREAD, MABOXPLOT, MAIMAGE, SPTREAD.
%
%   ImaGene is a registered trademark of BioDiscovery, Inc.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.2 $   $Date: 2004/01/24 09:18:24 $

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

% read in the header data -- this implementation is not particularly
% efficient, but it seems to fast enough.
theLines = textread(filename,'%s','delimiter','\n');

% First line should be Begin Header
if isempty(strmatch('begin header',lower(theLines{1})))
    error('Bioinfo:BadImaGeneFile','File does not appear to be a ImaGene file.')
end

EndHeader = find(~cellfun('isempty',regexpi(theLines,'^End Header','once')),1);
output.Header.Type = 'ImaGene';
output.Header.Text = strtrim(theLines(2:EndHeader-1));

if isempty(strmatch('begin raw',lower(theLines{EndHeader+1})))
    error('Bioinfo:BadImaGeneFile','File does not appear to be a ImaGene file.')
end

colNames = strread(theLines{EndHeader+2},'%s','delimiter','\t');
theLines(EndHeader+3:end) = [];

numFields = numel(colNames);


% now read in the raw data
format = ['%s%f%f%f%f%s' repmat('%f',1,numFields-6)];
rawdata = textscan(fid,format,'headerlines',EndHeader+2);
fclose(fid);

try
    output.Data = cell2mat(rawdata(7:end));
catch
    lastLine = size(rawdata{end},1);
    error('Bioinfo:BadImageneData',...
        'Problems reading ImaGene file. Possible bad data around line %d.',...
        lastLine);
end

%numBlockRows = max(rawdata{2});
numBlockCols = max(rawdata{3});
output.Blocks = numBlockCols*(rawdata{2}-1)+numBlockCols;
output.BlockRows = rawdata{2};
output.BlockColumns = rawdata{3};
output.Rows = rawdata{4};
output.Columns = rawdata{5};
output.Fields = rawdata{1};
output.IDs = rawdata{6};
if cleancolnames
    colNames = strrep(colNames,' ','_');
    colNames = strrep(colNames,'%','pct');
    colNames = strrep(colNames,'>','gt');
    colNames = strrep(colNames,'+','_plus_');
    colNames = strrep(colNames,'.','_dot_');
end
output.ColumnNames = colNames(7:end);
try
    [output.Indices, output.Shape] = block_ind(output);
    output = rmfield(output,'BlockColumns');
    output = rmfield(output,'BlockRows');
catch
    output.Indices  = [];
end


function [fullIndices, blockStruct] = block_ind(imgStruct)
% BLOCK_IND maps from block, row,column to MATLAB style indexing
% Blocks are numbered along the columns first.

blockRows = imgStruct.BlockRows;
blockColumns = imgStruct.BlockColumns;
rows = imgStruct.Rows;
columns = imgStruct.Columns;


numBlockRows = max(blockRows);
numBlockCols = max(blockColumns);
numRows = max(rows);
numCols = max(columns);
numBlocks = numBlockRows*numBlockCols;

% convert file indexing into MATLAB ordering -- row major
indices = zeros(numRows,numCols,numBlockRows,numBlockCols);

dataRows = size(blockRows,1);
for index = 1:dataRows
    indices(rows(index),columns(index),blockRows(index),blockColumns(index)) = index;
end

fullIndices = repmat(indices(:,:,1,1),numBlockRows,numBlockCols);
blockStruct.NumBlocks = numBlocks;
blockStruct.BlockRange = ones(numBlocks,2);
count =1;
for outer = 1:numBlockRows
    for inner = 1:numBlockCols
        [col,row] = ind2sub([numBlockCols,numBlockRows],count);
        rowStart = ((row-1)*numRows)+1;
        colStart = ((col-1)*numCols)+1;
        blockStruct.BlockRange(count,:) = [colStart, rowStart];
        count = count +1;
        fullIndices(rowStart:rowStart+numRows-1,colStart:colStart+numCols-1) = indices(:,:,outer,inner);
    end
end