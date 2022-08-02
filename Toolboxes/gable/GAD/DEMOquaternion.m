     disp('>> %	QUATERNIONS IN GEOMETRIC ALGEBRA');
     %	QUATERNIONS IN GEOMETRIC ALGEBRA
     GAfigure; clc; %/
     disp('>> %	QUATERNIONS IN GEOMETRIC ALGEBRA');
     %	QUATERNIONS IN GEOMETRIC ALGEBRA
     global i j k u q bivector Rangle Raxis; %/
     clf; %/
     disp('>> % The basic ''vectors'' in quaternions are unit bivectors.');
     % The basic 'vectors' in quaternions are unit bivectors.
     fprintf(1,'>> i = e1*I3     ');
     input('');
     i = e1*I3    %w
     fprintf(1,'>> j = -e2*I3     ');
     input('');
     j = -e2*I3    %w
     fprintf(1,'>> k = e3*I3     ');
     input('');
     k = e3*I3    %w
     disp('>> % The quaternion product is the geometric prodcut:');
     % The quaternion product is the geometric prodcut:
     fprintf(1,'>> i*i 		 ');
     input('');
     i*i 		%w
     fprintf(1,'>> j*j 		 ');
     input('');
     j*j 		%w
     fprintf(1,'>> k*k 		 ');
     input('');
     k*k 		%w
     fprintf(1,'>> i*j 		 ');
     input('');
     i*j 		%w
     fprintf(1,'>> i*j*k 		 ');
     input('');
     i*j*k 		%w
     disp('>> % A (unit) quaternion is a rotor:');
     % A (unit) quaternion is a rotor:
     fprintf(1,'>> q = 1 + i +j +k  ');
     input('');
     q = 1 + i +j +k %w
     GAprompt; %/
     fprintf(1,'>> u = q/norm(q) 	 ');
     input('');
     u = q/norm(q) 	%w
     bivector = sLog(u); %/
     Rangle = norm(bivector); %/
     Raxis = bivector/I3; %/
     disp('>> % A quaternion can be applied to a vector, bivector etc.,');
     % A quaternion can be applied to a vector, bivector etc.,
     disp('>> % without converting it to a matrix first');
     % without converting it to a matrix first
     disp('>> % (and without normalization).');
     % (and without normalization).
     clf; %/
     x = e1; %/
     draw(x,'b'); %/
     axis off; %/
     GAtext(1.1*x,'x','b'); %/
     draw(bivector,'r'); %/
     draw(Raxis,'k'); %/
     label = -0.5*unit(grade(inner(x + q*x/q,bivector)/bivector,1))+ 0.1*unit(Raxis); %/
     GAtext(label, 'log(q)'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAview([45 30]); %/
     GAprompt; %/
     fprintf(1,'>> Rx = q*x/q   ');
     input('');
     Rx = q*x/q  %w
     draw(Rx,'g'); %/
     GAtext(1.1*Rx,'q x q^{-1}','k'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAprompt; %/
     GAorbiter(360,10); %/
     GAprompt; %/
     disp('>> % And it can be applied directly to bivectors:');
     % And it can be applied directly to bivectors:
     disp('>> B = x^(e2+e3); ');
     B = x^(e2+e3); 
     draw(B,'b'); %/
     axis([-1 1 -1 1 -1 1]); %/
     label = grade(meet(B,bivector),1); %/
     GAtext(0.75*label,'B','b'); %/
     fprintf(1,'>> RB = q*B/q   ');
     input('');
     RB = q*B/q  %w
     draw(RB,'g'); %/
     GAtext(0.75*q*label/q,'q B q^{-1}','k'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAprompt; %/
     GAorbiter(360,10); %/
     disp('>> ');
     
