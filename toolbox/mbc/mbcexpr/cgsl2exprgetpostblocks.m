function [srcblock,line] = cgsl2exprgetpostblocks(b,varargin)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
srcblock=[];
line = [];
porthandles = get_param(b,'porthandles');

if nargin == 1
	inports = porthandles.Inport;
else
	inports = getfield(porthandles,varargin{1});
end

for i = 1:length(inports)
	line(i) = get_param(inports(i),'line');
	if line(i)==-1
        % no line feeding into this port
		srcblock(i)=-1;
	else
		srcblock(i) = get_param(line(i),'SrcBlockHandle');
		if srcblock~=-1
			while strcmp(get_param(srcblock(i),'BlockType'),'SubSystem') & ~strcmp(get_param(srcblock(i),'MaskType'),'Stateflow')
				if islibraryblock(cgslblock,srcblock(i))
					break
				end
				os_port = get_param(get_param(line(i),'SrcPortHandle'),'portnumber');
				is_port = find_system(srcblock(i),'findall','on','searchdepth',1,'LookUnderMasks','all','followlinks','on',...
					'blocktype','Outport','port',num2str(os_port));
				porthandles = get_param(is_port,'porthandles');
				inport = porthandles.Inport;
				line(i) = get_param(inport,'line');
				srcblock(i) = get_param(line(i),'SrcBlockHandle');
			end
		end
	end
end
%   $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:17:38 $
