function lab=labels(ps,TeX)
% localpspline/LABELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:20 $

if nargin<2
   TeX= 1;
end

lab= cell(size(ps,1),1);

if TeX
   lab{1}= 'k';
   lab{2}= '\beta_0';
   
   j=3;
   for i= 2:ps.order(1)
      lab{j}= sprintf('\\beta_{hi%d}',i);
      j=j+1;
   end
   for i= 2:ps.order(2)
      lab{j}= sprintf('\\beta_{lo%d}',i);
      j=j+1;
   end
else
   lab{1}= 'knot';
   lab{2}= 'max';
   
   j=3;
   for i= 2:ps.order(1)
      lab{j}= sprintf('Bhigh_%d',i);
      j=j+1;
   end
   for i= 2:ps.order(2)
      lab{j}= sprintf('Blow_%d',i);
      j=j+1;
   end
end   
