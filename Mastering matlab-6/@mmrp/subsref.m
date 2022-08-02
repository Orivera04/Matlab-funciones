function y=subsref(r,s)
%SUBSREF(R,S) Subscripted Reference for Rational Polynomial Objects. (MM)
% R('z') returns a new rational polynomial object having the same numerator
% and denominator, but using the variable 'z'.
%
% R(x) where x is a numerical array, evaluates the rational polynomial R
% at the points in x, returning an array the same size as x.
%
% R.n returns the numerator row vector of R.
% R.d returns the denominator row vector of R.
% R.v returns the variable associated with R.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98, 3/1/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if length(s)>1
   error('MMRP Objects Support Single Arguments Only.')
end
if strcmp(s.type,'()') % R( )
   arg=s.subs{1};
   argc=class(arg);
   if strcmp(argc,'char')
      if strcmp(arg(1),':')
    		error('MMRP Objects Do Not Support R(:).')
    	else
    		y=mmrp(r.n,r.d,arg(1));
    	end
   elseif strcmp(argc,'double')
    	if length(r.d)>1
    		y=polyval(r.n,arg)./polyval(r.d,arg);
    	else
    		y=polyval(r.n,arg);
    	end
   else
      error('Unknown Subscripts.')
   end
elseif strcmp(s.type,'.') % R.field
   arg=lower(s.subs);
   switch arg(1)
	case 'n'
		y=r.n;
	case 'd'
		y=r.d;
	case 'v'
		y=r.v;
	otherwise
		error('Unknown Data Requested.')
	end
else % R{ }
   error('Cell Addressing Not Supported.')   
end
