function  mpt_initialize_db(modelName)
%MPT_INTIALIZE_DB will intialize the data buffer for SDO record info.
%
% MPT_INTIALIZE_DB(MODELNAME) will initialize the data buffer that contains
% the records from each custom storage class define operation.

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/10/02 03:06:26 $
 
%This approach will evolve in the future.
global mptDataInfo;
mptDataInfo = [];