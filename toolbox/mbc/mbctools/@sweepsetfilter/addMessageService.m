function obj = addMessageService(obj, dms)
%SWEEPSETFILTER/ADDMESSAGESERVICE adds a message service to a sweepsetfilter
%
%  OBJ = ADDMESSAGESERVICE(OBJ, DMS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:08:30 $ 

if isa(dms, 'xregtools.datamessageservice')
    obj.dataMessageService = dms;
end
