function ptr = cgparsesum(b,blockname,lines, PLIST)	
%CGPARSESUM - A CAGE Simulink parse function
%
%  PTR = CGPARSESUM(blockHandle,blockName,lines)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:30 $

neweqn=[];
[handles,newlines] = cgsl2exprsrcblocks(b);
for i = 1:length(handles)
    p = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
    neweqn = [neweqn {p}];
end
ops = get_param(b,'inputs');
numops=str2double(ops);
if ~isnan(numops)
    ops=repmat('+',1,numops(1));
end
ops = deblank(strrep(ops,'|',''));
if strcmp(ops,'+')
    % Don't need a sum block
    ptr = neweqn{1};
else
    [ops,ind]=sort(ops);
    neweqn={neweqn{ind}};
    %ops and neweqn is now either + or - and is in order
    Left = [];Right = [];
    add_ind = findstr(ops,'+');
    Add = [neweqn{add_ind}];
    for i = 1:length(Add)
        if Add(i).isa('cgsubexpr')
            Left = [Left Add(i).get('left')];
            Right = [Right Add(i).get('right')];
        else
            Left = [Left Add(i)];
        end
    end
    sub_ind = findstr(ops,'-');
    Sub = [neweqn{sub_ind}];
    for i = 1:length(Sub)
        if Sub(i).isa('cgsubexpr')
            Left = [Left Sub(i).get('right')];
            Right = [Right Sub(i).get('left')];
        else
            Right = [Right Sub(i)];
        end
    end
    try
        ud=get_param(b,'userdata');
        ud.info = ud.set('left',Left,'right',Right);
        ud.info = ud.setname(blockname);
        ptr = ud;
    catch
        ptr = xregpointer(cgsubexpr(blockname,Left,Right));
        PLIST.info = [PLIST.info;ptr];
        set_param(b,'userdata',ptr);
    end
end