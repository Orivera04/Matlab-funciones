function set_std_model_state(primary_row, std_state)

% function updates the Primary_state structure with the Standard Model selection

global Primary_state

% set all states back to zero
for k = 1:size(Primary_state, 2)
  Primary_state(k).std_state = 0 ;
end

% set new state
Primary_state(primary_row).std_state = std_state ;
