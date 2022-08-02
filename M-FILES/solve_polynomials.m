%                               431-400 Year Long Project 
%                           LA1 - Medical Image Processing 2003
%  Supervisor     :  Dr Lachlan Andrew
%  Group Members  :  Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%                    Lee Siew Teng   102519  s.lee1@ugrad.unimelb.edu.au
%                    Loh Jien Mei    103650  j.loh1@ugrad.unimelb.edu.au
% 
%  File and function name : solve_polynomials
%  Version                : 1.0
%  Date of completion     : 19 December 2003   
%  Written by    :   Alister Fong    78629   a.fong1@ugrad.unimelb.edu.au
%
%  Inputs        :  
%               2 coefficient matrices as given by the "polyfit" function
%               ======================================================================
%                                       WARNING    
%               ======================================================================
%               For proper output from the "polyfit" function, 
%               DO NOT use extract the Mu output
%                   i.e.
%                   DO NOT USE THE FOLLOWING STATEMENT:
%                       [P,S,Mu] = polyfit(input_coordsX,input_coordsY,poly_degree);
%                   USE :
%                       [P2,S2] = polyfit(input_coordsX,input_coordsY,poly_degree);
%               ======================================================================
%
%  Outputs       :  
%               intersection_coords - The [X,Y] coordinates of the intersection 
%                                     between the two polynomial coefficients.
%                                     Returns an empty matrix if no intersections 
%                                     are found
%               real_intersection    - The real coordinates of intersection_coords
%               complex_intersection - The complex coordinates of intersection_coords
%               polystr - The string representation of the input matrices as 
%                         required by the "solve" function to process.
%
%  Description   : 
%       To find the intersection between 2 polynomials
%
%  To Run >> [intersection_coords,real_intersection,complex_intersection,polystr]=...
%                      solve_polynomials(P1,P2);
%
%  Example >> 
%            [P1,S1] = polyfit(inputX1,inputY1,polydegree);
%            [P2,S2] = polyfit(inputX2,inputY2,polydegree);
%            [coords,real_coord,complex_coord,polystr] = solve_polynomials(P1,P2);
%            X = [1:1:Xmax];
%            Y1 = polyval(P1,X,S1);
%            Y2 = polyval(P2,X,S2);
%            plot(X,Y1,'b.-');
%            plot(X,Y2,'g.-');
%            plot(real_coord(:,1),real_coord(:,2),'r*');

function [intersection_coords,real_intersection,complex_intersection,polystr] = ...
                solve_polynomials(varargin)
% ------------------------------------------------------------------------------
% Check the number of inputs
% ------------------------------------------------------------------------------
if (length(varargin) < 2)
    error('There must be more then 1 set of polynomial coeficients');
end

% ------------------------------------------------------------------------------
% Ensure that there are no "inf" or "nan"
% ------------------------------------------------------------------------------
for n = 1:1:length(varargin)
    if ~isempty(find(isnan(varargin{n}) | isinf(varargin{n})))
        error('"inf" or "nan" detected');
    end
end

% ------------------------------------------------------------------------------
% Converts the matrices to a string format that can be understion by "solve"
% ------------------------------------------------------------------------------
polystr = {};
for n = 1:1:length(varargin)
    coeff = varargin{n};
    %Coefficients are to be in accending order of degree
    coeff = coeff([length(coeff):-1:1]);
    tempstr = num2str(coeff(1));
    for m = 2:1:length(coeff)
        if (tempstr(1) == '-')
            % If the previous coefficient is a negative, do not place a "+" sign
            if m==2
                tempstr = strcat(num2str(coeff(m)),'*x',tempstr);
            else
                tempstr = strcat(num2str(coeff(m)),'*x^',num2str(m-1),tempstr);
            end
        else
            if m==2
                tempstr = strcat(num2str(coeff(m)),'*x+',tempstr);
            else
                tempstr = strcat(num2str(coeff(m)),'*x^',num2str(m-1),'+',tempstr);
            end
        end
    end
    tempstr = strcat('y=',tempstr);
    polystr = {polystr{:} tempstr};
end

% ------------------------------------------------------------------------------
% Solve the polynomial equations
% ------------------------------------------------------------------------------
warning off
results = solve(polystr{:});

% ------------------------------------------------------------------------------
% Extract the results and format them into a numeric form
% ------------------------------------------------------------------------------
intersection_coords = [];
if ~isempty(results)
	X = struct(results.x);
	Y = struct(results.y);
	for n = 1:1:length(X)
        intersection_coords = [intersection_coords; str2num(X(n).s),str2num(Y(n).s)];
	end
end

% ------------------------------------------------------------------------------
% Finds the real and complex intersections
% ------------------------------------------------------------------------------
real_intersection = [];
complex_intersection = [];
if ~isempty(intersection_coords)
    %Finds all real coordinates in the intersection_coords
    for n = 1:1:length(intersection_coords(:,1))
        if isreal(intersection_coords(n,:))
            real_intersection = [real_intersection;intersection_coords(n,:)];
        end
    end
    %Finds all imaginary coordinates in the intersection_coords
    for n = 1:1:length(intersection_coords(:,1))
        if ~isreal(intersection_coords(n,:))
            complex_intersection = [complex_intersection;intersection_coords(n,:)];
        end
    end
end
