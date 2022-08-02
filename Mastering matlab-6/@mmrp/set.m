function set(r,varargin)
%SET Set Rational Polynomial Object Parameters. (MM)
% SET(R,Name,Value, . . .) sets MMRP object parameters of R
% described by the Name/Value pairs:
%
%  Name          Value
% 'Numerator'    Numeric row vector of numerator coefficients
% 'Denominator'  Numeric row vector of denominator coefficients
% 'Variable'     Character Variable used to display polynomial

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/28/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if rem(nargin,2)~=1
   error('Parameter Name/Values Must Appear in Pairs.')
end
for i=2:2:nargin-1
   name=varargin{i-1};
   if ~ischar(name), error('Parameter Names Must be Strings.'), end
   name=lower(name(isletter(name)));
   value=varargin{i};
   switch name(1)
   case 'n'
      if ~isnumeric(value) | size(value,1)>1
         error('Numerator Must be a Numeric Row Vector.')
      end
      r.n=value;
   case 'd'
      if ~isnumeric(value) | size(value,1)>1
         error('Denominator Must be a Numeric Row Vector.')
      end
      r.d=value;
   case 'v'
      if ~ischar(value) | length(value)>1
         error('Variable Must be a Single Character.')
      end
      r.v=value;
   otherwise
      warning('Unknown Parameter Name')
   end
end
vname=inputname(1);
if isempty(vname)
   vname='ans';
end
r=mmrp(r.n,r.d,r.v);
assignin('caller',vname,r);
