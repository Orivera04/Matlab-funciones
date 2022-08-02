     clf; %/
     disp('>> % |  DIFFERENTIATION OF INVERSE OPERATION');
     % |  DIFFERENTIATION OF INVERSE OPERATION
     disp('>> % |');
     % |
     x = 1.2*(e1+e2/3); %/
     b = 0.1* unit(2*e2+e3); %/
     draw(x,'b'); GAtext(1.05*x,'x','b'); %/
     axis off; %/
     axis([ 0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    x = vector to invert');
     % |    x = vector to invert
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     ix = inverse(x); %/
     draw(ix,'r'); GAtext(1.05*ix,'x^{-1}','r'); %/
     axis([ 0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    inverse vector 1/x');
     % |    inverse vector 1/x
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     draw(b,'k'); GAtext(1.1*b,'b','k'); %/
     draw(x+b,'m'); GAtext(1.05*(x+b),'x+b','m'); %/
     DrawPolyline({x,x+b,x/1000},'m'); %/
     axis([ 0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    change x to x+b');
     % |    change x to x+b
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     xbi = inverse(x+b); %/
     DrawPolygon({ix,xbi,ix/1000},'y'); %/
     draw(xbi,'r'); GAtext(xbi+(b^x)/x,'(x+b)^{-1}','r'); %/
     axis([ 0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    change in inverse');
     % |    change in inverse
     disp('>> % | ');
     % | 
     waitforbuttonpress; %/
     dix = -ix*b/x;  %/
     draw(dix,'r'); GAtext(1.1*dix,'-x^{-1}b x^{-1}','r'); %/
     title('(x+b)^{-1} \approx x^{-1} - x^{-1}b x^{-1}'); %/
     DrawPolygon({ix,ix+dix,ix/1000},'w'); %/
     axis([ 0 1.2 0 0.5 0 0.1]); %/
     disp('>> % |    differentiation gives first order of this change');
     % |    differentiation gives first order of this change
     disp('>> % |');
     % |
     disp('>> % |  END OF DEMO');
     % |  END OF DEMO
     disp('>> ');
     
