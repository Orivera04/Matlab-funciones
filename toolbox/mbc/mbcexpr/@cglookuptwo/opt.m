function [om,OK,msg] = opt(LT, sf)
% OPT Create an xregoptimmgr suitable for filling this table from a model
% [OM, OK, MSG] = OPT( TABLE, FEATURE );
%
% The TABLE can then be optimised 
% {TABLE, COST, OK, MSG] = RUN( OM, TABLE, [], FEATURE, PTABLE )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:27:36 $

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om= contextimplementation(xregoptmgr,LT,@i_opt,[],['Opt_' tablename],@opt);
 
mod = get(sf,'model');
eq = get(sf,'model');

if isempty(mod)
   OK = 0;
   msg = 'The subfeature has no model.';
   om = [];
   return
end

if isempty(eq)
   OK = 0;
   msg = 'The subfeature has no equation.';
   om = [];
   return
end


% get the variables in LT but not mod (usually the same, but not always)
[tableVariables , problemVar, otherVariables]= getvariables(LT,mod);

varmin = zeros( 1,  length(tableVariables) );
varmax = zeros( 1, length(tableVariables) );
numgridpts = zeros( 1, length(tableVariables) );

for i =1:length(tableVariables)
   range = tableVariables(i).get('range');
   if ~isempty(range)
      varmin(i) = range(1);
      varmax(i) = range(2);
   else % use the underlying values
      varmin(i) = min(tableVariables(i).eval);
      varmax(i) = max(tableVariables(i).eval);
   end
   Norm = get(LT, 'x');
   BP = Norm.get('BreakPoints');
   numgridpts(i) = 3*length(BP);
end

for i = 1:length(tableVariables)
   omi =  omlinspace(tableVariables(i).info, varmin(i), varmax(i), numgridpts(i));
   om= AddOption(om,['Set_' tableVariables(i).getname],omi,'xregoptmgr', tableVariables(i).getname);
end   

ovarmin = zeros( 1, length(otherVariables) );
ovarmax = zeros( 1, length(otherVariables) );
numavepts = zeros( 1, length(otherVariables) );

for i =1 :length(otherVariables)
   setpoint = otherVariables(i).get('setpoint');
   if ~isempty(setpoint)
      ovarmin(i) = setpoint;
      ovarmax(i) = setpoint;
   else % use the underlying values
      ovarmin(i) = min(otherVariables(i).eval);
      ovarmax(i) = max(otherVariables(i).eval);
   end
   numavepts(i) = 1;
end

for i = 1:length(otherVariables)
   omi =  omlinspace(otherVariables(i).info, ovarmin(i), ovarmax(i), numavepts(i));
   om= AddOption(om,['Set_' otherVariables(i).getname],omi,'xregoptmgr', otherVariables(i).getname);
end   

% add a flag to say if we are in an abnormal case or not 
% eventually make this nonguisettable

if ~isequal(problemVar,0) 
   % if the table variables are not in the model, or if there are more than the 
   % expected number of input variables to the model
   abnormalflag = 1;
else
   abnormalflag = 0;
end

if abnormalflag 
   Nx = get(LT, 'x');
   Ny = get(LT, 'y');

   xvars = Nx.getvariables(eq);
   mvars = eq.getptrs; 
   
   if isempty(xvars)
      OK = 0;
      msg = ['There are no common variables feeding into ' Nx.getname '. '];
      return   
   elseif ~isequal(intersect(double(xvars), double(mvars)), double(xvars)) 
      OK = 0;
      msg = 'There are variables in the table that are not in the model. ';
      return  
   end
   
   xvarstr = '';
   for i = 1:length(xvars)-1
      xvarstr = [xvarstr xvars(i).getname '|'];  
   end
   xvarstr = [xvarstr xvars(end).getname];
      
   yvars = Ny.getvariables(eq);
   
   if isempty(yvars)
      OK = 0;
      msg = sprintf('There are no common variables feeding into %s.', Ny.getname);
      return
   elseif ~isequal(intersect(double(yvars), double(mvars)), double(yvars)) 
      OK = 0;
      msg = 'There are variables in the table that are not in the model. ';
      return  
   end
   
   yvarstr = '';
   for i = 1:length(yvars)-1
      yvarstr = [yvarstr yvars(i).getname '|'];  
   end
   yvarstr = [yvarstr yvars(end).getname];
      
   om= AddOption(om,'xVariable',xvars(1).getname, xvarstr,['Main variable in ' Nx.getname]);
   om= AddOption(om,'yVariable',yvars(1).getname, yvarstr,['Main variable in ' Ny.getname]);
end   

om= AddOption(om,'AbnormalFlag',abnormalflag, 'boolean', [],false);
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK,msg] = i_opt(LT,om,x0,sf, p)

if isempty(sf) || ~isfeature(sf);
   OK = 0;
   msg = 'Need a subfeature input';
   cost = Inf;
   return
end   

if isempty(p)
   OK = 0;
   msg = 'Need a pointer input to the table';
   cost = Inf;
   return
end   

eq = get(sf, 'equation');
mod = get(sf, 'model');

if isempty(eq)
   OK = 0;
   msg = 'The subfeature must have an equation';
   cost = Inf;
   return
end

