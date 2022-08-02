% evec2a85(vector)
% converts binary vector to ASCII85 vector 
% written by stefan.mueller@fgan.de (C) 2007
function a85code=evec2a85(bincode)
  if (nargin~=1)
    eusage('a85Vector=evec2a85(binVector)');
  end
  [n m]=size(bincode);
  if n==1
    bincode=bincode';
    trans=1;
    n=m;
  else 
    trans=0;
  end
  nTuples=ceil(n/4);
  nTail=nTuples*4-n;
  if nTail>0
    bincode=[bincode;zeros(nTail,1)];
  end
  a85code=[reshape(bincode,4,nTuples);zeros(1,nTuples)];
  tupSum=a85code(4,:)+bitshift(a85code(3,:),8)+...
         bitshift(a85code(2,:),16)+...
	 bitshift(a85code(1,:),24);
  a85code(1,:)=fix(tupSum/52200625);
  tupSum=tupSum-a85code(1,:)*52200625;
  a85code(2,:)=fix(tupSum/614125);
  tupSum=tupSum-a85code(2,:)*614125;
  a85code(3,:)=fix(tupSum/7225);
  tupSum=tupSum-a85code(3,:)*7225;
  a85code(4,:)=fix(tupSum/85);
  a85code(5,:)=tupSum-a85code(4,:)*85;
  a85code=a85code+33;
  a85code=reshape(a85code,5*nTuples,1);
  if trans
    a85code=a85code';
  end
