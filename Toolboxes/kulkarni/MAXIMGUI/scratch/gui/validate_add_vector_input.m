function valid_input = validate_add_vector_input(varname,vector_input);
global state_vector
valid_input=0; 
if any(vector_input == Inf)
   e=msgbox(sprintf('Numeric Value Expected for %s.',varname));
   uiwait(e);
   return
end


% check for valid input 
switch varname
case {'target_set'}
   for k=1:size(vector_input,2)
      wrong = 0;
      id = find(state_vector == vector_input(k));
      if isempty(id) | size(id,2) > 1
         wrong = 1;
      end
   end
   if wrong == 1
      e=msgbox('Invalid value for a target state');
      uiwait(e);
   else
      valid_input = 1;
   end
   
case 'state_vector'
   if  any(fix(vector_input)-vector_input ~= 0)
      e=msgbox('State labels must be integers');
      uiwait(e);
   else
      valid_input = 1;
   end
   
case 'action_vector'
   if  any(fix(vector_input)-vector_input ~= 0)
      e=msgbox('Action labels must be integers');
      uiwait(e);
   else
      valid_input = 1;
   end
   

   
case 'sojourn_time_vector'
   if any(vector_input <=0) 
      e=msgbox('Mean sojourn times must be positive');
      uiwait(e);
   else
      valid_input = 1;
   end


case 'init_dist'
   if any(vector_input < 0) | abs(sum(vector_input)-1) > .00001
      e=msgbox('Invalid value for the initial distribution');
      uiwait(e);
   else
      valid_input = 1;
   end

case 'cost_rate'
   valid_input = 1;
   

case 'lumpsum_cost'
   valid_input = 1;
  
case 'cost'
   valid_input = 1;
   
case 'revenue'
   valid_input =1;
   
   
end %switch varname

