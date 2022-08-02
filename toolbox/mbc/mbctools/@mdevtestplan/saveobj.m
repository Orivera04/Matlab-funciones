function T= saveobj(T);
%MDEVTESTPLAN/SAVEOBJ 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 08:08:13 $

T.DesignDev= saveobj(T.DesignDev);
T.modeldev = saveobj(T.modeldev);
for i=1:length(T.Responses)
	T.Responses{i}= saveobj(T.Responses{i});
end
