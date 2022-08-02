function [result]=comp(part,req)
%COMP Composite shape routine.
%   COMP(PARTS,REQUEST)
%
%   Shape described: A composite shape.
%
%   Datum location: Arbitrary, all shapes are individually placed.
%
%   Input arguments:
%     PARTS: An N by 9 matrix containing data on the components of the 
%        composite shape. 
%     PARTS=[area, circ, centX, centY, Ix, Iy, X, Y, SIGN]
%        The first six pieces of information are easily supplied with other
%          shape functions using the "comp" request.  
%        X and Y are the the distance from the composite datum to the datum 
%          of each individual shape datum.  
%        SIGN is either (1) or (-1) with (1) meaning the shape represents
%          material and (-1) meaning the shape represents a hole in the 
%          material.
%
%   Requesting circumference is a feature simply for compliance with other
%     shape functions.  The answer arrived at for the circumference is never
%     correct due to shared inner borders.  Some corrections can be done to 
%     the answer to find the correct value.
% 
%   Requests: (Must be in single quotes)
%     'area':  Area of the shape.
%     'circ':  Circumference of shape.
%     'Ix':    Area moment of inertia about the neutral x axis.
%     'Iy':    Area moment of inertia about the neutral y axis.
%     'centX': Distance from datum to centroid in the x direction.
%     'centY': Distance from datum to centroid in the y direction.
%     'comp':  All of the above in a 1x6 matrix.
%     'draw':  Show the shape graphically.
%
%   See also CHANNEL, CIRCLE, HALFCIRCLE, HORTRAP, HORTRIA, IBEAM, LBEAM, 
%      OBEAM, QUARTERCIRCLE, RECTANGL, RECTUBE, TBEAM, VERTRAP, VERTRIA. 

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

req=lower(req);

if     strcmp(req,'area')  result=sum (part(:,1).*part(:,9));
elseif strcmp(req,'circ')  result=sum (part(:,2));
elseif strcmp(req,'ix') 
  cent=comp(part,'centy');
  d=cent-(part(:,4)+part(:,8));
  result=sum((part(:,5)+part(:,1).*(d.^2)).*part(:,9));   

elseif strcmp(req,'iy')
  cent=comp(part,'centx');
  d=cent-(part(:,3)+part(:,7));
  result=sum((part(:,6)+part(:,1).*(d.^2)).*part(:,9));   

elseif strcmp(req,'centx') 
  num=sum((part(:,3)+part(:,7)).*part(:,1).*part(:,9));
  den=sum(part(:,1).*part(:,9));
  result= num/den;
elseif strcmp(req,'centy') 
  num=sum((part(:,4)+part(:,8)).*part(:,1).*part(:,9));
  den=sum(part(:,1).*part(:,9));
  result= num/den;
elseif strcmp(req,'comp') 
  result(1,1)=comp(part,'area');
  result(1,2)=comp(part,'circ');
  result(1,3)=comp(part,'centx');
  result(1,4)=comp(part,'centy');	
  result(1,5)=comp(part,'ix');
  result(1,6)=comp(part,'iy');
else 
  disp ('That is not a valid request, try area, circ, Ix, Iy, centX,')
  disp ('centY, comp.')
  disp ('You must use single quotes')
end

