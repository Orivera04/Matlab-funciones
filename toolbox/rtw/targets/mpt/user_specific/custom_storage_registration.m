function storageClass = custom_storage_registration(storageClass,name)
%CUSTOM_STORAGE_REGISTRATION - hook to allow for custom storage type registration.
%
%   [STORAGECLASS]=CUSTOM_STORAGE_REGISTRATION(STORAGECLASS,NAME)
%   This function returns the storage type qualifier for each case.
%   The possible storage types are  ARRAY, SCALAR, TIMER, FLAG, REGISTER, and STRUCTURE.
%
%
%   Inputs:
%           storageClass : Storage class passed in as a default value
%           name :         Name of data item to associate with storage class  
%
%   Outputs:
%           storageClass : Storage class as determined by this file.   

%
%  Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1.4.1 $  $Date: 2004/04/15 00:29:22 $
%  $ Revision:  $
%  $ Date:  $
%

return