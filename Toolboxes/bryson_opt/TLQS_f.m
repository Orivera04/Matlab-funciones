function yp=tlqs_f(t,y,flag,A,B,tk,K,uf)
% For forward integ. of states with TLQSR; 8/97, 6/18/02
%
[ns,nc]=size(B); Kt=formm(interp1(tk,K,t),ns);
uft=interp1(tk,uf,t); yp=(A-B*Kt)*y+B*uft';
	
	