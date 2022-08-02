function pp=mmspline(x,y,a,b,c)
%MMSPLINE Cubic Spline Construction with Method Choice. (MM)
% MMSPLINE(X,Y,METHOD,P) computes the cubic spline interpolant
% from the data in X and Y, using the method in METHOD and optional
% parameter vector P. MMSPLINE returns the piecewise polynomial
% pp-form to be evaluated with PPVAL.
%
% MMSPLINE(X,Y,J,METHOD,P) computes the cubic spline interpolant
% with J being a logical vector where J(i)=1 identifies the (i)th 
% breakpoint X(i) as a joint where the spline slope is discontinuous.
% Likewise J(i)=0 identifies the (i)th breakpoint as a smooth joint.
% J=ones(size(X)) makes the spline degenerate to linear interpolation.
% J=zeros(size(X)) or J=[] is the same as no J vector.
%
%  METHOD     Description
% 'clamped'   P is vector of slopes y' at the two endpoints  
% 'natural'   no P, curvature y'' is zero at the two endpoints
% 'extrap'    no P, extrapolated spline, same as function SPLINE
% 'parabolic' no P, first and last splines are parabolic
% 'curvature' P is vector of curvatures y'' at the two endpoints
% 'periodic'  no P, y' and y'' match at the two endpoints
% 'aperiodic' no P, y' opposite at endpoints, y'' equal at endpoints
%
% See also MMSPHELP, SPLINE

% Ref: Numerical Methods for Mathematics, Science, and Engineering, 2nd ed.
% John H. Mathews, Prentice Hall, 1992.

% D.C. Hanselman, C.J. Mallon, G. Smith, University of Maine, Orono, ME 04469
% 5/21/96 v5: 1/14/97, 9/22/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==5            % MMSPLINE(X,Y,J,METHOD,P)
   J=[]; m=b; p=c;
   if ~isempty(a),J=(a~=0);end
elseif nargin==4
   if ischar(a)         % MMSPLINE(X,Y,METHOD,P)
      J=[]; m=a; p=b;
   elseif ischar(b)     % MMSPLINE(X,Y,J,METHOD)
      J=[]; m=b;
      if ~isempty(a),J=(a~=0);end
   end
elseif nargin==3        % MMSPLINE(X,Y,METHOD)
   J=[]; m=a;
end
method=lower(m(1:2));
[x,idx]=sort(x(:)); % put x in increasing order
nx=length(x);
if nx~=prod(size(y));
   error('X and Y Must Contain the Same Number of Elements.')
end
y=reshape(y(idx),size(x));
n=nx-1;  % number of splines
if nx<4, error('Need at Least 4 Data Points.'), end

H=diff(x);    % differences in x
if any(H==0), error('X Values Must be Distinct.'), end

D=diff(y)./H;                   % slopes
V=[0;6*diff(D);0];              % right side vector
B=[0;2*(H(1:n-1)+H(2:n));0];    % diagonal elements
A=[0;H(2:n)];                   % subdiagonal elements
C=A;                            % superdiagonal elements

switch method
case 'cl'      % clamped spline
   B(1)=1; B(2)=B(2)-H(1)/2;
   B(n)=B(n)-H(n)/2; B(nx)=1;
   C(1)=0.5; C(n)=0;
   A(n)=0.5;
   V(1)=3*(D(1)-p(1))/H(1); V(2)=V(2)-3*(D(1)-p(1));
   V(n)=V(n)-3*(p(2)-D(n)); V(nx)=3*(p(2)-D(n))/H(n);
   
case 'na'  % natural spline
   B(1)=1; B(nx)=1;
   C(n)=0;
   A(n)=0;
   V(1)=0; V(nx)=0;
   
