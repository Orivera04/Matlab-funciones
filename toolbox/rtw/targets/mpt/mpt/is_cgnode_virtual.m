function status = is_cgnode_virtual(node)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.1 $
%   $Date: 2003/07/22 21:13:19 $

% len = length('TmpAtomicSubsys_Feeding_Switch_AtInput');  %for reference
% only. Result is 38

% status = strncmp(node.NodeName,'TmpAtomicSubsys_Feeding_Switch_AtInput',38);
%simple method to determine if node is virtual or not. Virtual is defined
%as a subsystem that is not visible to the user and does not have a
%"FullPath". The term "virtual" may be different that what is defined
%elsewhere.

try
    get_param(node.FullPath,'Name');
    status = 0;
catch
    status = 1;
end