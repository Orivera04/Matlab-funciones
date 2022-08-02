	function f=dhdu(u1,name,s1,dt,t,l1)
	% Grad of Hamiltonian; for zeroing w.r.t. 
	% u using 'fsolve';              2/24/97
	%
	[fs,fu]=feval(name,u1,s1,dt,t,3);
	la=fs'\l1;
	f=la'*fu;
	