function out = get(obj , prop)
%GET Get values of tradeoff properties
%
%  VAL = GET(TO, PROP) gets the value of the stated property from the
%  tradeoff object.  Since @cgtradeofff is no longer in active use, this
%  method exists solely to facilitate the upgrade process from earlier
%  object versions that have been saved in CAGE project files.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/04/04 03:27:49 $

switch lower(prop)
    case 'sameylimits'
        out = logical(obj.sameYlimits);
    case 'errordisp'
        out = logical(obj.showError);
    case 'viewstore'
        out = obj.viewStore;
    case 'oppoint'
        out = obj.opPoint;
    case 'fillptrs'
        out = obj.fillPtrs;
    case 'tableptrs'
        if isempty(obj.tablePtrs)
            out = null(xregpointer, 0);
        else
            out = obj.tablePtrs;
        end
    case 'hiddenfactors'
        out = obj.hiddenFactors;
    case 'hiddenmodels'
        out = obj.hiddenModels;
end
