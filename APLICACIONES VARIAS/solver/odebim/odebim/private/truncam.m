function [z] = truncam(m,f0,f,h,ord_ind)
psi4_1 = -1d0;
psi4_2 =  3d0;
psi6_1 =  1d0;
psi6_2 = -4d0;
psi6_3 =  6d0;
psi8_1 =  1d0;
psi8_2 = -6d0;
psi8_3 =  15d0;
psi8_4 = -20d0;
psi10_1 =  1d0;
psi10_2 = -8d0;
psi10_3 = 28d0;
psi10_4 =-56d0;
psi10_5 = 70d0;
psi12_1 =  1d0;
psi12_2 = -10d0;
psi12_3 =  45d0;
psi12_4 = -12d1;
psi12_5 =  21d1;
psi12_6 =-252d0;
z = zeros (m,1);
if(ord_ind==1)
      for i=1:m
           z(i)=h*(psi4_1*f0(i) +psi4_2*f(i,1)-...
                   psi4_2*f(i,2)-psi4_1*f(i,3));
      end
elseif(ord_ind==2)
      for i=1:m
           z(i)=h*(psi6_1*f0(i) +psi6_2*f(i,1)+...
                   psi6_3*f(i,2)+psi6_2*f(i,3)+...
                   psi6_1*f(i,4));
      end

elseif(ord_ind==3)
      for i=1:m
           z(i)=h*(psi8_1*f0(i) +psi8_2*f(i,1)+...
                   psi8_3*f(i,2)+psi8_4*f(i,3)+...
                   psi8_3*f(i,4)+psi8_2*f(i,5)+...
                   psi8_1*f(i,6));
      end

elseif(ord_ind==4)
      for i=1:m
           z(i)=h*(psi10_1*f0(i) +psi10_2*f(i,1)+...
                   psi10_3*f(i,2)+psi10_4*f(i,3)+...
                   psi10_5*f(i,4)+psi10_4*f(i,5)+...
                   psi10_3*f(i,6)+psi10_2*f(i,7)+...
                   psi10_1*f(i,8));
      end

elseif(ord_ind==5)
      for i=1:m
           z(i)=h*(psi12_1*f0(i) +psi12_2*f(i,1)+...
                   psi12_3*f(i,2)+psi12_4*f(i,3)+...
                   psi12_5*f(i,4)+psi12_6*f(i,5)+...
                   psi12_5*f(i,6)+psi12_4*f(i,7)+...
                   psi12_3*f(i,8)+psi12_2*f(i,9)+...
                   psi12_1*f(i,10));
      end
end