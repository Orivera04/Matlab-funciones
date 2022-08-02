function blk = slRecon(m,sname)
% LOGISTIC/SLRECON -  adds the appropriate reconstruct block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:44:06 $



try
	if ~isempty(findnl(m))
		%% pass through to the funcTemplate of the xregusermod part
		blk= feval(name(m),m.userdefined,'slRecon',m,sname);
	else
		blk = add_block(['Models2/Reconstruct/linearRecon'],[sname,'/Reconstruct']);
	end
catch
    blk = add_block(['Models2/Reconstruct/userLocalRecon'],[sname,'/Reconstruct']);
    
    % And warn that the non-linear block needs to be filled in
    warning('User Model block added to simulink system - Please fill the reconstruct block appropriately');   
end

set_param(blk,'linkstatus','none');


