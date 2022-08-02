function a=subsasgn(a,s,b)
%SUBSASGN Subscripted assignment for Rational Polynomial Objects.
%
% R(1,p)=C sets the coefficients of the Numerator of R identified
% by the powers in p to the values in the vector C.
%
% R(2,p)=C sets the coefficients of the Denominator of R identified
% by the powers in p to the values in the vector C.
%
% R(1,:) or R(2,:) simply replaces the corresponding polynomial
% data vector.
%
% For example, for the rational polynomial object
%           2x^2 + 3x + 4
% R(x) = --------------------
%         x^3 + 4x^2 + 5x + 6
%
% R(1,2)=5         changes the coefficient 2x^2 to 5x^2
% R(2,[3 2])=[7 8] changes x^3 + 4x^2 to 7x^3 + 8x^2
% R(1,:)=[1 2 3]   changes the numerator to x^2 + 2x + 3

% D.C. Hanselman, University of Maine, Orono ME 04469
% 7/23/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if length(s)>1
	error('MMRP Objects Support Single Arguments Only.')
end
if strcmp(s.type,'()') % R(1,p) or R(2,p)
   if length(s.subs)~=2
      error('Two Subscripts Required.')
   end
   nd=s.subs{1}; % numerator or denominator
   p=s.subs{2};  % powers to modify
   if ndims(nd)~=2 | length(nd)~=1 | (nd~=1 & nd~=2)
      error('First Subscript Must be 1 or 2.')
   end
   if isnumeric(p) & ...
      (ndims(p)~=2 | any(p<0) | any(fix(p)~=p))
      error('Second Subscript Must Contain Nonnegative Integers.')
   end
   if ndims(b)~=2 | length(b)~=prod(size(b))
      error('Right Hand Side Must be a Vector.')
   end
   b=b(:).';    % make sure b is a row
   p=p(:)';     % make sure p is a row
   if ischar(p) & length(p)==1 & strcmp(p,':')
      if nd==1  % replace numerator
         r.n=b;
         r.d=a.d;
      else      % replace denominator
         r.n=a.n;
         r.d=b;
      end
   elseif isnumeric(p)
      plen=length(p);
      blen=length(b);
      nlen=length(a.n);
      dlen=length(a.d);
      if plen~=blen
         error('Sizes Do Not Match.')
      end
      if nd==1  % modify numerator
         r.d=a.d;
         rlen=max(max(p)+1,nlen);
         r.n=zeros(1,rlen);
         r.n=mmpadd(r.n,a.n);
         idx=rlen-p;
         r.n(idx)=b;
      else      % modify denominator
         r.n=a.n;
         rlen=max(max(p)+1,dlen);
         r.d=zeros(1,rlen);
         r.d=mmpadd(r.d,a.d);
         idx=rlen-p;
         r.d(idx)=b;
      end
   else
      error('Unknown Subscripts.')
   end   
else % R{ } or R.field
   error('Cell and Structure Addressing Not Supported.')   
end
a=mmrp(r.n,r.d,a.v);
