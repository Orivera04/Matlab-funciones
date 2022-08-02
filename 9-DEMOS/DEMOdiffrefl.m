     disp('>> % | DIFFERENTIAL PROPERTIES OF REFLECTION ');
     % | DIFFERENTIAL PROPERTIES OF REFLECTION 
     clf; 				%/
     a = 1.5*(e1+e2); %/
     x = e1; %/
     b = 0.05* unit(2*e2+e3); %/
     draw(a,'m'); GAtext(1.05*a,'a','m');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     axis off;	%/
     disp('>> % |');
     % |
     disp('>> % |    a = vector to be reflected');
     % |    a = vector to be reflected
     waitforbuttonpress; %/
     disp('>> % |');
     % |
     draw(x,'b'); GAtext(1.05*x,'x','b');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     disp('>> % |    x = vector to reflect in');
     % |    x = vector to reflect in
     disp('>> % |');
     % |
     waitforbuttonpress; %/
     ix = inverse(x);	%/
     p = x*a/x;	%/
     DrawPolygon({a,p,p/1000},'y');	%/
     draw(p,'r'); GAtext(1.05*p,'x a x^{-1}','r');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     disp('>> % |    the reflection of a in x');
     % |    the reflection of a in x
     disp('>> % |');
     % |
     waitforbuttonpress; %/
     pb= (b+x)*a/(b+x);	%/
     draw(x+b,'b'); GAtext(1.05*(x+b),'x+b','b');	%/
     DrawPolyline({x,x+b},'k');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     disp('>> % |    b = change of x');
     % |    b = change of x
     disp('>> % |');
     % |
     waitforbuttonpress; %/
     draw(pb,'r'); GAtext(1.05*pb,'(x+b) a (x+b)^{-1}','r');	%/
     DrawPolygon({p,pb,a},'g');	%/
     DrawPolygon({x,x+b,x/1000},'c');	%/
     DrawPolyline({x,(a+p)/2,(a+pb)/2,x+b},'b');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     disp('>> % |    reflection of a in x+b');
     % |    reflection of a in x+b
     disp('>> % |');
     % |
     waitforbuttonpress; %/
     id = inner(a,ix^b);	%/
     draw(id,'b'); GAtext(1.05*id,'a \bullet (x^{-1} \wedge b) ','b');	%/
     d = -2*x*inner(a,ix^b)/x;	%/
     DrawPolygon({d+p,p,d/1000},'w');	%/
     axis([-0.1 1.7 -1.5 1.5 -0.1 0.2]); %/
     title('(x+b) a (x+b)^{-1} \approx x a x^{-1} - 2 x (a \bullet (x^{-1}\wedge b)) x^{-1}');	%/
     disp('>> % |    the derivative approximates the change due to b');
     % |    the derivative approximates the change due to b
     disp('>> % |');
     % |
     disp('>> % | END OF DEMO');
     % | END OF DEMO
