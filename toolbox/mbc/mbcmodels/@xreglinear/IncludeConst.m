function ic= IncludeConst(m)
%INCLUDECONST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:02 $

ic= m.Constant & ~m.TermsOut(1);