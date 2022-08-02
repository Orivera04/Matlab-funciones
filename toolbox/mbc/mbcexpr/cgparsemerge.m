function ptr = cgparsemerge(b,blockname,lines, PLIST)	
%CGPARSEMERGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.2 $  $Date: 2004/02/09 07:17:22 $

neweqn=[];
features = [];
[handles,newlines] = cgsl2exprgetpostblocks(b);

if length(handles)>1
    for i = 1:length(handles)
        p = cgsl2exprgetprior(handles(i),'',get_param(b,'handle'),newlines(i), PLIST);
        if isvalid(p)
            thisfeature = xregpointer(cgfeature([p.getname,'_',num2str(i)]));
            thisfeature.info = thisfeature.set('equation',[thisfeature,p]);
            neweqn = [neweqn;p];
            features = [features;thisfeature];
        end
    end
    try
        ud=get_param(b,'userdata');
        ud.info = ud.set('list',features);
        ud.info = ud.setname(blockname);
        ptr = ud;
    catch
        input = xregpointer(cgconstant([blockname,'_Switch'],1));
        ptr = xregpointer(cgmswitchexpr(blockname,input,features'));
        PLIST.info = [PLIST.info;ptr;features;input];
    end
else
    ptr = cgsl2exprgetprior(handles,'',get_param(b,'handle'),newlines, PLIST);
    PLIST.info = [PLIST.info;ptr];
end

