function []=plotSMD(x,shear,moment,displacement)
%PLOTSMD Plots a Shear Moment and optional Displacement diagram.
%   PLOTSMD(X,SHEAR,MOMENT,DISPLACEMENT) is a quick routine to show the
%   SHEAR, MOMENT and optional DISPLACEMENT diagrams on the same figure.
%   This routine can and should be modified to specific needs.
%
%   See also plotSMSD.

%   Details are to be found in Mastering Mechanics I, Douglas W. Hull,
%   Prentice Hall, 1998

%   Douglas W. Hull, 1998
%   Copyright (c) 1998-99 by Prentice Hall
%   Version 1.00

subplot(nargin-1,1,1)
plot ([0,x],[0,shear])
title ('Shear')
expandaxis; showx

subplot(nargin-1,1,2)
plot ([0,x],[0,moment])
title ('Moment')
expandaxis; showx;

if nargin==4
  subplot (nargin-1,1,3)
  plot (x,displacement)
  title ('Displacement')
  expandaxis; showx;
end
