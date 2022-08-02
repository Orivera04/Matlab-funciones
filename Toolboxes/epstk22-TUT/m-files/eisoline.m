%%NAME
%%  eisoline  - get isolines of a matrix 
%%
%%SYNOPSIS
%%  lines=eisoline(matrix,isoValue)
%%
%%PARAMETER(S)
%%  lines      empty matrix or 2n x 2 matrix,
%%             n=number of lines x [x1 y1;x2 y2]
%%  matrix     matrix of values
%%  isoValue   value of isoline  
%% 
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003

function lines=eisoline(matrix,isoValue)
  if nargin~=2
    eusage('eisoline(matrix,isoValue)');
  end
  if exist('matlabpath')~=5
    save_do_fortran_indexing = do_fortran_indexing;
    save_empty_list_elements_ok = empty_list_elements_ok;
    do_fortran_indexing = 1;
    empty_list_elements_ok = 1;
  end
  [rows colums]=size(matrix);
  diff=matrix(:,2:colums)-matrix(:,1:(colums-1));
  findzero=find(diff==0);
  diff(findzero)=diff(findzero)+eps;
  wex=(isoValue-matrix(:,1:(colums-1)))./diff;
  diff=matrix(2:rows,:)-matrix(1:(rows-1),:);
  findzero=find(diff==0);
  diff(findzero)=diff(findzero)+eps;
  nsx=(isoValue-matrix(1:(rows-1),:))./diff;
  wexT=wex';
  crossns=find(wexT>=0 & wexT<=1);
  crosswe=find(nsx>=0 & nsx<=1);
  limit=(rows-1)*(colums-1);
  kn=crossns(find(crossns<=limit));
  kn=rem(kn-1,colums-1)*(rows-1)+fix((kn-1)/(colums-1))+1;
  kw=crosswe(find(crosswe<=limit));
  limit=(colums-1);
  ks=crossns(find(crossns>limit))-limit;
  ks=rem(ks-1,colums-1)*(rows-1)+fix((ks-1)/(colums-1))+1;
  limit=(rows-1);
  ke=crosswe(find(crosswe>limit))-limit;
  lines=[kn   ones(length(kn),1);kw 2*ones(length(kw),1);
             ks 3*ones(length(ks),1);ke 4*ones(length(ke),1)];
  ncrosspoints=size(lines,1);
  if ncrosspoints>0
    [slist index]=sort(lines(:,1));
    lines=lines(index,:);
    si=1:ncrosspoints;
    sv=[lines(:,1);lines(ncrosspoints,1)+1];
    c1=find(sv(si)==sv(si+1));
    c2=c1+1;
    c3=[c1';c2'];
    c3=reshape(c3,1,2*length(c2));
    lines=lines(c3,:);
    row=rem(lines(:,1)-1,rows-1)+1;
    col=fix((lines(:,1)-1)/(rows-1))+1;
    north=find(lines(:,2)==1);
    west=find(lines(:,2)==2);
    south=find(lines(:,2)==3);
    east=find(lines(:,2)==4);
    if length(north)>0
      lines(north,1)=rem(lines(north,1)-1,rows-1)*...
                       (colums-1)+fix((lines(north,1)-1)/(rows-1))+1;
      lines(north,1)=col(north)-0.5+wexT(lines(north,1));
      lines(north,2)=rows-row(north)+0.5;
    end
    if length(west)>0
      lines(west,2)=rows-row(west)+0.5-nsx(lines(west,1));
      lines(west,1)=col(west)-0.5;
    end
    if length(south)>0
      lines(south,1)=rem(lines(south,1)-1,rows-1)*...
                       (colums-1)+fix((lines(south,1)-1)/(rows-1))+1;
      lines(south,1)=col(south)-0.5+wexT(lines(south,1)+colums-1);
      lines(south,2)=rows-row(south)-0.5;
    end
    if length(east)>0
      lines(east,2)=rows-row(east)+0.5-nsx(lines(east,1)+rows-1);
      lines(east,1)=col(east)+0.5;
    end
  end
  if exist('matlabpath')~=5
    do_fortran_indexing = save_do_fortran_indexing;
    empty_list_elements_ok = save_empty_list_elements_ok;
  end
