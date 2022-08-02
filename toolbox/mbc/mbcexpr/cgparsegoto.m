function ptr = cgparsegoto(b,blockname,lines, PLIST)
%CGPARSEGOTO - A CAGE Simulink parse function
%
%  PTR = CGPARSEGOTO(blockHandle,blockName,lines, pPointerList)
%  Also handles FROM blocks

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.3 $    $Date: 2004/02/09 07:17:16 $	

switch get_param(b,'Blocktype') 
case 'From'
    try
        name = get_param(b,'GotoTag');
        ptr = cgsl2exprcheckname(name, PLIST);
        if ~isvalid(ptr)
            goto = find_system(get_param(b,'parent'),'findall','on','LookUnderMasks','all','followlinks','on','searchdepth',1,...
                'blocktype','Goto','GotoTag',get_param(b,'GotoTag'));
            if isempty(goto)
                goto = find_system(bdroot(b),'findall','on','LookUnderMasks','all','followlinks','on','blocktype','Goto','GotoTag',get_param(b,'GotoTag'));
            end
            ptr = cgsl2exprgetprior(goto,'',b,[],PLIST);
        end
    catch
        % no matching goto block
        try
            ud=get_param(b,'userdata');
            if (isa(ud, 'xregpointer') && isvalid(ud))
                ptr = ud;
            else
                DD = get(cgbrowser, 'DataDictionary');
                goto_tag = get_param( b, 'GotoTag' );
                [DD.info,ptr] = add(DD.info, goto_tag);
            end
        end
    end
case 'Goto'
    [handle,newline] = cgsl2exprsrcblocks(b);
    neweqn = cgsl2exprgetprior(handle,'',b,newline,PLIST);
    ptr = neweqn;
end
