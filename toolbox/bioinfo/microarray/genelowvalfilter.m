function [I, data,labels] = genelowvalfilter(data,labels,varargin)
%GENELOWVALFILTER filters genes with low absolute expression levels.
%
%   MASK = GENELOWVALFILTER(DATA) identifies expression profiles in DATA
%   where all absolute expression levels are in the lowest 10 percent of
%   the data set. MASK is a logical vector with one element for each row in
%   DATA. The elements of MASK corresponding to rows with absolute
%   expression levels greater than the threshold have value 1, and those
%   with absolute expression levels less than the threshold are 0. 
%
%   [MASK, FDATA] = GENELOWVALFILTER(DATA) returns the filtered data matrix
%   FDATA. FDATA can also be created using FDATA = DATA(find(I),:);  
%
%   [MASK, FDATA, FNAMES] = GENELOWVALFILTER(DATA, NAMES) also returns the
%   filtered names array FNAMES, where NAMES is a cell array of the names
%   of the genes corresponding to each row of DATA. FNAMES can also be
%   created using FNAMES = NAMES(I);
%
%   GENELOWVALFILTER(...,'PRCTILE',PCT) filters genes with absolute
%   expression levels in the lowest PCT percent of the range. 
%
%   GENELOWVALFILTER(...,'ABSVALUE',VAL) filters genes with absolute
%   expression levels lower than VAL. 
%
%   GENELOWVALFILTER(...,'ANYVAL',true) filters genes where any expression
%   level is less than the threshold value.
%
%   Example:
%
%       % Load the yeast workspace variables and filter out the genes
%       % with low absolute expression levels.
%       load yeastdata
%       [mask, fyeastvalues, fgenes] = genelowvalfilter(yeastvalues,genes);
%
%       % Now compare the size of the filtered set with the original set.
%       size (fgenes,1)
%       size (genes,1)
%
%   See also EXPRPROFRANGE, EXPRPROFVAR, GENEENTROPYFILTER, GENEVARFILTER,
%   GENERANGEFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.4 $   $Date: 2004/01/24 09:18:18 $

absprctile = false;  
absp = 10;
absval = false;
numRows = size(data,1);
anyvals = false;
setval = false;

if nargin < 2
    labels = [];
end

if nargin > 2
    
    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'prctile','absvalue','anyval'};
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
                case 1  % absprctile
                    absprctile = true;
                    setval = true;
                    absp = pval;
                case 2  % absval
                    setval = true;
                    absval = true;
                    absv = pval;
                case 3
                    anyvals = opttf(pval);
                    if isempty(anyvals)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                            upper(char(okargs(k)))); 
                    end   
            end
        end
    end
end 

% if no options specifed, use prctile
if ~setval
    absprctile = true;
end
absdata = abs(data);
% all or any
if anyvals
    lowvals = min(absdata,[],2);
else
    lowvals = max(absdata,[],2);
end

% create the index
I = true(numRows,1);

if absprctile
    abscutoff = prctile(absdata(:),absp);
    I = (lowvals>abscutoff);
end

if absval 
    I = I & (lowvals>absv);
end

% handle labels if they were specified
if ~isempty(labels) && nargout > 2
    if numel(labels) ~= numRows
        warning('Bioinfo:LabelSizeMismatch',...
            'Label size does not match data size.');
        labels = [];
    else
        labels = labels(I);
    end
end

if nargout > 1
    data = data(I,:);
end
