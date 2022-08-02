	function [f1,f2,f3]=venust(be,s,t,flg)
	% Subroutine for Pb. 4.4.18; TDP for min time to the
	% orbit of Venus;           2/4/94, 9/11/96, 8/24/97
	%
	T=.1405; B=.07489; r=s(1); u=s(2); v=s(3);
	c=cos(be); si=sin(be); a=T/(1-B*t);
	if flg==1,
	 f1=[u;  v^2/r-1/r^2+a*si; -u*v/r+a*c;  v/r]; % f1 = f
	elseif flg==2,
	 f1=[t;  r-.7233;  u;  v-1.1758];           % f1 = Phi
	 f2=[zeros(1,4); eye(3) zeros(3,1)];       % f2 = Phis
	 f3=[1 0 0 0]';                            % f3 = Phit
	elseif flg==3,
    f1=[0 1 0 0; -(v/r)^2+2/r^3  0  2*v/r  0; ...
          u*v/r^2  -v/r  -u/r  0;  0 0 0 0];    % f1 = fs
	 f2=a*[0;  c;  -si;  0];                     % f2 = fu
	end

