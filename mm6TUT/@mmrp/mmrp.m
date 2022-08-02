function r=mmrp(varargin)
%MMRP Mastering MATLAB Rational Polynomial Object Constructor. (MM)
% MMRP(p) creates a polynomial object from the polynomial vector p
% with 'x' as the variable.
% MMRP(p,'s') creates the polynomial object using the letter 's' as
% the variable in the display of p.
% MMRP(n,d) creates a rational polynomial object from the numerator
% polynomial vector n and denominator polynomial d.
% MMRP(n,d,'s') creates the rational polynomial using the letter 's' as
% the variable in the display of p.
%
% All coefficients must be real.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[n,d,v,msg]=local_parse(varargin); % parse input arguments
if isempty(v) % input was mmrp so return it
   r=n;
else
   error(msg) % return error if it exists
	tol=100*eps;
	if length(d)==1 & abs(d)>tol % enforce scalar d=1
		r.n=mmpsim(n/d);
		r.d=1;
	elseif abs(d(1))>tol % make d monic if possible
		r.n=mmpsim(n/d(1));
		r.d=mmpsim(d/d(1));
	else	               % can't be made monic
		r.n=mmpsim(n);
		r.d=mmpsim(d);
	end
	r.v=v(1);
	
	r=class(r,'mmrp');   % create object from parts
	r=minreal(r);        % pole-zero cancelation
end
%--------------------------------------------------------------
function [n,d,v,msg]=local_parse(args)
% parse input arguments to mmrp
msg=''; % default outputs
n=[];
d=1;
v='x';
nargs=length(args);
if nargs==1 % mmrp(p)
   if isa(args{1},'mmrp') % input is mmrp already
      n=args{1};
      v=''; % flag for mmrp object
   elseif isnumeric(args{1})
      n=args{1};
   else
      msg='Numeric Input Expected.';
   end
elseif nargs==2 % mmrp(p,'s') or mmrp(n,d)
   if ~isnumeric(args{1})
      msg='Numeric First Argument Expected.';
   elseif ischar(args{2}) % mmrp(p,'s')
      n=args{1};
      v=args{2}(1);
   elseif isnumeric(args{2})
      n=args{1};
      d=args{2};
   else
      msg='Numeric Input Arguments Expected.';
   end
elseif nargs==3 % mmrp(n,d,'s')
   if ~isnumeric(args{1}) | ~isnumeric(args{2})
      msg='Two Numeric Input Arguments Expected.';
   elseif ~ischar(args{3})
      msg='Character Third Argument Expected.';
   else
      n=args{1};
      d=args{2};
      v=args{3}(1);
   end
end
if ~isempty(v) & (ndims(n)~=2 | size(n,1)>1 | ~isreal(n))
	msg='N Must be a Real Row Vector.';
end
if ~isempty(v) & (ndims(d)~=2 | size(d,1)>1 | ~isreal(n))
	msg='D Must be a Real Row Vector.';
end
