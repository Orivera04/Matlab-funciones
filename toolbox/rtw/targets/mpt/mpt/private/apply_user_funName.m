function apply_user_funName
%  ALPPLY_USER_FUNNAME applies user specified func names to the generated code
%
%  ALPPLY_USER_FUNNAME 
%        This function applies user specified funtiona names to the generated code.
%
%  INPUT:
%         none
%  OUTPUT:
%         none

%  Linghui Zhang
%  Copyright 2002 The MathWorks, Inc.
%  $Revision: 1.1 $
%  $Date: 2002/06/04 19:49:31 $

global ecac;

for j =1: length(ecac.machine.chart)
    chartName = ecac.machine.chart{j}.uniqueName;
    userFunName = ecac.machine.chart{j}.optionFcnFile.MPMFcnName;
    if  ~isequal(userFunName,chartName)
         mpt_register_seq_subs([chartName,'\('], [userFunName,'(']);
    end
end        
return;
