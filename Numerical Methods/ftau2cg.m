function ftauv=ftau2cg(tau);
global p1 d1
q1=p1+tau*d1;
ftauv=feval('f801',q1);