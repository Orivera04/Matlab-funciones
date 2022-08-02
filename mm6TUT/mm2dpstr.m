function s=mm2dpstr(p)
%MM2DPSTR 2D Polynomial Vector to String Conversion. (MM)
% MM2DPSTR(P) converts the 2-D polynomial vector P into a
% string for display purposes.
% The output is a row vector with a new line character inserted
% at each change in the power of Y.
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 12/9/96, v5: 1/14/97, 11/19/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[pp,nx,ny,ncy,cy]=mm2dpchk(p);
s='';

for yp=0:ny
   if yp==0,     ystr='';
   elseif yp==1, ystr='(y)';
   else,         ystr=sprintf('(y^%.0f)',yp);
   end
   for xp=0:ncy(yp+1)-1
      if xp==0,     xstr='';
      elseif xp==1, xstr='(x)';
      else,         xstr=sprintf('(x^%.0f)',xp);
      end
      c=pp(cy(yp+1)+xp);  % current coefficient
      if c<0,  pm=' -';
      else,    pm=' +';
      end
      if yp==0 & xp==0  % handle first coefficient
         if c==1,    pm='1';
         elseif c>0, pm='';
         end
      end
      pc=sprintf('%.4g',abs(c));
      s=[s pm pc ystr xstr];
   end
   s=[s sprintf('\n')];
end
s(end)=[];
