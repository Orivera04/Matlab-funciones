function [b,c]=splincof(xd,yd,endc)
%
% [b,c]=splincof(xd,yd,endc) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines coefficients for
% cubic spline interpolation allowing four
% different types of end conditions.
% xd,yd - data vectors for the interpolation
% endc  - endc=1 makes y'''(x) continuous at 
%         xd(2) and xd(end-1).
%         endc=[2,left_slope,right_slope]
%         imposes slope values at both ends.
%         endc=[3,left_slope] imposes the left
%         end slope and makes the discontinuity
%         of y''' at xd(end-1) small.
%         endc=[4,right_slope] imposes the right
%         end slope and makes the discontinuity
%         of y''' at xd(2) small.
%           
if nargin<3, endc=1; end;
type=endc(1); xd=xd(:); yd=yd(:);

switch type
    
case 1
  % y'''(x) continuous at the xd(2) and xd(end-1)
  [b,c]=unmkpp(spline(xd,yd));
  
case 2  
  % Slope given at both ends
  [b,c]=unmkpp(spline(xd,[endc(2);yd;endc(3)]));
  
case 3
  % Slope at left end given. Compute right end
  % slope.
  [b,c]=unmkpp(spline(xd,yd));
  c=[3*c(:,1),2*c(:,2),c(:,3)];
  sright=ppval(mkpp(b,c),xd(end));
  [b,c]=unmkpp(spline(xd,[endc(2);yd;sright]));
  
case 4 
  % Slope at right end known. Compute left end
  % slope.
  [b,c]=unmkpp(spline(xd,yd));
  c=[3*c(:,1),2*c(:,2),c(:,3)];
  sleft=ppval(mkpp(b,c),xd(1));
  [b,c]=unmkpp(spline(xd,[sleft;yd;endc(2)]));    
  
end