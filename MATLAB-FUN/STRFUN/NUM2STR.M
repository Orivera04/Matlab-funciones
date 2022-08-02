function t = num2str(x, prec)
%NUM2STR Number to string conversion.
%	T = NUM2STR(X) converts the scalar number X into a string
%	representation T with about 4 digits and an exponent if
%	required.  This is useful for labeling plots with the
%	TITLE, XLABEL, YLABEL, and TEXT commands.  An optional
%	argument can be supplied for indicating an alternate precision.
%	T = NUM2STR(X,PREC) converts the scalar number X into a string
%	representation with a maximum precision specified by PREC.
%
%	See also INT2STR, SPRINTF, FPRINTF.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if isstr(x)
    t = x;
else
    if (nargin == 1)
	num_format = '%.4g';
    else
	num_format = ['%.' num2str(prec) 'g'];
    end

    t = sprintf(num_format, real(x));
    if imag(x) > 0
       t = [t '+' sprintf(num_format, imag(x)) 'i'];
    elseif imag(x) < 0
       t = [t '-' sprintf(num_format, -imag(x)) 'i'];
    end
end
