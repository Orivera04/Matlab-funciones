function	Yi=interpol(y,Poin,ORD,STOP)
%Parabolic, cubic or SPLIN INTERPOLation of 
%data y (matrix or vector)sampled at equal intervals.
%ORD=2: symmetrical parabolic interpolation
%ORD=3: classical cubic interpolation
%ORD = default or []: smooth cubic interpolation ("SPLIN")
% Call:
%		yi=interpol(y,Poin,ORD,STOP);
% Input:
%	y = (matrix or vector) original data 
%	Poin >=1, default 1, number of points inserted in each interval
%   Interpolation method defined by ORD:
%   ORD = [] (default) SPLIN
%	ORD =  2 symmetric quadratic interpolation
%	ORD = 3 classical cubic interpolation 
%   STOP (def. 0): if nonzero, interpolates only in 1st dimension
%    
% Output:
%	yi = interpolated data		
%
%					Examples.
%
%   Example 1. Interpolating Vectors
%
%	f=inline('sin(x/2).*exp(-.001*x+cos(x*sqrt(2)))').';
% 	x=(1:4000)'/8; y=f(x); Poin=5; PER=Poin+1;
%	tic, xi=colon(x(1),(x(end)-x(1))/((length(x)-1)*PER),x(end))';toc
%	RES=zeros(5,2);  %Time and error
%	tic, yc=interp1(x,y,xi,'*cubic'); RES(1,1)=toc;
%   tic,y5=interp1(x,y,xi,'v5cubic'); RES(2,1)=toc;
% 	tic, y2=interpol(y,Poin,2); RES(3,1)=toc;
%	tic, y3=interpol(y,Poin,3);RES(4,1)= toc;
%	tic, ys=interpol(y,Poin);RES(5,1)=toc; %SPLIN=smooth cubic
%	tic, yss=interp1(x,y,xi,'*spline'); RES(6,1)=toc; %SPLINE
%	yt=f(xi); %true data for comparison
%%	Check error for inner intervals:
% 	IND=2*PER+1:length(xi)-2*PER;
%	ERC=norm(yt(IND)-yc(IND));   %Error '*cubic'
%	ER5=norm(yt(IND)-y5(IND));   %Error v5
%	ER2=norm(yt(IND)-y2(IND));   %Error parabolic
%	ER3=norm(yt(IND)-y3(IND));   %Error cubic classical
%	ERS=norm(yt(IND)-ys(IND));   %Error SPLIN
%	ERSS=norm(yt(IND)-yss(IND)); %Error SPLINE
%	RES(:,2)=[ERC ER5 ER2 ER3, ERS ERSS]'
%	plot(xi,yc-yt,'--',xi,y2-yt,xi,y3-yt,xi,ys-yt,xi,yss-yt,':')
%
%  Example 2. Interpolating matrices
%
% [X,Y]=meshgrid(-25:25);
% Z=exp(-(X.^2+Y.^2)/100).*sin((X+Y+10)/5);
% RES=zeros(5,2);
% tic,ZC=interp2(Z,3,'*cubic'); RES(1,1)=toc;
% tic,Z2=interpol(Z,7,2); RES(2,1)=toc; %Biparabolic symmetrical
% tic,Z3=interpol(Z,7,3); RES(3,1)=toc; %Bicubic classical
% tic,ZS=interpol(Z,7);   RES(4,1)=toc; %SPLIN = smooth bicubic
% tic,ZSS=interp2(Z,3,'*spline'); RES(5,1)=toc; %SPLINE
% [X,Y]=meshgrid(-25:1/8:25);
% ZT=exp(-(X.^2+Y.^2)/100).*sin((X+Y+10)/5);%for comparison
% ERC=norm(ZT(:)-ZC(:));	%Error '*cubic'
% ER2=norm(ZT(:)-Z2(:));	%Error biparabolic
% ER3=norm(ZT(:)-Z3(:));	%Error classical bicubic
% ERS=norm(ZT(:)-ZS(:));	%Error SPLIN
% ERSS=norm(ZT(:)-ZSS(:));	%Error SPLINE
% RES(:,2)=[ERC ER2 ER3 ERS ERSS]'

%	Vassili Pastushenko      30-th August 1999
%   Generalized for matrices: 3-rd September 1999
%	Revised     24-th Jan 2002
%===============================================
if nargin<4,STOP=0;end
[L,N]=size(y); %L = Lines, N = Number of columns
if N==1|L==1,STOP=1;end

