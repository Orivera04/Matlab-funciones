function valid_input = validate_add_scalar_input(varname,scalar_input)
%validate the input collected by the add_scalar_input process.
valid_input=0; 
   if isempty(scalar_input)
      e=msgbox('Numeric input expected');
      uiwait(e);
      return;
   end;
   
   %if varname is action_id followed by letters and a number, separate the two
   if varname(1) == 'a'
      if all(varname(1:10) == 'action_id_')
      m=length(varname);
      dim = str2num(varname(14:m));
      varname=varname(1:13);
   end
end

% check for valid input 
switch varname
case {'n' } 
   if scalar_input < 0 | scalar_input - fix(scalar_input) ~= 0
      e=msgbox(sprintf('Invalid value for %s',varname));
      uiwait(e);
      return;
   else
      valid_input = 1;
   end
   
case {'Number_of_states' 'Number_of_actions'} 
   if scalar_input <= 0 | scalar_input - fix(scalar_input) ~= 0
      e=msgbox(sprintf('Invalid value for %s',varname));
      uiwait(e);
      return;
   else
      valid_input = 1;
   end
         
   
case 'number_of_targets'
   if scalar_input < 1 | scalar_input - fix(scalar_input) ~= 0
         e=msgbox('Invalid value for number of targets');
         uiwait(e);
      else
         valid_input = 1;
      end;
   
   
case 'ct_time'
   if scalar_input < 0 
         e=msgbox('Invalid value for ct_time');
         uiwait(e);
      else
         valid_input = 1;
      end;
      
   case 'action_id_new'
      load new_model_parameters action_vector;
      act = find(action_vector == scalar_input);
      if isempty(act)
         e=msgbox('Invalid value for action');
         uiwait(e);
      else
         valid_input = 1;
      end
      
   case {'action_id_ogm', 'action_id_inv', 'action_id_ops', 'action_id_omo'}
      if (scalar_input-fix(scalar_input) ~= 0 | scalar_input < 0 | ...
         scalar_input > dim)         
         e=msgbox('Invalid value for action');
         uiwait(e);
      else
         valid_input = 1;
      end

   
   otherwise
      valid_input = 1;
      
end %switch varname

   
   
