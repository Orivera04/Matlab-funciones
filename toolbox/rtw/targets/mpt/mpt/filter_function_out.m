function newCFF = filter_function_out(functionPrototype,cff)


%states
% 0....nothing found
% 1...function prototype found
% 2...open curly brace (not inside of comment)
% 3...close curly brace (not inside of comment)...end of function
% 4.../*..comment open
% 5...*/..comment end

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.3.4.1 $  $Date: 2004/04/15 00:26:54 $

newCFF = [];

index = strfind( cff , functionPrototype);

len = length(cff);
startIndex = [];
finalIndex = [];
if isempty(index) == 0
    state = 1;    %function prototype found
    ind = index + length(functionPrototype);
    startIndex = index;
    commentCount = 0;
    curlyCount = 0;
    %main loop
    while ind <= len

        switch state
            case 0
            case 1
                if cff(ind) == '{'
                    %start of function body found
                    state = 2;
                    curlyCount = curlyCount + 1;
                end
            case 2  % open curly brace state
                switch(cff(ind))
                    case '{'
                               curlyCount = curlyCount + 1;
                    case '}'
                        curlyCount = curlyCount - 1;
                        if curlyCount == 0
                            %end of function found.
                            %save final index
                            state = 3;
                            finalIndex = ind;
                        end
                    case '/'
                        if cff(ind+1) == '*'
                            commentCount = commentCount + 1;
                            state = 4;
                            ind = ind + 1;
                        end
                    otherwise
                end
            case 3 %close curly brace.
                newCFF = [cff(1:startIndex-1),cff(ind:end)];
                break;
            case 4 %start of comment
                switch(cff(ind))
                    case '*'
                        if cff(ind+1) == '/'
                            commentCount = commentCount - 1;
                             ind = ind + 1;
                            if commentCount == 0
                                state = 5;
                            end
                        end
                    case '/'
                        if cff(ind+1) == '*'
                            commentCount = commentCount + 1;
                             ind = ind + 1;
                        end
                    otherwise
                end
            case 5 %end of comment
                switch(cff(ind))
                    case '/'
                        if cff(ind+1) == '*'
                            commentCount = commentCount + 1;
                            state = 4;
                            ind = ind + 1;
                        end
                    case '}'


                        curlyCount = curlyCount - 1;
                                             if curlyCount == 0
                            %end of function found.
                            %save final index
                            state = 3;
                            finalIndex = ind;

                        end
                    case '{'
                        state = 2;
                        curlyCount = curlyCount + 1;
                    otherwise
                end
            otherwise
        end
        ind = ind + 1;
    end
else
    %prototype not found, nothing to filter out
    newCFF = cff;
end
