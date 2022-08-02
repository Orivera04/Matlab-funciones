function h= plot(L,Xd,Yd,DataOK,Options,AxHand);
%LOCALMULTI/PLOT plot localmod with data
% 
% plot(L,Xd,Yd,DataOk,Options,AxHand)
%  L         localmod object
%  X         sweepset data
%  Y         sweepset data
%  AxHand    axes to plot in
%  optional flags
%      bdflag    logical to show bad data  (1)
%      Transform logical to plot in ytrans (0)
%      CI        plot confidence intervals (1)
%      AbsX      to use X relative to datum (0)
%      ModelRange use bounds from model to determine plotting range

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:40:08 $

if nargin < 4
    % default data indicator
    DataOK= isfinite(double(Y));
end
if nargin < 5
    Options= [1 0 1 1 1];
end
if nargin < 6
    AxHand= gca;
end

m= get(L.xregmulti,'currentmodel');
set(m,'ytrans',get(L,'ytrans'));
h = plot( m, Xd, Yd , DataOK, Options, AxHand );

