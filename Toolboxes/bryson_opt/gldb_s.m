function f1=gldb_s(al,s,t,flg)
% Subroutine for GLDB_F and GLDB_C;     9/18/02 
%
alm=1/12; eta=.5; V=s(1); ga=s(2); if flg==1
  f1=[-eta*(al^2+alm^2)*V^2-sin(ga) ...
      al*V-cos(ga)/V V*sin(ga) V*cos(ga)]'; end
