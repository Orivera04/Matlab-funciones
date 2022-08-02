function FigName = dlgfigname(Fig)
%DLGFIGNAME Determine name to use in PrintDlg for Figure
%   Name consistents values of Handle and Name properties
%   of Figure argument.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $ $Date: 2004/02/09 07:34:08 $

FigName = get(Fig,'name');
if strcmp(get(Fig,'numbertitle'),'on') 
    if (length(FigName)>0)
        FigName = [': ' FigName];
    end
    if strcmp(get(Fig,'IntegerHandle'),'on'),
        FigName = ['Figure ' sprintf('%d',Fig) FigName];
    else,
        FigName = ['Figure ' sprintf('%.16g',Fig) FigName];
    end
end

if isempty(FigName)   % no name, number title off
    if strcmp(get(Fig,'IntegerHandle'),'on'),
        FigName = ['Figure ' sprintf('%d',Fig)];
    else,
        FigName = ['Figure ' sprintf('%.16f',Fig)];
    end
end
