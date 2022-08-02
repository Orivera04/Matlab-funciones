function LT = loadobj(LT)
%LOADOBJ  Load time actions for cglookuptwo
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:54 $


if ~isfield(LT, 'version')
    if isa(LT,'struct')
        l = LT.cglookup;
        name = getname(l);
        L = cglookuptwo;
        L = setname(L,name);
        L.Values = LT.Values;
        L.Xexpr = LT.Xexpr;
        L.Yexpr = LT.Yexpr;
        L.Clips = LT.Clips;
        L.Memory = LT.Memory;
        L.VLocks = LT.VLocks;
        L.SFlist = LT.SFlist;
        L.Weights = LT.Weights;
        
        if ~isfield(LT,'Description')
            L.Description = [];
        else
            L.Description = LT.Description;
        end
        if ~isfield(LT,'Input')
            L.Input = [];
        else
            L.Input = LT.Input;
        end
        if ~isfield(LT,'Range')
            L.Range = [];
        else
            L.Range = LT.Range;
        end
        if ~isfield(LT,'cgprec')
            L.Precision = cgprecfloat('double');
        elseif isempty(LT.Precision)
            L.Precision = cgprecfloat('double');
        elseif ~isa(LT.Precision,'cgprec')
            L.Precision = precconvert(LT.Precision,LT.Range);
        else
            L.Precision = LT.Precision;
        end
        if isfield(LT,'ExtrapolationMask')
            [rowIdx, colIdx] = find(LT.ExtrapolationMask);
            L = addToExtrapolationMask(L, rowIdx, colIdx);
        end
        LT = L;
    elseif ~isa(LT.Precision,'cgprec')
        LT.Precision = precconvert(LT.Precision,LT.Range);
    end
end