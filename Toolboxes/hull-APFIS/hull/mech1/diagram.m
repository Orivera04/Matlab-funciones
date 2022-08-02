function [y]=diagram (x,option,mag,place)
%DIAGRAM Creates vectors for use in plotting of diagrams.
%   DIAGRAM(X,OPTION,MAG,PLACE) will create a data vector the same length as
%   the input X.  The data will be created to one of three options:
%  
%   Options:
%   'point' all data points that correspond to X>=PLACE are set equal to 
%      MAG.  This is useful in shear diagrams when a point load is used.
%   'linear' all data points that correspond to PLACE(1)<=X<=PLACE(2) are 
%      set equal to the linear interpolation of the values MAG(1) and 
%      MAG(2).  This is useful when describing the area of a shaft that is
%      constant over a set length or that changes linearly over a set 
%      length.  This is not for distributed loads.
%   'distributed' all data points are created to reflect the load from a 
%      linearly distributed load that starts at PLACE(1) with a MAG(1) and 
%      changes to MAG(2) at PLACE(2).
%
%   See also DIAGRAMINTEGRAL, DISPLACE.
 
%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

option=lower(option);
y=zeros(size(x));

if strcmp(option,'point')
  VI=find(x>=place); %Valid Indices
  y(VI)=mag;

elseif strcmp(option,'linear')
  VI=find(x>=place(1) & x<=place(2)); %Valid Indices
  y(VI)=(x(VI)-place(1))/(place(2)-place(1))*(mag(2)-mag(1))+mag(1);

elseif strcmp(option,'distributed')
  VI=find(x>=place(1) & x<=place(2)); %Valid Indices
  BVI=find(x>place(2)); %Beyond Valid Indices
  height(VI)=(x(VI)-place(1))/(place(2)-place(1))*(mag(2)-mag(1))+mag(1);
  y(VI)=(x(VI)-place(1)).*(height(VI)+mag(1))/2;
  y(BVI)=mean(mag)*(place(2)-place(1));

else
  disp ('Use a proper loading option: ''point'', ''linear'', or ''distributed''')
  return
end

