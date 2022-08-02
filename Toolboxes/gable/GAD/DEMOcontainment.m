     disp('>> % 	SPANNING AND CONTAINMENT');
     % 	SPANNING AND CONTAINMENT
     GAfigure; clc; %/
     disp('>> % 	SPANNING AND CONTAINMENT');
     % 	SPANNING AND CONTAINMENT
     disp('>> %');
     %
     global x B u; %/
     clf; %/
     v = e1; %/
     w = e2; %/
     B = unit(v^w); %/
     draw(B, 'y'); %/
     GAtext(-0.5*v+0.1*B/I3,'B'); %/
     u = B/I3; %/
     draw(u,'r'); %/
     ut = GAtext(0.7*u-0.08*v,'u'); %/
     axis([-0.5 1 -0.5 0.5 -1 1]); %/
     axis off; %/
     disp('>> % We span the trivector u^B, ');
     % We span the trivector u^B, 
     disp('>> % and observe its sign and magnitude as u rotates.');
     % and observe its sign and magnitude as u rotates.
     disp('>> % (click on figure)');
     % (click on figure)
     GAmouse = 1; GAprompt; %/ 
     for i = 0:pi/8:pi %/
     	x = u*cos(i)+v*sin(i); %/
        T = x^B; %/
        title(['u \wedge B = ' num2str(T/I3) '*I_3']);	%/
        delete(ut); %/
        ut = GAtext(0.7*x+0.08*x/(u^v)*norm(u^v),'u'); %/
        if (T/I3 > 1e-16) %/
           draw(x,'r'); %/
       	else if (T/I3 < -1e-16) %/
              draw(x,'b'); %/
        else %/
     		draw(x,'g'); %/
     	end %/
     	end %/
     	axis([-0.5 1 -0.5 0.5 -1 1]); GAprompt; %/ 
     end %/
     GAmouse = 0; %/
