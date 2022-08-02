function dataType = mpt_get_default_type()
%MPT_GET_DEFAULT_TYPE - returns the default data type for the mpt based objects
%
%   [DATATYPE]=MPT_GET_DEFAULT_TYPE()
%   This function returns the default data type for the mpt signal and mpt
%   parameter simulink data obejcts.
%
%   INPUTS:
%             none : 
%
%   OUTPUTS:
%            dataType : The default data object data type.
%
%

%
%   Patrick W. Menter
%   Linghui Zhang
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/04/15 00:29:30 $

dataType = 'double';
userTypes = rtwprivate('rtwattic', 'AtticData', 'userTypes');
if isempty(userTypes) == 1
    dataType = 'double';
else
    dataType = ac_get_type('real32_T', 'tmwName', 'userName', 'primary');
    if isempty(dataType) == 1
        dataType = 'double';
    end
end