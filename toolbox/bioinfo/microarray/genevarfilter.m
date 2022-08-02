function [I,data,labels] = genevarfilter(data,labels,varargin)
%GENEVARFILTER filters genes with small profile variance.
%
%   MASK = GENEVARFILTER(DATA) identifies expression profiles in DATA with
%   variance in the lowest 10 percent. MASK is a logical vector with one
%   element for each row in DATA. The elements of MASK corresponding to
%   rows with variance greater than the threshold have value 1, and those
%   with variance less than the threshold are 0.
%
%   [MASK, FDATA] = GENEVARFILTER(DATA) returns the filtered data matrix
%   FDATA. FDATA can also be created using FDATA = DATA(I,:);  
%
%   [MASK, FDATA, FNAMES] = GENEVARFILTER(DATA, NAMES) also returns the
%   filtered names array FNAMES, where NAMES is a cell array of the names
%   of the genes corresponding to each row of DATA. FNAMES can also be
%   created using FNAMES = NAMES(I);
%
%   GENEVARFILTER(...,'PRCTILE',PCT) filters genes with profile variances
%   in the lowest PCT percent of the range. 
%
%   GENEVARFILTER(...,'ABSVALUE',VAL) filters genes with profile variances
%   lower than VAL. 
%
%   Example:
%
%       % Load the yeast workspace variables and filter out the genes
%       % with a small profile variance.
%       load yeastdata
%       [mask, fyeastvalues, fgenes] = genevarfilter(yeastvalues,genes);
%
%       % Now compare the size of the filtered set with the original set.
%       size (fgenes,1)
%       size (genes,1)
%
%   See also EXPRPROFRANGE, EXPRPROFVAR, GENEENTROPYFILTER,
%   GENELOWVALFILTER, GENERANGEFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.3 $   $Date: 2004/01/24 09:18:20 $

absprctile = true;
absp = 10;
absval = false;
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
    okargs = {'prctile','absvalue'};
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
            end
        end
    end
end 

absvar = var(data,[],2);

% create the index
I = true(numRows,1);


if absprctile
    abscutoff = prctile(absvar,absp);
    I = absvar>abscutoff;
end

if absval 
    I = I & (absvar>absv);
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

