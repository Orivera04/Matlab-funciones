function ic= IncludeConst(m)
%INCLUDECONST

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:20 $

lenF= m.poly_order+length(m.knots)+1; 
incl= Terms(m);

ic= all(incl(1:lenF));