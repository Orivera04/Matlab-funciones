function s = detex(s)
%DETEX Convert string to include escape characters for TeX symbols
%
%  DETEX(S) allows S to be displayed as TeX without any TeX processing
%  taking place in it.  TeX characters in the string(\,_,{,},^) are escaped
%  so that they do not cause any inadvertent TeX effects.
%
%  If S is a cell array of strings, each string is detexed and returned.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 06:48:26 $


if isa(s,'cell')
    for i = 1:numel(s)
        s{i} = i_detex(s{i});
    end
else
    s = i_detex(s);
end


function s = i_detex(s);
s = strrep(s,'\','\\');
s = strrep(s,'_','\_');
s = strrep(s,'{','\{');
s = strrep(s,'}','\}');
s = strrep(s,'^','\^');
