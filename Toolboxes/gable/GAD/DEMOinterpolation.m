     disp('>> % 	INTERPOLATION OF ORIENTATIONS');
     % 	INTERPOLATION OF ORIENTATIONS
     GAfigure; clc; %/
     disp('>> % 	INTERPOLATION OF ORIENTATIONS');
     % 	INTERPOLATION OF ORIENTATIONS
     global RA RB u v; %/
          clf; %/
     disp('>> %	Problem: interpolate two orientations.');
     %	Problem: interpolate two orientations.
     disp('>> %');
     %
     disp('>> % 	An orientation can be characterized ');
     % 	An orientation can be characterized 
     disp('>> %	by a rotation from a standard pose.');
     %	by a rotation from a standard pose.
     disp('>> %	Let the orientations be RA and RB.');
     %	Let the orientations be RA and RB.
     disp('>> %');
     %
     u = e1+e2-e3; %/
     v = e1+e3; %/
     view = [-1 2 -1 2 -2 1]; %/
     disp('>> % 	Initial orientation RA (applied to a bivector u^v):');
     % 	Initial orientation RA (applied to a bivector u^v):
     fprintf(1,'\n');     disp('>> RA = gexp(-I3*e1*pi/2/2);');
     RA = gexp(-I3*e1*pi/2/2);
     DrawBivector(RA*u/RA,RA*v/RA,'b');  %/
     GAtext(1.1* RA*(u+v)/RA,'" R_A"','b'); %/
     axis(view); axis off; %/
     GAview([30 30]); %/
     GAprompt; %/
     disp('>> % 	Final orientation (applied to u^v):');
     % 	Final orientation (applied to u^v):
     fprintf(1,'\n');     disp('>> RB = gexp(-I3*e2*pi/2/2);');
     RB = gexp(-I3*e2*pi/2/2);
     DrawBivector(RB*u/RB,RB*v/RB,'g');  axis(view); %/
     GAtext(1.1* RB*(u+v)/RB,'" R_B"','k'); %/
     GAprompt; %/
     disp('>> % 	Interpolation through division of total rotor:');
     % 	Interpolation through division of total rotor:
     fprintf(1,'\n');     fprintf(1,'>> Rtot =  RB/RA  ');
     input('');
     Rtot =  RB/RA %w
     disp('>> % which is done through incremental rotor R:');
     % which is done through incremental rotor R:
     fprintf(1,'\n');     n = 8;                          %/
     disp('>> R = gexp(sLog(Rtot)/n)');
     R = gexp(sLog(Rtot)/n)
     axisR = unit(GAZ(-sLog(R)/I3));   %/ 
     draw(axisR,'r'); %/
     title('R = exp( log( R_B/R_A ) / n)','Color','r'); %/
     draw(-sLog(Rtot)/n,'r'); %/
     axis(view); %/
     GAprompt; %/
     disp('>> % 	Execute the interpolations from RA[u^v] to RB[u^v]');
     % 	Execute the interpolations from RA[u^v] to RB[u^v]
          Ri = RA;  %/
          for i=1:n-1  %/
     	 disp(['i = ', num2str(i) ':   R' num2str(i) ' = R*R' num2str(i-1)]); %/
              Ri = R*Ri; %/
              DrawBivector(Ri*u/Ri,Ri*v/Ri); %/
              axis(view); %/
              drawnow; %/
          end %/
     GAprompt; %/
     title(''); %/
     GAorbiter(125,10); %/
