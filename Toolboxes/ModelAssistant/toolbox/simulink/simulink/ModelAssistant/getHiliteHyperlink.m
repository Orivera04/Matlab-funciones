function hyperlink = getHiliteHyperlink(index)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

FOUND_OBJECTS = HTMLattic('AtticData', 'FOUND_OBJECTS');
ShowFullName = HTMLattic('AtticData', 'ShowFullName');
if ShowFullName
    objName = encodeStrtoHTMLsymbol(FOUND_OBJECTS(index).fullname);
else
    objName = encodeStrtoHTMLsymbol(FOUND_OBJECTS(index).name);
end
if ~isempty(objName)
    hyperlink = ['<a href="matlab: hiliteSystem '  num2str(index) '">' objName{:} '</a>'];
else
    hyperlink = ['<a href="matlab: hiliteSystem '  num2str(index) '">' 'It''s short name is empty' '</a>'];
end
return


% prevent special character broken HTML form
function dstString = encodeStrtoHTMLsymbol(srcString)
EncodeTable = ...
    { '<' '&#60;';...
      '>' '&#62;';...
      '&' '&#38;';...
      '#' '&#35;';...
  };
% clear first
dstString = '';
for i=1:length(srcString)
    for j=1:length(EncodeTable)
        dstSubString = strrep(srcString(i), EncodeTable(j,1), EncodeTable(j,2));
        if ~strcmp(dstSubString, srcString(i))
            break
        end
    end
    dstString = [dstString, dstSubString];
end
