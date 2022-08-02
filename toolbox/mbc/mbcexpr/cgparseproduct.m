function ptr = cgparseproduct(b,blockname,lines, PLIST)	
%CGPARSEPRODUCT - A CAGE Simulink parse function
%
%  PTR = CGPARSEPRODUCT(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:26 $

[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = cell( size(handles) );
for i = 1:length(handles)
    neweqn{i} = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
end
% this can be a list of operations, or the number of inputs
ops = get_param(b,'inputs');
numops = str2double(ops);
if ~isnan(numops)
    ops = repmat('*',1,numops(1));
end
[ops,ind]=sort(deblank(ops));
if strcmp(ops,'*')
    ptr=neweqn{1};
else
    neweqn=neweqn(ind);
    %ops and neweqn is now either * or / and is in order
    Top = [];Bottom = [];
    mult_ind = findstr(ops,'*');
    Mult = [neweqn{mult_ind}];
    for i = 1:length(Mult)
        if Mult(i).isa('cgdivexpr')
            Top = [Top Mult(i).get('top')];
            Bottom = [Bottom Mult(i).get('bottom')];
        else
            Top = [Top Mult(i)];
        end
    end
    div_ind = findstr(ops,'/');
    Div = [neweqn{div_ind}];
    for i = 1:length(Div)
        if Div(i).isa('cgdivexpr')
            Top = [Top Div(i).get('bottom')];
            Bottom = [Bottom Div(i).get('top')];
        else
            Bottom = [Bottom Div(i)];
        end
    end
    
    try
        ud=get_param(b,'userdata');
        ud.info = ud.set('top',Top,'bottom',Bottom);
        ud.info = ud.setname(blockname);
        ptr = ud;
    catch
        ptr = xregpointer(cgdivexpr(blockname,Top,Bottom));
        PLIST.info = [PLIST.info;ptr];
        set_param(b,'userdata',ptr);
    end
end