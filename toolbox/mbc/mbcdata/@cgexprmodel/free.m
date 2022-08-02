function free(S)
% cgExprModel / free
% deletes all ptrs used by the equation except the vals stored in 
% the valptrs

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:49:38 $

free(S.allPtrs);
