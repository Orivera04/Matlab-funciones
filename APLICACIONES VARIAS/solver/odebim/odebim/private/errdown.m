function [z,nerrdown,nlinsys] = errdown(m,f0,f,h,scal,...
    nlinsys,vmax,qinf,k,ord_ind,index1,index2,L,U,P,Q)
z(:,1) = truncam(m,f0,f,h,ord_ind-1);

z(:,1) = sollu(L,U,P,Q,z(:,1));

if (qinf)
    vmaxl=vmax(2);
else
    vmaxl=vmax(1);
end

z(1:index1,1)=vmaxl*z(1:index1,1);
z(index1+1:index1+index2,1)=vmax(2)*z(index1+1:index1+index2,1);
z(index1+index2+1:m,1)=vmax(3)*z(index1+index2+1:m,1);

[nerrdown,vmaxl] = norm1(m,1,scal,z(:,1));
nlinsys = nlinsys + 1;
