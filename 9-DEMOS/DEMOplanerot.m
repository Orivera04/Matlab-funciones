     disp('>> %	ROTATIONS IN A PLANE');
     %	ROTATIONS IN A PLANE
     GAfigure; clc; %/
     disp('>> %	ROTATIONS IN A PLANE');
     %	ROTATIONS IN A PLANE
     disp('>> %');
     %
     global a b c R x; %/
     disp('>> clf;');
     clf;
     va = [-1 1 -0.2 1.3 -0.5 0.5]; %/
     disp('>> a = unit(e1+e2/3);');
     a = unit(e1+e2/3);
     disp('>> b = unit(e1+e2/2);');
     b = unit(e1+e2/2);
     draw(a,'b'); %/
     GAtext(1.1*a,'a'); %/
     draw(b,'b'); %/
     bt = GAtext(1.1*b,'b'); %/
     GAview([0 90]); %/
     axis off; %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	Two vectors determine a rotation/dilation');
     % 	Two vectors determine a rotation/dilation
     fprintf(1,'>> R = b/a     ');
     input('');
     R = b/a    %w
     disp('>> %	This is an operator. applicable to vectors in the plane:');
     %	This is an operator. applicable to vectors in the plane:
     disp('>> c = 1.1*e2-e1/2;');
     c = 1.1*e2-e1/2;
     draw(c,'m');  %/
     GAtext(1.05*c,'c');  %/
     axis(va); %/
     fprintf(1,'>> x = R*c	    ');
     input('');
     x = R*c	   %w
     draw(x,'r'); %/
     GAtext(x-0.2*e1,'x = (b/a)c');%/
     axis(va); %/
     disp('>> %	x is to c as b is to a');
     %	x is to c as b is to a
     GAprompt;  %/
     disp('>> %	Repeated application to a:');
     %	Repeated application to a:
     title('R = b/a ','Color','r'); %/
     GAprompt; %/
     draw(R*a,'r');  		%/
     delete(bt); 		%/
     GAtext(1.1*R*a,'R a'); 		%/
     axis(va); %/
     GAprompt; %/
     draw(R*R*a,'r'); 		%/
     GAtext(1.1*R*R*a,'R^2 a'); 		%/
     axis(va); %/
     GAprompt; %/
     draw(R*R*R*a,'r'); 		%/
     GAtext(1.1*R*R*R*a,'R^3 a'); 		%/
     axis(va); %/
     GAprompt; %/
     draw(R*R*R*R*a,'r'); 		%/
     GAtext(1.1*R*R*R*R*a,'R^4 a'); 		%/
     axis(va); %/
     GAprompt; %/
     draw(R*R*R*R*R*a,'r'); 		%/
     GAtext(1.1*R*R*R*R*R*a,'R^5 a'); 		%/
     axis(va); %/
