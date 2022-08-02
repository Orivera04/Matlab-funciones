function dstString = regexpFilter(srcString)
% a start point to translate string into regular expression ready string
% i.e, "sfix(16)" needs be translated to "sfix\(16\)" to be used for
% regular expression search

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $


SpecialCharTable = ...
    { '(' ')' '[' ']' '{' '}' '$' '\' '+' '^' '/' '*' '.' '^' '?' '|'};

dstString='';
for i=1:length(srcString)
    if ~isempty(intersect(SpecialCharTable, srcString(i)))
        dstString = [dstString '\']; % append escape character
    end
    dstString = [dstString srcString(i)];
end
    
