% evec2b64(vector)
% converts binary vector to base64 vector 
% written by stefan.mueller@fgan.de (C) 2007
function b64code=evec2b64(bincode)
  if (nargin~=1)
    eusage('b64Vector=evec2b64(binVector)');
  end
  [n m]=size(bincode);
  if n==1
    bincode=bincode';
    trans=1;
    n=m;
  else 
    trans=0;
  end
  nTuples=ceil(n/3); 
  nTail=nTuples*3-n;
  if nTail>0
    bincode=[bincode;zeros(nTail,1)];
  end
  b64code=[reshape(bincode,3,nTuples);zeros(1,nTuples)];
  tupSum=b64code(3,:)+bitshift(b64code(2,:),8)+...
         bitshift(b64code(1,:),16);
  b64code(1,:)=bitshift(tupSum,-18);
  tupSum=tupSum-bitshift(b64code(1,:),18);
  b64code(2,:)=bitshift(tupSum,-12);
  tupSum=tupSum-bitshift(b64code(2,:),12);
  b64code(3,:)=bitshift(tupSum,-6);
  b64code(4,:)=tupSum-bitshift(b64code(3,:),6);
  b64code=reshape(b64code,4*nTuples,1);
  if trans
    b64code=b64code';
  end
% trans='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
% b64code=trans(b64code(:)+1);
  if nTail>0 
    e=nTuples*4;
    b64code(e-nTail+1:e)=64;
  end
