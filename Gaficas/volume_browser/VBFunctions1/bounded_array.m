function [x,ier]=bounded_array(x,lowerx,upperx)
% Modify array "x" in such a way that its entries do not exceed "upperx"
% and are not below "lowerx".
%
% Written by: E. Rietsch: October 21, 2006
% Last updated:
%
%        [x,ier]=bounded_array(x,lowerx,upperx)
% INPUT
% x      vector or matrix
% lowerx   lower limit of the entries of "x"; either a constant or 
%        a matrix with the same dimension as "x"
% upperx   upper limit of the entries of "x"; either a constant or 
%        a matrix with the same dimension as "x"
% OUTPUT
% x      input matrix where entries < "lowerx" are replaced by "lowerx" and 
%        entries > "upperx" are replaced by "upperx".
% ier    logical variable: "false" if no entry of "x" has been replaced and
%                          "true" otherwise
%
% EXAMPLE
%        x0=randn(3,5);
%        lowerx=-1;
%        upperx=ones(3,5);
%        [x,ier]=bounded_array(x0,lowerx,upperx);
%        disp(x-x0)


%	Error checking
dimsx=size(x);
if numel(lowerx) > 1
   dimsl=size(lowerx);
   if ~all(dimsx == dimsl)
      error('Incompatible dimensions of "x" and "lowerx".')
   end
end
if numel(upperx) > 1
   dimsu=size(upperx);
   if ~all(dimsx == dimsu)
      error('Incompatible dimensions of "x" and "upperx".')
   end
end

ier=false;
bool=x > upperx;
if any(bool(:))
  if numel(upperx) == 1
      x(bool)=upperx;
   else
      x(bool)=upperx(bool);
   end   
   ier=true;
end

bool=x < lowerx;
if any(bool(:))
   if numel(lowerx) == 1
      x(bool)=lowerx;
   else
      x(bool)=lowerx(bool);
   end
   ier=true;
end
