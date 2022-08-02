function [z,nerrup] = errup(m,k,ord_ind,z,h,...
          h0,h00,vmax,scal,index1,index2,L,U,P,Q)
      
%z is modified
if(ord_ind==1)
      cp  = 2d0/(k)*h/(h+h0);
      dbk = (k+1);
      dh  = (h/h0)^dbk;
      z(:,2) = cp *( z(:,1) - z(:,k+1)*dh );
else
      dbk = (k+1);
      dh  = (h/h0)^dbk;
      dh0 = (h/h00)^dbk;
      cp0 = h0+h00;
      cp2 = h+h0;
      cp1 = cp0+cp2;
      cp = cp0*cp1*cp2*(k*k);
      cp = 8d0*h^2d0/cp;
      z(:,2)= cp *(  cp0*z(:,1)- cp1*z(:,k+1)*dh +...
                        cp2*z(:,k+2)*dh0 );
end
z(:,2) = sollu(L,U,P,Q,z(:,2));

z(1:index1+index2,2)=vmax(1)*z(1:index1+index2,2);
z(index1+index2+1:m,2)=vmax(2)*z(index1+index2+1:m,2);


[nerrup,dh] = norm1(m,1,scal,z(:,2));
