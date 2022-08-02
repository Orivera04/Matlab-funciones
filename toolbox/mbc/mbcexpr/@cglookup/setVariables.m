function  [saveval, OK, msg] = setVariables(LT, Variables, om)
%SETVARIABLES
%
%  [SAVEVAL, OK, MSG] = SETVARIABLES(TBL, VARS, OM)
%  Set other variables using om. 
%  saveval are the preexisting values for reset purposes.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:12:11 $


OK = 1;
msg = [];
saveval = [];
% get the ranges on the Variables not in the table, and set their values 
for i = 1:length(Variables)
    varobj = Variables(i).info;
    saveval{i} = getvalue(varobj);
    % get the optmgr for setting the othervariables
    omseti = get(om,['Set_' getname(varobj)]);
    % run it
    [Variables(i).info, cost,tmpOK,tmpmsg] = run(omseti, varobj, []);
    if ~tmpOK
        OK = 0; % switch OK to 0 if anything goes wrong
        msg = [msg tmpmsg];
    end
end   