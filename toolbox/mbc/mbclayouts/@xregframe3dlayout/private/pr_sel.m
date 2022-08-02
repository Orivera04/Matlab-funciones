function pr_sel(obj,val)
%PR_SEL  select frame3dlayout
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:04 $


if val
   clrs={[0 0 0];...
         [.125 .125 .498];...
         [.1883 .1883 .7529];...
         [.2196 .2196 .8784]};
   
else
   clrs={[0 0 0];...
         [.498 .498 .498];...
         [.7529 .7529 .7529];...
         [.8784 .8784 .8784]};
end


set([obj.blackline;obj.darkline;obj.midline;obj.lightline],{'color'},clrs);

return