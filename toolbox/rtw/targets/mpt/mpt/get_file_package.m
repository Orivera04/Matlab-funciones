function fp = get_file_package(modelName)

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.2.4.1 $
%   $Date: 2004/04/15 00:27:03 $

machine = get_sf_data(modelName);
machineOrg=machine;
machine = what_is_top_sf_components( machine);
for i=1:length(machine.chart)
    fullName = [modelName,'/',machine.chart{i}.name];
    machine.chart{i}.optionFcnFile = establish_function_file_name(fullName,machine.chart{i}.uniqueName);
end
 
fp.filePackage = mpm_file_org1(modelName,machine);
fp.fileFunList = get_fun_and_files(fp.filePackage);
fp.machine = machine;
