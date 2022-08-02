function y=mminterp(a,b,c)
%MMINTERP 1-D Monotonic Linear Interpolation. (MM)
% YI=MMINTERP(X,Y,XI) interpolates the vector X to find YI associated
% with XI. NaNs are returned for XI values outside the range of X.
%
% YI=MMINTERP(TAB,COL,VALS) linearly interpolates the table TAB
% searching for values VALS in the column COL.
% TAB(:,COL) must be monotonic, but need NOT be equally spaced.
% YI has as many rows as VALS and as many columns as TAB.
% NaNs are returned where VALS are outside the range of TAB(:,COL).
%
% This routine is 10X faster than INTERP1 and TABLE1 in version 4.X.
% In version 5 this routine is up to 2X faster than INTERP1(X,Y,XI,'*linear')
% for scalar XI, but generally up to 50% slower than INTERP1(X,Y,XI)
% and INTERP1(X,Y,XI,'*linear') for linearly spaced X. However, it is
% 10% to 50% faster than INTERP1(X,Y,YI) and INTERP1Q(X,Y,Xi)
% for nonlinearly spaced X.
%
% See also INTERP1, INTERP1Q, MMSEARCH.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 8/21/95, revised 3/8/96 v5: 1/21/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

sizb=size(b);
if prod(sizb==1)    % MMINTERP(TAB,COL,VALS) syntax
   tab=a; col=b(1); vals=c(:); cflag=0; rflag=0;
   if ndims(tab)~=2, error('TAB Must be 2D.'), end
else                % MMINTERP(X,Y,XI) syntax
   a=a(:);
   la=length(a);
   if length(sizb)>2,     error('Y Must be 2D.')
   elseif sizb(1)==la,    tab=[a b];
   elseif sizb(2)==la,    tab=[a b.'];
   end
   col=1; vals=c(:); cflag=1;
   rflag=(size(c,1)==1);
end

[rt,ct]=size(tab);
if col>ct|col<1,  error('Chosen Column Outside Table Width.'), end
if rt<2, error('Table Too Small or Not Oriented in Columns.'), end
nv=length(vals);

if nv==1  % quick return for scalar interpolant
   i=find(abs(tab(:,col)-vals)<=eps);
   if ~isempty(i)  % value is in table
      y=tab(i(1),:);
   else  % value must be interpolated
      s=tab(2,col)-tab(1,col);
      if s>0,     i=find(vals<=tab(:,col));
      elseif s<0, i=find(vals>=tab(:,col));
      else,       error('Input Must be Monotonic.')
      end
      if isempty(i)  % vals outside of table
         y=repmat(nan,1,ct);
         y(:,col)=vals;
      else
         ip=i(1);
         ib=ip-1;
         if ib==0  % vals outside of table
            y=repmat(nan,1,ct);
            y(1,col)=vals;
         else
            dy=(vals-tab(ib,col))/(tab(ip,col)-tab(ib,col));
            y=dy*tab(ip,:)+(1-dy)*tab(ib,:);
         end
      end
   end
   if cflag, y(col)=[]; end
   return
end

ict=1:ct;            % index for table columns
dx=diff(tab);
dx=[dx;dx(rt-1,:)];  % differences within each column.
id=sign(dx(1,col));  % sign of differences in col

if any(sign(dx(:,col))~=id)
   error(sprintf('Column %.0f of Table Must be Monotonic.',col))
end

inan=vals<min(tab(1,col),tab(rt,col)) | vals>max(tab(1,col),tab(rt,col));
xo=vals(~inan);  % pick values within range of tab(:,col)
nxo=length(xo);
if nxo==0  % all values are outside range of tab(:,col)!
   y=repmat(nan,nv,ct);
   y(:,col)=vals;
else  % interpolate using algorithm posted by Hans Olsson of Lund University
   
   [svals,sidx]=sort(id*[tab(2:rt-1,col);xo]);
   ttab=sidx<=rt-2;      % True at tab(:,col) values in svals
   cidx=1+cumsum(ttab);  % index of xo in svals
   sidx(ttab)=[];        % throw out indices of tab(:,col) values
   yidx=zeros(nxo,1);    % storage for xo index in tab(:,col)
   yidx(sidx-(rt-2))=cidx(~ttab);  % xo index in tab(:,col)
   ndx=(xo-tab(yidx,col))./dx(yidx,col); % normalized dx increment
   y=tab(yidx,ict)+ndx(:,ones(1,ct)).*dx(yidx,ict);
   if ~isempty(inan)  % must poke in NaNs where they belong
      yt=zeros(nv,ct);
      yt(~inan,:)=y;
      yt(inan,:)=repmat(NaN,nv-nxo,ct);
      yt(:,col)=vals;
      y=yt;
   end
end
if cflag, y(:,col)=[]; end
if rflag, y=y(:)'; end
