function includeFile = mpt_get_include_dependency(dataType)
%MPT_GET_INCLUDE_DEPENDENCY  allows for custom registration of include 
%dependencies
%
%   [INCLUDEFILE]=MPT_GET_INCLUDE_DEPENDENCY(DATATYPE,DATAOBJ)
%   Based on the custom data type passed in to this file,
%   an include dependency is determinded.
%   
%   Inputs:
%               dataType : data type of a data object
%   Outputs:
%               includeFile : include file correcsponding to the datatype
%

%   Linghui Zhang
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.3 $  $Date: 2004/04/15 00:29:31 $
%

includeFile{1} = '';
type = ac_get_type(dataType,'userName','userName','all');
if isempty(type) == 1
    dataDepend = '<tmwtypes.h>';
else 
    dataDepend = ac_get_type(dataType,'userName','userName','depend'); 
end
includeFile{1} = dataDepend;
return
