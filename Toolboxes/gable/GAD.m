function GAD(GAn)
%GAD: run sample code.

try
if ( GAn == 1 ) 
     GAps = '>>>> ';
     disp('>> % 	VECTORS');
     % 	VECTORS
     GAfigure; clc; %/
     disp('>> % 	VECTORS');
     % 	VECTORS
     global v w; %/
     clf; %/
     disp('>> %	Vectors can be defined using coordinates:');
     %	Vectors can be defined using coordinates:
     disp('>> v = e1 + e2;');
     v = e1 + e2;
     disp('>> w = e2 + 2*e3;');
     w = e2 + 2*e3;
     disp('>> draw(v,''b'');');
     draw(v,'b');
     GAtext(0.5*v -0.1*unit(w),'v'); %/
     disp('>> draw(w,''g'');');
     draw(w,'g');
     GAtext(0.5*w-0.1*unit(v),'w'); %/ 
     axis('vis3d'); %/
     va = [-0.1 1 0 2 -0.1 2]; %/
     axis(va); %/
     GAprompt; %/
     GAorbiter(60,6); %/
     GAprompt; %/
     disp('>> % 	Adding vectors, as usual:');
     % 	Adding vectors, as usual:
     disp('>> v+w');
     v+w
     draw(v+w,'r'); %/
     GAtext(0.7*(v+w) -0.1*unit(w),'v+w'); %/
     DrawPolyline({v,v+w},'k'); %/
     DrawPolyline({w,v+w},'k'); %/
     disp('>> % 	But vector addition is coordinate-free,');
     % 	But vector addition is coordinate-free,
     disp('>> %	so we will drop the axes.');
     %	so we will drop the axes.
     axis(va); %/
     GAprompt; %/
     axis off; %/
     GAprompt; %/
     disp('>> %	Vectors `are'' geometrical objects in space.');
     %	Vectors `are' geometrical objects in space.
     GAorbiter(360,10); %/
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 2 ) 
     GAps = '>>>> ';
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 3 ) 
     GAps = '>>>> ';
     disp('>> % 	SPANNING A TRIVECTOR');
     % 	SPANNING A TRIVECTOR
     GAfigure; clc; %/
     disp('>> % 	SPANNING A TRIVECTOR');
     % 	SPANNING A TRIVECTOR
     disp('>> %');
     %
     global dummy; %/
     clf; %/
     disp('>> % 	We can also span a TRIVECTOR:');
     % 	We can also span a TRIVECTOR:
     fprintf(1,'\n');     fprintf(1,'>> e1^e2^e3  ');
     input('');
     e1^e2^e3 %w
     disp('>> % I3  is called the PSEUDOSCALAR of 3-space ');
     % I3  is called the PSEUDOSCALAR of 3-space 
     GAprompt; %/
     disp('>> % 	Again, there is anti-symmetry:');
     % 	Again, there is anti-symmetry:
     fprintf(1,'\n');     fprintf(1,'>> e2^e1^e3  ');
     input('');
     e2^e1^e3 %w
     GAprompt; %/
     disp('>> % 	Here''s how we draw it:');
     % 	Here's how we draw it:
     disp('>> draw(I3);');
     draw(I3);
     GAtext(0.7*e1+0.2*e3,'I3'); %/
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 4 ) 
     GAps = '>>>> ';
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 5 ) 
     GAps = '>>>> ';
     disp('>> % 	INNER PRODUCT');
     % 	INNER PRODUCT
     GAfigure; clc; %/
     disp('>> % 	INNER PRODUCT');
     % 	INNER PRODUCT
     disp('>> %');
     %
     global x B v w; %/
     clf; %/
     disp('>> % 	The inner product of two vectors is a scalar ');
     % 	The inner product of two vectors is a scalar 
     disp('>> % 	(its magnitude denotes the relative angle)');
     % 	(its magnitude denotes the relative angle)
     fprintf(1,'\n');     disp('>> v = e1;');
     v = e1;
     disp('>> w = unit(e1 + e2);');
     w = unit(e1 + e2);
     draw(v,'b'); %/
     GAtext(0.7*v - 0.1*unit(e2^v)/I3,'v'); %/
     draw(w,'g'); %/
     GAtext(0.7*w + 0.1*unit(e2^w)/I3,'w'); %/
     fprintf(1,'>> inner(v,w)  ');
     input('');
     inner(v,w) %w
     disp('>> % Geometrically, this is a zero-dimensional subspace:');
     % Geometrically, this is a zero-dimensional subspace:
     disp('>> % a weighted point at the origin.');
     % a weighted point at the origin.
     draw(inner(v,w),'r'); %/
     draw(I3/100000,'r'); %/
     GAprompt; %/
     fprintf(1,'\n');     disp('>> % 	The inner product x.B of a vector x and a bivector B is ');
     % 	The inner product x.B of a vector x and a bivector B is 
     disp('>> % 	a vector in B, perpendicular to x');
     % 	a vector in B, perpendicular to x
     disp('>> % 	(its magnitude denotes the relative angle)');
     % 	(its magnitude denotes the relative angle)
     fprintf(1,'\n');     clf; %/
     disp('>> x = unit(e1 + e3); ');
     x = unit(e1 + e3); 
     draw(x,'b'); %/
     GAtext(0.7*x + 0.1*unit(e2^x)/I3,'x'); %/
     disp('>> B = e1^e2; ');
     B = e1^e2; 
     draw(B,'y'); %/
     GAtext(-0.5*v+0.1*B/I3,'B'); %/
     fprintf(1,'>> inner(x,B)  ');
     input('');
     inner(x,B) %w
     axis off; %/
     draw(inner(x,B),'r'); %/
     GAtext(inner(x,B)+0.1*B/I3,'x \bullet B'); GAprompt; %/ 
     disp('>> %	Spinning shows that x.B is "the part of B least like x".');
     %	Spinning shows that x.B is "the part of B least like x".
     GAorbiter(-360,10); %/
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 6 ) 
     GAps = '>>>> ';
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
     
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 7 ) 
     GAps = '>>>> ';
     disp('>> % 	GEOMETRIC PRODUCT');
     % 	GEOMETRIC PRODUCT
     GAfigure; clc; %/
     disp('>> % 	GEOMETRIC PRODUCT');
     % 	GEOMETRIC PRODUCT
     disp('>> %');
     %
     global a b; %/
     clf; %/
     disp('>> a = e1 + e3;');
     a = e1 + e3;
     disp('>> b = e1 + e2; ');
     b = e1 + e2; %%
     GAprompt;
     disp('>> %	We use * to denote the geometric product in GABLE:');
     %	We use * to denote the geometric product in GABLE:
     fprintf(1,'>> a*b   ');
     input('');
     a*b %w 
     disp('>> %	Note: scalar + bivector ! ');
     %	Note: scalar + bivector ! 
     GAprompt; %/
     disp('>> %	Order matters!');
     %	Order matters!
     fprintf(1,'>> b*a     ');
     input('');
     b*a    %w
     GAprompt; %/
     disp('>> %	Square of a vector is scalar');
     %	Square of a vector is scalar
     fprintf(1,'>> b*b     ');
     input('');
     b*b    %w
     disp('>> %	Square of a bivector is negative');
     %	Square of a bivector is negative
     fprintf(1,'>> (e1^e2)*(e1^e2)     ');
     input('');
     (e1^e2)*(e1^e2)    %w
     disp('>> %	Every non-null vector has an inverse');
     %	Every non-null vector has an inverse
     fprintf(1,'>> 1/b     ');
     input('');
     1/b    %w
     fprintf(1,'>> b*(1/b)     ');
     input('');
     b*(1/b)    %w
     GAprompt; %/
     disp('>> % 	Inverse formula: ');
     % 	Inverse formula: 
     fprintf(1,'>> b/(b*b)     ');
     input('');
     b/(b*b)    %w
     GAprompt; %/
     disp('>> % 	Inverse of unit vector:');
     % 	Inverse of unit vector:
     fprintf(1,'>> 1/e1     ');
     input('');
     1/e1    %w
     GAprompt; %/
     disp('>> %	The geometric product is invertible; ');
     %	The geometric product is invertible; 
     disp('>> %	From (a*b) and b, retrieve a = e1+e3 :');
     %	From (a*b) and b, retrieve a = e1+e3 :
     disp('>> a*b');
     a*b
     disp('>> b');
     b
     fprintf(1,'>> (a*b)/b     ');
     input('');
     (a*b)/b    %w
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 8 ) 
     GAps = '>>>> ';
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
     GAtext(0.5*r-0.1*unit(grade((random^r)/r,1)),'r = x \wedge a) / a'); %/ 
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 9 ) 
     GAps = '>>>> ';
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 10 ) 
     GAps = '>>>> ';
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 11 ) 
     GAps = '>>>> ';
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
     
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 12 ) 
     GAps = '>>>> ';
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
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 13 ) 
     GAps = '>>>> ';
     disp('>> %	HOMOGENEOUS REPRESENTATION');
     %	HOMOGENEOUS REPRESENTATION
     GAfigure; clc; %/
     disp('>> %	HOMOGENEOUS REPRESENTATION');
     %	HOMOGENEOUS REPRESENTATION
     disp('>> %');
     %
     disp('>> % 	For 2-space representation of (e1,e2) plane,');
     % 	For 2-space representation of (e1,e2) plane,
     disp('>> %  	add 1 more dimension e.');
     %  	add 1 more dimension e.
     global e p P q Q plane u d M; %/
     clf; %/
     e=e3; %/
     size = 1; %/
     va = [-size size -size size 0 2]; %/
     plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
     disp('>> e = e3; ');
     e = e3; 
     I2 = e1^e2; %/
     draw(e,'k') %/
     GAview([120 5]); %/
     GAtext(e/2-0.1*e2,'e'); %/
     GAtext(1.1*e,'0','k'); %/
     axis off; %/
     DrawPolygon(plane,'w'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % A (weighted) point may be represented by a vector.');
     % A (weighted) point may be represented by a vector.
     disp('>> p = e1/3+e2/2;');
     p = e1/3+e2/2;
     draw(p,'b'); %/
     GAtext(0.5*p+0.1*e,'p','b'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> P = e+p;             ');
     P = e+p;             
     DrawHomogeneous(e,P,'b','r'); %/
     GAtext(0.5*P + 0.1*unit(p),'P','b'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	We might as well denote label at the point in 2-space.');
     % 	We might as well denote label at the point in 2-space.
     GAtext(1.1*P,'P','r'); %/
     GAprompt; %/
     disp('>> % 	Tilting for a better view.');
     % 	Tilting for a better view.
     GAtilt(10,5); %/
     GAprompt; %/
     clf; %/
     e=e3; %/
     size = 1; %/
     plane = {e+size*(e1+e2),e+size*(e1-e2),e+size*(-e1-e2),e+size*(-e1+e2)}; %/
     draw(e,'k'); %/
     GAtext(1.1*e,'0'); %/
     axis off; %/
     GAview([120 15]); %/
     disp('>> p = e1/4+e2/2;');
     p = e1/4+e2/2;
     disp('>> q = 2*e2/3-e1/2;');
     q = 2*e2/3-e1/2;
     disp('>> P = e+p;');
     P = e+p;
     disp('>> Q = e+q;');
     Q = e+q;
     DrawPolygon(plane,'w'); %/
     DrawHomogeneous(e,P,'b','r'); %/
     GAtext(1.1*P,'P','r'); %/
     DrawHomogeneous(e,Q,'g','r'); %/
     GAtext(1.1*Q,'Q','r'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> % 	The bivector formed by P and Q can be used');
     % 	The bivector formed by P and Q can be used
     disp('>> % 	to represent the line element from P to Q.');
     % 	to represent the line element from P to Q.
     fprintf(1,'>> P^Q  ');
     input('');
     P^Q %w
     DrawBivector(P,Q,'y'); %/
     GAtext(0.25*(P+Q)-0.1*unit((P^Q)/I3),'P \wedge Q'); %/
     DrawSimplex({P,Q},'n','r'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The bivector can be reshaped to P^(Q-P):');
     %	The bivector can be reshaped to P^(Q-P):
     DrawBivector(P,Q-P,'g'); %/
     draw(Q-P,'r'); %/
     GAtext((Q-P)/2-0.1*e,'Q-P','r'); %/
     axis(va); %/
     title('P \wedge Q = P \wedge (Q-P)','Color','r'); %/
     disp('>> %	A line element: characterized by 2 points, ');
     %	A line element: characterized by 2 points, 
     disp('>> %	or by point and direction.');
     %	or by point and direction.
     GAprompt; %/
     GAtilt(-20,5); %/
     GAtilt(20,7.5); %/
     disp('>> %	The projective split of the bivector');
     %	The projective split of the bivector
     disp('>> %	retrieves the line parameters.');
     %	retrieves the line parameters.
     disp('>> %');
     %
     disp('>> %	The tangent vector:');
     %	The tangent vector:
     GAprompt; %/
     disp('>> PQ = P^Q');
     PQ = P^Q
     fprintf(1,'>> u = inner(e,PQ)     ');
     input('');
     u = inner(e,PQ)    %w
     DrawBivector(e,u,'m'); %/
     perp = grade((e^u)/norm(e^u)/I3,1); %/
     GAtext( (e+u)/2 + 0.1*perp,'e \wedge u'); %/
     DrawSimplex({e,e+u},'n','m'); %/
     GAtext( u/2+1.05*e+0.05*perp,'u'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The moment:');
     %	The moment:
     fprintf(1,'>> M = inner(e,e^PQ)     ');
     input('');
     M = inner(e,e^PQ)    %w
     d = M/u;  %/
     DrawBivector(d,u,'m'); %/
     GAtext( (d+u)/2 + 0.05*grade((d^u)/norm(d^u)/I3,1),'M'); %/
     axis(va); %/
     GAprompt; %/
     disp('>> %	The perpendicular support vector:');
     %	The perpendicular support vector:
     fprintf(1,'>> d = M/u     ');
     input('');
     d = M/u    %w
     DrawSimplex({e,e+d},'n','m'); %/
     GAtext( d/2+1.05*e+0.05*unit(u),'d'); %/
     axis(va); %/
     GAprompt; %/
     GAtilt(70,5); %/
     disp('>> ');
     
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 14 ) 
     GAps = '>>>> ';
     disp('>> % 	INTERSECTION OF SUBSPACES');
     % 	INTERSECTION OF SUBSPACES
     GAfigure; clc; %/
     disp('>> % 	INTERSECTION OF SUBSPACES');
     % 	INTERSECTION OF SUBSPACES
     disp('>> %');
     %
     global e P Q R S PQ RS M MM; %/
     e = e3;         %/
     size = 1; 	%/
     IP = {e+size*(-e1-e2),e+size*(-e1+e2),e+size*(e1+e2),e+size*(e1-e2)}; %/
     disp('>>      % LINE INTERSECTION AS MEET OF BIVECTORS');
          % LINE INTERSECTION AS MEET OF BIVECTORS
          clf; %/
     disp('>> % extra dimension of the homogeneous embedding');
     % extra dimension of the homogeneous embedding
     disp('>>      e = e3;            ');
          e = e3;            
          draw(e,'k'); %/
          GAview([30 15]); %/
     	axis off; %/
          DrawPolygon(IP,'w'); %/
     disp('>> % points P,Q,R,S');
     % points P,Q,R,S
     disp('>>      P = e- e1/3+0.9*e2;    ');
          P = e- e1/3+0.9*e2;    
          DrawHomogeneous(e,P,'n','b'); GAtext(1.07*P,'P'); %/
     disp('>>      Q = e+ 0.9*e1+e2/2;    ');
          Q = e+ 0.9*e1+e2/2;    
          DrawHomogeneous(e,Q,'n','b'); GAtext(1.07*Q,'Q'); %/
     disp('>>      R = e- e1/2-e2/4;  ');
          R = e- e1/2-e2/4;  
          DrawHomogeneous(e,R,'n','b'); GAtext(1.07*R,'R'); %/
     disp('>>      S = e+ 0.9*(e1+e2);');
          S = e+ 0.9*(e1+e2);
          DrawHomogeneous(e,S,'n','b'); GAtext(1.07*S,'S'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
     disp('>> % lines');
     % lines
     disp('>>      PQ = join(P,Q);  ');
          PQ = join(P,Q);  
          %% DrawHomogeneous(e,PQ,'n','c'); %/
     GAprompt;
          DrawSimplex({P,Q},'n','c'); %/
          draw(PQ,'c'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
     disp('>>      RS = join(R,S);  ');
          RS = join(R,S);  
          %% DrawHomogeneous(e,RS,'n','g'); %/
     GAprompt;
          DrawSimplex({R,S},'n','g'); %/
          draw(RS,'g'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
          GAprompt; %/
     disp('>> % intersection of those lines');
     % intersection of those lines
     disp('>>      MM = meet(PQ,RS)       ');
          MM = meet(PQ,RS)       
          DrawHomogeneous(e,MM,'n','m'); %/
     	draw(MM,'m'); %/
     disp('>>      M = MM/inner(e,MM); ');
          M = MM/inner(e,MM); 
          DrawHomogeneous(e,M,'n','m'); GAtext(1.07*M,'M'); %/
          axis([-size size -size size (-2*size+1.2) 1.2]); %/
          GAprompt; %/
          GAtilt(-20,5); %/
          GAtilt(40,10); %/
     disp(' ');     disp('End of GAD sequence.  Returning to Matlab.');
elseif ( GAn == 15 ) 
     GAps = '>>>> ';
     disp('>> %	PAPPUS'' THEOREM');
     %	PAPPUS' THEOREM
     GAfigure; clc; %/
     disp('>> %	PAPPUS'' THEOREM');
     %	PAPPUS' THEOREM
     disp('>> %');
     %
     disp('>> % 	We use Pappus merely as an example doing geometry.');
     % 	We use Pappus merely as an example doing geometry.
     disp('>> %');
     %
     disp('>> %	Pappus'' theorem (actually from projective geometry):');
     %	Pappus' theorem (actually from projective geometry):
     disp('>> %	-- Specify two pairs of collinear points');
     %	-- Specify two pairs of collinear points
     disp('>> % 	-- Cross-connect the points and intersect corresponding lines.');
     % 	-- Cross-connect the points and intersect corresponding lines.
     disp('>> % 	-> The result is three collinear points.');
     % 	-> The result is three collinear points.
     disp('>> %');
     %
     disp('>> % Two points and a factor to determine collinear point:');
     % Two points and a factor to determine collinear point:
     global P1 P2 P3 Q1 Q2 Q3 H1 H2 H3 A1 A2 A3; %/
     clf;	%/
     e = e3;	%/
     P1 = e - e1; %/
     P2 = e  + e2/4; %/
     mu = 1.5; %/
     P3 = (1-mu)*P1 + mu*P2; %/
     Q1 = e - 3*e1/4 -e2; %/
     Q2 = e + e1/6 - 1.1*e2; %/
     nu = 1.5; %/
     Q3 = (1-nu)*Q1 + nu*Q2; %/
     maxx = max([inner(e1,P1),inner(e1,P2),inner(e1,P3), inner(e1,Q1),inner(e1,Q2),inner(e1,Q3)]); %/
     minx = min([inner(e1,P1),inner(e1,P2),inner(e1,P3), inner(e1,Q1),inner(e1,Q2),inner(e1,Q3)]); %/
     maxy = max([inner(e2,P1),inner(e2,P2),inner(e2,P3), inner(e2,Q1),inner(e2,Q2),inner(e2,Q3)]); %/
     miny = min([inner(e2,P1),inner(e2,P2),inner(e2,P3), inner(e2,Q1),inner(e2,Q2),inner(e2,Q3)]); %/
     disp('>> ');
     
     GAmouse = 1; %/
     disp('>> % 	First line');
     % 	First line
     DrawHomogeneous(e,P1,'n','r'); GAtext(1.1*P1,'P_1','r'); %/
     DrawHomogeneous(e,P2,'n','r'); GAtext(1.1*P2,'P_2','r'); %/
     DrawHomogeneous(e,P3,'n','r'); GAtext(1.1*P3,'P_3','r'); %/
     DrawPolyline({P1,P2,P3},'r'); %/
     axis off; %/
     GAview([0 90]); %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: second line');
     % 	Next: second line
     GAprompt; %/
     DrawHomogeneous(e,Q1,'n','m'); GAtext(1.1*Q1,'Q_1','m'); %/
     DrawHomogeneous(e,Q2,'n','m'); GAtext(1.1*Q2,'Q_2','m'); %/
     DrawHomogeneous(e,Q3,'n','m'); GAtext(1.1*Q3,'Q_3','m'); %/
     DrawPolyline({Q1,Q2,Q3},'m'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: intersect the connection lines');
     % 	Next: intersect the connection lines
     GAprompt; %/
     DrawPolyline({P1,Q2},'k'); %/
     DrawPolyline({P2,Q1},'k'); %/
     disp('>> H1 = meet(join(P1,Q2),join(P2,Q1));');
     H1 = meet(join(P1,Q2),join(P2,Q1));
     disp('>> A1 = H1/inner(H1,e3);');
     A1 = H1/inner(H1,e3);
     DrawHomogeneous(e3,A1,'n','g'); GAtext(1.1*A1,'A_1','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({P3,Q2},'k'); %/
     DrawPolyline({P2,Q3},'k'); %/
     H2 = meet(join(P2,Q3),join(P3,Q2)); %/
     A2 = H2/inner(H2,e3); %/
     DrawHomogeneous(e3,A2,'n','g'); GAtext(1.1*A2,'A_2','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({P1,Q3},'k'); %/
     DrawPolyline({P3,Q1},'k'); %/
     H3 = meet(join(P1,Q3),join(P3,Q1)); %/
     A3 = H3/inner(H3,e3); %/
     DrawHomogeneous(e3,A3,'n','g'); GAtext(1.1*A3,'A_3','b'); %/
     axis([minx maxx miny maxy 0 1]);  %/
     GAprompt; %/
     DrawPolyline({A1,A2},'b') %/
     axis([minx maxx miny maxy 0 1]);  %/
     disp('>> % 	Next: check whether A1, A2, A3 are on a line:');
     % 	Next: check whether A1, A2, A3 are on a line:
     GAprompt; %/
     error = grade( A1^A2^A3/I3, 0); %/
     title(['A_1 \wedge A_2 \wedge A_3 = ' num2str(error) ' * I_3'],'Color','b'); %/
     GAmouse =0; %/
     disp(' ');
     disp('End of GAD sequence.  Returning to Matlab.');
end
catch ; end
