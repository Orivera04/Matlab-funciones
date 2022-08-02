function [tx,ty,txy,tp1,tp2]= ...
                       cartstrs(z,Phi,Psi,Phip)
%
% [tx,ty,txy,tp1,tp2]=cartstrs(z,Phi,Psi,Phip)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function uses values of the complex 
% stress functions to evaluate cartesian stress 
% components relative to the x,y axes.
%
% z         - matrix of complex values where 
%             stresses are required
% Phi,Psi   - matrices containing complex stress 
%             function values
% Phip      - values of  Phi'(z)
%
% tx,ty,txy - values of the cartesian stress 
%             components for the x,y axes
% tp1,tp2   - values of maximum and minimum 
%             principal stresses
%
% User m functions called:  none
%----------------------------------------------

A=2*real(Phi); B=conj(z).*Phip+Psi; 
C=A-B; R=abs(B); 
tx=real(C); ty=2*A-tx; txy=-imag(C); 
tp1=A+R; tp2=A-R;