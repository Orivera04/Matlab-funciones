function arraydisp(opcobj)
%ARRAYDISP Display OPC Toolbox objects

% Copyright 2003-2004 OPTI-NUM solutions (Pty) Ltd.
% $Revision: 1.1.6.3 $  $Date: 2004/03/24 20:43:24 $

classDesc = {'Data Access'; 'Group'; 'Item'};
className = {'opcda'; 'dagroup'; 'daitem'};

uddObjs = getudd(opcobj);
% Write out the header.
newline = '\n';
isLoose = strcmpi(get(0,'FormatSpacing'), 'loose');
if isLoose,
    fprintf(1, newline);
end
fprintf(1, '   OPC %s Object Array:\n', classDesc{strcmp(class(opcobj),className)});
if isLoose,
    fprintf(newline);
end
switch class(opcobj)
    case 'opcda'
        hdrs = {'Status:', 'Name:'};
        props = {'Status', 'Name'};
        propFmtStr = '%-16s%s\n';
    case 'dagroup'
        hdrs = {'GroupType:','Active:','Name:'};
        props = {'GroupType', 'Active', 'Name'};
        propFmtStr = '%-12s%-10s%s\n';
    case 'daitem'
        hdrs = {'DataType:','Active:','ItemID:'};
        props = {'DataType', 'Active', 'ItemID'};
        propFmtStr = '%-11s%-9s%s\n';
end
fmtStr = [blanks(3) '%-8s', propFmtStr];
% Print the header
fprintf(1, fmtStr, 'Index:', hdrs{:});
% Get all the values for the display.
for i = 1:length(uddObjs)
    if ishandle(uddObjs(i))
        propVal = get(uddObjs(i), props);
    else
        propVal = repmat({'invalid'}, 1, length(props));
    end
    index = sprintf('%d',i);
    fprintf(1, fmtStr, index, propVal{:});
end	
if isLoose,
    fprintf(newline);
end

