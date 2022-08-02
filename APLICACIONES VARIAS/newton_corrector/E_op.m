function E = E_op( n )

E=1./[1:n]*M_inv(n,2-n);
renormal=1/sum(E);
E=renormal*E;