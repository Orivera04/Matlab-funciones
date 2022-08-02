function [head,width]= colhead(m);
%COLHEAD   Get statistics column headings for xreginterprbf object 
%   [Head,Width] = COLHEAD(M)
%
%   See also STATS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:48:39 $ 

head  = {'Observations','Parameters','Box-Cox','RMSE'};
width = [35,30,25,40];

% EOF
