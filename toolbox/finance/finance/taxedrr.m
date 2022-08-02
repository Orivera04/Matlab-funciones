function r = taxedrr(rtn,tax) 
%TAXEDRR After-tax rate of return. 
%   R = TAXEDRR(RTN,TAX) calculates the after-tax rate of return
%   given the nominal rate of return, RTN, and tax rate, TAX. 
% 
%   For example, an investment has a rate of return of 12% and is  
%   taxed at a rate of 30%.  The rate of return diminished by the  
%   tax rate is r = taxedrr(.12,.30) which returns r = 8.4%. 
%
%   See also EFFRR, IRR, MIRR, NOMRR, XIRR.

%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.7 $   $Date: 2002/04/14 21:53:38 $ 
 
if nargin < 2 
  error('Missing one of RTN and TAX.') 
end 
 
r = rtn.*(1-tax);
