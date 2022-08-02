function E = saveobj(E)
% cgExprModel \ saveobj
% required to do the right thing with the pointers this object contains
% E.store = save(E.allPtrs);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:45 $
E.xregexportmodel = saveobj(E.xregexportmodel);
E.modObj = saveobj(E.modObj);
	