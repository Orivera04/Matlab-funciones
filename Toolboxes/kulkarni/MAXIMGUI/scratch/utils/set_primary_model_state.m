function set_primary_model_state(pid, state)

% for the primary_model specified, function sets the corresponding value
% of the state variable in the global primary model structure to the state specified

global Primary_state

% set all states back to zero
for k = 1:size(Primary_state, 2)
  Primary_state(k).state = 0 ;
end

% set new state
Primary_state(pid).state = state ;
