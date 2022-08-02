function varargout=get(r,varargin)
%GET Get Rational Polynomial Object Parameters. (MM)
% GET(R,Name) gets the MMRP object parameter of R described by
% one of the following names:
%
%  Name          Description
% 'Numerator'    Numeric row vector of numerator coefficients
% 'Denominator'  Numeric row vector of denominator coefficients
% 'Variable'     Character Variable used to display polynomial
%
% [A,B,. . .]=get(R,NameA,NameB,. . .) returns multiple parameters
% in the corresponding output arguments.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/28/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if (nargout+(nargout==0))~=nargin-1
   error('No. of Outputs Must Equal No. of Names.')
end
for i=1:nargin-1
   name=varargin{i};
   if ~ischar(name), error('Parameter Names Must be Strings.'), end
   name=lower(name(isletter(name)));
	switch name(1)
	case 'n'
       varargout{i}=r.n;
	case 'd'
       varargout{i}=r.d;
	case 'v'
       varargout{i}=r.v;
	otherwise
       warning('Unknown Parameter Name')
	end
end
