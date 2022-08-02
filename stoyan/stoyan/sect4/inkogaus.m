function y=inkogaus(a,b,idd1,idd2,n,maxit,epsi,S)
% Kiszamitja az inkomplett Gauss-eliminaciot, majd iteracio-
% val oldja meg az Sy=b rendszert. Itt S az a matrix, amely
% a spdiags(a,idd1,n,n) utasitassal keszithet"o. Ennek meg-
% felel"oen a idd1 megadja a foglalt atlok helyet.
%
% © Stoyan Gisbert 1998; program a Linearis algebra c. reszhez
%
% Hivasa:
%         y=inkogaus(a,b,idd1,idd2,n,maxit,epsi,S)
% ahol:
% y       a lin. rendszer k"ozelit"o megoldasa,
% a       az atlonkent tarolt matrix,
% b       a jobboldali (oszlop-)vektor,
% idd1    az atlok helyet megado (oszlop-)vektor,
% idd2    az iteracio jobb konvergencia celjabol el"oirhato,
% kiegeszit"o atlok helye, mint oszlopvektor
% n       az a matrix es a b vektor merete
% maxit   a maximalis iteracioszam
% epsi    a kilepesi feltetel abszolut pontossagi korlatja
% S       kihagyhato: S=spdiags(a,idd1,n,n)
%         Ha ez a matrix meg nincs, akkor inkogaus kesziti.

[dda dda1]=size(idd1);
[idd,indd]=sort([idd1' idd2']); % a teljes indexvektor
%idd,indd,dda                   % "osszeallitasa

[dda1 dd]=size(idd);idi=0;
for i=1:dd
   if idd(i)==0            % a f"oatlo helyenek
     idi=i;                % meghatarozasa
     break
   end
end
%idi
if idi==0
  inputhiba=idi  
else
  idip=idi+1;idim=idi-1;
  ddd=dd-idi;

  for j=1:idim            
     k=j+1;llij=idd(j);  
     for i=1:ddd         
        iae=-1;iai=idd(i+idi)+llij;
        for l=k:dd         % az itt kesz"ul"o ia
           if idd(l)==iai  % indext"omb megadja azon
             k=l+1;        % atlok indexet, amelyen
             iae=1;        % valtozhatnak a matrix 
             ia(j,i)=l;    % elemei (a f"oatlo alatti 
             break         % atlokrol nezve)
           elseif idd(l)>iai
             break
           end
        end
        if iae==-1
          ia(j,i)=0;
        end
     end
  end
% ia                       % elkesz"ult az indext"omb
                          
id1=1;                     % bef"uzve a kiegeszit"o 
for id=1:idi               % nulla oszlopokat, olyan
   if indd(id)>dda         % alakra hozzuk a matrixot, 
     aa(:,id)=zeros(n,1);  % hogy a felbontasnal keves
   else                    % i>n-fele teszt kelljen
     aa(:,id)=[zeros(-idd(id),1);a(1:n+idd(id),id1);];
     id1=id1+1;
   end
end
for id=idip:dd
   if indd(id)>dda
     aa(:,id)=zeros(n,1);
   else
     aa(:,id)=[a(1+idd(id):n,id1);zeros(idd(id),1)];
     id1=id1+1;
   end
end
clear indd
%aa                        % ezen matrix helyen
                           % t"ortenik a felbontas
zerus=0;
for i=1:n
   if aa(i,idi)==0
     zerus=i
     break
   else
      d(i)=1/aa(i,idi);
      for j=1:idim
         ij=i-idd(j);
         if ij<=n
           llij=aa(ij,j)*d(i);
           ll(ij,j)=llij;
           for k=1:ddd     % a felbontas legbels"obb
              l=ia(j,k);   % ciklusa
              if l>0
                aa(ij,l)=aa(ij,l)-llij*aa(i,idi+k);
              end
           end
         end
      end % j-ciklus vege
      for id=1:ddd
         uu(i,id)=aa(i,id+idi);
      end
   end
end

%aa,d,uu,ll                % a felbontas matrixai
clear aa ia                % elkesz"ultek

if zerus==0
  y=b;
  for i=1:n-1              % el"ore a nulladik
     for j=1:idim          % approximaciohoz
        ij=i-idd(j);
        if ij<=n
          y(ij)=y(ij)-ll(ij,j)*y(i);
        end
     end
  end 
  for i=n:-1:1             % vissza
     w=y(i);
       for id=idip:dd
          is=i+idd(id);
          if is<=n 
            w=w-uu(i,id-idi)*y(is);
          end
       end
     y(i)=w*d(i);
  end

  if nargin<8
    S=spdiags(a,idd1,n,n);
  end

  for it=1:maxit           % az inkomplett felbontas
                           % utani iteracio kezdete, a
     f=b-S*y;              % maradekvektor kiszamitasa
     z=norm(f,inf);
     if z<epsi
       break
     end
     for i=1:n-1           % el"ore
        for j=1:idim
           ij=i-idd(j);
           if ij<=n
             f(ij)=f(ij)-ll(ij,j)*f(i);
           end
        end
     end 
     for i=n:-1:1          % vissza
        w=f(i);
        for id=idip:dd
           is=i+idd(id);
           if is<=n 
             w=w-uu(i,id-idi)*f(is);
           end
        end
        f(i)=w*d(i);
     end
     y=y+f;
   end                     % iteracio vege
norm_y=z,it
end                        % nullaoszto if vege
end                        % inputhiba  if vege