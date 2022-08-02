function mat = makefish(siz);
% make a Poisson matrix

leng = siz*siz;
dia = zeros(siz,siz);
off = -eye(siz,siz);
 for i=1:siz, dia(i,i)=4; end;
 for i=1:siz-1, dia(i,i+1)=-1; dia(i+1,i)=-1; end;
mat = zeros(leng,leng);
 for ib=1:siz,
  mat(1+(ib-1)*siz:ib*siz,1+(ib-1)*siz:ib*siz) = dia; end;
 for ib=1:siz-1,
  mat(1+(ib-1)*siz:ib*siz,1+ib*siz:(ib+1)*siz) = off;
  mat(1+ib*siz:(ib+1)*siz,1+(ib-1)*siz:ib*siz) = off; end;
return;
