function f=anglefun(t)
% f=anglefun computes multipliers involving 
% t, the rotation angle of the volume.
c=cos(t); s=sin(t);
f=[t,s,-c,(t+c*s)/2,s*s/2,(t-c*s)/2];