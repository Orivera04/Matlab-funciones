function sp=stage_o(t,s)
% Subroutine for stage.m; s=[r v m]';             9/7/02
%
c=.5; T=3.5; r=s(1); v=s(2); m=s(3); if t>2/35, T=0; end
sp=[v T/m-1/r^2 -T/c]';