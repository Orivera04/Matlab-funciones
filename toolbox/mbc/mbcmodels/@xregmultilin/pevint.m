function [int,s]= pevint(m,lowerlim,upperlim)
%PEVINT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:47 $

[int,s]= pevint(get(m,'currentmodel'),lowerlim,upperlim);