     clf; %/
     disp('>> % |  DIFFERENTIATION OF VECTOR UNIT NORMALIZATION OPERATION');
     % |  DIFFERENTIATION OF VECTOR UNIT NORMALIZATION OPERATION
     disp('>> % |');
     % |
     x = 1.2*(e1+e2/3); %/
     b = 0.1* unit(2*e2+e3); %/
     draw(x,'b'); GAtext(1.05*x,'x','b'); %/
     axis off; %/
     axis([0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    x = vector to normalize');
     % |    x = vector to normalize
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     ux = unit(x); %/
     draw(ux,'r'); GAtext(1.05*ux,'x/|x|','r'); %/
     axis([0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    normalized vector x/|x|');
     % |    normalized vector x/|x|
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     draw(b,'k'); GAtext(1.1*b,'b','k'); %/
     draw(x+b,'m'); GAtext(1.05*(x+b),'x+b','m'); %/
     DrawPolyline({x,x+b,x/1000},'m'); %/
     axis([0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    change x to x+b');
     % |    change x to x+b
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     xbn = (x+b)/norm(x+b); %/
     DrawPolygon({ux,xbn,ux/1000},'y'); %/
     draw(xbn,'r'); GAtext(xbn+(b^x)/x,'(x+b)/|x+b|','r'); %/
     axis([0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    change in normalization');
     % |    change in normalization
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     nx = norm(x); %/
     dux = (b^x)/x/nx; %/
     draw(dux,'r'); GAtext(1.1*dux,'(b \wedge x^{-1})x/|x|','r'); %/
     title('(x+b)/|x+b| \approx x/|x| + (b \wedge x^{-1})x/|x|'); %/
     DrawPolygon({ux,ux+dux,ux/1000},'w'); %/
     axis([0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    differentiation is first order of this change');
     % |    differentiation is first order of this change
     disp('>> % |');
     % |
     disp('>> % |  END OF DEMO');
     % |  END OF DEMO
     disp('>> ');
     
