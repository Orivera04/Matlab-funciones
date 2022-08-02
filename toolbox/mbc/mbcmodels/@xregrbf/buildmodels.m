function [mlist,name]= buildmodels(r,nobs);
% BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.9.2.2 $  $Date: 2004/02/09 07:54:20 $

[r,ok]= gui_fitoptions(r);

if ok
   k= {@multiquadric,@recmultiquadric,@gaussian,...
         @thinplate,@logisticrbf,...
         @wendland,@wendland,@wendland,@wendland,...
         @linearrbf, @cubicrbf };
   c= [0 0 0 0 0 0 2 4 6 0 0];
   
   mlist= cell(1,length(k));
   for i=1:length(k);
      r.kernel= k{i};
      r.cont  = c(i);
      mlist{i}= r;
   end
   name= 'RBF Kernels';
else
   mlist= {};
   name = '';
end

