function cost= wcost(Wp,c,varargin);
% COVMODEL/WCOST cost function for 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:33 $

e= feval(c.costFunc,Wp,c,varargin{:});

cost= sum(e.^2);