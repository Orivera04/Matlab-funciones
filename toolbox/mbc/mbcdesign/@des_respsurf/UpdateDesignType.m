function des=UpdateDesignType(des,opt)
% UPDATEDESIGNTYPE  Decide new design type after optimal operation
%
%  D=UpdateDesignType(D,OPTIM)
%
%   OPTIM is a string indicating the optimisation operation that caused
%   the update:  either 'v' or 'd'.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:03:27 $

% Created 10/1/2001

[tp,info]=DesignType(des);
switch tp
case 1
   tp=1;
   if strcmp(opt,'v')
      if ~strcmp(info,'V-optimal')
         info='Hybrid';
      end
   elseif strcmp(opt,'d')
      if ~strcmp(info,'D-optimal')
         info='Hybrid';
      end
   elseif strcmp(opt,'a')
      if ~strcmp(info,'A-optimal')
         info='Hybrid';
      end     
   end
otherwise
   % optimal on top of something else
   tp=0;
   info=[];
end
des=DesignType(des,tp,info);