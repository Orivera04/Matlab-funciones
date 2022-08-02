function sys_out=mv2sl(md, Xmodels, file, parentsys, DO_PEV)
% MODELDEV/MVSL build a SIMULINK version of model 
% 
% This function will build a simulink version of the dialup
% facility.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 08:10:42 $




%% IS THIS WHAT WE WANT TO DO????
%% currently parentsys argument is ignored....system named using the filename

[path, filename, ext]=fileparts(file);
parentsys=validmlname(filename);
fl =fullfile(path,parentsys); %% == fl
try 
	open_system(file);
catch
	newsys=new_system('tmp');
	set_param(newsys,'name',parentsys);
	save_system(newsys,fl);
end

warn = warning;
warning on;

mlist= Xmodels;

if ~isa(mlist,'cell')
   mlist = {mlist};
end

for i=1:length(mlist)
   if i > 1 
      [oldc,oldw,oldh] = LTRB2Centre(get_param(blk,'position'));     
   end
   % Build the model
   [blk,blk_name,mod] = mv2sl(mlist{i},DO_PEV,parentsys);
   if i > 1
      % Ensure next block doesn't overlap previous
      [newc,neww,newh] = LTRB2Centre(get_param(blk,'position'));
      centre = oldc + [ceil(oldw/2 + neww/2 + 30), 0];
      set_param(blk,'position',Centre2LTRB(centre,neww,newh));
   end
   % Build model constraints
   mod_const = constraintbuild(mlist{i},blk_name,md);
   % Position the constraints sub-system within the model block
   [centre,width,height] = LTRB2Centre(get_param(mod,'position'));
   centre(2) = centre(2) + height + 40;
   set_param(mod_const,'position',Centre2LTRB(centre,width,height));
   if ~strcmp(blk_name,parentsys)
      % Add line between model input and constraints input
      line = [get_param(mod,'inport');get_param(mod_const,'inport')];
      add_line(blk_name,line);
      % Add a new outport
      out = add_block('built-in/Outport',[blk_name '/Constraints']);
      centre = get_param(mod_const,'outport') + [80 0];
      set_param(out,'position',Centre2LTRB(centre,20,20));
      add_line(blk_name,'Constraint Block/1','Constraints/1');
   end
end

% save system
save_system(parentsys,fl);
set_param(parentsys,'open','on');
if nargout>0
   sys_out = blk;
end

warning(warn);