     disp('>> %	ROTATION BY ROTORS');
     %	ROTATION BY ROTORS
     GAfigure; clc; %/
     disp('>> %	ROTATION BY ROTORS');
     %	ROTATION BY ROTORS
     global plane angle i phi Raxis; %/
     clf; %/
     disp('>> %');
     %
     disp('>> % 	Making a rotor:');
     % 	Making a rotor:
     disp('>> %');
     %
     disp('>> plane = e1^e2;');
     plane = e1^e2;
     disp('>> angle = pi/4;');
     angle = pi/4;
     i = plane; %/
     phi = angle; %/
     fprintf(1,'>> R = gexp(-plane*angle/2)   ');
     input('');
     R = gexp(-plane*angle/2) %w %%
     GAprompt;
     disp('>> % 	Applying the rotor:');
     % 	Applying the rotor:
     disp('>> x = e1 + e3;');
     x = e1 + e3;
     draw(x,'r'); %/
     axis([-1 1 -1 1 -1 1]); %/
     axis off; %/
     GAtext(0.7*x+0.1*unit(grade(inner(x,plane)/plane,1)),'x'); %/
     draw(plane*angle); %/
     GAview([15 30]); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAtext(0.1*plane/I3-0.3*unit(grade(inner(x,plane)/plane,1)),'i \phi'); %/
     fprintf(1,'>> r = R*x/R  ');
     input('');
     r = R*x/R %w
     draw(r,'m'); %/
     axis([-1 1 -1 1 -1 1]); %/
     title(['rotor R = e^{-i \phi /2}'],'Color','b'); %/
     GAtext(0.9*r+0.1*unit(grade(inner(r,plane)/plane,1)),'R x R^{-1}'); %/
     GAprompt; %/
     title(''); %/
     GAorbiter(-360,5); %/
     disp('>> % In 3-space, you could characterize the rotation by an axis:');
     % In 3-space, you could characterize the rotation by an axis:
     fprintf(1,'>> Raxis = plane/I3  ');
     input('');
     Raxis = plane/I3 %w
     draw(Raxis,'k'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAtext(1.1*Raxis,'i \phi / I_3'); %/
     GAprompt; %/
     disp('>> % Now rotate a bivector.');
     % Now rotate a bivector.
     disp('>> B = 0.7*x^(e1+e2);');
     B = 0.7*x^(e1+e2);
     draw(B,'w'); %/
     axis([-1 1 -1 1 -1 1]); %/
     Blabel = -0.75*unit(meet(B,i)); %/
     GAtext(Blabel,'B'); %/
     fprintf(1,'>> RB = R*B/R  ');
     input('');
     RB = R*B/R %w
     draw(RB,'y'); %/
     axis([-1 1 -1 1 -1 1]); %/
     GAtext(R*Blabel/R,'R B R^{-1}'); %/
     GAprompt; %/
     GAorbiter(-400,10); %/
