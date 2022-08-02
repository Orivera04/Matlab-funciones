function [lint2,mom,x,y1,f]=ad_quad2(logpost,mom,iter,par)
% AD_QUAD2 Summarizes a two-parameter posterior by adaptive quadrature.
%	[LINT2,MOM,X,Y1,F]=AD_QUAD1(LOGPOST,MOM,ITER,PAR) returns the estimate LINT2
%	at the log integral of the posterior, a vector MOM containing the posterior 
%	moments (mean1,std1,mean2,std2,corr), vectors X and Y1 containing the 
%	grids for the first parameter and a transformed second parameter, and
%	a matrix F of values of the log posterior, where LOGPOST is a
%	function containing the definition of the log posterior, MOM is the
%	vector containing the initial guess at the moments, ITER is the
%	number of iterations in the procedure, and PAR is vector of parameters
%	used in the function.

np=10;

for i=1:iter
  [mom,x,y1,f,lint2]=ns2(logpost,mom,np,par);
end

function [newmom,x,y1,f,lint]=ns2(logpost,mom,np,par);

% naylor-smith adaptive quadrature for 2 parameters
% logpost is definition of log posterior evaluated at x and y
% mom is initial guess at [m1 s1 m2 s2 rho]
% np is size of grid, par is parameters used in function
% output is new moment estimates, vectors of the x and y1 values of
% the grid, the values of the log posterior defined on the grid,
% and the log of the integral estimate

gr=[ -1.65068012, -0.52464762,   .52464762,  1.65068012,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000
 -2.02018287, -0.95857246,   .00000000,   .95857246,  2.02018287,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000
 -2.35060497, -1.33584907, -0.43607741,   .43607741,  1.33584907  2.35060497,   .00000000,   .00000000,   .00000000,   .00000000
 -2.65196136, -1.67355163, -0.81628788,   .00000000,   .81628788  1.67355163,  2.65196136,   .00000000,   .00000000,   .00000000;
 -2.93063742, -1.98165676, -1.15719371, -0.38118699,   .38118699,  1.15719371,  1.98165676,  2.93063742,   .00000000,   .00000000;
 -3.19099320, -2.26658058, -1.46855329, -0.72355102,   .00000000,   .72355102,  1.46855329,  2.26658058,  3.19099320,   .00000000;
 -3.43615912, -2.53273167, -1.75668365, -1.03661083, -0.34290133,   .34290133,  1.03661083,  1.75668365,  2.53273167,  3.43615912];
wts=[  1.24022581,  1.05996448,  1.05996448,  1.24022581,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000;
  1.18148862,   .98658100,   .94530872,   .98658100,  1.18148862,   .00000000,   .00000000,   .00000000,   .00000000,   .00000000;
  1.13690833,   .93558056,   .87640133,   .87640133,   .93558056,  1.13690833,   .00000000,   .00000000,   .00000000,   .00000000;
  1.10133072,   .89718460,   .82868730,   .81026462,   .82868730,   .89718460,  1.10133072,   .00000000,   .00000000,   .00000000;
  1.07193014,   .86675260,   .79289005,   .76454413,   .76454413,   .79289005,   .86675260,  1.07193014,   .00000000,   .00000000;
  1.04700358,   .84175270,   .76460812,   .73030245,   .72023522,   .73030245,   .76460812,   .84175270,  1.04700358,   .00000000;
  1.02545169,   .82066612,   .74144193,   .70329632,   .68708185,   .68708185,   .70329632,   .74144193,   .82066612,  1.02545169];

tq=gr(np-3,1:np);
wet=wts(np-3,1:np);
con=sqrt(2);

mx=mom(1); sx=mom(2); my=mom(3); sy=mom(4); cov=mom(5);
scale=feval(logpost,[mx my],par);

a=-cov/sx^2;
my1=my+a*mx; sy1=sqrt((a*sx)^2+sy^2+2*a*cov);

x=mx+tq*sx*con; y1=my1+tq*sy1*con;
wx=wet*sx*con;	wy1=wet*sy1*con;

[xm,ym]=meshgrid(x,y1); yv=ym-a*xm;
f=reshape(feval(logpost,[xm(:) yv(:)],par)-scale,np,np);

i=(f>-700);
f=i.*f-700*(1-i);

abf=exp(f).*(wy1'*wx);
spost=sum(sum(abf));
smx=sum(sum(abf.*xm)); smxx=sum(sum(abf.*xm.*xm));
smy=sum(sum(abf.*ym)); smyy=sum(sum(abf.*ym.*ym));
smxy=sum(sum(abf.*xm.*ym));

mx=smx/spost; sx=sqrt(smxx/spost-mx^2);
my1=smy/spost; sy1=sqrt(smyy/spost-my1^2);
cov1=smxy/spost-mx*my1;

my=my1-a*mx; sy=sqrt((a*sx)^2+sy1^2-2*a*cov1);
cov=cov1-a*sx^2;
newmom=[mx sx my sy cov];
lint=log(spost)+scale;

