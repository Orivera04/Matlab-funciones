function z=integr(y,maxhiba,method,fx_y,xa,xf,pvektor)
% © Jeney Andras 1998; program az Integralok kiszamitasa reszhez

  n=length(y);
  tol=xa;
  ig=xf;
  for i=1:n
    if ischar(xa)       % ha nem konstans az also hatar:
      tol=feval(xa,y(i),pvektor);
    end
    if ischar(xf)       % ha nem konstans a felso hatar:
      ig=feval(xf,y(i),pvektor);
    end
    if isempty(method)  % a quad-ot akarjuk?
      z(i)=quad(fx_y,tol,ig,maxhiba,[],y(i));
    else                % vagy mast akarunk, mint a quad?
      z(i)=feval(method,fx_y,tol,ig,maxhiba,[],y(i));
    end
  end