%%NAME
%%  efillmat  - fill matrix with interpolated values by given xyz-samples
%%
%%SYNOPSIS
%%  matrix=efillmat(xData,yData,zData,dx,dx)
%%
%%PARAMETER(S)
%%  xData       vector of x-coordinates
%%  yData       vector of y-coordinates
%%  zData       vector of z-values
%%  dx          pixel distance of x-direction 
%%  dy          pixel distance of y-direction 
%%  matrix      interpolated matrix 
%% 
% written by stefan.mueller@fgan.de (C) 2007
function matrix= efillmat (xData,yData,zData,dx,dy)
  if (nargin ~= 5)
    eusage('matrix = efillmat(xData,yData,zData,dx,dy)');
  end
  minX=min(xData);
  maxX=max(xData);
  minY=min(yData);
  maxY=max(yData);
  cols=round((maxX-minX)/dx);
  rows=round((maxY-minY)/dy);
  dx=(maxX-minX)/cols;
  dy=(maxY-minY)/rows;
  cols=cols+1;
  rows=rows+1;
  matrix=ones(rows*cols,1)*NaN;
  x=round((xData-minX)/dx);
  y=round((maxY-yData)/dy);
  matrix(x*rows+y+1)=zData;
  matrix=reshape(matrix,rows,cols);
  smat=~isnan(matrix);
  xr=sum(smat)/cols;
  yr=sum(smat')/rows;
  [sv sp]=sort([xr yr]);
  for i=fliplr(sp)
    if i>cols 
      j=i-cols;
      svec=~isnan(matrix(j,:));
      x=find(svec);
      n=length(x);
      if n<cols
        xi=find(~svec);
        x0=1;z0=matrix(j,x(1)); 
        xn=cols;zn=matrix(j,x(n)); 
        matrix(j,xi)=elineip([x0 x xn],[z0 matrix(j,x) zn],xi); 
      end
    else
      svec=~isnan(matrix(:,i));
      x=find(svec);
      n=length(x);
      if n<rows
        xi=find(~svec);
        x0=0;z0=matrix(x(1),i); 
        xn=rows+1;zn=matrix(x(n),i); 
        matrix(xi,i)=elineip([x0 x' xn],[z0 matrix(x,i)' zn],xi')'; 
      end
    end
  end
