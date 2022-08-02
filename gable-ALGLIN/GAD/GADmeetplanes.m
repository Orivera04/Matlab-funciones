% |
% |   MEET AND JOIN OF PLANES
% |
clf; %/
A = e1^(e2+0.1*e3); %/
B = (e1+e2)^(e2+e3); %/
draw(A,'g'); GAtext(0.35*e1+0.1*e3,'A'); %/
draw(B,'b'); GAtext(0.6*(e2+e3),'B'); %/
axis off; %/
axis([-0.6 0.9 -0.6 1 -0.75 0.75]); %/
% |
% |   The bivectors A and B.
% |
GAprompt; %/
GAorbiter(180,5); %/
GAprompt; %/
J = I3; %/
draw(J,'y'); GAtext(0.5*(e1-e2)+0.05*e3,'J \equiv A \cup B = I_3'); %/
axis([-0.6 0.9 -0.6 1 -0.75 0.75]); %/
% |
% |  Their join is the trivector I3.
% | 
GAprompt; %/
M = inner((B/J),A)
draw(M,'r'); GAtext(1.1*M,'M \equiv A \cap B = (B/I_3) \bullet A'); %/
axis([-0.6 0.9 -0.6 1 -0.75 0.75]); %/
% |
% |  Their Meet is a vector.
% |
GAprompt; %/
GAorbiter(-180,5); %/
