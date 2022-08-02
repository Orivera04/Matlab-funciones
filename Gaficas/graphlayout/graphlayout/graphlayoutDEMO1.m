load smallExample 
nodeColors = {'g','b','r','c'}; % if too few specified, it will cycle through
graphlayout('adjMatrix',adj,'nodeLabels',names,'currentLayout',treelayout,'nodeColors',nodeColors);
