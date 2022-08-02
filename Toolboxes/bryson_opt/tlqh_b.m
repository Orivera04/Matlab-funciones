function yp=tlqh_b(t,y,flag,A,B,Q,N,R,Mf)
% Bkwd integ. S(t), M(t), & Qc(t) for TLQHR;             8/97, 6/18/02
%
[nt,ns]=size(Mf); Ab=A-B*(R\N'); Bb=B*(R\B'); Qb=Q-N*(R\N');
n1=ns*(ns+1)/2; ys=y([1:n1]); S=forms(ys); Sd=-S*Ab-Ab'*S-Qb+S*Bb*S;
n2=nt*ns; M=(formm(y([1+n1:n1+n2]),nt)); Md=-M*(Ab-Bb*S); Qcd=-M*Bb*M';
yp=[forms(Sd); formm(Md,'c'); forms(Qcd)];
	

	
	