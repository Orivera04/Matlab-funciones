function  [head,width]= colhead(mdev);
%COLHEAD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:10:05 $

[head,width]= StatsList(mdev.Model);
width= width/sum(width);

