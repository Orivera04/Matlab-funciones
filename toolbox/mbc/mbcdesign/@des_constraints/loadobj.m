function cout=loadobj(cin)
% LOADOBJ   Object loading function
%
%   B=LOADOBJ(A) is called when a des_constraints object
%   is loaded

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:57 $



if isa(cin,'des_constraints');
   % loading worked ok anyway
   cout=cin;
else
   cout=cin;
   % do version switching
   % new features are cumulatively added to this section
   if ~isfield(cout,'version')
      % version 1 --> 2 additions
      cout.Table2D = {};
      cout.version = 2;
   end
   
   if cout.version<3
      cout.Constraints=i_createcons(cout);
      cout=mv_rmfield(cout,{'NumConstraints',...
            'A','b',...
            'Table',...
            'Ellipsoid',...
            'Table2D',...
            'NonLinear'});      
      cout.version=3;
   end
   cout=des_constraints(cout);
end



function cons=i_createcons(cout)

NF=length(cout.Factors);
cons={};
for n=1:length(cout.b)
   cons(end+1)={conlinear(NF,'A',cout.A(n,:),'b',cout.b(n))};
end

for n=1:length(cout.Ellipsoid)
   cons(end+1)={conellipsoid(NF,'xc',cout.Ellipsoid{n}{1},'W',cout.Ellipsoid{n}{2})};
end

for n=1:length(cout.Table2D)
   cons(end+1)={contable1(NF,'breakx',cout.Table2D{n}{1},'table',cout.Table2D{n}{2},...
         'factors',cout.Table2D{n}{3},'le',cout.Table2D{n}{4})};
end

for n=1:length(cout.Table)
   cons(end+1)={contable2(NF,'breakx',cout.Table{n}{2},'breaky',cout.Table{n}{1},...
         'table',cout.Table{n}{3},...
         'factors',cout.Table{n}{4},'le',cout.Table{n}{5})};
end
return