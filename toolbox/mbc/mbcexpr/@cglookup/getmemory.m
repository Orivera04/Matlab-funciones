function [out,ind] = getmemory(T,ind)
%GETMEMORY
%
%  out = GETMEMORY(index)
%  out = GETMEMORY(date)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.2.2 $  $Date: 2004/02/09 07:10:21 $

out = [];
mem = get(T,'memory');
if isa(ind,'double') & ind < 6e5
    % index
    if ind <= length(mem)
        out = mem{ind};
    end
else
    % date
    date = datenum(ind)+1e-5;
    OK = 0;
    for ind = length(mem):-1:1
        if datenum(mem{ind}.Date) < date
            OK = 1;
            break
        end
    end
    if OK
        out = mem{ind};
    else
        ind = [];
    end
end
