function scroll_control(vdim)

global state_vector opt_policy control_state control_policy

% Scrolls through values of a matrix using the value of the slider bar


row_dim = size(opt_policy, 2); 
offset = floor((row_dim-vdim)*(1 - get(gcbo, 'Value'))); 

maxdim = min(vdim, row_dim); 

for k = 1:maxdim
   set(control_state(k), 'String', sprintf('%i', state_vector(k+offset)));
   set(control_policy(k), 'String', sprintf('%i', opt_policy(k+offset)));
end
