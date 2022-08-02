% Script chkdf1(name,u,s,dt,t,et)
%CHKDOPC - Checks data file used in DOPC
% chkdopc(name,u,s,dt,t,et)
% Compares derivatives computed by the data file with
% numerical differencing.
% INPUT:
%   name = data file name
%   f=feval(name,u,s,dt,t,1);
%   [Phi,Phis]=feval(name,u,s,dt,t,2)
%   [fs,fu]=feval(name,u,s,dt,t,3),;
%   s    = state vector 
%   u    = scalar control value
%   dt   = time step
%   et   = increment used for numerical differentiation
% OUTPUT:
% The differences between the analytical and numerical derivatives
% are given by the variable "err" in the display output.
% Sun H. Hur 12/27/92; modified AEB 5/1/97
%
% Find analytical derivatives:
  [Phi,Phis]=feval(name,u,s,dt,t,2);
  [fs,fu,fsu,fuu]=feval(name,u,s,dt,t,3);
% Check Phis:
  disp('Phis'); ns=length(s);
  for i=1:ns
   s1=s; s1(i)=s1(i)+et;
   f1=feval(name,u,s1,dt,t,2);
   der=(f1-Phi)/et; err(:,i)=der-Phis(:,i);
  end;  err, clear der err
% Check fs:
  disp('fs');
  f=feval(name,u,s,dt,t,1);	
  for i=1:ns
   s1=s; s1(i)=s1(i)+et;
   f1=feval(name,u,s1,dt,t,1);
   der=(f1-f)/et; err(:,i)=der-fs(:,i);
  end; err, clear der err
% Check fu:
  disp('fu'); 
  u1=u+et;
  f1=feval(name,u1,s,dt,t,1);
  der=(f1-f)/et;  err=der-fu;
  err, clear der err
% Check fsu:
  disp('fsu');
  f1=feval(name,u1,s,dt,t,3);
  der=(f1-fs)/et; err=der-fsu;
  err, clear der err 	
% Check fss:
  disp('fuu');
  [f1,f2]=feval(name,u1,s,dt,t,3);
  der=(f2-fu)/et; err=der-fuu;
  err
	
 