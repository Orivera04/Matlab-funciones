function handle = cgsl2exprdestblock(b,outportnum)
%CGSL2EXPRDESTBLOCK Return the destination block for this block
%
%  [blockHandle] = CGSL2EXPRDESTBLOCK(blockHandle,outPortNumber)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:36 $ 
if nargin==1
    outportnum=1;
end
porthandles = get_param(b,'porthandles');
outport = porthandles.Outport;
line = get_param(outport(outportnum),'line'); 
if line==-1
    handle=get_param(b,'handle');
    return
else
    handle = get_param(line,'DstBlockHandle');
end
if length(handle)==1
    switch get_param(handle,'BlockType')
    case 'SubSystem'
        if ~cgsl2expristabletype(handle)
            dstport=get_param(line,'dstporthandle');
            num = get_param(dstport,'portnumber');
            subsysinport = find_system(handle,'findall','on','searchdepth',1,'LookUnderMasks','all','followlinks','on',...
                'blocktype','Inport','Port',num2str(num));
            % recursive call to get next block
            handle = cgsl2exprdestblock(subsysinport,1);
        end
    case 'Outport'
        parent=get_param(handle,'parent');
        if ~isempty(parent)
            if ~strcmp(get_param(parent,'type'),'block_diagram');
                portnum = get_param(handle,'Port');
                handle=cgsl2exprdestblock(parent,str2num(portnum));   
            end
        end
    end
end