function varargout=mmpolyfit(varargin)
% Fit Polynomial to Data with Constraints. (MM)
% P=MMPOLYFIT(X,Y,N) finds the coefficients of a polynomial P(X) of degree
% N that fits the data Y in a least-squares sense. P is a row vector of
% length N+1 containing the polynomial coefficients in descending order,
% P(1)*X^N + P(2)*X^(N-1) +...+ P(N)*X + P(N+1). This matches POLYFIT.
% The number of elements in X and Y must be equal and greater than N.
%
% MMPOLYFIT(X,Y,N,'Param1',PValue1,...) sets selected options based on
% pairs of parameters and associated values as described below.
% MMPOLYFIT(X,Y,N,D) sets options based on the options structure D, whose
% fieldnames are parameters names and whose contents are associated values.
%
% D=MMPOLYFIT('Param1',PValue1,...) returns an options structure D using
% the given input parameter names and parameter values that can be used for
% calls to MMPOLYFIT.
% Dnew=MMPOLYFIT(Dold,'Param1',PValue1,...) returns an options structure
% Dnew that is a copy of the existing options structure Dold altered by the
% added parameters and associated parameter values.
% 
% Parameter    VALUE and DESCRIPTION
%
% Weight       A vector having NUMEL(X) real positive weights. Solution
%              found is the weighted least squares solution. Default value 
%              is ONES(SIZE(X)), i.e., no weighting. The equation for the
%              i(th) data point is scaled by the square root of the i(th)
%              weight.
%
% ZeroCoef     A vector containing the powers of x whose coefficients must
%              be zero, e.g., [1 3 0] sets the x^1, x^3 and x^0
%              coefficients to zero.
%
% Point        A p-by-2 matrix containing p points that the resulting
%              polynomial must pass through. The i(th) row contains the
%              i(th) data pair [x(i) y(i)].
%              
% Slope        An s-by-2 matrix containing s points that the slope of the
%              polynomial must pass through. The i(th) row contains the
%              (i)th data pair [x(i) dy(i)/dx].
%
% Equal        A k-by-(N+2) matrix containing k equality constraints on the
%              N+1 coefficients. The structure of this matrix is [B d]
%              where B is k-by-N+1, d is k-by 1, and the constraints are
%              given by B*P' = d where P is the row vector solution 
%              containing the polynomial coefficients.
%
% See also POLY, POLYVAL, ROOTS.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% masteringmatlab@yahoo.com
% Mastering MATLAB 7
% 2005-01-14

D=[];
%--------------------------------------------------------------------------
% Parse Inputs                                                 Parse Inputs
%--------------------------------------------------------------------------
if nargin>=2 && ischar(varargin{1}) % MMPOLYFIT('Param1',PValue1,...)
   for k=1:2:nargin-1
      [fname,errmsg]=local_isfield(varargin{k});
      error(errmsg)
      p.(fname)=varargin{k+1};
   end
   varargout{1}=p;
   return
elseif nargin>2 && isstruct(varargin{1}) % MMPOLYFIT(Dold,'Param1',PValue1)
   Dold=varargin{1};
   Dfn=fieldnames(Dold); % make sure Dold is proper structure
   for k=1:length(Dfn)
      [fn,errmsg]=local_isfield(Dfn{k});
      warning(errmsg)
      if isempty(errmsg)
         p.(fn)=Dold.(Dfn{k});
      end
   end
   for k=2:2:nargin-1
      [fname,errmsg]=local_isfield(varargin{k});
      error(errmsg)
      p.(fname)=varargin{k+1};
   end
   varargout{1}=p;
   return
elseif nargin>=3 && isnumeric(varargin{1}) % MMPOLYFIT(X,Y,N,...)
   x=varargin{1}(:);
   b=varargin{2}(:);
   n=varargin{3};
   neqn=numel(x);
   ncoef=n+1;
   if ~isnumeric(b) || ~isequal(neqn,numel(b))
      error('X and Y Must be Numeric and the Same Size.')
   end
   if ~isnumeric(n) || ~isscalar(n)
      error('N Must be a Numeric Scalar.')
   end
   last=[];
   k=4; % 'Param' or D can't appear before 4th argument
   while k<=nargin 
      vark=varargin{k};
      k=k+1;
      if ischar(vark)
         [fname,errmsg]=local_isfield(vark);
         error(errmsg)
         if ~isempty(fname)
            if isempty(last)
               last=k-1;
            end
            D.(fname)=varargin{k};
            k=k+1; % skip known PValue
         end
      elseif isstruct(vark) % found appended structure
         if isempty(last)
            last=k-1;
         end
         Vfn=fieldnames(vark);
         for ki=1:length(Vfn)
            [fname,errmsg]=local_isfield(Vfn{ki});
            error(errmsg)
            D.(fname)=vark.(Vfn{ki});
         end
      end
   end
