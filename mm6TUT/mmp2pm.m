function P=mmp2pm(varargin)
%MMP2PM Polynomial to Polynomial Matrix Conversion. (MM)
% P=MMP2PM(P1,P2,P3,...) builds a polynomial matrix P from the
% individual polynomials P1,P2, etc.
% The (i)th row of P contains the (i)th polynomial input.
%
% Inputs can also be polynomial matrices.
%
% See also MMPM2P, MMPMDER, MMPMFIT, MMPMINT, MMPMROOT, MMPMSEL, MMPMEVAL

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/22/96, revised 8/16/96, 9/9/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

ni=nargin;
rcp=zeros(ni,2);
N=1:ni;
eval(sprintf('rcp(%.0f,:)=size(varargin{%.0f});',[N;N]))
i=find(rcp(:,1)>1 & rcp(:,2)==1);
if ~isempty(i)
	error(sprintf('Input Argument P%.0f is Not a Polynomial.\n',i))
end

nrow=sum(rcp(:,1));
ncol=max(rcp(:,2));
lrow=cumsum(rcp(:,1))';
frow=(lrow-rcp(:,1)'+1);
lcol=ncol(ones(1,ni));
fcol=(ncol-rcp(:,2)'+1);
P=zeros(nrow,ncol);
eval(sprintf('P(%.0f:%.0f,%.0f:%.0f)=varargin{%.0f};',[frow;lrow;fcol;lcol;1:ni]))
