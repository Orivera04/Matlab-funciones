function y = yldmat(sd,md,id,rv,price,cpn,basis) 
%YLDMAT Yield with interest at maturity. 
%   YLDMAT(SD,MD,ID,RV,PRICE,CPN,BASIS) returns the yield of a security
%   paying interest at maturity.  SD is the settlement date, MD is the  
%   maturity date, ID is the issue date, RV is the redemption value,   
%   PRICE is the price, CPN is the coupon rate, and BASIS is the day 
%   count basis: 0 = actual/actual (default), 1 = 30/360, 2 = actual/360,
%   3 = actual/365.  Enter dates as serial date numbers or date strings. 
% 
%   Using the following data, 
% 
%       SD = '02/07/1992'
%       MD = '04/13/1992'
%       ID = '10/11/1991'
%       RV = 100
%       PRICE = 99.98
%       CPN = 0.0608
%       BASIS = 1
%       
%   y = yldmat(sd,md,id,rv,price,cpn,basis)
%       
%   returns y = 0.0607 or 6.07%.
% 
%   See also PRBOND, YLDBOND, YLDDISC, PRMAT. 
% 
%   Reference: Mayle, Standard Securities Calculation Methods, Volumes
%              I-II, 3rd edition.  Formula 3. 
  
%       Author(s): C.F. Garvin, 2-23-95 
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.6 $   $Date: 2002/04/14 21:52:29 $ 
 
if nargin < 7 
  basis = zeros(size(rv)); 
end 
if nargin < 6 
  error(sprintf('Missing one of SD, MD, ID, RV, CPN, and YLD.')) 
end 
i = find(basis ~= 0 & basis ~= 1 & basis ~=2 & basis ~=3); 
if ~isempty(i) 
  error(sprintf('Invalid day count basis specified.')) 
end 
if any(any(isstr(sd) | isstr(md) | isstr(id))) 
  sd = datenum(sd); 
  md = datenum(md); 
  id = datenum(id); 
end 
if length(sd) == 1 
  sd = sd*ones(size(md)); 
end 
if length(md) == 1 
  md = md*ones(size(sd)); 
end 
if length(id) == 1 
  id = id*ones(size(sd)); 
end 
if length(rv) == 1 
  rv = rv*ones(size(sd)); 
end 
if length(price) == 1 
  price = price*ones(size(sd)); 
end 
if length(cpn) == 1 
  cpn = cpn*ones(size(sd)); 
end 
if length(basis) == 1 
  basis = basis*ones(size(sd)); 
end 
if checksiz([size(sd);size(md);size(rv);size(price);size(cpn);... 
             size(basis)],mfilename) 
  return 
end 
 
 
tmp = inf; 
infpad = tmp(ones(1,length(sd(:))),1); 
if checkrng(str2mat('sd','md','cpn'),[sd(:),md(:),cpn(:)],[id(:) sd(:) zeros(size(sd(:)))],... 
            [md(:) infpad infpad],str2mat('id','sd','0'),str2mat('md','inf','inf'),... 
            ['l';'e';'e'],['e';'l';'l'],mfilename) 
  return 
end 
 
a = daysdif(id(:),sd(:),basis(:));                % days from id to sd 
dim = daysdif(id(:),md(:),basis(:));              % days from id to md 
dsm = daysdif(sd(:),md(:),basis(:));              % days from sd to md 
b = zeros(size(rv)); 
i = find(basis == 0); 
if ~isempty(i);b(i) = daysact(datemnth(sd(i),-12,0,0),sd(i));end 
i = find(basis == 1 | basis == 2); 
if ~isempty(i);b(i) = 360*ones(size(i));end 
i = find(basis == 3); 
if ~isempty(i);b(i) = 365*ones(size(i));end 
b = b(:); 
 
num = (1+(dim./b.*cpn(:)))-(price(:)./rv(:)+(a./b.*cpn(:))); % Formula 3 
den = price(:)./rv(:)+(a./b.*cpn(:)); 
y = reshape((num./den).*b./dsm,size(rv));
