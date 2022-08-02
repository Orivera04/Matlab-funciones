     disp('>> % 	PROJECTION, REJECTION');
     % 	PROJECTION, REJECTION
     GAfigure; clc; %/
     disp('>> % 	PROJECTION, REJECTION');
     % 	PROJECTION, REJECTION
     disp('>> %');
     %
     global x a A p r; %/
     clf; %/
     disp('>> % 	Take two vectors x and a:');
     % 	Take two vectors x and a:
     fprintf(1,'\n');     disp('>> x = e1 + e2 + e3;');
     x = e1 + e2 + e3;
     disp('>> a = e2/4 + e3/2;');
     a = e2/4 + e3/2;
     draw(x,'r'); %/
     random=unit(pi*e1+pi/exp(1)*e2+exp(1)*e3); %/
     GAtext(0.7*x+0.1*unit(grade((random^x)/x,1)),'x'); %/
     draw(a,'g'); %/
     GAtext(0.7*a-0.1*unit(grade((random^a)/a,1)),'a'); %/
     va = [-0.05 1.1 0 1.25 -0.25 1.5]; %/
     axis(va); %/
     axis('vis3d'); %/
     axis off; %/
     GAprompt; %/
     GAorbiter(60,3); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	projection of x onto a: ');
     % 	projection of x onto a: 
     fprintf(1,'\n');     disp('>> p = inner(x,a)/a ');
     p = inner(x,a)/a 
     draw(p,'m'); %/
     draw(a,'g'); %/
     DrawPolyline({x,p},'k'); %/
     GAtext(0.7*p-0.1*unit(grade((random^p)/p,1)),'(x \bullet a) / a'); %/ 
     axis(va); %/
     GAprompt; %/
     disp('>> % 	rejection of x by a:');
     % 	rejection of x by a:
     fprintf(1,'\n');     disp('>> r = (x^a)/a  ');
     r = (x^a)/a  
     draw(r,'m'); %/
     DrawPolyline({x,r},'k'); %/
     GAtext(0.5*r-0.1*unit(grade((random^r)/r,1)),'r = (x \wedge a) / a'); %/ 
     axis(va); %/
     GAprompt; %/
     axis(va); %/
     GAorbiter(360,10); %/ 
     axis(va); %/
     GAprompt; %/
     disp('>> % 	Explanation: ');
     % 	Explanation: 
     axis(va); %/
     GAprompt; %/
     disp('>> %	span x^a,');
     %	span x^a,
     DrawBivector(x,a,'y'); %/
     GAtext((x+a)/2 + 0.1*(x^a)/I3,'x \wedge a'); %/
     axis(va); %/
     disp('>> % 	reshape orthogonally,');
     % 	reshape orthogonally,
     GAprompt; %/
     DrawBivector(r,a,'y'); %/
     GAtext((r+a)/2 + 0.1*(x^a)/I3,'x \wedge a'); %/
     axis(va); %/
     GAprompt; %/
     title('x \wedge a = r \wedge a = r \bullet a + r \wedge a = r a','FontSize',12);%/
     disp('>> % 	division by a then gives the rejection.');
     % 	division by a then gives the rejection.
     axis(va); %/
     GAprompt; %/
     fprintf(1,'\n');     disp('>> %	Projection and rejection formulas also work for bivectors:	');
     %	Projection and rejection formulas also work for bivectors:	
     GAprompt; %/
     clf; %/
     disp('>> x = e1/3 - e2/2 + e3;');
     x = e1/3 - e2/2 + e3;
     disp('>> A = e1^(e2/3 + e3/2);');
     A = e1^(e2/3 + e3/2);
     draw(x,'r'); %/
     axis off; %/
     axis([-0.5 0.5 -0.8 0.2 -0.4 1]); %/
     random=unit(pi*e1+pi/exp(1)*e2+exp(1)*e3); %/
     GAtext(0.7*x-0.1*unit(grade((random^x)/x,1)),'x'); %/
     draw(A,'g'); %/
     GAtext(-0.4*unit(grade(inner(random,A)/A,1))+0.1*unit(A/I3),'A'); %/ 
     va = [-0.5 0.5 -0.81 0.31 -0.4 1]; %/
     axis(va); %/
     axis('vis3d'); %/
     GAprompt; %/
     GAorbiter(360,4); %/
     axis off; %/
     disp('>> % 	projection of x onto A: ');
     % 	projection of x onto A: 
     fprintf(1,'\n');     disp('>> p = inner(x,A)/A  ');
     p = inner(x,A)/A  
     draw(p,'m'); %/
     DrawPolyline({x,p},'k'); %/
     GAtext(0.9*p+0.1*unit(grade((random^p)/p,1)),'(x \bullet A) / A'); %/ 
     axis(va); %/
     GAprompt; %/
     disp('>> % 	rejection of x by a:');
     % 	rejection of x by a:
     fprintf(1,'\n');     disp('>> r = (x^A)/A  ');
     r = (x^A)/A  
     draw(r,'m'); %/
     DrawPolyline({x,r},'k'); %/
     GAtext(0.7*r-0.1*unit(grade((random^r)/r,1)),'(x \wedge A) / A'); %/ 
     axis(va); %/
     GAprompt; %/
     GAorbiter(340,10); %/
