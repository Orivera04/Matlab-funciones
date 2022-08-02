function [y,idx,rnk]=mmsortcc(x,tol)
%MMSORTCC Sort Vector into Complex Conjugate Pairs. (MM)
% MMSORTCC(X) sorts the vector X by increasing real part.
% Complex numbers are sorted into complex conjugate pairs.
% Values sharing the same real part are sorted by increasing
% magnitude of their imaginary parts, with a+jb appearing
% before a-jb.
%
% Y=MMSORTCC(X) returns the sorted vector in Y.
% [Y,IDX]=MMSORTCC(X) in addition returns indices in IDX,
% [Y,IDX,RNK]=MMSORTCC(X) in addition returns ranks in RNK,
% such that Y=X(IDX) and X=Y(RNK).
% 
% MMSORTCC(X,TOL) uses a relative tolerance of TOL for
% comparison purposes. By default TOL=100*EPS.
%
% This function differs from CPLXPAIR in that it works for vectors
% only and it optionally returns indices and ranks.
% For inputs with real parts that are not repeated more than three
% times, this function is up to fifty times faster than CPLXPAIR.
% This function is up to three times slower than CPLXPAIR when ALL
% real parts are repeated more than three times.
%
% See also CPLXPAIR, SORT

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/11/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

errmsg='Vector Must Contain Complex Conjugate Pairs.';
if nargin==1
   tol=100*eps;
elseif nargin==2 & (max(size(tol))>1 | tol<eps)
   error('TOL Must be a Positive Scalar.')
elseif nargin~=2
   error('One or Two Input Arguments Required.')
end
xlen=length(x);
xsiz=size(x);
if ndims(x)~=2 | prod(xsiz)~=xlen | xlen<2
   error('Vector Input Required.')
end
if isreal(x)   % only reals in input!
   [y,idx]=sort(x);
else  % there are complex conjugate pairs to sort
   x=reshape(x,xlen,1);
   yi=imag(x);
   ytol=tol*(abs(x)+1);
   % chose preliminary order of a+j0, a+jb, a-jb
   idx=[find(abs(yi)<ytol);find(yi>ytol);find(yi<-ytol)];
   x=x(idx);
   [y,tmp]=sort(real(x));  % then sort by reals
   y(:)=x(tmp);            % default output
   idx(:)=idx(tmp);
   yr=real(y);
   yi(:)=imag(y);
   ytol(:)=tol*(abs(y)+1);
   
   ycc=abs(yi)>ytol;       % true where complex elements exist
   y(~ycc)=real(y(~ycc));  % delete negligible imaginary components
   if rem(sum(ycc),2)~=0  % odd number of complex elements
      error(errmsg)
   end
   b=find([1;abs(diff(yr))>ytol(1:end-1)]);  % starting indices
   e=[b(2:end)-1;xlen];                      % ending indices
   r=e-b+1;             % run length of individual real values
   
   tmp=b(r==1);   % single real values
   if any(abs(yi(tmp))>ytol(tmp))   % negligible imag part required
      error(errmsg)
   end
   tmp=b(r==2);   % potential single cc pairs
   if any(abs(yi(tmp)+yi(tmp+1))>ytol(tmp))  % must be cc pairs
      error(errmsg)
   end
   tmp=b(r==3)+1; % real followed by potential cc pair
   if any(abs(yi(tmp)+yi(tmp+1))>ytol(tmp))  % must be cc pairs
      error(errmsg)
   end   
   b=b(r>3);   % beginings of potential multiple cc pairs
   e=e(r>3);   % ends
   r=r(r>3);   % run lengths
   % now look at these cases
   for j=1:length(b)
      k=b(j):e(j);   % element indices to consider now
      inc=b(j)-1;    % offset from global index to local
      mask=ycc(k);   % mask of local complex elements not paired
      mlen=length(mask);
      
      while any(mask)   % work until all elements paired
         i=find(mask);        % local indices of all unmatched pairs
         ml=i(1);             % local index of first complex value
         m=ml+inc;            % global index of first complex value
         mask(ml)=0;          % mask this value
         ndx=inc+find(mask);  % indices of possible conjugate locations
         i=find(abs(yi(m)+yi(ndx))<ytol(ndx));
         if isempty(i)        % no conjugate available
            error(errmsg)
         else
            n=i(1)+ndx(1)-1;  % matching global conjugate index
            nl=n-inc;         % matching local index
            mask(nl)=0;       % mask conjugate
            ndx=[1:ml nl ml+1:nl-1 nl+1:mlen]; % new local index order
            mask(:)=mask(ndx);
            ndx=[1:m n m+1:n-1 n+1:xlen]; % new global index order
            y(:)=y(ndx);
            yi(:)=yi(ndx);
            ytol(:)=ytol(ndx);
            idx(:)=idx(ndx);
         end
      end
   end
end
y=reshape(y,xsiz);
idx=reshape(idx,xsiz);
if nargout==3
   rnk(idx)=1:xlen;
   rnk=reshape(rnk,xsiz);
end
