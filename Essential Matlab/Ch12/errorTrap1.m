lasterr('1');                     % true (not empty)  
while ~isempty(lasterr)                               
lasterr('');                    % false (empty)     
f = input( 'Enter expression: ', 's' );             
f = [f ';'];       % suppress display when evaluated
eval(f, 'disp(''Dum-dum!'')');                      
                    % trap error and display message
if ~isempty(lasterr)                                
  lasterr                                           
  fprintf( 'Please try again!\n' )                  
end                                                 
end 