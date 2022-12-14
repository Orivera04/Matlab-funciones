function dstString = HTMLjsencode(srcString, choice)
% a start point to translate string into/from HTML encode...
% it must correspond to javascript which does the translation on the page

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

if nargin~=2
    usage
    return
end;

% it's a special case needs take care of...
char_carriageReturn = sprintf('\n');
%  var srcList = new Array('z', '(', ')', '?', '&', '$', '|', '^', '{' , '}','\'','\"','\\', '[', ']', '/', '#', '<', '>', '.', '+', '=', '~', '@', '%', '`', ',');
%  var dstList = new Array('z0','z1','z2','z3','z4','z5','z6','z7','z8','z9','za','zb','zc','zd','ze','zf','zg','zh','zi','zj','zk','zl','zm','zn','zo','zp','zq');

EncodeTable = ...
    { 'z' 'z0';...
      '(' 'z1';...
      ')' 'z2';...
      '?' 'z3';...
      '&' 'z4';...
      '$' 'z5';...
      '|' 'z6';...
      '^' 'z7';...
      '{' 'z8';...
      '}' 'z9';...
      '''' 'za';...
      '"' 'zb';...
      '\' 'zc';...
      '[' 'zd';...
      ']' 'ze';...
      '/' 'zf';...
      '#' 'zg';...
      '<' 'zh';...
      '>' 'zi';...
      '.' 'zj';...
      '+' 'zk';...
      '=' 'zl';...
      '~' 'zm';...
      '@' 'zn';...
      '%' 'zo';...
      '`' 'zp';...
      ',' 'zq';...
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
            dstString = [dstString, dstSubString];
        end
    case 'decode'
        i=1;
        while i<=length(srcString)
            if i < length(srcString)
                for j=1:length(EncodeTable)
                    dstSubString = strrep(srcString(i:i+1), EncodeTable(j,2), EncodeTable(j,1));
                    dstSubString = dstSubString{:};
                    if ~strcmp(dstSubString, srcString(i:i+1))
                        i = i+1;
                        break
                    else
                        dstSubString = srcString(i);
                    end
                end
            else
                dstSubString = srcString(i);
            end
            dstString = [dstString dstSubString];
%            if i==length(srcString)
%                dstString = [dstString srcString(i)];
%            end
            i = i+1;
        end
        
    otherwise
        usage;
        return
end


function usage
disp(' dstString = HTMLjsencode(srcString, ''encode'')');
disp(' dstString = HTMLjsencode(srcString, ''decode'')');
