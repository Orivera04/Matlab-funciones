function L= pevinit(L,X,Y);
% LOCALMOD/PEVINIT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:07 $

if nargin>=3
    m= get(L.xregmulti,'currentmodel');
    [X,Y]= checkdata(L,X,Y);
    
    
    if isa(m,'xregarx')
        Y= double(Y);
        m= set(m,'ycode',Y);
        
        
        % initialize initial conditions
        m= set(m,'InitialConditions',Y(1));
    end
    [m,OK]= InitModel(m,double(X),double(Y),[],0);
    
    
    L.xregmulti= set(L.xregmulti,'currentmodel',m);
end
