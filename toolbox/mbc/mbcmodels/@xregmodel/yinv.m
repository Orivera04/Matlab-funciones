function y = yinv(m,y);
% XREGMODEL/YINV perform inverse Y transformation on model
%
% y= yinv(m,y)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:53:30 $

if ~isempty(m.yinv)
   y= m.yinv(y);   
end