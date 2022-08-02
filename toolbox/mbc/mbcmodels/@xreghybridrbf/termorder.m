function [NewOrder,numorder,orderlabels] = termorder(m)
%TERMORDER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:48:26 $



numlm = size(m.linearmodpart,1);
[lmNewOrder,lmnumorder,lmorderlabels] = termorder(m.linearmodpart);
[rbfNewOrder,rbfnumorder,rbforderlabels] = termorder(m.rbfpart);
NewOrder = [lmNewOrder(:) ; rbfNewOrder(:)+numlm(:)];
numorder = [lmnumorder rbfnumorder];
orderlabels = [lmorderlabels rbforderlabels];