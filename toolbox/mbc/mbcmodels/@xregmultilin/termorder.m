function [NewOrder,numorder,orderlabels] = termorder(m)
% xregcubic/EVAL evaluate xregcubic
% 
% y= eval(m,X)
% This code is vectorised and expects an nxm matrix where n is the number of data 
% points and m is the number of factors
%
% This is normally called from MODEL/SUBSREF rather than called directly.
% MODEL/SUBSREF does all model transformations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:03 $

[NewOrder,numorder,orderlabels] = termorder(get(m,'currentmodel'));