function output = sptread(filename,varargin)
%SPTREAD reads SPOT format files.
%
%   SPOTDATA = SPTREAD(FILE) reads in SPOT format results from FILE and
%   creates a structure SPOTDATA, containing these fields:
%           Header
%           Data
%           Blocks
%           Columns
%           Rows
%           IDs
%           ColumnNames
%           Indices
%           Shape
%
%   SPTREAD(...,'CLEANCOLNAMES',true) returns ColumnNames that are valid
%   MATLAB variable names. By default, the ColumnNames in the GPR file may
%   contain spaces and some characters that cannot be used in MATLAB
%   variable names. This option should be used if you plan to use the
%   column names as variables names in a function.
%
%   The Indices field of the structure contains MATLAB indices that can be
%   used for plotting heat maps of the data with the image or imagesc
%   commands. 
%
%   Spot is a software package for the analysis of microarray images.
%
%   Example:
%       % Read in a sample SPOT file and plot the median foreground
%       % intensity for the 635 nm channel. 
%       spotStruct = sptread('spotdata.txt')
%       maimage(spotStruct,'Rmedian');
%
%       % Alternatively you can create a similar plot using 
%       % more basic graphics commands.
%
%       rmedCol = find(strcmp(spotStruct.ColumnNames,'Rmedian'));
%       Rmedian = spotStruct.Data(:,rmedCol);
%       imagesc(Rmedian(spotStruct.Indices));
%       colormap bone
%       colorbar
%
%   See also GPRREAD, IMAGENEREAD, MABOXPLOT, MAIMAGE.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.6.4 $   $Date: 2004/01/24 09:19:15 $ 

try
    fid = fopen(filename,'rt');
catch
    fid = -1;
end

if fid == -1
    error('Bioinfo:CannotOpenSPTFile','Problem opening file %s. %s',filename,lasterr);
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
            error('Bioinfo:UnknownParameterName','Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName','Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % font
                    cleancolnames = opttf(pval);
                    if isempty(cleancolnames)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end
            end
        end
    end
end 


headerLine = fgetl(fid);
fclose(fid);

colNames = strread(headerLine,'%s');

if cleancolnames
    colNames = strrep(colNames,'.','_');
    colNames = strrep(colNames,'%','pct');
    colNames = strrep(colNames,'>','gt');
    colNames = strrep(colNames,'+','_plus_');
    colNames = strrep(colNames,' ','__');
end

numFields = numel(colNames);

data = textread(filename,'%f','headerlines',1,'delimiter','\t');
data = reshape(data,numFields,numel(data)/numFields)';


output.Header.Type = 'SPOT format data.';
output.Header.Filename = filename;
output.Data = [];

blockColRow = find(strcmp('grid.r',colNames));
blockColCol = find(strcmp('grid.c',colNames));
output.Blocks = [data(:,blockColRow) data(:,blockColCol)];
ColCol = find(strcmp('spot.c',colNames));
RowCol = find(strcmp('spot.r',colNames));
output.Rows = data(:,RowCol);
output.Columns = data(:,ColCol);
IDCol = find(strcmp('indexs',colNames));
output.IDs = data(:,IDCol);
output.ColumnNames = colNames(ColCol+1:end);
output.Data = data(:,ColCol+1:end);


try
    [output.Indices, output.Shape] = block_ind(output.Blocks,output.Rows,output.Columns);
catch
    output.Indices  = [];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fullIndices, blockStruct] = block_ind(blocks,rows,columns)
% BLOCK_IND maps from block, row,column to MATLAB style indexing
% Blocks are numbered along the columns first.


blockMax = max(blocks);
numBlockCols = blockMax(2);
numBlockRows =  blockMax(1);
numBlocks = prod(blockMax);
numRows = max(rows);
numCols = max(columns);


% convert file indexing into MATLAB ordering -- row major
indices = zeros(numRows,numCols,numBlocks);

dataRows = size(blocks,1);
for index = 1:dataRows
    indices(rows(index),columns(index),(((blocks(index,1)-1)*4)+blocks(index,2))) = index;
end

%
% decide if each block is orientated top left to bottom right

% Assume that block 1 is in top left and that blocks are column major
% figure out if there is more than one column

fullIndices = repmat(indices(:,:,1),numBlockRows,numBlockCols);
blockStruct.NumBlocks = numBlocks;
blockStruct.BlockRange = ones(numBlocks,2);

for count = 2:numBlocks
    [col,row] = ind2sub([numBlockRows,numBlockCols],count);
    rowStart = ((row-1)*numRows)+1;
    colStart = ((col-1)*numCols)+1;
    blockStruct.BlockRange(count,:) = [colStart,rowStart];
    fullIndices(rowStart:rowStart+numRows-1,colStart:colStart+numCols-1) = indices(:,:,count);
end


