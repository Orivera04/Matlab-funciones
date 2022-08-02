function [tr,tt,trt]=rec2polr(tx,ty,txy,theta)
%
% [tr,tt,trt]=rec2polr(tx,ty,txy,theta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function transforms cartesian stress 
% components tx,ty,txy to polar coordinate 
% stresses tr,tt,trt.
%
% tx,ty,txy - matrices of cartesian stress 
%             components
% theta     - a matrix of polar coordinate 
%             values.  This can also be a 
%             single value if all stress 
%             components are rotated by the
%             same angle.
%
% tr,tt,trt - matrices of polar coordinate 
%             stresses
%
% User m functions called:  none
%----------------------------------------------

if length(theta(:))==1
  theta=theta*ones(size(tx)); end
a=(tx+ty)/2; 
b=((tx-ty)/2-i*txy).*exp(2*i*theta);
c=a+b; tr=real(c); tt=2*a-tr; trt=-imag(c);