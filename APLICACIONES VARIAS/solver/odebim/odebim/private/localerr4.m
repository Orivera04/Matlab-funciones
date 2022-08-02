function [z,nerr,nerrup,nlinsys] = localerr4(m,f0,f,h,scal,...
          nlinsys,vmax,imas,m0,k,ord_ind,index1,index2,L,U,P,Q)
z(:,1) = truncam(m,f0,f,h,ord_ind);
z(:,2) = z(:,1);
z(:,2) = sollu(L,U,P,Q,z(:,2));
if((imas+1)==1)
%     ode case
	z(:,3)=z(:,1)-z(:,2);
    z(:,3) = sollu(L,U,P,Q,z(:,3));
    z(:,2)=vmax(1)*z(:,2);
    z(:,3)=vmax(2)*z(:,3);
    [nerr,nerrup] = norm1(m,2,scal,z(:,2:3));
    nlinsys = nlinsys + 2;
else
%     dae case
    z(:,3) = m0*z(:,2);
    z(:,3)=z(:,1)-z(:,3);
    z(:,3) = sollu(L,U,P,Q,z(:,3));
    z(1:index1,2)=vmax(1)*z(1:index1,2);
    z(1:index1,3)=vmax(2)*z(1:index1,3);
    z(index1+1:index1+index2,2) = vmax(2)*z(index1+1:index1+index2,2);
    z(index1+1:index1+index2,3) = vmax(2)*z(index1+1:index1+index2,3);
    
    z(index1+index2+1:m,2) = vmax(3)*z(index1+index2+1:m,2);
    z(index1+index2+1:m,3) = vmax(3)*z(index1+index2+1:m,3)/2;
    [nerr,nerrup] = norm1(m,2,scal,z(:,2:3));
    nlinsys = nlinsys + 2;
end