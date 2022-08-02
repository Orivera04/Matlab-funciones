function des=saveobj(des)
% SAVEOBJ
%
%  Saveobj reduces the constraints size
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:07:40 $

des = ResetConstraints(des);

des.model = saveobj(des.model);
return
