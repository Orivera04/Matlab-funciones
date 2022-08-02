function cFunctions = extract_functions(cff)


%states
% 0....nothing found
% 1...function prototype found
% 2...open curly brace (not inside of comment)
% 3...close curly brace (not inside of comment)...end of function
% 4.../*..comment open
% 5...*/..comment end

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/15 00:26:53 $

newCFF = [];
ind = 1;
state = 0;
len = length(cff);
startIndex = 1;
finalIndex = [];
cFunctions=[];
    state = 1;    %function prototype found

    commentCount = 0;
    curlyCount = 0;
    functionPrototype=[];
    %main loop
    len = length(cff);
    while ind <= len
        
        switch state
            case 0
               
            case 1
                if cff(ind) == '{'
                    %start of function body found
                    %NOte body must always start with "{".
                    state = 2;
                    curlyCount = curlyCount + 1;
                    bodyStartIndex=ind;
                else
                     functionPrototype = cff(startIndex:ind);
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
                functionTotal = cff(startIndex:ind);
                functionBody  = cff(bodyStartIndex:ind);
                functionDetail.functionTotal = functionTotal;
                functionDetail.functionBody = functionBody;
                functionDetail.functionPrototype = functionPrototype;
                cFunctions{end+1}=functionDetail;
                functionPrototype=[];
                state = 1;
                startIndex = ind+1;
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
    
