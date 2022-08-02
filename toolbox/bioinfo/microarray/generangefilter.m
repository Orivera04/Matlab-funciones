function [I,data,labels] = generangefilter(data,labels,varargin)
%GENERANGEFILTER filters genes with small profile ranges.
%
%   MASK = GENERANGEFILTER(DATA) identifies expression profiles in DATA
%   with range in the lowest 10 percent. MASK is a logical vector with
%   one element for each row in DATA. The elements of MASK corresponding to
%   rows with range greater than the threshold have value 1, and those
%   with range less than the threshold are 0. 
%
%   [MASK, FDATA] = GENERANGEFILTER(DATA) returns the filtered data matrix
%   FDATA. FDATA can also be created using FDATA = DATA(find(I),:);  
%
%   [MASK, FDATA, FNAMES] = GENERANGEFILTER(DATA, NAMES) also returns the
%   filtered names array FNAMES, where NAMES is a cell array of the names
%   of the genes corresponding to each row of DATA. FNAMES can also be
%   created using FNAMES = NAMES(I);
%
%   GENERANGEFILTER(...,'ABSVALUE',VAL) filters genes with profile ranges
%   less than VAL. 
%
%   GENERANGEFILTER(...,'PRCTILE',PCT) filters genes with profile ranges
%   in the lowest PCT percent of the range. 
%
%   GENERANGEFILTER(...,'LOGVALUE',VAL) filters genes with profile log
%   ranges less than VAL.
%
%   GENERANGEFILTER(...,'LOGPRCTILE',PCT) filters genes with profile
%   ranges in the lowest PCT percent of the log range.
%
%   Example:
%
%       % Load the yeast workspace variables and filter out the genes
%       % with small profile ranges.
%       load yeastdata
%       [mask, fyeastvalues, fgenes] = generangefilter(yeastvalues,genes);
%
%       % Now compare the size of the filtered set with the original set.
%       size (fgenes,1)
%       size (genes,1)
%
%   See also EXPRPROFRANGE, EXPRPROFVAR, GENEENTROPYFILTER,
%   GENELOWVALFILTER, GENEVARFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.5 $   $Date: 2004/01/24 09:18:19 $

absprctile = true;
absp = 10;
dorel = false;
absval = false;
logval = false;
logprctile = false;
numRows = size(data,1);

if nargin < 2
    labels = [];
end

if nargin > 2
    absprctile = false;  
    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'prctile','absvalue','logprctile','logvalue'};
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
                    absp = pval;
                case 2  % absval
                    absval = true;
                    absv = pval;
                case 3  % logprctile
                    dorel = true;
                    logprctile = true;
                    logp = pval;
                case 4  % logval
                    dorel = true;
                    logval = true;
                    logv = pval;
            end
        end
    end
end 

if dorel
    [absrange, logrange] = exprprofrange(data,'showhist',false);
    if isempty(logrange)
        dorel = false;
    end
    
else
    absrange = exprprofrange(data,'showhist',false);
end

I = true(numRows,1);

if absprctile
    abscutoff = prctile(absrange,absp);
    I = (absrange>abscutoff);
end

if absval 
    I = I & (absrange>absv);
end

if logprctile && dorel
    logcutoff = prctile(logrange,logp);
    I = I & (logrange>logcutoff);
end

if logval && dorel
    I = I & (logrange>logv);
end

% handle labels if defined
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



