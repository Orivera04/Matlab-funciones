function bf=c_table(y,a)
%
% C_TABLE Bayes factor for testing independence in a contingency table.
%	BF=C_TABLE(Y,A) returns the Bayes factor BF against independence in a 
%	2-way contingency table using uniform priors, where Y is a matrix
%	containing the 2-way table, and A is a matrix of prior parameters
%	of the Dirichlet (A=ones(size(ymat)) is the default.

if nargin==1,a=1+0*y;end

ac=sum(a); ar=sum(a');
yc=sum(y); yr=sum(y'); 
[I,J]=size(y); oc=1+0*yc; or=1+0*yr;

lbf=ldirich(y(:)+a(:))+ldirich(ar-(J-1)*or)+ldirich(ac-(I-1)*oc)-...
    ldirich(a(:))-ldirich(yr+ar-(J-1)*or)-ldirich(yc+ac-(I-1)*oc);

bf=exp(lbf);

function val=ldirich(a)
val=sum(gammaln(a))-gammaln(sum(a));

