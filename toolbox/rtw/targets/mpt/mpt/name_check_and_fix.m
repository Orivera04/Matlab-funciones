function [newNameList, status] = name_check_and_fix(modelName,oldNameList)
%NAME_CHECK_and_fix Check identifier validity and fix invalid identifiers
%
%   INPUT:
%         modelName:    name of the model
%         oldNameList:  name list for check
%
%   OUTPUT:
%         newNameList:  new name list after check
%         status:       1: no error; 0: error

%   Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $
%   $Date: 2004/04/15 00:27:41 $

global mpmResult;
if isempty(mpmResult) | isfield(mpmResult,'warning')==0
    mpmResult.warning = {};
end

cr = sprintf('\n');
status = 1;
badList = '';
goodList = '';
newNameList = '';
for i = 1:length(oldNameList) 
    name = fliplr(deblank(fliplr(deblank(oldNameList{i}))));
    if isempty(regexp(name,'^<'))==0 &  isempty(regexp(name,'>$'))==0
        name = regexprep(name,'^<','');
        name = regexprep(name,'>$','');
    end
    name = fliplr(deblank(fliplr(deblank(name))));
    if isempty(regexp(name,'\W*')) == 0  % check if not a word
        status = 0;                     % not a word 
        [II, JJ] = regexp(name,'\W*');
        temp = name;
        for j = length(II):-1:1               % change to a work
            if JJ(j) < length(temp) &  II(j) > 1
               if isequal(temp(JJ(j)+1),'_')
                   temp = [temp(1:II(j)-1),temp(JJ(j)+1:end)];
               else
                   temp = [temp(1:II(j)-1),'_',temp(JJ(j)+1:end)];
               end
               if isequal(temp(II(j)-1),'_') 
                  temp = [temp(1:II(j)-1),temp(II(j)+1:end)];
               end
           else
               temp = regexprep(temp,'\W*','_');   
           end 
        end
        name = temp;
        if  isempty(regexp(name,'^[a-zA-Z]')) == 1   % check if name start with alphabetic char 
            name = regexprep(name,'^[^a-zA-Z]','');   % No. correct it
        end
        while 1
            if isempty(regexp(name,'_$')) == 1 & isempty(regexp(name,'^_')) == 1 
                break;
            else
                name = regexprep(name,'[_]$','');  % remove tail _ 
                name = regexprep(name,'^[_]','');  % remove lead _ 
            end
        end
        badList{end+1} = oldNameList{i};  
        if isempty(name)
            goodList{end+1} = ['No fix and no data object',cr,blanks(53),'created for this signal.'];  
        else
            goodList{end+1} = name;
        end
    elseif isempty(regexp(name,'^\d')) == 0 % check if name start with digit
        status = 0;
        name = regexprep(name,'^[\d]','');   % Yes. Remove the digit
        badList{end+1} = oldNameList{i};  
        goodList{end+1} = name;
    elseif isempty(regexp(name,'^_')) == 0 % check if name start with _
        status = 0;
        name = regexprep(name,'^[_]','');   % Yes. Remove lead _
        badList{end+1} = oldNameList{i};  
        goodList{end+1} = name;
    end
    newNameList{i} = name;
end

if status == 0
    msg = 'Invalid Identifier';
    outStr='';
    [goodListN, I, J ] = unique(goodList);
    for k = 1:length(goodListN)
        fixL = 32;
        if length(badList{I(k)}) < fixL
           space = blanks(fixL-length(badList{I(k)}));
        else
           space = ' ';
        end 
        outStr = [outStr,'     Invalid: ',badList{I(k)}, space,'Fixed: ',goodListN{k},cr];
    end
    detailMsg = ['The following are invalid identifiers and the fixes for code generation:',cr, outStr];   
    if isempty(mpmResult.warning) == 1 | isequal(mpmResult.warning{end}.detailMsg,detailMsg) == 0
         disp(['*** Warning: ',detailMsg]);
         mpmResult.warning{end+1}.detailMsg = detailMsg;
         mpmResult.warning{end}.msg = msg;
         mpmResult.warning{end}.type = 'Warning';
    end
end
return;

