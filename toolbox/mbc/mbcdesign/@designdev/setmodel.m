function D= setModel(D,m);
% DESIGNDEV/SETMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:04:10 $

% des= D.DesignTree.designs{1};
% D.DesignTree.designs{1}= model( des, m );
D.DesignTree.designs{1}= designobj(m);