function [out] = istwostage(bdev)
%ISTWOSTAGE True for two-stage boundary modeling tree nodes
%
%  ISTWOSTAGE(NODE) is true if the boundary modeling tree node NODE should
%  be viewed as two-stage and is false otherwise.
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:12:52 $ 

out = bdev.Stages == 1;
