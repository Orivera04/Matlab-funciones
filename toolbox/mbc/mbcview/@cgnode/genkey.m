function k=genkey(T,subitem)
%GENKEY  Generate a key for the activex tree
%
%  key=genkey(T)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:53 $

if nargin<2
   subitem=0;
end

T=address(T);
ind=double(T);
k= sprintf('K%d;S%d',ind,double(subitem));
