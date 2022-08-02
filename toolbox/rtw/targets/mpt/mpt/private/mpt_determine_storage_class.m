function storageClass = mpt_determine_storage_class(objectName)
%[strorageClass]=mpt_determine_storage_class(objectName)
%
%    [STORAGECLASS]=MPT_DETERMINE_STORAGE_CLASS(OBJECTNAME)
%    This function determines the storage class of the associated data item
%    passed into it.  The base storage classes are SCALAR and ARRAY, this
%    provides a hook for registration of the timer data types and flag data
%    types based on customer types or the base usage of boolean as a flag
%    type if no user type is registered.
%
%    Inputs:
%              objectName : name of the data item that the storage class
%                           will be determined.
%              
%    Outputs:  
%              storageClass : the resultant storage class to be passed back
%     


%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.4.3 $  $Date: 2004/04/15 00:28:35 $

storageClass = 'MPT';
%   storageClass = 'SCALAR';
%   
%   arraySizePrelim = get_data_info(objectName,'DIMENSION');
%   
%   [m,n]=size(arraySizePrelim);
%   arraySize = m*n;
%   
%   if isempty(arraySize) == 1
%         arraySize = 1;
%   end
%     
%  if arraySize > 1,
%      storageClass = 'ARRAY';
%  else
%      storageClass = 'SCALAR';
%  end
   
storageClass = custom_storage_registration(storageClass,objectName);

return