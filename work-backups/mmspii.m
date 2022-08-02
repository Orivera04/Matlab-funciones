function [xi,yi]=mmspii(pp,y,xlim)
%MMSPII Inverse Interpolate Spline. (MM)
% Xi=MMSPII(PP,yi) inverse interpolates the piecewise polynomial PP,
% to find the points Xi where the spline has the scalar value yi.
% If none are found an empty array is returned.
%
% Xi=MMSPII(PP,yi,Xlim) limits the search to the interval Xlim=[Xmin Xmax];
% [Xi,Yi]=MMSPII(...) in addition returns Yi=yi(1,ones(length(Xi))).
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 12/17/96, v5: 1/14/97, 2/17/97, 4/26/99, 5/30/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==2, xlim=[];
elseif nargin~=3, error('Incorrect Number of Input Arguments.')
end
error(mmspchk(pp));  % make sure pp is a piecewise poly
y=y(1);              % allow only a scalar interpolant

[br,co,npy,nco]=unmkpp(pp);	% take apart pp
dxbr=diff(br);
tol=100*eps;
xi=[];
if ~isempty(xlim)
   idx=find(br(1:end-1)>=min(xlim) & br(1:end-1)<=max(xlim));
else
   idx=1:npy;
end
co(:,end)=co(:,end)-y;  % shift all polys by y
for k=idx
   p=co(k,:);     % k-th poly to investigate
   inz=find(p);   % index of nonzero elements of poly
   fnz=inz(1);    % first nonzero element
   lnz=inz(end);  % last nonzero element
   
   p=p(fnz+1:lnz)/p(fnz);  % strip leading,trailing zeros, make monic
   r=zeros(1,nco-lnz);     % roots at zero
   
   if (lnz-fnz)>1          % add nonzero roots
      a=diag(ones(1,lnz-fnz-1),-1); % form companion matrix
      a(1,:)=-p;
      r = [r eig(a).'];             % find eignevalues to get roots
   end
   
   i=find(abs(imag(r))<tol & ... % find real roots with
          real(r)>=0 & ...       % nonnegative real parts that are
          real(r)<dxbr(k));      % less than the next breakpoint
   if ~isempty(i)
      xi=[xi br(k)+r(i)];
   end
end
if nargout==2, yi=repmat(y,size(xi)); end
