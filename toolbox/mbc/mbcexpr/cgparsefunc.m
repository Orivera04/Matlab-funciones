function ptr = cgparsefunc(b,blockname,lines,PLIST)
%CGPARSEFUNC - A CAGE Simulink parse function
%
%  PTR = CGPARSEFUNC(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:13 $

funcStr = lower(get_param(b,'Expr'));
L = length(funcStr);
ind = 1;
while ind < L
    i = findstr(funcStr(ind:end),'u');
    if ~isempty(i)
        ind = i(1)+ind -1;
        if strcmp(funcStr(ind:ind+1),'u(') 
            % Input variable to be recognised
            endInd = findstr(funcStr(ind+1:end),')')+ind;
        elseif strcmp(funcStr(ind:ind+1),'u[')
            % Input variable to be recognised
            endInd = findstr(funcStr(ind+1:end),']')+ind;
        else
            % no brackets on u - single input
            break
        end
        % remove brackets
        funcStr([ind+1 endInd(1)]) = [];
        ind = endInd(1) - 1;
    else
        break
    end
end
f = cgfuncmodel(funcStr);
[srcblock,line] = cgsl2exprsrcblocks(b);
if strcmp(get_param(srcblock,'blocktype'),'Mux')
    b = srcblock;
end

[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = cell(size(handles));
for i = 1:length(handles)
    neweqn{i} = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
end

ptr = xregpointer(cgfuncexpr(blockname,f,[neweqn{:}]));
PLIST.info = [PLIST.info;ptr];
