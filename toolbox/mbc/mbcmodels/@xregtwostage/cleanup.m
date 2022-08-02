function m=cleanup(m);
%CLEANUP

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:25 $

m.Local= cleanup(m.Local);
for i=1:length(m.Global);
   m.Global{i}= cleanup(m.Global{i});
end
if isa(m.datum,'xregmodel')
   m.datum= cleanup(m.datum);
end