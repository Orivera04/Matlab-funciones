function s=galag(func,n)
% Implements Gauss-Laguerre integration.
%
% Example call: s=galag(func,n)
% Integrates user defined function func from 0 to inf, using n divisions
% n must be 2 or 4 or 8.
%
if (n==2)|(n==4)|(n==8)
  c=zeros(8,3); t=zeros(8,3);
  c(1:2,1)=[1.533326033; 4.450957335];
  c(1:4,2)=[.8327391238; 2.048102438; 3.631146305; 6.487145084];
  c(:,3)  =[.4377234105; 1.033869347; 1.669709765; 2.376924702;...
            3.208540913; 4.268575510; 5.818083368; 8.906226215];  
  t(1:2,1)=[.5857864376; 3.414213562];
  t(1:4,2)=[.3225476896; 1.745761101; 4.536620297; 9.395070912];
  t(:,3)  =[.1702796323; .9037017768; 2.251086630; 4.266700170;...
            7.045905402; 10.75851601; 15.74067864; 22.86313174];
  j=1;
  while j<=3
    if 2^j==n;break;
    else
      j=j+1;
    end
  end
  s=0;
  for k=1:n
    x=t(k,j); y=feval(func,x);
    s=s+c(k,j)*y;
  end
else
  disp('n must be 2, 4 or 8');break
end
