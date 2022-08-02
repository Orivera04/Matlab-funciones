function k=genkey(T,subitem)
%GENKEY  Generate a key for the activex tree
%
%  key=genkey(T)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:21 $


% data dictionary defaults to using subitem as first in DD list.
if nargin<2
   subitem=getprimarysubitem(T);
end

k=genkey(T.cgcontainer,subitem);