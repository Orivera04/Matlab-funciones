function r = effrr(apr,per) 
%EFFRR Effective rate of return. 
%   R = EFFRR(APR,PER) calculates the annual effective rate of return
%   based on the annual percentage rate, APR, and the number of  
%   compounding periods per year, PER. 
% 
%   For example, the effective annual rate of return based on an annual 
%   percentage rate of 9% compounded monthly is represented as  
% 
%   r = effrr(.09,12) returning r = 0.0938 or 9.38%.   
% 
%   Compounding continuously returns r equivalent to (e^apr-1). 
% 
%   See also NOMRR. 
 
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:54:53 $ 
 
if nargin < 2 
  error('Missing one of APR and PER.') 
end 
 
% Check input arguments 
if checkrng('apr',apr,0,inf,'0','inf','e','l',mfilename);return;end 
if checktyp('per',per,'int',mfilename);return;end 
 
r = (1+apr./per).^per-1;
