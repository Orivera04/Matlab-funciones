function [X,Y,Z,C]=mmxtract(x,y,z,c,xlim,ylim)
%MMXTRACT Extract Subset of 3D Graphics Data. (MM)
% [Xx,Yx,Zx]=MMXTRACT(X,Y,Z,Xlim,Ylim) extracts a data subset from
% the set [X,Y,Z] that reside within the limits in Xlim=[Xmin Xmax]
% and Ylim=[Ymin Ymax]. If Xlim or Ylim are empty they are
% assumed to be [-inf inf].
% X and Y can be plaid matrices, e.g., created by MESHGRID
% or they can be vectors defining the x and y axes.
%
% [Xx,Yx,Zx,Cx]=MMXTRACT(X,Y,Z,C,Xlim,Ylim) also extracts the
% Surface Color data in C which has the same size as Z.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 2/18/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==5	% MMXTRACT(X,Y,Z,Xlim,Ylim)
   ylim=xlim;	xlim=c;	% rearrange variables as required
end
if length(xlim)<2, xlim=[-inf inf];else xlim=xlim(1:2); end
if length(ylim)<2, ylim=[-inf inf];else ylim=ylim(1:2); end

sx=size(x);
sy=size(y);
sz=size(z);
if all(sx==sz), x=x(1,:); end		% get x-axis vector
if all(sy==sz), y=y(:,1); end		% get y-axis vector

i=find(y>=min(ylim) & y<=max(ylim));	% desired y indices
j=find(x>=min(xlim) & x<=max(xlim));	% desired x indices
Z=z(i,j);

if all(sx==sz)	% user provided plaid matrices, so return plaid
   [X,Y]=meshgrid(x(j),y(i));
else			% user provided vectors, so return vectors
   X=x(j); Y=y(i);
end
if nargin==6, C=c(i,j); end
