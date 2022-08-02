function p= parameters(m);
% MODEL/PARAMETERS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:52 $

p= m.Beta; 
p= p(~m.TermsOut);