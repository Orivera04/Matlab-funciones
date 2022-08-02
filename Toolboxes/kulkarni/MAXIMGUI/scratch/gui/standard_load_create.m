function standard_load_create()

global Primary_state Next_process Last_process Current_process

% If this is not the correct procedure to be executing, return to caller
if strcmp(lower(Next_process), 'standard_load_create') ~= 1
  return
end
Current_process = 'standrd_load_create';
% based upon the primary model state, launch the next set of menus
[rownum state] = get_primary_model ;

switch state
  % Standard Model selected 
  case 2    
    Next_process = 'select_standard_model' ;

    % create a loop that will allow Previous Screen to function
    quit = 0 ; kd=0;
    while (quit == 0)

      select_standard_model(rownum) ; 
      std_state = get_std_model_state(rownum) ;

      % get scalar input - continue looping until input is valid
      if strcmp(lower(Next_process), 'scalar_input')
         valid_scalar_input = 0 ;
         while (valid_scalar_input == 0)
            valid_scalar_input = scalar_input(rownum, std_state) ;
         end
         if strcmp(lower(Next_process), 'vector_input')
           get_vector_size(rownum,std_state);
        end

      end
      
     
     
     
     
      % get distributional input where necessary
      %kd gives the numerical id of the input distribution; 
     if strcmp(lower(Next_process), 'distribution_input')
        kd = distribution_input(rownum, std_state); 
     end
     
     if strcmp(lower(Next_process), 'distribution_parameter_input')
        valid_distribution_input = 0;
        while (valid_distribution_input == 0)
           valid_distribution_input = distribution_parameter_input(kd,rownum, std_state) ;
        end
                
        if strcmp(lower(Next_process), 'vector_input')
           get_vector_size(rownum,std_state);
        end
     end
     

      % get vector input where necessary
      if strcmp(lower(Next_process), 'vector_input')
          valid_vector_input = 0 ;
          while (valid_vector_input == 0)
             valid_vector_input = vector_input(rownum, std_state) ;
          end
          if strcmp(lower(Next_process), 'matrix_input')
             get_matrix_size(rownum,std_state);
          end
       end

      % get matrix input where necessary
      if strcmp(lower(Next_process), 'matrix_input')
        valid_matrix_input = 0 ;
        while (valid_matrix_input == 0)
          valid_matrix_input = matrix_input(rownum, std_state) ;
        end 
      end
     
     

      % call the workbench (the workbench module will determine which
      % menu is appropriate given the current state)
      workbench(kd,rownum, std_state) ;

      if (strcmp(lower(Next_process), 'select_mode') ...
         | strcmp(lower(Next_process), 'quit'))
        quit = 1 ;                       
      end 
    end  %while quit

  % Load Model selected
case 3
   
   Next_process = 'edit_existing_model';
   quit = 0;
       
    while (quit == 0)
       if (strcmp(lower(Next_process), 'edit_existing_model'))
          valid_input = edit_existing_model(rownum);
          while(valid_input == 0)
             valid_input=edit_existing_model(rownum);
          end

          workbench(0,rownum,-1)
       end

       if (strcmp(lower(Next_process), 'maxim_main') ...
             | strcmp(lower(Next_process), 'select_mode') ...
             | strcmp(lower(Next_process), 'quit'))
          quit = 1 ;                       
       end
    end
    if strcmp(lower(Next_process), 'maxim_main')
       close all ;
       maxim_main ;
    end
  
         
    
    
    
  % Create a Model selected
  case 4          

    Next_process = 'new_model_input';
    quit = 0;
    while (quit == 0)
       if (strcmp(lower(Next_process), 'new_model_input'))
          valid_input = new_model_input(rownum);
          while(valid_input == 0)
             valid_input=new_model_input(rownum);
          end
          workbench(0,rownum,0)
       end
       if (strcmp(lower(Next_process), 'maxim_main') ...
             | strcmp(lower(Next_process), 'select_mode') ...
             | strcmp(lower(Next_process), 'quit'))
          quit = 1 ;                       
       end
    end
    

    % If we came here from Previous Screen, restart main module
    if strcmp(lower(Next_process), 'maxim_main')
       close all ;
       maxim_main ;
    end

end 

