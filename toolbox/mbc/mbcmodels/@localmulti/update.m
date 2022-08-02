function L= update(L,p,dat)
%LOCALMULTI/UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:15 $

% p= [index2model; numParams; params]

if ~isfinite(p(1))
   m= get(L.xregmulti,'currentmodel');
   b= allparameters(m);
   p= [get(L.xregmulti,'currentindex'); length(b); b];
end
L.xregmulti= set(L.xregmulti,'currentindex',p(1));
m= get(L.xregmulti,'currentmodel');
m= updateallparameters(m,p(3:p(2)+2));

L.xregmulti= set(L.xregmulti,'currentmodel',m);
