function [orient,signed_area] = polyorient(x,y)
%POLYORIENT Orientation of polygon
%   Returns the orientation and signed area of a 2D polygon
%
%   Syntax:
%      [ORIENT,SAREA] = POLYORIENT(X,Y)
%
%   Inputs:
%      X, Y   Vectors with the polygon vertices
%
%   Outputs:
%      ORIENT   Polygon orientation. 1 if the orientation is
%               counter-clockwise (direct), 0 otherwise
%      SAREA    Signed area of the polygon, negative if orientation is
%               not direct
%
%   Examples:
%      x1 = [0 0 1 1]; y1 = [1 2 2 1];
%      x2 = [0 0 1 1]; y2 = [1 0 0 1];
%      x3 = [x1 x2];   y3 = [y1 y2];
%
%      [o1,a1] = polyorient(x1,y1) % 0, -1
%      [o2,a2] = polyorient(x2,y2) % 1,  1
%      [o3,a3] = polyorient(x3,y3) % 0,  0
%
%   MMA 21-4-2006, mma@odyle.net

signed_area=0.5* sum(x.*y([2:end 1]) - y.*x([2:end 1]));
orient = signed_area > 0;

