function mpc555pil_replace_config_subsys(action, libName, srcBlkName, fullDstBlkName)
%MPC555PIL_INSERT_CONFIG_SUBSYS  Insert Configurable Subsystem in place of original block

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.7 $ $Date: 2002/11/05 11:11:33 $

% Get names needed to do replacement                                       
fullSrcBlkName = sprintf([libName, '/', srcBlkName]);                      
[dstModel, dstBlkName] = strtok(fullDstBlkName, '/');                      
% get rid of leading /                                                     
dstBlkName = dstBlkName(2:end);                             

% Make sure the original model is open                                     
load_system(dstModel);                                                     

% check whether dstBlkName is already in the dstModel
blockX = find_system(dstModel, 'name', dstBlkName);
[rows, cols] = size(blockX);                        
if (rows == 0) & (action == 'revert')                        
  return;                          
end                                                                        

% check whether srcBlkName is already in the dstModel
blockX = find_system(dstModel, 'name', srcBlkName);                        
[rows2, cols] = size(blockX);                        
if (rows2 ~= 0) & (action == 'insert')
  return;                                       
end                                                                        

% Get block parameters from destination block                           
dstPos = get_param(fullDstBlkName, 'Position');                           
dstParent = get_param(fullDstBlkName, 'Parent');

% Open parent system of the destination block
open_system(dstParent);

% Delete destination block and copy in the source block                    
newFullDstBlkName = sprintf([dstParent, '/', srcBlkName]);                 
delete_block(fullDstBlkName);                                              
add_block(fullSrcBlkName, newFullDstBlkName, 'Position', dstPos);          

switch action                                                              
case 'insert'                                                              
  % No further action                                                        
case 'revert'                                                              
  % Break library link on new destination block if the block                 
  % in the PIL library is not a link from some other library.                
  if strcmp(get_param(fullSrcBlkName, 'LinkStatus'), 'none')                 
    set_param(newFullDstBlkName, 'LinkStatus', 'none');
  end
end