% function delta_.m is called by function stret_.m
% Solves sinh(delta)=B*delta
% Copyright S. Nakamura, 1995
function DELTA = delta_(B)
if (B<1.0 ), 
   fprintf('B IS LESS THAN 1. CODE IS STOPPED IN SUB. DELTA' )
   B=0.0;
return 
end 
DELTA=0;
K=0;
X=sqrt(6*B-6.);
XB = 0;
x=6.0;
      if (B< 3) x=B;  end
      if (B< 80) x=7. ;end
      if (B<100) x=7.3;end
      if (B<200) x=8.  ;end
      if (B<300) x=8.65;end
      if (B<400) x=8.86;end
X = x;
flag = 0;
while abs(X-XB)>0.000001*abs(X) ,
      XB=X;
      XP = exp(X);
      XM=1./XP;
      F=XP-XM -B*2.0*X;
      FD=XP+XM -B*2.0 ;
      X= XB-F/FD ;
      K=K+1;
        if  (K>40) 
          fprintf(' ITERATION LIMIT EXCEEDED.  STOPPED IN SUB. DELTA')
          flag = 1;return 
        end  
      if flag==1; return ,end
end 
DELTA=X;