if L==1;
   TRANS=1>0;
   y=y.';
   L=N;
   N=1;
else
   TRANS=1<0;
end

if nargin<3
ORD=4;
else
    if isempty(ORD)
     ORD=4;
    end
end




if nargin<2,Poin=1;end



%Expanding data
if ORD>2
    yf=cubpad(y);
end
if ORD==3,
    yf(1,:)=[]; yf(end,:)=[];
end

if ORD==2
    M=[3 -3 1];
    yf=zeros(L+2,N);
    yf(1,:)=M*y(1:3,:);
    yf(2:L+1,:)=y;
    yf(L+2,:)=M*y(L:-1:L-2,:);
end


%FILter design
SPLIN=ORD==4;
PER=Poin+1;
   if SPLIN
   t=vanderm((1:Poin)/PER,3);
   FIL=[(t(:,1)+t(:,3))/12-t(:,2)/6,-7/12*t(:,1)+5/4*t(:,2)-2/3*t(:,3),...
   4/3*t(:,1)-7/3*t(:,2)+1,-4/3*t(:,1)+5/3*t(:,2)+2/3*t(:,3),...
   7/12*t(:,1)-.5*t(:,2)-t(:,3)/12, (t(:,2)-t(:,1))/12];
   else
	t=2*(1:Poin)'/PER;
	if ORD==2	%Left-right symmetric interpolation
			tt=t-2;ttt=t.*tt;
			FIL=[ttt,-tt.*(t+8),t.*(10-t),ttt]/16;
	end
	if ORD==3
		FIL=polyfilt(-3:2:3,t-1);
	else
	  if ORD~=2, error('ORDer can be 2 or 3'),end
	end
end
WIF=size(FIL,2);%WIdth of Filter, 4 or 6

% Vertical interpolation
END=L-1;
NEWLEN=PER*END;	% 1 less than new_ver_length
Yi=zeros(NEWLEN,N);%Space for results but last row
yi=zeros(PER,END); %variable matrix for each column
F=zeros(WIF,END);
IND=F;
%t=1:END;
T=1:END;

IND(1,:)=T;
for i=2:WIF,
   IND(i,:)=IND(i-1,:)+1;
end
TT=2:PER;
for i=1:N %Column-wise interpolation
   F(:)=yf(IND,i);
 %DAT=yf(:,i).';
	yi(1,:)=y(T,i).';%given data
  	yi(TT,:)=FIL*F;%interpolated data
%   yi(tt,:)=FIL*DAT(IND);
	Yi(:,i)=yi(:);
end
Yi(NEWLEN+1,:)=y(L,:);%last given
if TRANS,Yi=Yi.';end
if STOP~=0,
    return,
else
    Yi=interpol(Yi.',Poin,ORD,1).';
end

function FIL=polyfilt(x,z)
%Lagrange explicite implementation
%x = data abscissae, real
%z = interpolation abscissae, real
xc=x(:);
LX=length(x);

%Lagrange DENominator
ONELX=ones(1,LX);
xx=xc(:,ONELX);
DEN=prod(xx'-xx+eye(LX));

%Lagrange NUMerator
LZ=length(z);
ONELZ=ones(LZ,1);
z=z(:)';
zmx=z(ONELX,:)-xc(:,ONELZ);
PRO=prod(zmx);
NUM=PRO(ONELX,:)./zmx;

%Interpolating FILter
FIL=NUM'./DEN(ONELZ,:);
%=========================

function VDM = vanderm(c,M)
%VANDERMonde matrix, cut version.
%	Call: 
%		VDM=VANDERM(c,M)
%	Input: 
%		c=vector (of length N).
%		M = highest degree of c, default N-1
%	Output:  
%	VDM = (Cut) Vandermonde matrix, N by M+1, 
% 	with j-th column as VDM(:,j) = c(:).^(j-M+1).
n = length(c);
if nargin<2,M=n-1;end
c = c(:);
VDM = ones(n,M+1);
for j = M:-1:1
    VDM(:,j) = c.*VDM(:,j+1);
end

function yp=cubpad(y)
%cubic padding 2 points at the beginning and end of each column
x=[-2;-1];
M=[-(x-1).*(x-2).*(x-3)/6, x.*(x-2).*(x-3)/2, -x.*(x-1).*(x-3)/2,  x.*(x-1).*(x-2)/6];
ytop=M*y(1:4,:);
faly=flipud(y(end-3:end,:));
ybot=flipud(M*faly);
yp=[ytop;y;ybot];

