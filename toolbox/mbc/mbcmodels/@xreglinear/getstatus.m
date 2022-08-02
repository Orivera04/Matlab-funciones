function s = getstatus(m)
%GETSTATUS Return in/out status of terms
%
%  GETSTATUS(M) returns a vector containing integers that indicate whether
%  each term in the model is in or out of the model.  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:33 $

s = m.TermStatus;
