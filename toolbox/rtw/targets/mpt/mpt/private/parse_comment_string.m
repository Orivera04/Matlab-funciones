function [pcomment, tsym, csym] = parse_comment_string(comment)
%PARSE_COMMENT_STRING Parses a comment string.
%
%  [PCOMMENT, TSYM, CSYM] = PARSE_COMMENT_STRING(COMMENT) 
%        It is used to parse a comment string and determine the symbol 
%        associated with the comment. 
%
%  INPUT:
%        comment:  a comment string
%         
%  OUTPUTS:
%        pcomment:  parsed comment 
%        tsym:      template symbol token 
%        csym:      template comment token
%
%  RULES:
%         first non white space character must be '<';
%         next non white space character must be either 'S','s','C','c'
%         next non white space character must be ':'
%         next non white space character must be a alpha numeric string 
%                 with '_' permited;
%         next non white space character must be a '>';
%         if patter is not found, then return complete comment, no symbols
%               found.
%
%  Example:
%         <S:abstract> This function does this and that.
%        if '<' and '>' are present
%        and if '<' position is before '>'
%        then
%            check remaining rules
%        else
%         exit

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.11.4.1 $
%  $Date: 2004/04/15 00:28:41 $

tsym = [];
csym = [];
pcomment =[];
f1 = findstr(comment,'<');
c1 = findstr(comment,':');
f2 = findstr(comment,'>');


if (isempty(f1) == 0) & (isempty(f2) == 0) & (isempty(c1) == 0)
    if (f2(1) > f1(1)) & (c1(1) > f1(1)) & (c1(1) < f2(1))
        str = comment(f1(1):f2(1));
        pcomment = comment(f2(1)+1:end);
        sym = comment(f1(1)+1:c1(1)-1);
        switch(sym)
        case {'S','s'}
            tsym = comment(c1(1)+1:f2(1)-1);
        case {'C','c'}
            csym = comment(c1(1)+1:f2(1)-1);
        otherwise
            pcomment = comment;
        end
    else
        pcomment = comment;
    end
else
    pcomment = comment;
end