function [status, parameters, stInd, endInd] = find_function_pattern(string, functionName, paramCnt)
%FIND_FUNCTION_PATTERN detects a specific function pattern parse the arguments
%
%   [STATUS,PARAMETERS,STIND,ENDIND]=FIND_FUNCTIONPATTERN(STRING,FUNCTIONNAME
%   ,PARAMCNT)  This function will find a function pattern (functionName) 
%   in the C string (string).  Once this pattern is detected it will
%   parse out and determine the arguments of the function.
%
%   INPUT:
%         string:          C String to search
%         functionName:    Function name of interest
%         paramCnt:
%   OUTPUT:
%         status:          status of operation
%         parameters:      cell array of parameters passed to the function
%         sfInd:           start index of function
%         endInd:          end index of function

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.13.4.1 $
%   $Date: 2004/04/15 00:26:56 $

%search each line of string\
%ignore anything after a oomment on the line
%find function name
%  search for paired ().
%  count parameters in ().
%  return function name and parameter names

str = string;

%find all instances of functionName in the string
[mi] = findstr(str,functionName);
found_name = [];
parameters = [];
status = -1;
stInd = [];
endInd = [];
cr = sprintf('\n');
%for all instances of functionName
%
% This next section is added to filter out any functions foun inside of
% comment delimiters as invalid finds of a function and should be ignored.
%
% Use matlab regilar expressions to detect the /* and */ comment
% delimiters.   Assume that all valid comment delimer pairs exist.  As
% stateflow will not generate comments without valid delimiter pairs. 

[commentStrt,a,b] = regexp(str,'\/\*');     % This finds the opening comment delimiter "/*" 
[commentEnd,a,b] = regexp(str,'\*\/');      % This finds the closing comment delimiter "*/"

%
% Next Loop through the comment delimiter pairs checing if the index of the
% function found is within comment delimiters.   If inside comment
% delimiters then the function is ignored.  by setting the index in teh
% string of the function to "-1".
%

for indx=1:length(commentStrt), 
    for indxm=1:length(mi),
        if (mi(indxm) > commentStrt(indx)) & (mi(indxm) < commentEnd(indx)+1),         
           mi(indxm) = -1;
        end
    end
end

%
% Don't check for the function if the index is empty
%

if isempty(mi) == 0
    for i=1:length(mi)
        %get string relative to start of function pattern
        % Ignore the fucntion patter that has a -1 index indicating we
        % should ignore as an invalid function (located in a comment string).
        if mi(i)>1,
            str = string(mi(i):end);
            %check if start is beyond 1.
            %If beyond one, need to check if prior operator is not part of the function name
            %else
            %dont need to check
            if mi(i)>1
                back=string(mi(i)-1);
                noFlag = non_operator(back);
            else
                noFlag = 0;
            end
            %if non operator
            % then continue to parse function out.
            if noFlag == 0
                %find open/close () pair. Preserve calling parameters
                [lstatus, param,endPos] = find_matched_par(str,functionName);
                if lstatus == 0
                    status = 0;
                    if isempty(param{1}) == 0
                        param = strrep(param,cr,'');
                        param = no_leading_or_trailing_space(param);
                    end
                    parameters{end+1}=param;
                    stInd{end+1} = mi(i);   %start of function
                    endInd{end+1} = endPos + mi(i); %end of function           
                end
            end
        end
    end
end
% end

%--------------------------------------------------------------------------------
%----------------------------- no_leading_space ---------------------------------
%--------------------------------------------------------------------------------
function param = no_leading_or_trailing_space(inStr)
% Search until there are no more leading spaces.


for i=1:length(inStr)
    wStr = inStr{i};
    len = length(wStr);
    j=1;
    while (wStr(j) == ' ') & (j < len)
        j=j+1;
    end
    param{i}=deblank(wStr(j:end));
   
end

%--------------------------------------------------------------------------------
%----------------------------- find_matched_par ---------------------------------
%--------------------------------------------------------------------------------
function [status, parameters, endPos] = find_matched_par(string,functionName)

%search for matching ( ) and tokenize parameters
%filter out comments inside of parameters

%states:
%  0...NULL. Nothing found
%  1...open paren found
%  2...close paren found

% while not at the close paren and end of string
%  if state 0
%    check for open paran. If space found it is an error.
%  if state 0
%    check for close paran. if closed, save param
state = 0;
lenFun = length(functionName);
str = string(lenFun+1:end);
len = length(str);
i=0;
par = [];
parameters=[];
status = 0;
endPos = 0;

%loop until the close paren is found or all char are processed
while (state ~= 2) & (i < len)
    i=i+1;           %increment index
    switch(state)           %handle states between start, open and close paren.
    case 0                  %nothing found except characters
        if str(i)  == '('   %start of open paren
            state = 1;
            cnt = 1;
        else
            if str(i) ~= ' ' %found space between function name and paren (not good)
                status = -1; % fail and abort
                break;
            end
        end
    case 1                  %handle open paren
        switch(str(i))
        case ')'            %start of close paren
            if cnt == 1     %if cnt is 1, then this is the final close paren
                state = 2;
                parameters{end+1}=par;  %save parameters
                endPos = i+lenFun;
            else
                cnt = cnt - 1;      %reduce paren pair count
                par = [par,str(i)]; %save parameter
            end
        case '('                    %find additional open paren associate with a function
                                    %inside of a function
            cnt = cnt + 1;          %increment the paren pair count
            par = [par,str(i)];
        case ','                    %seperator between parameters
            if (str(i) == ',') & (cnt == 1)
                parameters{end+1}=par;
                par = [];
            else
                par = [par,str(i)];

            end
        otherwise
            par = [par,str(i)];
        end

    otherwise
    end
end

%--------------------------------------------------------------------------------
%----------------------------- non_operator -------------------------------------
%--------------------------------------------------------------------------------
function status = non_operator(backChar)
%determine if char is a non operator (leter, number or underscore).
if isletter(backChar) == 1
    status = 1;
elseif (backChar >= '0') & (backChar <= '9')
    status = 1;
elseif backChar == '_'
    status = 1;
else
    status = 0;
end

