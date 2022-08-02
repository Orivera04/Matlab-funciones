% eva852vec(vector)
% converts binary vector to ASCII85 vector 
% written by stefan.mueller@fgan.de (C) 2006
function bincode=ea852vec(a85code)
  if (nargin~=1)
    eusage('binVector=ea852vec(a85Vector)');
  end
  [n m]=size(a85code);
  if n==1
    a85code=a85code';
    trans=1;
    n=m;
  else 
    trans=0;
  end
  nTuples=n/5;
  bincode=reshape(a85code,5,nTuples)-33;
  tupSum=bincode(5,:)+bincode(4,:)*85+bincode(3,:)*7225+...
         bincode(2,:)*614125+bincode(1,:)*52200625;
  bincode(1,:)=bitshift(tupSum,-24);
  tupSum=tupSum-bitshift(bincode(1,:),24);
  bincode(2,:)=bitshift(tupSum,-16);
  tupSum=tupSum-bitshift(bincode(2,:),16);
  bincode(3,:)=bitshift(tupSum,-8);
  bincode(4,:)=tupSum-bitshift(bincode(3,:),8);
  bincode=bincode(1:4,:); 
  bincode=reshape(bincode,4*nTuples,1);
  if trans
    bincode=bincode';
  end
