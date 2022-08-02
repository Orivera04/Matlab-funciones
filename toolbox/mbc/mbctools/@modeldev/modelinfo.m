function mdev=modelinfo(mdev,Update);
% MODELDEV/MODELINFO fill out modelinfo fields

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:10:40 $

TP= mdevtestplan(mdev);
m= mdev.Model;
Yname= varname(mdev,'Y');
Y= getdata(mdev,'Y');
if size(Y,2)==1
   if isa(Y,'sweepset')
      Yu= get(Y,'units');
      if isa(Yu,'cell') & length(Yu)==1
         Yu= Yu{1};
      end
   else
      Yu= junit;
   end
else
   Yname= 'y';
   Yu=junit;
end
X= getdata(mdev,'X');
if isa(X,'sweepset')
   Xu= get(X,'units');
else
   Xu= repmat({junit},1,size(X,2));
end

if isa(m,'xregtwostage');
   % handle twostage
   Xg= getdata(TP,'X');
	if iscell(Xg)
		X= Xg{1};
		Xg=Xg{end};
	end
	xs= get(X,'name');
   gm=get(m,'global');
   s= [xs; get(gm{1},'symbol')];
   Xnames= [xs ; get(Xg,'Name')];
   Xu= [Xu ; get(Xg,'units')];
elseif isa(m,'localmod');
   s= get(X,'name');
   Xnames= s;
else
   s= get(m,'symbol');
   Xnames= get(X,'name');
end      

xi = struct('Names',{Xnames},...
   'Units',{Xu},...
   'Symbols',{s});
yi = struct('Name',Yname,...
   'Units',Yu,...
   'Symbol',Yname);

m= xinfo(m,xi);
mdev.Model= yinfo(m,yi);

pointer(mdev);
