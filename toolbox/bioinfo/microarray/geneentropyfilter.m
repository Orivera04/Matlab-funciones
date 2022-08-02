function [I data labels] = geneentropyfilter(data,labels,varargin)
%GENEENTROPYFILTER filters genes with profiles with low entropy.
%
%   MASK = GENEENTROPYFILTER(DATA) identifies expression profiles in DATA
%   with entropy in the lowest 10 percent. MASK is a logical vector with
%   one element for each row in DATA. The elements of MASK corresponding to
%   rows with variance greater than the threshold have value 1, and those
%   with variance less than the threshold are 0. 
%
%   [MASK, FDATA] = GENEENTROPYFILTER(DATA) returns the filtered data matrix
%   FDATA. FDATA can also be created using FDATA = DATA(find(I),:);  
%
%   [MASK, FDATA, FNAMES] = GENEENTROPYFILTER(DATA, NAMES) also returns the
%   filtered names array FNAMES, where NAMES is a cell array of the names
%   of the genes corresponding to each row of DATA. FNAMES can also be
%   created using FNAMES = NAMES(I);
%
%   GENEENTROPYFILTER(..., 'PRCTILE', PCT) filters genes with entropy
%   levels in the lowest PCT percent of the data.
%
%   Example:
%
%       % Load the yeast workspace variables and filter out the genes
%       % with low entropy.
%       load yeastdata
%       [mask, fyeastvalues, fgenes] = geneentropyfilter(yeastvalues,genes);
%
%       % Now compare the size of the filtered set with the original set.
%       size (fgenes,1)
%       size (genes,1)
%
%   See also EXPRPROFRANGE, EXPRPROFVAR, GENELOWVALFILTER, GENEVARFILTER,
%   GENERANGEFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.6.4.2 $   $Date: 2004/01/24 09:18:17 $

absp = 10;
numBins = ceil(size(data,2)/2);
numRows = size(data,1);

if nargin < 2
    labels = [];
end

if nargin > 2
    
    if rem(nargin,2)== 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'prctile','bins'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pentropy = varargin{j+1};
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
                    absp = pentropy;
                case 2  % numBins                    
                    numBins = pentropy;
            end
        end
    end
end 

p = zeros(numRows,numBins);

for count = 1:numRows
    p(count,:) = hist(data(count,:),numBins);
end

p = p./numBins;
% calculate sum(p.*log2(p))
% this will run into problems with 0*log2(0) so we trick this into doing
% the right thing.

p(p==0) = 1;
entropy = -sum(p.*log2(p),2);

% create the index

abscutoff = prctile(entropy,absp);
I = (entropy>abscutoff);

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

