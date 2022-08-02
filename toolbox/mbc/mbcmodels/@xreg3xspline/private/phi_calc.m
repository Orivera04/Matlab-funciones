function PHI=phi_calc(knots,s,X)
% xreg3xspline/PHI_CALC (private) calculates B-Spline basis for xreg3xspline 
% 
% PHI= PHI_CALC(knots,s,x)
% INPUTS
%  	knots  a vector of augmented knot positions from [-1 -1 -1 -1 -.33 .33 1 1 1 1]
%              note the outer knots must be repeated s+1 times
%	  s      the order of the spline
%	  x      is a vector of xvalues that are to be evaluated.
%
% OUTPUTS
%   PHI    the matrix of phi values evaluated at each xget
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:44:18 $



%DEFINE VARIABLES
os=s+1; 				  %offset for matrix referencing
k=length(knots)-2*os; 	%number of knots


%SET UP THE KNOT POSITIONS
% K= [-ones(os,1); knots(:);  ones(os,1)]';
K= knots(:);

B1= zeros(length(X),2*s+k);
for i= os:os+k
   % extrapolate below -1
   B1(X<K(1), i)   = K(i) <= K(1);
   % extrapolate above +1
   B1(X>=K(end), i) = K(i+1)==K(end);
   % interpolate
   B1(( K(i) <= X) & (X < K(i+1) ),i)= 1;
end


%RECURSIVE SECTION
%loop through the levels
for j = 2 : s+1 
   % save last level
   B0=B1;
   for i= 1:2*s+k+2-j  % matrix of index points
      dK= K(i+j-1)-K(i);
      if dK~=0
         B1(:,i)= ((X-K(i))/dK).* B0(:,i);
      else 
         B1(:,i)= 0;
      end
      
      dK=K(i+j)-K(i+1);
      if dK~=0
         B1(:,i)= B1(:,i) + ((K(i+j)-X)/dK) .* B0(:,i+1);
      end
      
   end
end

% only need the first s+k+1 columns
PHI= B1(:,1:s+k+1);
