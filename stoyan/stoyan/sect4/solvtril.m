function [x]=solvtril(AM,b,p,me)
%Lx=b1 megoldasa, ahol L az AM-ben oszlopfolytonosan tarolt
%matrix sorok szerinti permutaltjanak also haromszog resze,
%a foatloban 1-ek feltetelezve, tovabba
%b1 a b parameter megfelelo permutacioja.
%
% © Jeney Andras 1998; program a Linearis algebra c. reszhez
%
%Parameterek:
%  AM : file-nev (string)
%   b : az Lx=b1 egyenletrendszer
%       jobboldalanak inverz permutaltja
%   p : a permutacio mutatoja (integer vektor)
%  me : az L hany eleme lehet egyszerre a memoriaban
  n=length(b);
  x=zeros(n,1);
% A memoriaban egyszerre tarthato oszlopok szama: kc
  kc=floor(me/n);
  if kc>n
     kc=n;
  elseif kc<1
    disp('HIBA! Kotelezoen: me>=egyenletek szama'), return
  end
% Az L egyutthatomatrix particioinak szama: mc
  mc=floor(n/kc);
  if mc*kc>n
     mc=mc-1;
  elseif kc*mc<n
     mc=mc+1;
  end
  l=0;
  n1=kc;
  [am,hibajel]=fopen(AM,'rb');
  if am<0 disp('file nyitasi HIBA az also haromszogmatrixban!')
     uzenet=hibajel, return
  end
  jel=0;
%Az egyenletrendszer megoldasa mc reszletben:
  for k1=1:mc
    if k1==mc
      n1=n-(mc-1)*kc;
    end
    jel=jel+8*n*n1;
%Az L egyutthatomatrix kovetkezo n1 db oszlopanak beolvasasa
%(n1=kc, ha nem az utolso particio, egyebkent a maradek):
    L=fread(am,[n,n1],'double'); %AM(1:n,l+1:l+n1);
    if jel~=ftell(am)
      particio=k1,
      disp('adatolvasasi HIBA az also haromszogmatrixban!')
      uzenet=ferror(am), return
    end
    for i=1:n1
      x(l+i)=b(p(l+i));
      b=b-x(l+i)*L(1:n,i);
   end
   clear L;
    l=l+kc;
  end
  fclose(am);
return