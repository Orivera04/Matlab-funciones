function [x]=solvtriu(AM,b,p,me)
%Ux=b megoldasa, ahol U az AM-ben oszlopfolytonosan tarolt
%matrix sorok szerinti permutaltjanak felso haromszog resze
%
% © Jeney Andras 1998; program a Linearis algebra c. reszhez
%
%Parameterek:
%  AM : file-nev (string)
%   b : az egyenletrendszer jobboldala
%   p : a permutacio mutatoja (integer vektor)
%  me : az U hany eleme lehet egyszerre a memoriaban (integer)
  n=length(b);
  x=zeros(n,1);
% A memoriaban egyszerre tarthato oszlopok szama: kc
  kc=floor(me/n);
  if kc>n
     kc=n;
  elseif kc<1
    disp('HIBA! Kotelezoen: me>=egyenletek szama'), return
  end
% Az U egyutthatomatrix particioinak szama: mc
  mc=floor(n/kc);
  if mc*kc>n
     mc=mc-1;
  elseif kc*mc<n
     mc=mc+1;
  end
  l=n;
  n1=kc;
  [am,hibajel]=fopen(AM,'rb');
  if am<0 disp('file nyitasi HIBA a felso haromszogmatrixban!')
     uzenet=hibajel, return
  end
  jel=8*n*n;
%Az egyenletrendszer megoldasa mc reszletben:
  for k1=1:mc
    if k1==mc
      n1=n-(mc-1)*kc;
    end
      fseek(am,8*n*(l-n1),-1);
%Az U egyutthatomatrix kovetkezo n1 db oszlopanak beolvasasa
%(n1=kc, ha nem az utolso particio, egyebkent a maradek):
      U=fread(am,[n,n1],'double'); %AM(1:n,l-n1+1:l);
      if jel~=ftell(am)
        particio=k1,
        disp('adatolvasasi HIBA a felso haromszog matrixban!')
        uzenet=ferror(am), return
      end
    for i=1:n1
      s=U(p(l-i+1),n1-i+1);
      if abs(s)<1e-50
         disp('Figyelem! Az egyutthatomatrix (majdnem)szingularis!')
      end
      x(l-i+1)=b(l-i+1)/s;
      b=b-x(l-i+1)*U(p,n1-i+1);
    end
    clear U;
    l=l-kc; jel=jel-8*n*n1;
  end
  fclose(am);
return