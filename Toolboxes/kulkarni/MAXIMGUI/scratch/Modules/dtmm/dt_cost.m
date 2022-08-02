function cost = dt_cost(std_state, state_vector, scalar, vector_matrix)

% Returns cost column vector for the selected DTMM
global cost_parameters cost_parameter_labels

cost = [] ;
cost_parameters =[];
cost_parameter_labels =[];

switch std_state
  % Machine Reliability
  case 1
    ru = add_scalar_input('Machine Reliability', 'revenue', 'Per day revenue of an up machine',0) ;
    if isempty(ru)
       return;
    end
    cd = add_scalar_input('Machine Reliability', 'cost', 'Per day cost of a down machine',0) ;
    if isempty(cd)
       return;
    end
    cbr = add_scalar_input('Machine Reliability', 'cost', 'Per day cost of a busy repairperson',0) ;
    if isempty(cbr)
       return;
    end

    cost_parameters = [ru,cd,cbr];
    cost_parameter_labels ={'Per day revenue of an up machine', 'Per day cost of a down machine',...
             'Per day cost of a busy repairperson'};
    cost = ex5mrcost(scalar(4), scalar(3), scalar(2), scalar(1), ru, cd, cbr)' ;
    

  % Inventory Systems
  case 3
    hc = add_scalar_input('Inventory Systems', 'cost', 'Cost of holding one item for one unit of time',0) ;
    if isempty(hc)
       return;
    end

    ps = add_scalar_input('Inventory Systems', 'profit', 'Profit from selling one item',0) ;
    
    if isempty(ps)
       return;
    end
    oc = add_scalar_input('Inventory Systems', 'cost', 'Cost of placing an order',0) ;
    if isempty(oc)
       return;
    end

    cost_parameters = [hc,ps,oc];
    cost_parameter_labels ={'Cost of holding one item for one unit of time', 'Profit from selling one item',...
             'Cost of placing an order'};
    cost = ex5invcost(scalar(2), scalar(1), vector_matrix(1,:), hc, ps, oc)' ;
    

  % Manufacturing Systems
  case 4
    r = add_scalar_input('Manufacturing Systems', 'revenue', 'Revenue from a complete assembly',0) ;
    if isempty(r)
       return;
    end
    du = add_scalar_input('Manufacturing Systems', 'cost', 'Cost of turning a machine on',0) ;
    if isempty(du)
       return;
    end
    hA = add_scalar_input('Manufacturing Systems', 'cost', 'Cost of holding an item in bin A for one period',0) ;
    if isempty(hA)
       return;
    end
    hB = add_scalar_input('Manufacturing Systems', 'cost', 'Cost of holding an item in bin B for one period',0) ;
    if isempty(hB)
       return;
    end
    cost_parameters = [r,du,hA,hB];
    cost_parameter_labels ={'Revenue from a complete assembly', 'Cost of turning a machine on',...
             'Cost of holding an item in bin A for one period', 'Cost of holding an item in bin B for one period'};
    cost = ex5mfgcost(scalar(1), scalar(2), scalar(3), scalar(4), r, du, hA, hB) ;
    

  % Manpower Systems
  case 5
     
     s = add_vector_input('Manpower Systems', 'cost', 'Salary of an employee in grade i',...
        size(state_vector, 2), state_vector,zeros(1,size(state_vector,2))); 
    if isempty(s)
       return;
    end 
    b = add_vector_input('Manpower Systems', 'cost', 'Bonus for promotion from grade i to i+1 (last element = 0)',...
       size(state_vector, 2), state_vector,zeros(1,size(state_vector,2))); 
    if isempty(b)
       return;
    end
    d = add_vector_input('Manpower Systems', 'cost', 'Cost of an employee departing from grade i',...
       size(state_vector, 2), state_vector,zeros(1,size(state_vector,2))); 
    if isempty(d)
       return;
    end
    t = add_vector_input('Manpower Systems', 'cost', 'Cost of training an employee starting in grade i',...
       size(state_vector, 2), state_vector,zeros(1,size(state_vector,2))); 
    if isempty(t)
       return;
    end
    cost_parameters = [s;b;d;t];
    cost_parameter_labels ={'Salary of an employee in grade i', 'Bonus for promotion from grade i to i+1',...
             'Cost of an employee departing from grade i', 'Cost of training an employee starting in grade i'};
    cost = ex5manpcost(vector_matrix(1,:), vector_matrix(2,:), vector_matrix(3,:), s, b, d, t); 
    

  % Telecommunications
  case 7
    rt = add_scalar_input('Telecommunications', 'revenue', 'Revenue from transmitting a single packet',0) ;
    if isempty(rt)
       return;
    end
    cl = add_scalar_input('Telecommunications', 'cost', 'Cost of losing a single packet',0) ;
    if isempty(cl)
       return;
    end
    cost_parameters = [rt,cl];
    cost_parameter_labels ={'Revenue from transmitting a single packet', 'Cost of losing a single packet'}
    cost = ex5telcost(scalar(1), vector_matrix(1,:), rt, cl) ;
    

end  % switch std_state

