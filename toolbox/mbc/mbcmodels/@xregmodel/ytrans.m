function y = ytrans(m,y);
% XREGMODEL/YTRANS perform Y transformation on model
%
% y= ytrans(m,y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:32 $

if ~isempty(m.ytrans)
   y= m.ytrans(y);   
end