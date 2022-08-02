function [y,p]= reconstruct(m,Yrf,x,Datum);
% localpspline/RECONSTRUCT reconstruct localpspline for multiple values

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:41:32 $

p= Yrf/delG(m)';

knot= p(:,1)-Datum;
polyhigh = zeros(size(p,1),m.order(1)+1);
polylow= zeros(size(p,1),m.order(2)+1);


polyhigh(:,1:m.order(1)-1)  = p(:,m.order(1)+1:-1:3);
polylow(:,1:m.order(2)-1) = p(:,end:-1:m.order(1)+2);


polylow(:,end)  = p(:, 2);;
polyhigh(:,end)  = p(:, 2);

xd= x-knot;
md= xd <= 0;
y= zeros(size(xd));
if size(p,1)==size(x,1)
   for i= 1:size(y,1) 
      mi= md(i,:);
      y(i,mi) = polyval_mex(polylow(i,:), xd(i,mi) ) ;
      y(i,~mi) = polyval_mex(polyhigh(i,:), xd(i,~mi) );
   end
else
   y(md) = polyval_mex(polylow, xd(md) ) ;
   y(~md) = polyval_mex(polyhigh, xd(~md) ) ;
end
