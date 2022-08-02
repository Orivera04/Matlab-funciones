function yp=tlqh_f(t,y,flag,A,B,t1k,K,uf)
% For fwd integ. of states with TLQHR; 8/97, 6/18/02
%
[ns,nc]=size(B); Kt=formm(interp1(t1k,K,t),ns);
uft=interp1(t1k,uf,t); yp=(A-B*Kt)*y+B*uft';
	
	