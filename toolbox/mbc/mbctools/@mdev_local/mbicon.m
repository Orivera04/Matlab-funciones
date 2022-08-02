function ic= mbicon(mdev);
% MODELDEV/MBICON

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:04:43 $

m= BestModel(mdev);
if isempty(m)
	m= model(mdev);
end
[im,ic]= icon(m);



