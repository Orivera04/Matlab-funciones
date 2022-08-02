function ps=getBoolPackstatus(obj)
% getBoolPackstatus  return boolean packstatus
%
%  PS=getBoolPackstatus(obj) is the preferred method of returning
%  the boolean packstatus flag.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:35:20 $

ps=obj.g.PSobj.packstatus;