else
   error('Unknown Input Arguments.')
end
%--------------------------------------------------------------------------
% Now have x,y,n and possibly an options structure D
%--------------------------------------------------------------------------

if isempty(D)                  % No options structure, use standard polyfit
   [varargout{1:nargout}]=polyfit(varargin{:});
else                                             % Options Structure Exists
   % Construct Vandermonde matrix.
   V(:,ncoef)=ones(neqn,1,class(x));
   for k=n:-1:1
      V(:,k)=x.*V(:,k+1);
   end
   B=zeros(0,ncoef,class(x));
   d=zeros(0,1,class(x));
   optnames=fieldnames(D);
   for k=1:length(optnames)
      switch optnames{k}
      case 'Weight'
         w=D.Weight(:);
         if ~isnumeric(w) || any(w<=0)
            error('Weights Must be Positive.')
         elseif length(w)~=neqn
            error('Number of Weights Must Equal Number of Data Points.')
         end
         w=sqrt(w); % add weights to matrix V and b
         V=V.*repmat(w,1,ncoef); 
         b=b.*w;
      case 'ZeroCoef'
         zc=D.ZeroCoef(:);
         if ~isnumeric(zc) || any(zc<0) || any(zc>ncoef) || any(zc~=fix(zc))
            error('Zero Coefficients Must be Integers Between 0 and N+1')
         end
         for k=1:length(zc)
            tmpz=zeros(1,ncoef);
            tmpz(ncoef-zc(k))=1;
            B=[B;tmpz];
            d=[d;0];
         end
      case 'Point'
         [rp,cp]=size(D.Point);
         if ~isnumeric(D.Point) || rp>neqn || cp>2
            error('Point Contents Must be p-by-2 where p<NUMEL(X)')
         end
         tmpp(:,ncoef)=ones(rp,1,class(x));
         for k=n:-1:1
            tmpp(:,k)=D.Point(:,1).*tmpp(:,k+1);
         end
         B=[B;tmpp];
         d=[d;D.Point(:,2)];
      case 'Slope'
         [rs,cs]=size(D.Slope);
         if ~isnumeric(D.Slope) || rs>neqn || cs>2
            error('Slope Contents Must be s-by-2 where s<NUMEL(X)')
         end
         tmps(:,ncoef)=zeros(rs,1,class(x));
         tmps(:,ncoef-1)=ones(rs,1,class(x));
         for k=n-1:-1:1
            tmps(:,k)=D.Slope(:,1).*tmps(:,k+1);
         end
         dp=n:-1:0;
         tmps=tmps.*repmat(dp,rs,1);
         B=[B;tmps];
         d=[d;D.Slope(:,2)];         
      case 'Equal'
         [re,ce]=size(D.Equal);
         if ~isnumeric(D.Equal) || re>neqn || ce~=ncoef+1
            error('Equal Contents Must be k-by-N+2 where k<NUMEL(X)')
         end
         B=[B;D.Equal(:,1:ncoef)];
         d=[d;D.Equal(:,end)];
      end
   end
   if isempty(B)
      p=V\b;
   else
      rB=size(B,1);
      [QB,RB]=qr(B');
      Ro=RB(1:rB,:);
      if sum(abs(diag(Ro))<abs(Ro(1)).*rB.*eps(class(Ro)))
         error('Constraints in B Must be Independent.')
      end
      VQB=V*QB;
      V1=VQB(:,1:rB);
      V2=VQB(:,rB+1:end);
      y=Ro'\d;
      z=V2\(b-V1*y);
      p=QB*[y;z];
   end
   varargout{1}=p';
end
%--------------------------------------------------------------------------
function [out,errmsg]=local_isfield(str)                   % local_isfield
% compare str to options, if found, return complete fieldname
% otherwise return error and empty string.
% str is a string, outputs are strings

if ~ischar(str)
   out='';
   errmsg='Option Parameter String Expected.';
   return
end
options={'Weight';'ZeroCoef';'Point';'Slope';'Equal'};
idx=find(strcmpi(str,options)); % check for exact match

if isempty(idx) % no exact match, so look for more general match
   idx=find(strncmpi(str,options,length(str)));
end
if numel(idx)==1 % unique match found
   out=options{idx};
   errmsg='';
else             % trouble
   out='';
   errmsg=sprintf('Unknown Option: %s',str);
end

