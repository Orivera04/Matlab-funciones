function R = jacobian(A,v)
%JACOBIAN	Jacobian matrix.
%	JACOBIAN(f,v) computes the Jacobian of the scalar or vector f 
%	with respect to the vector v. The (i,j)-th entry of the result
%	is df(i)/dv(j). Note that when f is scalar, the Jacobian of f
%	is the gradient of f.
%
%	Example:
%	    jacobian(sym('x*y*z; y; x+z'),sym('x,y,z'))
%	    jacobian('u*exp(v)',sym('u,v'))
%
%	See also DIFF.

%	Copyright (c) 1993-94 by The MathWorks, Inc.
%	$Revision: 1.5 $  $Date: 1994/01/24 22:36:59 $

% Convert v to row vector, if necessary
if symsize(v,1) > 1, v = transpose(v); end

% Convert A to row vector, if necessary
if symsize(A,2) == 1
    if symsize(A,1) == 1
        A = ['[' A ']']; 
    else 
        A = transpose(A);
    end
end

R = maple(['jacobian(' A ',' v ')']);
