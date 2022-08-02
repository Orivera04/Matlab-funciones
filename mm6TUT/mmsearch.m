function y=mmsearch(tab,col,val)
%MMSEARCH 1-D NON-Monotonic Linear Interpolation. (MM)
% XI=MMSEARCH(Y,X,Yval) linearly interpolates the vector Y to find Yval and
% returns the associated interpolated values from the vector X which must 
% have the same length as Y. All crossings are found and Y is commonly not
% monotonic. Each crossing is returned as a separate row in XI.
% If Yval is not found, XI=[].
%
% TI=MMSEARCH(TAB,COL,VAL) linearly interpolates the table TAB searching
% for the scalar value VAL in the column COL. All crossings are found and
% TAB(:,COL) need not be monotonic. Each crossing is returned as a separate
% row in TI and TI has as many columns as TAB. The column COL of TI contains
% the value VAL. If VAL is not found in the table, TI=[].
%
% If TAB(:,col) or Y is monotonic use MMINTERP instead.
%
% See also MMINTERP, INTERP1.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 1/26/95, revised 9/19/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rt,ct]=size(tab);
[rc,cc]=size(col);
lval=length(val);
xyflag=0;

if lval>1, error('VAL must be a scalar.'), end
if max(rc,cc)>1  % MMSEARCH(Y,X,Yval)
   if min(rt,ct)>1, error('Y Must be a Vector.'), end
   if rt==1, tab=tab.'; rt=ct; end
   if rc==1, col=col.'; rc=cc; end
   if rt~=rc, error('Length of Y Must Equal Rows in X.'), end
   tab=[tab col]; col=1;
   [rt,ct]=size(tab);
   xyflag=1;
end
if ndims(tab)~=2, error('Input Must be 2D.'), end
if col>ct|col<1,  error('Chosen Column Outside Table Width.'), end
if rt<2, error('Table Too Small or Not Oriented in Columns.'), end
above=tab(:,col)>val;
below=tab(:,col)<val;
equal=tab(:,col)==val;
if all(above==0)|all(below==0), % handle simplest case
   y=tab(find(equal),:);
   return
end
pslope=find(below(1:rt-1)&above(2:rt)); %indices where slope is pos
nslope=find(below(2:rt)&above(1:rt-1)); %indices where slope is neg

ib=sort([pslope;nslope+1]);   % put indices below in order
ia=sort([nslope;pslope+1]);   % put indices above in order
ie=find(equal);               % indices where equal to val

[tmp,ix]=sort([ib;ie]);		% find where equals fit in result
ieq=ix>length(ib);			% True where equals values fit
ry=length(tmp);				% # of rows in result y

y=zeros(ry,ct);				% poke data into a zero matrix

if length(ie)~=ry  % interpolate if needed
   alpha=(val-tab(ib,col))./(tab(ia,col)-tab(ib,col));
   alpha=alpha(:,ones(1,ct));
   y(~ieq,:)=alpha.*tab(ia,:)+(1-alpha).*tab(ib,:); % interpolated values
end

y(ieq,:)=tab(ie,:);			% equal values
if xyflag  % MMSEARCH(Y,X,Yval)
   y(:,1)=[];
else       % MMSEARCH(TAB,COL,VAL)
   y(:,col)=repmat(val,ry,1);	% remove roundoff error
end
