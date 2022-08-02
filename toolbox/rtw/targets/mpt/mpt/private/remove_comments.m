function [parsed, noCommentStr] = remove_comments(string)
%REMOVE_COMMENTS Removes all comments from a given string of C code.
%
%  [PARSED, NOCOMMENTSTR] = rREMOVE_COMMENTS(STRING)
%        It will remove /* */ type comments from a string. The processed string
%        is returned.
%
%  INPUT:
%        string:  C string to remove comments from
%
%  OUTPUTS: 
%        noCommentStr:  processed C string without comments
%        parsed:        parsed information
%

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $  
%  $Date: 2004/04/15 00:28:47 $

%parsed.active
%parsed.comment

%remove /* */ type comments

%find /* and search until */, then remove

startC=[];
endC=[];

%states
%  c0 ... no comment open
%  c1 ... start of comment

noCommentStr = [];
parsed=[];
state = 0;  %no comment
i=0;
len = length(string);
pi = 0;
% for each character in the string,
%   check for a opening or closing comment pattern (/* and */)
while (i < len)
    i=i+1;
    switch(state)
    case 0  %no comment open state
        % if "/*" is found
        %  then it is start of comment. 
        %     set state to "open comment" and count number of open comments
        %  else
        %  save character and stay in no comment state
        if string(i) == '/'
            i=i+1;
            if string(i) == '*'
                state = 1;                    %open comment found
                pi = pi + 1;
                parsed.comment{pi}=[];
            else
                state = 0;                    %not an open commnet, save the char
                i = i - 1;
                noCommentStr = [noCommentStr,string(i)];
            end
        else
            noCommentStr = [noCommentStr,string(i)];
        end
    case 1   %open comment state
        % if closed comment "*/"
        %   then decement comment count
        %     if all nesting is closed
        %       then total comment is closed
        %    else
        %      remain in comment open state
        if string(i) == '*'
            i=i+1;
            if string(i) == '/'
                
                state = 0;
            else
                parsed.comment{pi} = [parsed.comment{pi},string(i)];
                state = 1;
                i = i - 1;
            end
        else
            parsed.comment{pi} = [parsed.comment{pi},string(i)];
        end    
    otherwise
    end
end