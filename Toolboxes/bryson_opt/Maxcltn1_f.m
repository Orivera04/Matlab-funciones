function f=maxcltn1_f(p,ga,flg)
% Subroutine for Pb.1.3.13;                    10/96, 6/27/02
%
V=p(1); al=p(2); sg=p(3); T=.2; alm=1/12; eta=.5; ep=2*pi/180; 
if flg==1, f=-tan(sg)/(V^2*cos(ga));                    % -1/r
elseif flg==2,  f=-tan(sg)/V;                        % -psidot
end

