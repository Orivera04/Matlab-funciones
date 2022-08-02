function hOut = maboxplot(maStruct,theFieldName,varargin)
%MABOXPLOT displays a box plot of microarray data.
%
%   MABOXPLOT(DATA) displays a box plot of the values in the columns of
%   DATA. DATA can be a numeric array or a structure containing a field
%   called Data.
%
%   MABOXPLOT(DATA,COLUMN_NAMES) labels the box plot column names.
%
%   For microarray data structures that are block-based, MABOXPLOT creates
%   a box plot of a given field for each block.
%
%   MABOXPLOT(MASTRUCT,FIELDNAME) displays a box plot of field FIELDNAME
%   for each block in microarray data structure MASTRUCT.
%
%   MABOXPLOT(...,'TITLE',TITLE) allows you to specify the title of the plot.
%   The default title is FIELDNAME.
%
%   MABOXPLOT(...,'NOTCH',true) draws notched boxes. The default is to show
%   square boxes. 
%
%   MABOXPLOT(...,'SYMBOL',SYM) allows you to specify the symbol used for
%   outlier values. The default symbol is '+'.
%
%   MABOXPLOT(...,'ORIENTATION',ORIENT) allows you to specify the
%   orientation of the box plot. The choices are 'Vertical' and
%   'Horizontal'. The default is 'Vertical'.
%
%   MABOXPLOT(...,'WHISKERLENGTH',WHIS) allows you to specify the whisker
%   length for the box plot. WHIS defines the maximum length of the
%   whiskers as a function of the interquartile range (IQR). The default
%   length is 1.5. The whisker extends to the most extreme data value
%   within WHIS*IQR of the box. If WHIS is 0, then BOXPLOT displays all
%   data values outside the box using the plotting symbol SYM.
%
%   H = MABOXPLOT(...) returns the handle of the box plot axes.
%
%   [H,HLINES] = MABOXPLOT(...) returns the handles of the lines used to
%   separate the different blocks in the image. 
%
%   Examples:
%
%       load yeastdata
%       maboxplot(yeastvalues,times);
%       xlabel('Sample Times');
%
%       % Using a structure
%       geoStruct = getgeodata('GSM1768');
%       maboxplot(geoStruct);
%
%       % For block-based data
%       madata = gprread('mouse_a1wt.gpr');
%       maboxplot(madata,'F635 Median');
%       figure
%       maboxplot(madata,'F635 Median - B635','TITLE','Cy5 Channel FG - BG');
%
%   See also BOXPLOT, MAIMAGE, MAIRPLOT, MALOGLOG, MALOWESS.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.11.6.4 $   $Date: 2004/01/24 09:18:25 $  

if ~isstruct(maStruct)
    
    dataIsBlockBased = false;
    data = maStruct;
    if nargin >1 
        ColumnNames = theFieldName;
    else
        ColumnNames = 1:size(data,2);
    end
else % only supports GPR and SPOT structure at the moment
    if isfield(maStruct,'Header')&& isfield(maStruct.Header,'Type') && ...
        (~isempty(strfind(maStruct.Header.Type,'GenePix')) ...
        || ~isempty(strfind(maStruct.Header.Type,'SPOT'))...
        || ~isempty(strfind(maStruct.Header.Type,'ImaGene')))
        if nargin < 2
            theFieldName = maStruct.ColumnNames{1};
        end
        dataIsBlockBased = true;
        
    elseif isfield(maStruct,'Header')&& isfield(maStruct.Header,'Type')&& ...
            ~isempty(strfind(maStruct.Header.Type,'Gene Expression Omnibus'))
        dataIsBlockBased = false;
        data = maStruct.Data;
        ColumnNames = maStruct.ColumnNames;
        if iscell(data)
            numCols = size(data,2);
            numRows = size(data,1);
            isNum = true(numCols,1);
            for colCheck = 1:numCols
                if ~isnumeric(maStruct.Data{1,colCheck})
                    isNum(colCheck) = false;
                end
            end
            data = reshape(cell2mat({maStruct.Data{:,find(isNum)}}),numRows,numel(find(isNum)));
            ColumnNames = ColumnNames(find(isNum));
        end            
        
    else
        warning('Bioinfo:MABOXPLOTNotSupported',...
            'MABOXPLOT only supports GenePix, SPOT and GEO format data.');
    end
