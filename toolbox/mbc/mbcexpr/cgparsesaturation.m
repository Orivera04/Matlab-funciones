function ptr = cgparsesaturation(b,blockname,lines, PLIST)
%CGPARSESATURATION - A CAGE Simulink parse function
%
%  PTR = CGPARSESATURATION(blockHandle,blockName,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:28 $

[handles,newlines] = cgsl2exprsrcblocks(b);
neweqn = cell( size(handles) );
for i = 1:length(handles)
    neweqn{i} = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
end

mx = str2double(get_param(b,'upperlimit'));
if isnan(mx), 
    mx = inf;
end

mn = str2double(get_param(b,'lowerlimit'));
if isnan(mn),
    mn = -inf;
end

ptr = xregpointer(cgclipexpr(blockname,[mn,mx], neweqn{1}));
PLIST.info = [PLIST.info;ptr];
