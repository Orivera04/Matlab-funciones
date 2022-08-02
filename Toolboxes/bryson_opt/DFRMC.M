function [f1,f2,f3,f4]=dfrmc(th,s,dt,t,flg)
% Subroutine for Pbs. 3.2.4 & 3.5.4; max range with V=1+y & specified yf
% (disc. Fermat Pb);                                       5/97, 6/22/98
%
global yf; x=s(1); y=s(2); ct=cos(th); st=sin(th); a=exp(dt*st);
if flg==1, if abs(th)<1e-4, f1=s+(1+y)*[dt; 0]; else b=(a-1)/st;  
 f1=s+(1+y)*b*[ct; st]; end;
elseif flg==2;
 f1=[x; y-yf];				   % f1=Phi
 f2=eye(2);				  % f2=Phis
 f3=zeros(4,2);				 % f3=Phiss
elseif flg==3,
 if abs(th)<1e-4, f1=[1 dt; 0 1];
  f2=(1+y)*[dt^2/2; dt];
  f3=[0 dt^2/2; 0 dt];
  f4=(1+y)*[-dt; dt^2];		        
 else b=(a-1)/st; bt=(ct/st)*(dt*a-b);
  btt=(b-dt*a+st*ct*(dt^2*ct*a-bt))/st^2;
  f1=[1 b*ct; 0 1+b*st];		    % f1=fs
  f2=(1+y)*[bt*ct-b*st; bt*st+b*ct];        % f2=fu
  f3=[0 bt*ct-b*st; 0 bt*st+b*ct];	   % f3=fsu
  f4=(1+y)*[btt*ct-2*bt*st-b*ct;...
            btt*st+2*bt*ct-b*st];	   % f4=fuu
 end;
end;
	