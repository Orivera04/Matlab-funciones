function p=NumTerms(m)
% xreglinear/NUMTERMS
%
%  P=NUMTERMS(M) returns the number of terms currently included
%  in the model.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:10 $

p=NumTerms(get(m,'currentmodel'));