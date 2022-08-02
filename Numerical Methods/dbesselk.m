function  w = dbesselk(nu,z,scale)
%
%     ==============================================================
%     Purpose: Compute the derivatives of modified Bessel functions of the
%    second kind
%
%     Input:  nu  --- Order of Bessel functions
%     z --- Argument of Mathieu functions
%     Output:  w --- Derivative of Modified Bessel function of the second kind 

%author:    Da Ma,State key lab of millimeter waves,Southeast
%           University,China
%edition:   V1.0,2008-12-12
%     ==============================================================
if nargin == 2, scale = 0; end
if nu==0
    w=-besselk(1,z)
else
    w=-0.5.*(besselk(nu-1,z)+besselk(nu+1,z));
end


