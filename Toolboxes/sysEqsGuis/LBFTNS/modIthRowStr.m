function newStr=modIthRowStr(ithRow,Str,ithRowStr)
%This is exactly the same thing as modVerTxtEq
%but it's MUCH MUCH shorter and less computation
%it modifies the ithRow of a string
% IE Str=strvcat('chun','michelle','Janet')
% Str =
% chun    
% michelle
% Janet   
% modIthRowStr(3,Str,'Liz')
% ans =
% chun    
% michelle
% Liz     
[maxRow c]=size(Str);
newStr='';
for(iRow=1:maxRow)
    if(iRow~=ithRow)
        newStr=strvcat(newStr,Str(iRow,:));
    else
        newStr=strvcat(newStr,ithRowStr);
    end
end
newStr=char(cellstr(newStr));