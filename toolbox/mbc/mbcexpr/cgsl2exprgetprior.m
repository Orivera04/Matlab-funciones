function [ptr] = cgsl2exprgetprior(b,ptr,prevblock,lines, PLIST)
%CGSL2EXPRGETPRIOR Main recursive algorithm for parsing Simulink Diagrams
%
%  OUT = CGSL2EXPRGETPRIOR(blockHandle,ptr,prevBlock,lines, pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 07:17:39 $ 
ptr = [];
% If this block is empty
if isempty(lines)
    lines=-2;
end
if b==-1
    if lines~=-1
        dstp = get_param(lines,'dstporthandle');
        pnum = get_param(dstp,'portnumber');
        blockname=get_param(b,'name');
        error( 'Blocks feeding into port #%d of %s failed to parse', num2str(pnum), blockname );
    end
    return
end


isopen = strcmp(get_param(b,'priority'),'1');
if isopen
    OK = 0;
    if strcmp(get_param(b,'blocktype'),'From') | strcmp(get_param(b,'blocktype'),'Goto')
        % May be an algebraic loop signal that we can convert to a variable
        name = get_param(b,'GotoTag');
        if ~isempty(name)
            [DD.info,ptr] = add(DD.info,name);
            OK = 1;
        end
    end
    if ~OK & ~isempty(lines)
        name = get_param(lines,'name');
        if ~isempty(name)
            [DD.info,ptr] = add(DD.info,name);
            OK = 1;
        end
    end
    if ~OK	
        set_param(b,'priority','0');  
        cgsl2exprerror( 'This block is part of an algebraic loop which CAGE cannot solve.', b);
        return   
    else
        set_param(b,'priority','1');
        return
    end
else
    set_param(b,'priority','1'); 
end	
blockname=get_param(b,'name');
blockname=fliplr(deblank(fliplr(blockname)));
blockname=strrep(blockname,' ','_');
blockname=strrep(blockname,char(10),'_');
blockname=strrep(blockname,'/','over');
if isempty(blockname)
    blockname = ['empty_',num2str(floor(rand*100))];
end

func = parsefunc(cgslblock,b);
if isempty(func)
    ptr = cgsl2exprunknown(b,blockname,prevblock,lines, PLIST);
else
    ptr = feval(func,b,blockname,lines, PLIST);
end

set_param(b,'priority','0');

return