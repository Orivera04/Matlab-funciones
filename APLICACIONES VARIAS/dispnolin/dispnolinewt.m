function [Y]=dispnolinewt(fnew,fy,fyp,a,b,alfa,beta,n,tol,maxiter)

%[Y]=dispnoliewt('fnew','fy','fyp',a,b,alfa,beta,n,tol,maxiter)
%Editar fy e fyp
%fy = derivada de f respecto de y
%fyp = derivada de f respecto de y'
%a=1;b=3;alfa=17;beta=43/3;n=20;tol=1e-5;maxiter=20;


h=(b-a)/n;
k=1;
tk(1)=(beta-alfa)/(b-a);
incr=1;									%inicializacion del contador de error

while (k<=maxiter)&(incr>=tol)   
   y1(1)=alfa;
   y2(1)=tk;
   z1=0;
   z2=1;      
   for i=1:n
      x=a+(i-1).*h;
      k11=h.*y2(i);
      k12=h.*feval(fnew,x,y1(i),y2(i));
      k21=h.*(y2(i)+(1/2).*k12);
      k22=h.*feval(fnew,(x+h/2),(y1(i)+(1/2).*k11),(y2(i)+(1/2).*k12));
      k31=h.*(y2(i)+(1/2).*k22);
      k32=h.*feval(fnew,(x+h/2),(y1(i)+(1/2).*k21),(y2(i)+(1/2).*k22));
      k41=h.*(y2(i)+k32);
      k42=h.*feval(fnew,(x+h),(y1(i)+k31),(y2(i)+k32));
      y1(i+1)=y1(i)+(1/6).*(k11+2.*k21+2.*k31+k41);
      y2(i+1)=y2(i)+(1/6).*(k12+2.*k22+2.*k32+k42);
            
      kp11=h.*z2;
      kp12=h.*((feval(fy,x,y1(i),y2(i)).*z1)+(feval(fyp,x,y1(i),y2(i)).*z2));
      kp21=h.*(z2+(1/2).*kp12);
      kp22=h.*(feval(fy,(x+h/2),y1(i),y2(i)).*(z1+0.5.*kp11)+(feval(fyp,(x+h/2),y1(i),y2(i)).*(z2+0.5.*kp12)));    %En el libro pone que la ultima es kp21
      kp31=h.*(z2+(1/2).*kp22);
      kp32=h.*(feval(fy,(x+h/2),y1(i),y2(i)).*(z1+0.5.*kp21)+(feval(fyp,(x+h/2),y1(i),y2(i)).*(z2+0.5.*kp22)));
      kp41=h.*(z2+kp32);
      kp42=h.*(feval(fy,(x+h),y1(i),y2(i)).*(z1+kp31)+(feval(fyp,(x+h),y1(i),y2(i)).*(z2+kp32)));
      z1=z1+((1/6).*(kp11+2.*kp21+2.*kp31+kp41));
      z2=z2+((1/6).*(kp12+2.*kp22+2.*kp32+kp42));                       
   end
   z1
   incr=abs(y1(n+1)-beta);						 
   tk=tk-(y1(n+1)-beta)./z1;
   k=k+1;
end

if(incr>tol)
   disp('Numero maximo de iteraciones excedido');
else
   for j=1:(n+1)
      x=a+(j-1)*h;
      Y(j,1)=x;									%Puntos x(j) donde se ha evaluado la solucion
      Y(j,2)=y1(j);								%Solucion de fnewt en los puntos x(j)
      Y(j,3)=y2(j);								%Derivada de la solucion en los puntos x(j)
   end
end
k
   
         
   
   