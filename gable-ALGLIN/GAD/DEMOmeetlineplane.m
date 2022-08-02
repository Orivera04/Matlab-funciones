     disp('>> % |');
     % |
     disp('>> % |   MEET AND JOIN OF LINE AND PLANE ');
     % |   MEET AND JOIN OF LINE AND PLANE 
     disp('>> % |');
     % |
     clf; %/
     A = e1+e3; %/
     A=A/norm(A); %/
     B = (e1+e2)^(e2+e3); %/
     B =B/norm(B); %/
     draw(A,'m'); GAtext(1.1*A,'A'); %/
     draw(B,'c'); GAtext(0.45*(e2+e3),'B'); %/
     axis off; %/
     axis([-0.7 0.7 -0.7 0.7 -0.75 0.75]); %/
     disp('>> % |   The line A and plane B.');
     % |   The line A and plane B.
     disp('>> % |');
     % |
     GAprompt; %/
     GAorbiter(40,5); %/
     GAprompt; %/
     J = I3; %/
     draw(J,'y'); GAtext(0.5*(e1-e2)+0.05*I3,'J \equiv A \cup B = I_3'); %/
     axis([-0.7 0.7 -0.7 0.7 -0.75 0.75]); %/
     disp('>> % |  Their join is the trivector I3.');
     % |  Their join is the trivector I3.
     disp('>> % | ');
     % | 
     GAprompt; %/
     M = inner((B/J),A) %/
     DrawPoint({0},'r',20); %/
     GAtext(0.1*e1,'M \equiv A \cap B = scalar'); %/
     axis([-0.7 0.7 -0.7 0.7 -0.75 0.75]); %/
     disp('>> % |  Their Meet is a scalar, representing the point at the origin.');
     % |  Their Meet is a scalar, representing the point at the origin.
     disp('>> % |');
     % |
     GAprompt; %/
     GAorbiter(-30,5); %/
