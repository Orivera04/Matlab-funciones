function [ratio]=triratio(base,height)
% TRIRATIO.M Compute and plot the ratio of area to perimeter of 
% isosceles triangle given base and height
% Call: [ratio]=triratio(base,height)
base2=0.5*base;
area=base2.*height;
perimeter=base+2*sqrt(base2.^2+height.^2);
ratio=area./perimeter;
%
%  Note: The preamble and statements could use a few more comments.
%
