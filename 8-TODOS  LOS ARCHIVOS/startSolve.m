function startSolve(solver,precv,threshold,mat,tol,step,symmflag,restartv,color)


symmdir='./matrices/symm';
unsymmdir='./matrices/unsymm';
precdir='./matrices/prec';
owndir='./matrices/eigene';

switch color
case 'yellow'
   cv='y';
case 'magenta'
   cv ='m';
case 'cyan'
   cv='c';
case 'red'
   cv='r';
case 'green'
   cv='g';
case 'blue'
   cv='b';
case 'black'
   cv='k';
end


if strcmp(mat,'Eigene');
   mat=inputdlg('Matrix-Name','Eigene Matrix eingeben');
   mat=mat{1}
   mat=strcat(owndir,'/',lower(mat),'.mtx');
elseif symmflag==1
   mat=strcat(symmdir,'/',lower(mat),'.mtx');
else
   mat=strcat(unsymmdir,'/',lower(mat),'.mtx');
end

matrix=mmread(mat);
   
   prectime=0;
   
   % Get Dimension of the Matrix
   
   n = size(matrix);
   n = n(1);
   
   % Choose Preconditioner
   
   if precv == 1
   	L=speye(n);
   	U=speye(n);
   else
      if precv==2
         threshold = '0'
      elseif precv == 3
         threshold = eval(threshold)
      else
         L=inputdlg('L=','Untere Dreiecksmatrix eingeben');
         L=L{1};
         R=inputdlg('R=','Obere Dreiecksmatrix eingeben');
         R=R{1};
         L=mmread(strcat(precdir,'/',lower(L),'.mtx'));
         U=mmread(strcat(precdir,'/',lower(R),'.mtx'));
         prectime=0;
      end
      if (precv==2) | (precv==3)
      	if symmflag == 1
         	tic;
         	U=cholinc(matrix,threshold);
         	prectime=toc;
         	L=U';
      	else
         	tic;
         	[L,U]=luinc(matrix,threshold);
         	prectime=toc;
         end
      end
   end
   
   % Initialize Startvector
   
   vstart=zeros(n,1);
   
   switch solver
   case 'CG',
      tic;
      [x,res_norm,iter,flag,hist]=cg_p(matrix,ones(n,1),L,tol,step,vstart);
      count=toc;
   case 'SYMMLQ',
      tic;
      [x,res_norm,iter,flag,hist]=symmlq(matrix,ones(n,1),tol,step,vstart);
      count=toc;
   case 'MINRES'
      tic;
      [x,res_norm,iter,flag,hist]=minres_p(matrix,ones(n,1),L,tol,step,vstart);
      count=toc;
   case 'CR',
      tic;
      [x,res_norm,iter,flag,hist]=cr(matrix,ones(n,1),tol,step,vstart);
      count=toc;
   case 'GMRES',
      tic;
      [x,res_norm,iter,flag,hist]=gmresm_lp(matrix,ones(n,1),restartv,tol,step,L,U,vstart);
      count=toc;
   case 'BICG',
      tic;
      [x,res_norm,iter,flag,hist]=bicg_lp(matrix,ones(n,1),tol,step,L,U,vstart);
      count=toc;
   case 'BICGSTAB',
      ops.Tol=tol;
      ops.MaxIt=step;
      ops.ell=restartv;
      temphandle=gcf;
      nhandle=figure(999);
      figure(nhandle);
      set(gcf,'Visible','off');
      tic;
      [x,hist]=bcgstabl(matrix,ones(n,1),ops,L,U);
      count=toc;
%      clf;
      figure(temphandle);
      hist=hist(:,1);
      if norm(ones(n,1)-matrix*x)/sqrt(n)<tol
         flag=0;
      else
         flag=1;
      end
   case 'TFQMR',
      tic;
      [x,res_norm,iter,flag,hist]=tfqmr_lp(matrix,ones(n,1),tol,step,L,U,vstart);
      count=toc;
   case 'QMRBCGSTAB',
      tic;
      [x,res_norm,iter,flag,hist]=qmrbcgst_lp(matrix,ones(n,1),tol,step,L,U,vstart);
      count=toc;
   case 'CGNR'
      tic;
      [x,res_norm,iter,flag,hist]=cgnr(matrix,ones(n,1),tol,step,vstart);
      count=toc;
   case 'CGS'
      tic;
      [x,res_norm,iter,flag,hist]=cgs_lp(matrix,ones(n,1),tol,step,L,U,vstart);
      count=toc;
   case 'QMR-2'
      tic;
      [x,res_norm,iter,flag,hist]=qmr2(matrix,vstart,ones(n,1),L,U,step,tol);
      count=toc;
   case 'QMR-3'
      tic;
      [x,res_norm,iter,flag,hist]=qmr_lp(matrix,ones(n,1),tol,step,L,U,vstart);
      count=toc;
   otherwise, disp('Not yet implemented');
   end
   
   % Perform Output
   
   
   iter=length(hist)-1;
   if flag==0
      outstring={'Anzahl der Schritte';sprintf('%d',iter);'';'Zeit für den Löser';sprintf('%E',count);'';'Zeit für den Präkonditionierer';sprintf('%E',prectime)};
   else
      outstring={'Keine Konvergenz'};
   end
   
   semilogy(1:length(hist),hist,cv);
   objRef=findobj(gcf,'Tag','StaticText1');
   set(objRef,'String',outstring);
   
   