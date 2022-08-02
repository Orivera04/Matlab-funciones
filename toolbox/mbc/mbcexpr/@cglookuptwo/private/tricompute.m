function zout = tricompute(LT, X1,X2,X3,x,y);
% TRICOMPUTE
%
% Imagine a plane goes through the three points X1,X2 and X3 in 3-space. We are given the x-y coordinates
% of a fourth point, X, and this here function computes the z-value that would then put this point on the
% aforementioned plane.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 07:12:33 $

if ~isequal(size(x),size(y))
    error('no non no');
    return
end

zout = (-(-X1(3)*X2(2)+X1(3)*X3(2)+X2(3)*X1(2)-X2(3)*X3(2)-X3(3)*X1(2)+...
    X3(3)*X2(2))/(X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+...
    X3(1)*X1(2)-X3(1)*X2(2)))*x+((-X1(3)*X2(1)+X1(3)*X3(1)+X2(3)*X1(1)-X2(3)*X3(1)-X3(3)*X1(1)+X3(3)*X2(1))/...
    (X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+X3(1)*X1(2)-X3(1)*X2(2)))*y+...
    ((X1(3)*X2(1)*X3(2)-X1(3)*X3(1)*X2(2)-X2(3)*X1(1)*X3(2)+X2(3)*X3(1)*X1(2)+...
    X3(3)*X1(1)*X2(2)-X3(3)*X2(1)*X1(2))/(X1(1)*X2(2)-X1(1)*X3(2)-X2(1)*X1(2)+X2(1)*X3(2)+X3(1)*X1(2)-X3(1)*X2(2)));

return