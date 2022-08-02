function [new_sys,EvM]=modelbuild(m,parent,name,DO_PEV)
%MODELBUILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:17 $

%Downcast the rbf to a xreglinear to call inherited modelbuild
[new_sys, EvM, JcbM] = modelbuild(m.xreglinear, parent, name, DO_PEV, m);

% Get the J output from the eval block
evPort = get_param(EvM,'outport');
evPort = evPort(2,:);

% Now join 2nd output of Eval to 2nd Inport of Jacob
if DO_PEV
	jPort = get_param(JcbM,'inport');
	jPort = jPort(2,:);
	
	add_line(new_sys,[...
			evPort;...
			evPort + [5 0];...
			evPort + [5 30];...
			evPort + [-140 30];...
			[evPort(1)-140 jPort(2)] ;...
			jPort]);
else
	term = add_block('built-in/terminator', [parent '/' name '/term']);
	set_param(term, 'position', [(evPort + [20 -10]) (evPort + [40 10])]);
	tPort = get_param(term, 'inport');
	add_line(new_sys, [evPort; tPort]);
end
