function A = denf(R,na)
%DENF	Compute denominator from covariances.
%	A = DENF(R,NA) computes order NA denominator A from covariances 
%	R(0)...R(nr) using the Modified Yule-Walker method.  
%	This function is used by YULEWALK.

%	Copyright (c) 1984-94 by The MathWorks, Inc.
%       $Revision: 1.5 $  $Date: 1994/01/25 17:59:00 $

nr = max(size(R));
Rm = toeplitz(R(na+1:nr-1),R(na+1:-1:2));
Rhs = - R(na+2:nr);
A = [1 Rhs/Rm'];

