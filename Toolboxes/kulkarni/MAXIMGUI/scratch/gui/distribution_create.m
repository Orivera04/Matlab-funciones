function distribution_create(k);
global Next_process Last_process Primary_state
% set all states back to zero
set_primary_model_state(1, 1);
set_std_model_state(1,k);
Last_process = 'distribution_input';
Next_process = 'standard_load_create';
standard_load_create;
