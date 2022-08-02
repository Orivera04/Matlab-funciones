function [y,p]= reconstruct(u,Yrf,x,dat);
% USERLOCAL/RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:37:53 $

y= eval(u,x);
p= repmat(double(u)',size(Yrf,1),1);


   