if isempty(mod)
   OK = 0;
   msg = 'The subfeature must have a model';
   cost = Inf;
   return
end

abnormalflag = get(om, 'AbnormalFlag');


% get the variables in the table, and the ones in the model, but not the table
[var, problem, otherVariables] = getvariables(LT, mod);

% set them according to the om 
[saveothervar, OK,msg] = setVariables(LT, otherVariables,om);

if ~OK
   resetVariables(LT, otherVariables,saveothervar);
   return
end

% grid the input variables with the given values
[savetablevar, OK, msg] = setVariables(LT, var,om);

if ~OK
   resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
   return
end

if abnormalflag % get variables to use in the table
   xstr = get(om, 'xVariable');
   ystr = get(om, 'yVariable');
   for i = 1:length(var)
      if strcmp(var(i).getname, xstr)
         x = var(i);
      elseif  strcmp(var(i).getname, ystr)  
         y = var(i);
      else % if it is not to be used as either x or y, average it
         var(i).info = var(i).set('value', mean(var(i).eval));
         % I don't set this back again....
      end   
   end      
   mainvar = [x y];
else
   mainvar = var;
   x = var(1);
   y = var(2);
end   


X = get(LT,'x');
Y = get(LT,'y');
% normaliser expressions
xin = X.get('x');
yin = Y.get('x');

% values of the model
M = evalAveOtherVariables(mod.info, mainvar);


if any(isnan(M))
     OK = 0;
     msg = 'A Nan encountered.';
     resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
     return;
elseif   any(isinf(M))
     OK = 0;
     M(isinf(M)) = 1;
     msg = 'An Inf encountered.';
elseif ~isreal(M)
   OK =0;
   msg = 'The model returned some complex numbers -- filling those entries with zero.';
   M(find(imag(M))) = 0;
end


Val = get(LT,'values');

N = size(Val);

BPx = X.invert((0:N(2)-1)');
BPy = Y.invert((0:N(1)-1)');

if ~abnormalflag % in the normal case, grid the values of the normaliser expressions
   [Xe,Ye] = ndgrid(xin.eval,yin.eval);
   Xin = Xe(:);
   Yin = Ye(:);
else % in the abnormal case
   xstore = x.eval;
   ystore = y.eval;
   % grid the variables given
   [xv,yv] = ndgrid(x.eval,y.eval);
   x.info = x.set('value',xv(:));
   y.info = y.set('value',yv(:));
   
   % evaluate the normaliser expressions for these variable values
   Xin = xin.i_eval;
   Yin = yin.i_eval;
   
   % reset the variables
   x.info = x.set('value',xstore);
   y.info = y.set('value',ystore);
end   

Jac = [];

for i = 1:length(BPx)
   for j = 1:length(BPy)
      if i == 1 
         if j == 1
            C = sparse(double(BPx(i)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j)<Yin(:) & Yin(:)<BPy(j+1)));
         elseif j==length(BPy)
            C = sparse(double(BPx(i)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j)));
         else
            C = sparse(double(BPx(i)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j+1)));
         end
      elseif i==length(BPx)
         if j == 1
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i) & BPy(j)<Yin(:) & Yin(:)<BPy(j+1)));
         elseif j==length(BPy)
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j)));
         else
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j+1)));
         end
      else
         if j == 1
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j)<Yin(:) & Yin(:)<BPy(j+1)));
         elseif j==length(BPy)
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j)));
         else
            C = sparse(double(BPx(i-1)<Xin(:) & Xin(:)<BPx(i+1) & BPy(j-1)<Yin(:) & Yin(:)<BPy(j+1)));
         end
      end
      Jac = [Jac C];
   end
end

Jac = sparse(Jac);

options = optimset('JacobPattern',Jac);

Lock = get(LT,'vlocks');
if ~any(Lock)
   %i_cost(Val(:),p,M,eq,var,N);
   Z = lsqnonlin(@i_cost,Val(:),[],[],options,p,M,eq,mainvar,N);
elseif all(Lock)
   % don't do anything
   % set the values of the variables back again
   resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
   cost = Inf;
   OK = 1;
   return
else
   Z = Val(:);
   L = Lock(:);
   LZ = Z(L==1);
   Z = Z(L==0);
   N = size(Val);   
   Ind = (1:length(Val(:)))';
   lind = Ind(L==1);
   uind = Ind(L==0);
   i_costlock(Z,p,M,eq,var,LZ,lind,uind,N);
   Z = lsqnonlin(@i_costlock,Z,[],[],[],p,M,eq,mainvar,LZ,lind,uind,N);
end

% officially set the values
Values = p.get('values');
LT = set(LT, 'values', {Values, 'Optimized'});

% set the values of the variables back again
resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);

cost = Inf;
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function out = i_cost(Z,p,M,eq,var,N)

Z = reshape(Z,N);

p.info = p.setVunofficial(Z);

E = evalAveOtherVariables(eq.info, var);

out = (M - E);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_costlock(Z,p,M,eq,var,LZ,lind,uind,N)

K = [lind LZ;uind Z];
K = sortrows(K,1);
Z = K(:,2);
Z = reshape(Z,N);


p.info = p.setVunofficial(Z);
E = evalAveOtherVariables(eq.info, var);
out = (M - E);

