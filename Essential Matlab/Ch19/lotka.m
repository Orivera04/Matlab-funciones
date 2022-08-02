function dxdt = lotka(t,x,nvars,parms)
dxdt = zeros(nvars,1);

%user-friendly names for parameters:
p = parms(1).val; 
q = parms(2).val;
r = parms(3).val;
s = parms(4).val;

%user-friendly names for variables:
prey = x(1);
pred = x(2);

%user-friendly names in the model:
dxdt(1) = p*prey - q*pred*prey;
dxdt(2) = r*pred*prey - s*pred;