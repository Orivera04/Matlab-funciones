function dstString = HTMLencode(srcString, choice)
% a start point to translate string into/from HTML encode...

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

if nargin~=2
    usage
    return
end;

% it's a special case needs take care of...
char_carriageReturn = sprintf('\n');

% Note: we can't use direct HTML Latin-1 standard encoding as browser will
% try to intepret the encoding for us before we have chnace to catch it. So
% instead of use full latin-1 table, a intentationally '!' is inserted. 
EncodeTable = ...
    { char_carriageReturn '&!#32;';...
      '!' '&!#33;';...
      '"' '&!#34;';...
      '#' '&!#35;';...
      '$' '&!#36;';...
      '%' '&!#37;';...
      '&' '&!#38;';...
      '''' '&!#39;';...
      '<' '&!#60;';...
      '>' '&!#62;';...
      ' ' '&!#160;';...
      '|' '&!#166;';...
  };

% clear first
dstString = '';
switch choice
    case 'encode'
        for i=1:length(srcString)
            for j=1:length(EncodeTable)
                dstSubString = strrep(srcString(i), EncodeTable(j,1), EncodeTable(j,2));
                if ~strcmp(dstSubString, srcString(i))
                    break
                end
            end
            dstString = [dstString dstSubString];
        end
    case 'decode'
        for j=1:length(EncodeTable)
            srcString = strrep(srcString, EncodeTable(j,2), EncodeTable(j,1));
        end
        dstString = srcString;
    otherwise
        usage;
        return
end


function usage
disp(' dstString = HTMLencode(srcString, ''encode'')');
disp(' dstString = HTMLencode(srcString, ''decode'')');
