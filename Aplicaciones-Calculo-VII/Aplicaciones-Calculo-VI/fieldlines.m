function fieldlines(X,Y,U,V,x0,y0)

% fieldlines(X,Y,U,V,x0,y0) plots a field line 
% with the initial point P(x0,y0).
%
% The matrices X,Y,U,V must all be the same size
% and contain corresponding position and field components.
%
% The function employs the 4th order Runge-Kutta method
% for solving numerically differential equation y'=f(x,y) if |y'| <= 1,
% or x'=g(y,x) if |y'| > 1, where  f(x,y)=V./U  and g(y,x)=U./V  .
%
% Example:
%       [x,y] = meshgrid(-2:.2:2,-1:.15:1);
%       z = x .* exp(-x.^2 - y.^2); [px,py] = gradient(z,.2,.15);
%       quiver(x,y,px,py), axis image, hold on
%       fieldlines(x,y,px,py,-0.7,0.2)
%
% Copyright (c) 2004, Version 1.00
% Avni Pllana <avniu66@hotmail.com>

Xj=X(1,1:end);
xm=min(Xj);
xM=max(Xj);
hx=Xj(2)-Xj(1);
hxx=hx/10;

if(x0<xm)
   x0=xm;
elseif(x0>xM)
   x0=xM;
end

Yi=Y(1:end,1)';
ym=min(Yi);
yM=max(Yi);
hy=Yi(2)-Yi(1);
hyy=hy/10;

if(y0<ym)
   y0=ym;
elseif(y0>yM)
   y0=yM;
end

xn=x0;
yn=y0;
Xn(1)=x0;
Yn(1)=y0;
Fu_old=0;
Fv_old=0;
r=0;
k=0;
n=1;
c=[0,1/2,1/2,1];
K=[0 0 0 0];

while(1)
   
   xx=xn;
   yy=yn;
           
   J1=find(Xj<=xx);
   j=length(J1);
                 
   I1=find(Yi<=yy);
   i=length(I1);
      
   a=(xx-Xj(j))/hx;
   b=(yy-Yi(i))/hy;
   
   a1=(1-a)*(1-b);
   a2=a*(1-b);
   a3=(1-a)*b;
   a4=a*b;
   
   Fv=a1*V(i,j)+a2*V(i,j+1)+a3*V(i+1,j)+a4*V(i+1,j+1);
   Fu=a1*U(i,j)+a2*U(i,j+1)+a3*U(i+1,j)+a4*U(i+1,j+1);
   
   if([Fu Fv]*[Fu_old ; Fv_old] < 0)
      Xn(n)=[];
      Yn(n)=[];
      break
   end
   Fu_old=Fu;
   Fv_old=Fv;
   
   if Fu==0
      Fu=eps;
   end
   if(abs(Fv/Fu)<=1)
      dir = 1;
      h=hxx*sign(Fu);
   else
      dir = 0;
      h=hyy*sign(Fv);
   end

   if(dir == 1)
   
      for l=1:4
      
         xx=xn+c(l)*h;
         yy=yn+c(l)*k;
      
         if((xx>xM)|(xx<xm))
            r=1;
            break
         end

         J1=find(Xj<=xx);
         j=length(J1);
      
         if((yy>yM)|(yy<ym))
            r=1;   
            break
         end
      
         I1=find(Yi<=yy);
         i=length(I1);
      
         a=(xx-Xj(j))/hx;
         b=(yy-Yi(i))/hy;
   
         a1=(1-a)*(1-b);
         a2=a*(1-b);
         a3=(1-a)*b;
         a4=a*b;
         
         Fv=a1*V(i,j)+a2*V(i,j+1)+a3*V(i+1,j)+a4*V(i+1,j+1);
         Fu=a1*U(i,j)+a2*U(i,j+1)+a3*U(i+1,j)+a4*U(i+1,j+1);
         if Fu==0
            Fu=eps;
         end
         
         K(l)=h*Fv/Fu;
         k=K(l);
         
      end
      
      if(r==1)
         break
      end
   
      n=n+1;
      xn=xn+h;
      Xn(n)=xn;
      yn=yn+1/6*(K(1)+2*K(2)+2*K(3)+K(4));
      Yn(n)=yn;

   else
   
      for l=1:4
      
         xx=xn+c(l)*k;
         yy=yn+c(l)*h;
      
         if((xx>xM)|(xx<xm))
            r=1;
            break
         end

         J1=find(Xj<=xx);
         j=length(J1);
      
         if((yy>yM)|(yy<ym))
            r=1;   
            break
         end
      
         I1=find(Yi<=yy);
         i=length(I1);
      
         a=(xx-Xj(j))/hx;
         b=(yy-Yi(i))/hy;
   
         a1=(1-a)*(1-b);
         a2=a*(1-b);
         a3=(1-a)*b;
         a4=a*b;
         
         Fv=a1*V(i,j)+a2*V(i,j+1)+a3*V(i+1,j)+a4*V(i+1,j+1);
         Fu=a1*U(i,j)+a2*U(i,j+1)+a3*U(i+1,j)+a4*U(i+1,j+1);
         if Fv==0
            Fv=eps;
         end
         
         K(l)=h*Fu/Fv;
         k=K(l);
         
      end
      
      if(r==1)
         break
      end
   
      n=n+1;
      xn=xn+1/6*(K(1)+2*K(2)+2*K(3)+K(4));
      Xn(n)=xn;
      yn=yn+h;
      Yn(n)=yn;
      
   end
  
   if(r==1)
      break
   end
   
   if(((Xn(n)-Xn(2))^2+(Yn(n)-Yn(2))^2)^0.5 <= abs(h) & n>10 )
      break
   end
            
end

plot(Xn,Yn,'r')
grid on
hold on
