	function [f,g]=f4_crus1(p,h)         
   % F4H cruise condition; p=[V alpha]' in ft/sec, rad;
   % 12/25/97
	%
	S=530; rho=.002378; W=38000;  
	V=p(1); alp=p(2); ca=cos(alp); sa=sin(alp);
	%
	% Atmos. model; a(h), rhor(h); comp. of Mach number:
	ao=1116; hc=145820; la=4.269; ha=20860; ht=36090;
	if h<ht,
	  a=ao*(1-h/hc)^.5; rhor=(1-h/hc)^la;
	else
	  a=968.1; rhor=((1-ht/hc)^la)*exp(-(h-ht)/ha);
	end
	M=V/a;
	%
	% Aerodynamic model - cdo(M), cla(M), ka(M): 
   if M<1.15,
      cdo=.013+.0144*(1+tanh((M-.98)/.06));
      cla=3.44+1.0/(cosh((M-1)/.06))^2;
      ka=.54+.15*(1+tanh((M-.9)/.06));
   else 
      cdo=.013+.0144*(1+tanh(.17/.06))-.011*(M-1.15);
	   cla=3.44+1.0/(cosh(.15/.06))^2-(.96/.63)*(M-1.15);
	   ka=.54+.15*(1+tanh((.25)/.06))+.14*(M-1.15);
   end;
   cd=cdo+ka*cla*alp^2;
	%   
   % Max thrust in lb:
   h1=h/10000;
	Q=[ 30.21     -.668  -6.877   1.951   -.1512; ...
	   -33.80     3.347  18.13   -5.865    .4757; ...
	   100.80   -77.56    5.441   2.864   -.3355; ...
	   -78.99   101.40  -30.28    3.236   -.1089; ...
	    18.74   -31.60   12.04   -1.785    .09417];
	T=1000*[1 M M^2 M^3 M^4]*Q*[1 h1 h1^2 h1^3 h1^4]';  
   %
   % Outputs:
   sg=.29e-3; g=5280*sg*T/V;      % Fuel consump. (lb/mile)
   L=cla*alp*S*rho*rhor*V^2/2;                % Lift in lb
   D=cd*S*rho*rhor*V^2/2;                     % Drag in lb
   f(1)=T*ca-D;                     % Equality constraints
   f(2)=T*sa+L-W;                    
                                 
   		  
