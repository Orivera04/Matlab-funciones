function r=meantol(TP,coding);
%MEANTOL depreciating code

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:08:03 $

M= model(TP);

Tgt= gettarget(M);
r= diff(Tgt,[],2)'/20;
if nargin==1
    r= invcode(M,r)- invcode(M,zeros(1,length(r)));
end
