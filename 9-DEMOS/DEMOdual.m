     disp('>> % 	DUAL: INNER PRODUCT WITH I3 ');
     % 	DUAL: INNER PRODUCT WITH I3 
     GAfigure; clc; %/
     disp('>> % 	DUAL: INNER PRODUCT WITH I3 ');
     % 	DUAL: INNER PRODUCT WITH I3 
     fprintf(1,'\n');     global x B b; %/
     clf; %/
     disp('>> % 	The inner product with I3 gives the DUAL');
     % 	The inner product with I3 gives the DUAL
     disp('>> %	(the part of I3 least like x).');
     %	(the part of I3 least like x).
     fprintf(1,'\n');     disp('>> x = e1/2 - e2 +e3/3');
     x = e1/2 - e2 +e3/3
     random = unit(pi*e1 + pi/exp(0)*e2 + exp(0)*e3); %/
     fprintf(1,'>> B = inner(x,I3)  ');
     input('');
     B = inner(x,I3) %w
     draw(x,'b'); %/
     GAtext(0.7*x + 0.1*unit(random^x)/I3,'x','b'); %/
     axis off; %/
     axis([-1 1 -1 1 -1 1]); %/
     GAprompt; %/
     disp('>> % 	(The bivector coefficients match the vector coefficients.)');
     % 	(The bivector coefficients match the vector coefficients.)
     fprintf(1,'\n');     draw(B,'g'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAtext(0.3*unit(grade(inner(random,B),1))+0.1*B/I3,'x \bullet I_3'); %/
     GAprompt; %/ 
     GAorbiter(360,10); GAprompt; %/ 
     disp('>> % 	Taking the dual of the bivector gives a vector:');
     % 	Taking the dual of the bivector gives a vector:
     fprintf(1,'\n');     fprintf(1,'>> b = inner(B,I3)  ');
     input('');
     b = inner(B,I3) %w
     draw(b,'r'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAtext(0.9*b - 0.15*unit(random^b)/I3,'(x \bullet I_3) \bullet I_3','r'); %/ 
     disp('>> ');
     
