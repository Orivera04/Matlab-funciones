function checkList = custom_error_check_hook
%CUSTOM_ERRECK_CHECK_HOOK Create a hook for using custom error check
% 
% Find all custom_err_check_*.m files in toolbox\rtw\targets\mpt\custom_example 
% of the matlabroot dirctory.  These custom error check files need to give name 
% in the form of 'custom_err_check_xxx.m', such as, custom_err_check_table.m 
% for checking consistency of table data and its size. 
% 
%  OUTPUT: 
%         checkList: a cell array for containing custom error checking files
%
% This function should be put into the directory of custom_example,
% and the code in this function should look like:
% list = dir([matlabroot,filesep,'toolbox',filesep,'rtw',filesep,'targets',filesep,'mpt',...
%                 filesep,'custom_example',filesep,'custom_err_check_*.m']);
% for i = 1:length(list)
%     checkList{i} = list(i).name;
% end
% return;
% 

%  Linghui Zhang
%  Copyright 2002 The MathWorks, Inc. 
%  $Revision: 1.1 $
%  $Date: 2002/07/19 17:02:36 $

% In user_specific, this function does nothing but return an empty string.
checkList = '';
return;
