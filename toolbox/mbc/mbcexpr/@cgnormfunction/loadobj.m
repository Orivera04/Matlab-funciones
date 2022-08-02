function LT = loadobj(LT)
%LOADOBJ  Load time actions for cgnormfunction class
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:14:59 $

% Old table versions had no version field and require a messy update
if ~isfield(LT, 'version')
    if isa(LT,'struct')
        l = LT.cglookup;
        name = getname(l);
        L = cgnormfunction;
        L = setname(L,name);
        L.Breakpoints = LT.Breakpoints;
        L.Values = LT.Values;
        L.Xexpr = LT.Xexpr;
        L.Memory = LT.Memory;
        L.VLocks = LT.VLocks;
        L.SFlist = LT.SFlist;
        L.Weights = LT.Weights;
        L.Clips = LT.Clips;
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
        if ~isfield(LT,'Precision')
            L.Precision = cgprecfloat('double');
        elseif isempty(LT.Precision)
            L.Precision = cgprecfloat('double');
        elseif ~isa(LT.Precision,'cgprec')
            L.Precision = precconvert(LT.Precision,LT.Range);
        else
            L.Precision = LT.Precision;
        end
        if isfield(LT, 'ExtrapolationMask')
            idx = find(LT.ExtrapolationMask);
            L = addToExtrapolationMask(L, idx);
        end
        LT = L;
    elseif ~isa(LT.Precision,'cgprec')
        LT.Precision = precconvert(LT.Precision,LT.Range);
    end
end
