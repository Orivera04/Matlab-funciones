function m=reducetofull(m,x,ExtraDF)
%xreglinear/REDUCETOFULL   Reduce model to maximum fittable from x
%   M=REDUCETOFULL(M,X) reduces the number of terms in the model M 
%   until the regression matrix is full rank.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:55:50 $

m2=reducetofull(get(m,'currentmodel'),x,ExtraDF);
set(m,'currentmodel',m2);