case 'ex'  % extrapolated spline
   B(1)=H(2); B(2)=B(2)+H(1)+H(1)*H(1)/H(2);
   B(n)=B(n)+H(n)+H(n)*H(n)/H(n-1); B(nx)=H(n-1);
   C(1)=-H(1)-H(2); C(2)=C(2)-H(1)*H(1)/H(2); C(n)=0;
   A(n)=-H(n-1)-H(n); A(n-1)=A(n-1)-H(n)*H(n)/H(n-1);
   V(1)=0; V(nx)=0;
   
case 'pa'  % parabolically terminated spline
   B(1)=1; B(2)=B(2)+H(1);
   B(n)=B(n)+H(n); B(nx)=-1;
   C(1)=-1; C(n)=0;
   A(n)=1;
   V(1)=0; V(nx)=0;
   
case 'cu'  % curvature adjusted spline
   B(1)=1; B(nx)=1;
   C(n)=0;
   A(n)=0;
   V(1)=p(1); V(2)=V(2)-H(1)*p(1);
   V(n)=V(n)-H(n)*p(2); V(nx)=p(2);
   
case 'pe'  % periodic spline
   B(1)=1; B(nx)=H(n)/H(1);
   C(1)=1/2;
   A(1)=H(1); A(n)=B(nx)/2;
   V(1)=3*(D(1)-D(n))/H(1); V(nx)=V(1);
   
case 'ap'  % aperiodic spline
   B(1)=1; B(nx)=-H(n)/H(1);
   C(1)=1/2;
   A(1)=H(1); A(n)=B(nx)/2;
   V(1)=3*(D(1)+D(n))/H(1); V(nx)=V(1);
   
otherwise
   error('Unknown METHOD chosen.')
end
if ~isempty(J) % joint vector exists, set chosen curvatures to zero
   nj=sum(J); % # of nonzeros in j
   V(J)=zeros(nj,1);
   B(J)=ones(nj,1);
   JJ=J(2:nx);  % J on subdiagonal
   A(JJ)=zeros(sum(JJ),1);
   JJ=J(1:n);   % J on superdiagonal
   C(JJ)=zeros(sum(JJ),1);
end
i=[2:nx 1:nx  1:n ]; % row indices for A;B;C
j=[1:n  1:nx  2:nx]; % column indices for A;B;C
ABC=sparse(i,j,[A;B;C],nx,nx,3*(nx+1)); % create sparse matrix

switch method
case 'ex'               % poke in extra elements
   if isempty(J)
      ABC(1,3)=H(1); ABC(nx,n-1)=H(n);
   else
      if ~J(1), ABC(1,3)=H(1);    end
      if ~J(nx),ABC(nx,n-1)=H(n); end
   end
case 'pe'
   if isempty(J)
      ABC(1,nx)=H(n)/H(1);
      ABC(1,n)=ABC(1,nx)/2;
      ABC(nx,1)=1;
      ABC(nx,2)=1/2;
   else
      if ~J(1), ABC(1,nx)=H(n)/H(1); ABC(1,n)=ABC(1,nx)/2; end
      if ~J(nx),ABC(nx,1)=1; ABC(nx,2)=1/2; end
   end
case 'ap'
   if isempty(J)
      ABC(1,nx)=-H(n)/H(1);
      ABC(1,n)=ABC(1,nx)/2;
      ABC(nx,1)=1;
      ABC(nx,2)=1/2;
   else
      if ~J(1), ABC(1,nx)=-H(n)/H(1); ABC(1,n)=ABC(1,nx)/2;  end
      if ~J(nx),ABC(nx,1)=1; ABC(nx,2)=1/2; end
   end		
end
sflag=spparms('autommd');
spparms('autommd',0);   % no reordering required
m=ABC\V;                % find solution
spparms('autommd',sflag);

s(:,4)=y(1:n);                    % x^3 coefficients
s(:,3)=D-H.*(2*m(1:n)+m(2:nx))/6; % x^2 coefficients
s(:,2)=m(1:n)/2;                  % x^1 coefficients
s(:,1)=diff(m)./(6*H);            % x^0 coefficients

pp=mkpp(x,s);           % construct pp-form
