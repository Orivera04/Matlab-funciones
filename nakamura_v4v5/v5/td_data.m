% function td_data prepares demonstration input
% data for List 2.23. Copyright S. Nakamura 1995
function [x,y,f] = td_data
ni= 10; nj=20;
%if 2==3
  for j=1:nj
    for i=1:ni
      r = 3 + (5+j)*0.05*(i-1) ;
      th = j*pi/10;
      x(i,j) = r*cos(th) ;
      y(i,j) = r*sin(th);
    end
  end
  f=zeros(ni,nj);
  for j=2:nj-1
    f(ni,j)=sin(0.5*j);
  end
  for it = 1:20
    for i=2:ni-1
      f(i,nj) = f(i,nj-1);
      f(i,1) = f(i,2);
    end
    f(ni,nj) = 0.5*(f(ni-1,nj) + f(ni,nj-1));
    f(ni,1) = 0.5*(f(ni,2) + f(ni-1,1));
    for i=2:ni-1
      for j=2:nj-1
       f(i,j) = 0.375*(f(i-1,j) + f(i+1,j) + f(i,j-1) + f(i,j+1))   ...
             - 0.5* f(i,j) ;
      end
    end
  end
%end
