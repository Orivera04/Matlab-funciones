function cost = ct_cost (std_state, scalar, vector_matrix)

% Computes cost for a Continuous Time Markov Model
global cost_parameters cost_parameter_labels

cost = [] ;
cost_parameters =[];
cost_parameter_labels =[];

switch std_state
  % General Machine Shop
  case 1
     r = add_scalar_input('General Machine Shop', 'revenue',...
        'Revenue per working machine per unit time',0) ;
    if isempty(r)
       return
    end
    dc = add_scalar_input('General Machine Shop', 'cost',...
       'Cost per unit time per down machine',0) ;
    if isempty(dc)
       return
    end
    rc = add_scalar_input('General Machine Shop', 'cost',...
       'Cost per unit time per machine under repair',0) ;
    if isempty(rc)
       return
    end
      cost_parameters = [r,dc,rc];
      cost_parameter_labels ={'Revenue per working machine per unit time', 'Cost per unit time per down machine',...
             'Cost per unit time per machine under repair'};
      cost = ex6gmscost(scalar(4), scalar(3), scalar(2), scalar(1), r, dc, rc) ; 
      
  % Finite Capacity Single Server Queue
  case 2
     hc = add_scalar_input('Single Server Queue', 'cost',...
        'Cost per unit time of holding a customer',0) ;
    if isempty(hc)
       return
    end
    lc = add_scalar_input('Single Server Queue', 'cost', 'Cost of losing a customer',0) ;
    if isempty(lc)
       return
    end
    bc = add_scalar_input('Single Server Queue', 'cost',...
       'Cost per unit time of keeping the server busy',0) ;
    if isempty(bc)
       return
    end
       cost_parameters = [hc,lc,bc];
       cost_parameter_labels ={'Cost per unit time of holding a customer', 'Cost of losing a customer',...
             'Cost per unit time of keeping the server busy'};
 
       cost = ex6ssqcost(scalar(3), scalar(2), scalar(1), hc, lc, bc) ; 
    

  % Inventory Management
  case 3
     hc = add_scalar_input('Inventory Management', 'cost',...
        'Holding cost per machine per unit time',0) ;
    if isempty(hc)
       return
    end
    oc = add_scalar_input('Inventory Management', 'cost',...
       'Cost of placing an order',0) ;
    if isempty(oc)
       return
    end
    rev = add_scalar_input('Inventory Management', 'revenue',...
       'Net revenue from selling a machine',0) ;
    if isempty(rev)
       return
    end
       cost_parameters = [hc,oc,rev];
       cost_parameter_labels ={'Holding cost per machine per unit time', 'Cost of placing an order',...
             'Net revenue from selling a machine'};
       cost = ex6invcost(scalar(4), scalar(3), scalar(2), scalar(1), hc, oc, rev) ; 
    

  % Telephone Switch
  case 5
     hc = add_scalar_input('Telephone Switch', 'cost',...
        'Cost per unit of time of holding a call',0) ;
    if isempty(hc)
       return
    end
    lc = add_scalar_input('Telephone Switch', 'cost', 'Cost of losing a call',0) ;
    if isempty(lc)
       return
    end
       cost_parameters = [hc,lc];
       cost_parameter_labels ={'Cost per unit of time of holding a call', 'Cost of losing a call'};
       cost = ex6telcost(scalar(3), scalar(2), scalar(1), hc, lc) ; 
    

  % Call Center
  case 6
    r = add_scalar_input('Call Center', 'revenue', 'Revenue from one call',0) ;
    if isempty(r)
       return
    end
    h = add_scalar_input('Call Center', 'cost',...
       'Cost per unit time of putting a call on hold',0) ;
    if isempty(h)
       return
    end
       cost_parameters = [r,h];
       cost_parameter_labels ={'Revenue from one call', 'Cost per unit time of putting a call on hold'};
       cost = ex6cccost(scalar(4), scalar(3), scalar(2), scalar(1), r, h) ; 
    

  % Manufacturing Systems
  case 7
     rev = add_scalar_input('Manufacturing System', 'revenue',...
        'Net revenue from selling an item',0) ;
    if isempty(rev)
       return
    end
    hc = add_scalar_input('Manufacturing System', 'cost',...
       'Cost per unit time of holding an item',0) ;
    if isempty(hc)
       return
    end
    du = add_scalar_input('Manufacturing System', 'cost', 'Cost of turning a machine on',0) ;
    if isempty(du)
       return
    end
       cost_parameters = [rev,hc,du];
       cost_parameter_labels ={'Net revenue from selling an item', 'Cost per unit time of holding an item',...
             'Cost of turning a machine on'};
       cost = ex6mfgcost(scalar(4), scalar(3), scalar(2), scalar(1), rev, hc, du) ; 
    

end  % switch std_state

