function  res =get(obj,parameter)
%  Synopsis
%     function  res =get(obj,parameter)
%
%  Description
%     Peforms the same action as the handle graphics get function.
%     Some parameter types are overloaded however to take into account
%     object groupings.
%
%  Parameters
%     DIMENSION
%     GAPX
%     GAPY
%     CORRECTALG
%     COLSIZES
%     ROWSIZES
%     COLRATIOS
%     ROWRATIOS
%     VISIBLE
%     HSCROLL
%     VSCROLL
%     CURRENTROW
%     CURRENTCOL
%
%  See Also
%     methods xregcontainer
%     methods xreggridLayout

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:36:09 $

switch upper(parameter)
    case 'DIMENSION'
        res = [obj.hGrid.Rows, obj.hGrid.Columns];
    case 'GAPX'
        res = obj.hGrid.ColumnGap;
    case 'GAPY'
        res = obj.hGrid.RowGap;
    case 'CORRECTALG'
        res = obj.g.info.usecorrectalg;
        if res
            res = 'on';
        else
            res = 'off';
        end
    case 'COLSIZES'
        res = obj.hGrid.ColumnSizes;
    case 'ROWSIZES'
        res = obj.hGrid.RowSizes;
    case 'COLRATIOS'
        res = obj.hGrid.ColumnRatios;
    case 'ROWRATIOS'
        res = obj.hGrid.RowRatios;
    case 'VISIBLE'
        res = {'off','on'};
        res = res{obj.g.info.visible+1};
    case 'HSCROLL'
        res = {'off','on'};
        res = res{obj.g.info.hscrollon+1};
    case 'VSCROLL'
        res = {'off','on'};
        res = res{obj.g.info.vscrollon+1};
    case 'CURRENTROW'
        res = obj.g.info.currentrow;
    case 'CURRENTCOL'
        res = obj.g.info.currentrow;
    case 'SLIDERSIZE'
        res = obj.g.info.slidersize;
    otherwise
        res = get(obj.xregcontainer,parameter);
end
