function [ptrs,str] = InversionFilter(T,Tlist)
%INVERSIONFILTER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:14:26 $

% Takes a list of cgtablenodes and works out which of them can be inverted by a cgnormfunction 
% (and hence also cglookupone) and returns a list of these along with a string to display in the listbox.

ptrs = [];
k = 0; str = {};

for i = 1:length(Tlist)
    temp = getdata(Tlist{i});
    if isa(temp.info,'cgnormfunction') & ~isequal(temp.info,T)
        V = temp.get('values');
        if ~isempty(V) & length(unique(V)) ~= 1 % Can't invert empty or constant tables.
            ptrs = [ptrs;temp];
            k = k+1;
            str{k} = temp.getname;
        end 
    end
end

return