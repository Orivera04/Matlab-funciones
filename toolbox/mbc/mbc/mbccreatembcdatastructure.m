function out = mbccreatembcdatastructure
%MBCCREATEMBCDATASTRUCTURE create a template mbc datastructure
%
%  MBC_DATA_STRUCT = MBCCREATEMBCDATASTRUCTURE
%  
%  This function returns a template structure as defined in the mbc data
%  loading API
%
%  See also MBCMODEL, MBCCHECKINDATALOADINGFCN.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:48:51 $ 

out = sweepset2struct(sweepset);