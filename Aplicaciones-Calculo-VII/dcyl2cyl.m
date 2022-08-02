function dsqr=dcyl2cyl(...
              w,r0,m,rdat,zdat,R0,M,Rdat,Zdat)
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~             
% dsqr=dcyl2cyl(w,r0,m,rdat,zdat,R0,M,Rdat,Zdat)
% This function computes the square of the 
% distance between generic points on the
% surfaces of two circular cylinders in three
% dimensions. 
%
% User m functions called: cylpoint

global fcount
fcount=fcount+1;
r=cylpoint(w(1),w(2),r0,m,rdat,zdat); 
R=cylpoint(w(3),w(4),R0,M,Rdat,Zdat);
dsqr=norm(r-R)^2;