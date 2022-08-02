function om= setConstraints(om,LB,UB,A,c,nlcon);
% XREGOPTMGR/SETCONSTRAINTS
% 
%  om= setConstraints(om,LB,UB,A,c,nlcon);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.8.4.2 $  $Date: 2004/02/09 07:56:59 $

om.Constraints= struct('LB',LB,'UB',UB,...
   'A',A,'c',c,'nlcon',nlcon);

