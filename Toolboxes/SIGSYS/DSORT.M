function [s,ndx]=dsort(p)
%DSORT	Sort complex discrete eigenvalues in descending order.
%
%	S=DSORT(P) sorts the complex eigenvalues in the vector P in 
%	descending order by magnitude.  The unstable eigenvalues will 
%	appear first.
%
%	[S,NDX] = DSORT(P) also returns the vector NDX containing the 
%	indexes used in the sort.
%
%	See also: ESORT and SORT.

%	Clay M. Thompson  7-23-90
%	Copyright (c) 1986-93 by the Mathworks, Inc.

error(nargchk(1,1,nargin));
[m,n] = size(p);
if m==1, p=p.'; [m,n] = size(p); end

[s,ndx] = sort( -abs(p) );
for i=1:n, s(:,i) = p(ndx(:,i),i); end

% Work around sort bug -- Remove when new sort routine is released.
for i=1:n,
  k=1;
  while k<length(s),
    if (imag(s(k,i))~=0),
      if (imag(s(k,i))<0),
         s(k:k+1,i)=conj(s(k:k+1,i));
         swap = ndx(k,i); ndx(k,i)=ndx(k+1,i); ndx(k+1,i)=swap;
      end
      k = k+2;
    else
      k = k+1;
    end
  end
end
