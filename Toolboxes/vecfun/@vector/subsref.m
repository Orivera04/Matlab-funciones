function B=subsref(A,S)
%SUBSREF  Subscripted reference.
%   V.x, V.y or V.z returns the scalar component of the
%   vector function V.
%
%   V(X,Y,Z) returns the vector function V indexed by
%   X, Y and Z where each of the indexes can be a number or
%   the empty vector []. If X, Y and Z all are numbers then
%   the function V will be evaluated using these numbers
%   if and only if V are indexed by .x, .y or .z.
%
%   See also SUBSASGN.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

err1='Wrong type of index.';
err2='Didn''t quite understand your request.';
err3='-value is out of range.';
err4='Wrong number of variables.';
[xs ys zs]=vars(A);
if S(1).type=='.'
   B.x=A.x;B.y=A.y;B.z=A.z;
   B.xval=A.xval;B.yval=A.yval;B.zval=A.zval;
   switch(S(1).subs)
   case {xs}
      B.f=A.fx;B.F=A.Fx;
   case {ys}
      B.f=A.fy;B.F=A.Fy;
   case {zs}
      B.f=A.fz;B.F=A.Fz;
   otherwise
      error(err1);
   end
   B.coords=A.coords;
   B=scalar(B);
   if length(S)==2
      if strcmp(S(2).type,'()') & isscalar(B)
         B=subsref(B,S(2));
      else
         error(err2);
      end
   end
elseif strcmp(S(1).type,'()') & length(S(1).subs)==1 & isvector(S(1).subs{1})
   xval=struct(vec2sca(S(1).subs{1},1));
   yval=struct(vec2sca(S(1).subs{1},2));
   zval=struct(vec2sca(S(1).subs{1},3));
   B=A;
   for i='xyz'
      eval(['B.f' i '=strrepx(B.f' i ',xs,[''('' xval.f '')''],'''');'])
      eval(['B.F' i '=strrepx(B.F' i ',xs,[''('' xval.F '')''],{''pdiffev'',''integral''});'])
      eval(['B.f' i '=strrepx(B.f' i ',ys,[''('' yval.f '')''],'''');'])
      eval(['B.F' i '=strrepx(B.F' i ',ys,[''('' yval.F '')''],{''pdiffev'',''integral''});'])
      eval(['B.f' i '=strrepx(B.f' i ',zs,[''('' zval.f '')''],'''');'])
      eval(['B.F' i '=strrepx(B.F' i ',zs,[''('' zval.F '')''],{''pdiffev'',''integral''});'])
   end
elseif strcmp(S(1).type,'()') & length(S(1).subs)==3
   B=A;
   val={S.subs{1} S.subs{2} S.subs{3}};
   if ~(B.x(1)<=val{1} & val{1}<=B.x(2))
      error([xs err3]);
   end
   if ~(B.y(1)<=val{2} & val{2}<=B.y(2))
      error([ys err3]);
   end
   if ~(B.z(1)<=val{3} & val{3}<=B.z(2))
      error([zs err3]);
   end
   vals={num2str(val{1}) num2str(val{2}) num2str(val{3})};
   isval=[~isempty(val{1}) ~isempty(val{2}) ~isempty(val{3})];
   compute=0;
   fcns={'pdiffev','integral'};
   if isval(1)
      B.Fx=strrepx(B.Fx,xs,vals{1},fcns);
      B.Fy=strrepx(B.Fy,xs,vals{1},fcns);
      B.Fz=strrepx(B.Fz,xs,vals{1},fcns);
      B.xval=vals{1};
      compute=compute+1;
   end
   if isval(2)
      B.Fx=strrepx(B.Fx,ys,vals{2},fcns);
      B.Fy=strrepx(B.Fy,ys,vals{2},fcns);
      B.Fz=strrepx(B.Fz,ys,vals{2},fcns);
      B.yval=vals{2};
      compute=compute+1;
   end
   if isval(3)
      B.Fx=strrepx(B.Fx,zs,vals{3},fcns);
      B.Fy=strrepx(B.Fy,zs,vals{3},fcns);
      B.Fz=strrepx(B.Fz,zs,vals{3},fcns);
      B.zval=vals{3};
      compute=compute+1;
   end
   
   if compute==3
      X=linspace(B.x(1),B.x(2),B.x(3));
      Y=linspace(B.y(1),B.y(2),B.y(3));
      Z=linspace(B.z(1),B.z(2),B.z(3));
      eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);'])
      vars=eval(['{' xs ',' ys ',' zs '}']);
      value{1}=eval(B.Fx);
      value{2}=eval(B.Fy);
      value{3}=eval(B.Fz);
      [ix iy iz]=eval(['index(' xs ',' ys ',' zs ',val)']);
      if length(value{1})>1
         value{1}=mean(value{1}(iy,ix,iz));
      end
      if length(value{2})>1
         value{2}=mean(value{2}(iy,ix,iz));
      end
      if length(value{3})>1
         value{3}=mean(value{3}(iy,ix,iz));
      end
      %B=cell2num(value);
      B.fx=num2str(value{1});B.Fx=B.fx;
      B.fy=num2str(value{2});B.Fy=B.fy;
      B.fz=num2str(value{3});B.Fz=B.fz;
   end
else
   error(err4);
end
