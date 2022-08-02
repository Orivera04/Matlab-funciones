function ptr = cgparsemux(b,blockname,lines, PLIST)	
%CGPARSEMUX - A CAGE Simulink parse function
%
%  PTR = CGPARSEMUX(blockHandle,blockName,lines,pPointerList)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:25 $

persistent MUXINDEX

switch get_param(b,'Blocktype') 
case 'Mux'	
    [handles,newlines] = cgsl2exprsrcblocks(b);
    % we can get a inbalance between muxes and demuxes. Particularly if
    % switch blocks are used.
    if isempty(MUXINDEX)
        error( 'Unbalanced mex/demux blocks.' );
    end
    
	thisindex = MUXINDEX{end};    
	if ischar(thisindex)
		ports = get_param(b,'PortHandles');
		portNames = get_param(ports.Inport,'name');
		portNames = strrep(portNames,'<','');
		portNames = strrep(portNames,'>','');
		thisindex = strrep(thisindex,'<','');
		thisindex = strrep(thisindex,'>','');
		ind = find(strcmp(thisindex,portNames));
		if isempty(ind)
			thisindex=ind;
		end
	end
	neweqn = cgsl2exprgetprior(handles(thisindex),'',b,newlines(thisindex),PLIST);
	MUXINDEX(end)=[];
	ptr=neweqn;
case 'Demux'
	port = get_param(lines,'srcporthandle');
	MUXINDEX = [MUXINDEX {get_param(port,'portnumber')}];
	[handles,newlines] = cgsl2exprsrcblocks(b);
	neweqn = cgsl2exprgetprior(handles,'',b,newlines,PLIST);
	ptr=neweqn;
case 'BusCreator'
    error( 'Bus Creator block is not supported.' );
case 'BusSelector'
    port = get_param(lines,'srcporthandle');
	MUXINDEX = [MUXINDEX {get_param(port,'name')}];
	[handles,newlines] = cgsl2exprsrcblocks(b);
	neweqn = cgsl2exprgetprior(handles,'',b,newlines,PLIST);
	ptr=neweqn;
case 'Selector'
    error( 'Selector block is not supported.' );
end
