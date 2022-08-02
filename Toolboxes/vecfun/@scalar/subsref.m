function B=subsref(A,S)
%SUBSREF  Subscripted reference.
%   S(X,Y,Z) returns the scalar function S indexed by
%   X, Y and Z where each of the indexes can be a number or
%   the empty vector []. If X, Y and Z all are numbers then
%   the function S will be evaluated using these numbers.
%
%   S(V) returns the scalar function S indexed by the
%   vector function V.
%
%   See also SUBSASGN.

% Copyright (c) 2001-04-17, B. Rasmus Anthin.

B=A;
err1='Must have paranthesis around variables.';
err2='-value is out of range.';
err3='Wrong number of variables.';
[xs ys zs]=vars(A);
if ~strcmp(S.type,'()')
   error(err1)
end
if length(S.subs)==1 & isvector(S.subs{1})
   xval=vec2sca(S.subs{1},1);
   yval=vec2sca(S.subs{1},2);
   zval=vec2sca(S.subs{1},3);
   B.f=strrepx(B.f,xs,['(' xval.f ')'],'');
   B.F=strrepx(B.F,xs,['(' xval.F ')'],{'pdiffev','integral'});
   B.f=strrepx(B.f,ys,['(' yval.f ')'],'');
   B.F=strrepx(B.F,ys,['(' yval.F ')'],{'pdiffev','integral'});
   B.f=strrepx(B.f,zs,['(' zval.f ')'],'');
   B.F=strrepx(B.F,zs,['(' zval.F ')'],{'pdiffev','integral'});
elseif length(S.subs)==3
   val={S.subs{1} S.subs{2} S.subs{3}};
   if ~(B.x(1)<=val{1} & val{1}<=B.x(2))
      error([xs err2]);
   end
   if ~(B.y(1)<=val{2} & val{2}<=B.y(2))
      error([ys err2]);
   end
   if ~(B.z(1)<=val{3} & val{3}<=B.z(2))
      error([zs err2]);
   end
   vals={num2str(val{1}) num2str(val{2}) num2str(val{3})};
   isval=[~isempty(val{1}) ~isempty(val{2}) ~isempty(val{3})];
   compute=0;
   if isval(1)
      B.F=strrepx(B.F,xs,vals{1},{'pdiffev','integral'});
      B.xval=vals{1};
      compute=compute+1;
   end
   if isval(2)
      B.F=strrepx(B.F,ys,vals{2},{'pdiffev','integral'});
      B.yval=vals{2};
      compute=compute+1;
   end
   if isval(3)
      B.F=strrepx(B.F,zs,vals{3},{'pdiffev','integral'});
      B.zval=vals{3};
      compute=compute+1;
   end
   
   if compute==3
      X=linspace(B.x(1),B.x(2),B.x(3));
      Y=linspace(B.y(1),B.y(2),B.y(3));
      Z=linspace(B.z(1),B.z(2),B.z(3));
      eval(['[' xs ',' ys ',' zs ']=meshgrid(X,Y,Z);'])
      vars=eval(['{' xs ',' ys ',' zs '}']);
      value=eval(B.F);
      if length(value)>1
         [ix iy iz]=eval(['index(' xs ',' ys ',' zs ',val)']);
         value=mean(value(iy,ix,iz));
      end
      %B=value;
      B.f=num2str(value);B.F=B.f;
   end
else
   error(err3);
end