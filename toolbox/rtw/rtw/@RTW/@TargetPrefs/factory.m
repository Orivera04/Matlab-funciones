function factory(h)
%FACTORY  Flush current instance with factory value, but NOT save it to disk.

%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/19 01:16:38 $
fullName = h.class;
str = [fullName];
tempObj = eval(str);

fldNames = fieldnames(h);
len = size(fldNames);
for i = 1:len
    str = ['h.' fldNames{i} ' = tempObj.' fldNames{i} ';'];
    eval(str);
end