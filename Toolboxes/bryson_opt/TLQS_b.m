function yp=tlqs_b(t,y,flag,A,B,Q,N,R)
% Bkwd integ. of S(t) and g(t) for TLQSR;        8/97, 6/18/02
%
Qb=Q-N*(R\N'); Ab=A-B*(R\N'); [ns,ns]=size(A); n1=ns*(ns+1)/2;
ys=y([1:n1]); S=forms(ys); Sd=-S*Ab-Ab'*S-Qb+S*B*(R\(B'*S)); 
g=y([1+n1:n1+ns]); gd=-(A-B*(R\(N'+B'*S)))'*g; 
yp=[forms(Sd); gd];
	

	
	