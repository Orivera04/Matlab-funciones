function r = annurate(nper,p,pv,fv,due)  
%ANNURATE Periodic interest rate of annuity.  
%   R = ANNURATE(NPER,P,PV,FV,DUE) returns the periodic interest rate paid of   
%   a loan or annuity.  NPER is the number of periods, P is the periodic  
%   payment, PV is the present value of the annuity, FV is the future value  
%   of the annuity, and DUE specifies whether the payments are made at the 
%   beginning (due = 1) or end (due = 0) of the period.  The default values
%   are fv = 0 and due = 0.  
%  
%   For example, to find the period interest rate of 4 year $5000 loan with  
%   $130 monthly payments made at the end of each month, use the command   
%   r = annurate(4*12,130,5000,0,0).  The periodic interest rate returned in    
%   this example is r = .94% which, when multiplied by 12, gives an annual   
%   interest rate of 11.3% on the loan.    
%   
%   See also YLDBOND, ANNUTERM, IRR.  
  
%       Author(s): C.F. Garvin, 2-23-95  
%       Copyright 1995-2002 The MathWorks, Inc.   
%       $Revision: 1.7 $   $Date: 2002/04/14 21:58:22 $  

%Checking input arguments
if nargin < 3                                                              
    error('Missing one of NPER, P, and PV.')                                   
end    

if nargin < 4                                                              
    fv = zeros(size(p)); % Default future value is 0.                          
end  

if nargin < 5                                                              
    due = zeros(size(p)); % Payments made at end of period                     
end        

if any(any(due ~= 0 & due ~= 1))                                           
    error(sprintf('DUE must be 0 (end of month) or 1 (beginning of month).'))  
end  
  
sz = [size(nper);size(p);size(pv);size(fv);size(due)];  
if length(nper) == 1  
  nper = nper*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(p) == 1  
  p = p*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(pv) == 1  
  pv = pv*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(fv) == 1  
  fv = fv*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if length(due) == 1  
  due = due*ones(max(sz(:,1)),max(sz(:,2)));  
end  
if checksiz([size(nper);size(p);size(pv);size(fv);size(due)],mfilename)  
  return  
end  
  
m = length(p(:));  
r = zeros(size(p));  
% ROOTS takes vectors, must use for loop  
for k = 1:m  
  if due(k) == 0  
    % Solve p = (fv-pv*c^nper)*(1-c)/(1-c^nper) for c, use roots  
    c = roots([pv(k) -pv(k)-p(k) zeros(1,nper(k)-2) fv(k) -fv(k)+p(k)]);  
  else  
    % Solve p = (fv-pv*c^nper)/(c^nper+(1-c^nper)/(-c)) for c  
    c = roots([(pv(k)-p(k)) -pv(k) zeros(1,nper(k)-2) fv(k)+p(k) -fv(k)]);  
  end  
  x = (c-1);  
  % Find rates that make sense  
  rt = x(min(find(imag(x)<1e-6 & imag(x)>-1e-6 & abs(x)>0 & abs(x)<1)));  
  if isempty(rt)  
    r(k) = 0;     % if no roots, fill element of r with zero  
  else  
    r(k) = rt;   
  end  
  if abs(r(k)) < 1e-6  
    r(k) = 0;  
  end  
end
