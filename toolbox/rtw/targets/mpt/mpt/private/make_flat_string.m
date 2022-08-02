function lstr = make_flat_string(string)
%MAKE_FLAT_STRING puts all lines within a file into a single string
%
%   [LSTR]=MAKE_FLAT_STRING(STRING)
%   This function puts all lines (string) from a file into a single string.
%
%   INPUTS:
%          string : array of strings to process
%   OUTPUT:
%          lstr   : flat string

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.7.4.1 $  $Date: 2004/04/15 00:28:22 $


lstr = [];
cr = sprintf('\n');

%for each line in the file
%  combine it into a single string, insert '/n' at each line

for i=1:length(string)
    lstr = [lstr,string{i},cr];
end