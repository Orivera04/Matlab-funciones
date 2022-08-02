function [x,res]=gaufile(AF,AM,b,me,ep,imax)
% Nagymeretu, n ismeretlenes Ax=b egyenletrendszer megoldasa
% LU-modszerrel, iterativ javitassal.
%
% © Jeney Andras 1998; program a Linearis algebra c. reszhez
%
%  Parameterek:
%  AF : az A egyutthatomatrix elemeit oszlopfolytonos
%       sorrendben tartalmazo file-nev (string)
%  AM : segedfile-nev, a permutalt A matrix LU-felbontasat
%       fogja tartalmazni a vegen (string)
%   b : az egyenletrendszer jobboldala
%  me : hany egyutthato fer be egyszerre a memoriaba,
%       me>=n (integer)
%  ep : a relativ modositas tureshatara (double)
%imax : az iteraciok maximalis szama (integer)
%   x : az egyenletrendszer megoldasa
% res : a rezidualis hiba (res=Ax-b)
%
% A program hivja a
%    solvtril es a solvtriu
% fuggvenyeket.
  n=length(b);
% A memoriaban egyszerre tarthato oszlopok szama: kc
  kc=floor(me/n);
  if kc>n, kc=n;
  elseif kc<1,
    disp('HIBA! Kotelezoen: me>=egyenletek szama'), return
  end
% Az A egyutthatomatrix particioinak szama: mc
  mc=floor(n/kc);
  if mc*kc>n
     mc=mc-1;
  elseif kc*mc<n
     mc=mc+1;
  end
  x=zeros(n,1); y=zeros(n,1);
% Az egyenletek permutaciojat mutato pointer vektor: p
  p=1:n;
  am=fopen(AM,'wb'); fclose(am);
  [af,hibajel]=fopen(AF,'rb');
  if af<0 disp('adatfile nyitasi HIBA az LU-felbontas elott!')
     uzenet=hibajel, return
  end
  l=0;
  n1=kc;
  jel=0;
  jels=0;
%Az LU-felbontas mc reszletben:
for k1=1:mc
   if k1==mc, n1=n-(mc-1)*kc; end
%Az egyutthatomatrix kovetkezo n1 db oszlopanak beolvasasa
%(n1=kc, ha nem az utolso particio, egyebkent a maradek):
  jel=jel+8*n*n1;
  A=fread(af,[n,n1],'double');
  if jel~=ftell(af)
    particio=k1, disp('adatolvasasi HIBA!')
    uzenet=ferror(af), return
  end
%Elmaradt eliminaciok potlasa
%(szukseg van az elozo, mar kesz oszlopokra):
  [am,hibajel]=fopen(AM,'rb');
  if am<0
    particio=k1, disp('segedfile nyitasi HIBA!')
    uzenet=hibajel, return
  end
  sjel=0;
  for k=1:l
    sjel=sjel+8*n;
    col=fread(am,n,'double');
    if sjel~=ftell(am)
      particio=k1, disp('segedolvasasi HIBA!')
      uzenet=ferror(am), return
    end
    for i=k+1:n
      r=col(p(i));
      A(p(i),1:n1)=A(p(i),1:n1)-r*A(p(k),1:n1);
    end;
  end
  fclose(am);
%A memoriaban levo oszlopok tovabbi eliminacioja:
  for k=1:n1
    [s,t]=max(abs(A(p(l+k:n),k)));
    if abs(s)<1e-50
      disp('Figyelem! Az egyutthatomatrix (majdnem)szingularis!')
    end
    t=l+t+k-1; if k<t, p([l+k,t])=p([t,l+k]); end;
    for i=l+k+1:n
      r=A(p(i),k)/A(p(l+k),k); A(p(i),k)=r;
      if k<n1
        A(p(i),k+1:n1)=A(p(i),k+1:n1)-r*A(p(l+k),k+1:n1);
      end;
    end;
  end;
%Elkeszult oszlopok felvitele az AM file-ba:
[am,hibajel]=fopen(AM,'ab');
  if am<0
    particio=k1, disp('segedfile nyitasi HIBA!')
    uzenet=hibajel, return
  end
  jels=jels+8*n*n1;
  as=fwrite(am,A,'double');q=ftell(am);
    if as~=n*n1|jels~=ftell(am)
      particio=k1, disp('segedirasi hiba HIBA!')
      uzenet=ferror(am), return
    end
  fclose(am);
  l=l+kc;
end
fclose(af); clear A;
%Befejezodott a permutalt A matrix LU-felbontasa.
%Mind az L, mind az U az AM file-ban van.
%A p mutatja a sorok permutaciojat, b1 jelolje a permutalt b-t.
%Az LUx=b1 megoldasa az eredeti Ax=b megoldasaval egyezik.
%Oldjuk meg elobb az Ly=b1 egyenletet, majd az Ux=y egyenletet!
  y=solvtril(AM,b,p,me);
  x=solvtriu(AM,y,p,me);
%A res=Ax-b rezidualis hiba:
    res=-b;
    n1=kc;
    l=0;
    [af,hibajel]=fopen(AF,'rb');
    if af<0 disp('adatfile nyitasi HIBA az iteracio elott!')
      uzenet=hibajel, return
    end
    jel=0;
    for k1=1:mc
      if k1==mc, n1=n-(mc-1)*kc; end
      jel=jel+8*n*n1;
      A=fread(af,[n,n1],'double');
      if jel~=ftell(af)
        disp('adatolvasasi hiba HIBA az iteracioban!')
        particio=k1, uzenet=ferror(af), return
      end
      res=res+A*x(l+1:l+n1);
      l=l+kc;
    end
    fclose(af); clear A;
    nmin=norm(res,inf);
    xx=x;
    re=res;
%Az x javitasa iteracioval mindaddig amig a relativ modositas
%nagyobb epszilon-nal, de legfeljebb imax lepesben:
  for k=1:imax
%Eloszor az Az=re egyenletrendszert oldjuk meg,
%itt is felhasznalva a permutalt A matrix LU felbontasat:
    y=solvtril(AM,re,p,me);
    z=solvtriu(AM,y,p,me);
    d=norm(z,inf)/norm(xx,inf);
%A kozelito xx modositasa:
    xx=xx-z;
%Az uj rezidualis hiba:
    re=-b;
    n1=kc;
    l=0;
    [af,hibajel]=fopen(AF,'rb');
    if af<0 disp('adatfile nyitasi HIBA az iteracio elott!')
      uzenet=hibajel, return
    end
    jel=0;
    for k1=1:mc
      if k1==mc, n1=n-(mc-1)*kc; end
      jel=jel+8*n*n1;
      A=fread(af,[n,n1],'double');
      if jel~=ftell(af)
        disp('adatolvasasi hiba HIBA az iteracioban!')
        particio=k1, uzenet=ferror(af), return
      end
      re=re+A*xx(l+1:l+n1);
      l=l+kc;
    end
    fclose(af); clear A;
    nm=norm(re,inf);
%A vegeredmenyben csak akkor vesszuk figyelembe
%a modositast, ha valoban javitott ez a lepes
    if nm<nmin
       nmin=nm;
       x=xx;
       res=re;
    end
    if d<=ep
       am=fopen(AM,'w');fclose('all');
       return
    end
  end
   am=fopen(AM,'w');fclose('all');
return