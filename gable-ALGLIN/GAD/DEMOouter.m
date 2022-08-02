     disp('>> % 	SPANNING: THE OUTER PRODUCT');
     % 	SPANNING: THE OUTER PRODUCT
     GAfigure; clc; %/
     disp('>> % 	SPANNING: THE OUTER PRODUCT');
     % 	SPANNING: THE OUTER PRODUCT
     disp('>> %');
     %
     global v w; %/
     clf; %/
     disp('>> % 	The outer product is anti-symmetric:');
     % 	The outer product is anti-symmetric:
     disp('>> %');
     %
     fprintf(1,'>> e1^e2  ');
     input('');
     e1^e2 %w
     fprintf(1,'>> e2^e1  ');
     input('');
     e2^e1 %w
     fprintf(1,'>> e1^e1  ');
     input('');
     e1^e1 %w
     GAprompt; %/
     disp('>> % 	and the outer product is linear:');
     % 	and the outer product is linear:
     fprintf(1,'\n');     fprintf(1,'>> e1^(e2+e3)  ');
     input('');
     e1^(e2+e3) %w
     disp('>> %	All bivectors expressible on BIVECTOR BASIS.');
     %	All bivectors expressible on BIVECTOR BASIS.
     fprintf(1,'\n');     disp('>> % 	Those properties yield certain identities:');
     % 	Those properties yield certain identities:
     fprintf(1,'\n');     fprintf(1,'>> e1^(e1+e2)  ');
     input('');
     e1^(e1+e2) %w
     GAprompt; %/
     disp('>> %');
     %
     disp('>> % Now let us draw these bivectors');
     % Now let us draw these bivectors
     fprintf(1,'\n');     disp('>> v = e1 + e2;');
     v = e1 + e2;
     disp('>> w = e2 + 2*e3;');
     w = e2 + 2*e3;
     disp('>> B = v^w;');
     B = v^w;
     disp('>> DrawBivector(v,w);');
     DrawBivector(v,w);
     GAview([30 30]); %/
     GAtext(0.5*v-0.1*unit(w)+0.1*unit(grade(((v^w)/I3),1)),'v'); %/
     GAtext(0.5*w+0.1*unit(v)+0.1*unit(grade(((v^w)/I3),1))+v,'w'); %/
     GAtext(0.5*v+0.7*w-0.2*unit((v^w)*I3),'v \wedge w'); %/
     axis('vis3d'); %/
     GAprompt; %/ 
     disp('>> %	Again, the actual object is coordinate-free.');
     %	Again, the actual object is coordinate-free.
     axis off; %/
     GAprompt; %/
     GAorbiter(380,10); %/
     disp('>> % 	The bivector v^w has dimension, direction, ');
     % 	The bivector v^w has dimension, direction, 
     disp('>> %	sense and area, but NO SHAPE');
     %	sense and area, but NO SHAPE
     GAprompt; %/
     va = [-1.5 2.5 -0.75 3.5 -1 2]; %/
     axis(va); %/
     disp('>> % 	(a more distant view)'');');
     % 	(a more distant view)');
     GAprompt; %/
     disp('>> DrawBivector(v,1.5*v+w); ');
     DrawBivector(v,1.5*v+w); 
     GAtext(0.5*v+0.7*(1.5*v+w)-0.2*unit((v^w)*I3),'v \wedge w');  %/
     axis(va); %/
     GAprompt; %/
     disp('>> DrawBivector(v,-1.5*v+w); ');
     DrawBivector(v,-1.5*v+w); 
     GAtext(0.5*v+0.7*(-1.5*v+w)-0.2*unit((v^w)*I3),'v \wedge w'); %/
     axis(va); %/
     GAprompt; %/
     GAorbiter(360,10); GAprompt; %/
     disp('>> %	(Note that all points spanning same bivector with v');
     %	(Note that all points spanning same bivector with v
     disp('>> %	are on a line parallel to v)');
     %	are on a line parallel to v)
     disp('>> %');
     %
     GAprompt; %/
     disp('>> % 	If no spanning vectors are known ');
     % 	If no spanning vectors are known 
     disp('>> %	we draw the bivector as a disk:');
     %	we draw the bivector as a disk:
     fprintf(1,'\n');     disp('>> draw(v^w,''g''); ');
     draw(v^w,'g'); 
     GAtext(-0.2*unit((v^w)*I3)-w/4,'v \wedge w'); %/ 
     axis(va); %/
     GAprompt; %/
     GAorbiter(360,10); %/
