function addlegend(h, hlines, names)
%ADDLEGEND Add legend.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/03/30 13:11:40 $

l = legend;
if isempty(l)
    legend(hlines, names{1:end}); 
else
    string = get(l, 'String');
    exist_legend = length(string);
    new_legend = length(names);
    for i = 1:new_legend
        string{exist_legend+i} = names{i};
    end
    legend(l, string{1:end}); 
end
legend hide;
if findobj(gca, 'Type', 'patch')
    hasbehavior(findobj(gca, 'Type', 'patch'),'legend',false);   
end