end

titleString = '';
hgargs = {}; %#ok
showNotch = false;
symbol = [];
vertical = true;
whiskerLength = [];

if nargin > 2
    
    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'title','notch','symbol','orientation','whiskerlength'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            % here we assume that these are handle graphics options
            hgargs{end+1} = pname;
            hgargs{end+1} = pval;
        elseif length(k)>1
              error('Bioinfo:AmbiguousParameterName',...
                  'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % title
                    titleString = pval;
                case 2 % notch
                    showNotch = opttf(pval);
                    if isempty(showNotch)
                        error('BIOSEQ:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end
                case 3 % symbol
                    if ~isempty(pval) && ischar(pval)
                        symbol = pval(1);
                    else
                        warning('Bioinfo:MABOXPLOTBadSymbol','SYMBOL should be a character.');
                    end
                    
                case 4 %orientation
                    if ~isempty(pval) && ischar(pval)
                        if(lower(pval(1)) == 'h')
                            vertical = false;
                        end
                    else
                        warning('Bioinfo:MABOXPLOTBadOrientation',...
                            'ORIENTATION should be a character string.');
                    end
                case 5 %whiskerlength
                    whiskerLength = pval;
            end
        end
    end
end


if dataIsBlockBased
    
    col = find(strcmpi(maStruct.ColumnNames,theFieldName));
    
    if isempty(col)
        fields = char(maStruct.ColumnNames);
        fields(:,end+1) = repmat(sprintf('\n'),size(fields,1),1);
        error('Bioinfo:BadMAField',...
            'Unknown field name. Valid field names are:\n%s',fields');
    end
    
    theData = maStruct.Data(:,col);
    numPoints = numel(theData);
    numBlocks = maStruct.Shape.NumBlocks;
    
    % data should be sorted by blocks, but we should make sure
    if ~issorted(maStruct.Blocks,'rows')
        [sBlocks,perm] = sortrows(maStruct.Blocks); %#ok
        theData = theData(perm);
    end
    theData = reshape(theData,numPoints/numBlocks,numBlocks);
    
    uniqueBlocks = unique(maStruct.Blocks,'Rows');
    boxplot(theData,showNotch,symbol,vertical,whiskerLength);
    hAxis = gca;
    
    
    if size(uniqueBlocks,2) > 1
        tickLabels = cell(numBlocks,1);
        for count = 1:numBlocks
            tickLabels{count} = regexprep(['{' num2str(uniqueBlocks(count,:)) '}'],' .?',',');
        end
    else
        tickLabels = num2str((1:numBlocks)');
    end
    
    if vertical
        xlabel('Block');
        set(hAxis,'xticklabel',tickLabels)
        ylabel(theFieldName)
    else
        ylabel('Block');
        set(hAxis,'yticklabel',tickLabels)
         xlabel(theFieldName)
    end
    
    if isempty(titleString)
        titleString = theFieldName;
    end
    title(titleString);
    
    if nargout > 0
        hOut = hAxis;
    end
    
else
    boxplot(data,showNotch,symbol,vertical,whiskerLength);
    
    hAxis = gca;
    if vertical
        xlabel('');
        set(hAxis,'xticklabel',ColumnNames)
    else
        ylabel('');
        set(hAxis,'yticklabel',ColumnNames)
    end
    
    if ~isempty(titleString)
        title(titleString);
    end
    
    
    if nargout > 0
        hOut = hAxis;
    end
end
