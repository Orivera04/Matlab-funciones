function filldata = pGetTableData(otf, outdata, ptrlist, outweights, table_no)
%PGETTABLEDATA
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:35 $

% Intialise 
filldata = [];

% Get the table to be filled 
tptr = otf.tables(table_no);

% Get indices of axes inputs in pointer list of optimization output factors
axesptrs = tptr.get('axesptrs');
axesind= zeros(1, length(axesptrs));
for i = 1:length(axesptrs)
    axesind(i) = find(ptrlist==axesptrs(i));
end  

% Get index of selected output column
outind = 0;
outptr = otf.fillfactors(table_no);
outind = find(ptrlist==outptr);

% Check for zeros in axes/out indices
indcheck = [axesind, outind];
icheck = [];
icheck = find(~indcheck);
if ~isempty(icheck)
    % An axis pointer or the selected output is no longer in the data set 
    return
end

% Get the data to fill the table
solnindex = otf.solutionindex(table_no);
outsz = size(outdata);
NFAC = length(axesind) + length(outind);
if length(outsz) > 2
    NSOL = outsz(3);
else
    NSOL = 1;
end
% The optimization data may have changed from underneath us. Do the
% retrieval in a try-catch.
try
    switch otf.solutiontype{table_no}
        case 'solution'
            filldata = outdata(:,[axesind outind], solnindex);
        case 'pareto'
            filldata = outdata(solnindex,[axesind outind], :);
            filldata = reshape(filldata, [NFAC NSOL]);
            filldata = filldata';
        case 'weightedpareto'
            wts = repmat(outweights, [1 NFAC NSOL]);
            tmp = wts.*outdata(:, [axesind outind], :);
            wtsum = sum(tmp);
            wtsum = reshape(wtsum, [NFAC NSOL]);
            filldata = wtsum';
    end
catch
    filldata = [];
    return
end

