function plotscale(SpacingPercentage)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%    This is private file of the BDT Demo and is not meant to be called
%    directly by the user.
%
%Author: C. Bassignani, 05-20-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 0000/00/00 00:00:00

%Build a vector containing the expansion factors for the X and Y axis
F = [(1 + SpacingPercentage) (1 + SpacingPercentage)];

%Set the axis to "tight"
axis tight;

%Get the axis limits
v = axis;

%Get the centers
vc = 0.5*[ v(1)+v(2), v(3)+v(4) ];

%Expand the axis limits according to the new spacing percentage
vnew = [ vc(1) - (vc(1)-v(1))*F(1), vc(1) + (v(2)-vc(1))*F(1) ,...
           vc(2) - (vc(2)-v(3))*F(2), vc(2) + (v(4)-vc(2))*F(2) ];
 
axis(vnew); 
%Reset the axis to reflect the spacing
