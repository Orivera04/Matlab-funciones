function [nextC, restOfC] = parsec(str, size)
%PARSEC Parses a string.
%
%  [NEXTC, RESTOFC] = PARSEC(STR, SIZE) 
%        It is used to parse a string.
%
%  INPUT:  
%        str:  a string which needs to be parsed
%        size: size of section to parse
%
%  OUTPUT:
%        nextC:   start of string   
%        restOfC: the rest of the string

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.9.4.1 $
%  $Date: 2004/04/15 00:28:44 $

nextC = [];
restOfC = [];
len = length(str);
if len > size
    cnt = size;
    index = 0;
    while ( cnt > 0)
        if str(cnt) == ' '
            index = cnt;
            break;
        end
        cnt = cnt - 1;
    end
    if index > 0
        nextC = str(1:index);
        restOfC = str(index+1:end);
    end
else
    nextC = str;
    restOfC = [];
end
