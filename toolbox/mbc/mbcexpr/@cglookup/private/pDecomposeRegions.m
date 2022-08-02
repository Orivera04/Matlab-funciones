function regs = pDecomposeRegions(mask)
%PDECOMPOSEREGIONS Find connected regions in a mask
%
%  REGS = PDECOMPOSEREGIONS(MASK) takes in a logical mask and returns a
%  cell array of logical masks, each one containing a separate disconnected
%  region from the original mask.  A connected region is composed of a set
%  of true values which all have at least one of their compatriots in one
%  of their immediately surrounding 8 cells.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:11:59 $ 

Numregs = 0;
[nR nC] = size(mask);

% This is the maximum theoretical number of distinct regions
regs = cell(1, ceil(nR*nC/4));
for n = 1:nR
    for m = 1:nC
        if mask(n, m)
            Numregs = Numregs + 1;
            thisreg = pFindRegion(mask, n, m);
            % Remove this whole region from mask
            mask(thisreg) = false;
            regs{Numregs} = thisreg;
        end
    end
end
regs = regs(1:Numregs);
