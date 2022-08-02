function gridOK = getSwitchGrid(m, varargin)
%GETSWITCHGRID Generate a logical grid of valid sites 
%
%  GRID = GETSWITCHGRID(M, X1, X2, ..., Xn) where X1...Xn are vectors of
%  input values for each input factor returns a logical grid of size
%  (length(X1)-by-length(X2)-by-...-by-length(Xn)) that contains true
%  values at the positions where there is a valid evaluation point.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:53:42 $ 

nf = nfactors(m);
if length(varargin)~=nf
    error('mbc:xregmodswitch:InvalidArgument', ...
        'You must specify a vector of values for each input factor.');
end

swFact = getSwitchFactors(m);
dims = cellfun('length', varargin);
sliceDims = ones(size(dims));
sliceDims(swFact) = dims(swFact);
sliceOK = false(sliceDims);

gridcell = cell(1, length(swFact));
[gridcell{:}] = ndgrid(varargin{swFact});

checkPts = zeros(numel(sliceOK), nf);
for n = 1:length(swFact)
    checkPts(:,swFact(n)) = gridcell{n}(:);
end
clear('gridcell');
sliceOK(:) = isSwitchPoint(m, checkPts);
clear('checkPts');

% Expand slice up into non-switching dimensions
dims(swFact) = 1;
gridOK = repmat(sliceOK, dims);