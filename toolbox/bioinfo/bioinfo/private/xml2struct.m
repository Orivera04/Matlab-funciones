function theStruct = xml2struct(filename)
% XML2STRUCT Convert an XML file into a MATLAB structure.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/02/01 21:38:03 $

%   Based on an idea by Douglas M. Schwarz, Eastman Kodak Company

try
    tree = xmlread(filename);
catch
    error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes
% This could run into problems with very deeply nested trees...
try
    theStruct = parseChildNodes(tree);
catch
    error('Unable to parse XML file %s.');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nodeStruct = makeStructFromNode(theNode)

nodeStruct = struct('Name',char(theNode.getNodeName),...
    'Attributes',parseAttributes(theNode),'Data','',...
    'Children',parseChildNodes(theNode));

if any(strcmp(methods(theNode),'getData'))
   nodeStruct.Data = char(theNode.getData); 
else
    nodeStruct.Data = '';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function attributes = parseAttributes(theNode)
% Create attributes struct
attributes = [];
if theNode.hasAttributes
    theAttributes = theNode.getAttributes;
    numAttributes = theAttributes.getLength;
    allocCell = cell(1,numAttributes);
    attributes = struct('Name',allocCell,'Value',allocCell);
    for count = 1:numAttributes
        attrib = theAttributes.item(count-1);
        attributes(count).Name = char(attrib.getName);
        attributes(count).Value = char(attrib.getValue);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function children = parseChildNodes(theNode)
% Recurse over node children
children = [];
if theNode.hasChildNodes
    childNodes = theNode.getChildNodes;
    numChildNodes = childNodes.getLength;
    allocCell = cell(1,numChildNodes);
    children = struct('Name',allocCell,'Attributes',allocCell,...
                                 'Data',allocCell,'Children',allocCell);
    for count = 1:numChildNodes
        theChild = childNodes.item(count-1);
        children(count) = makeStructFromNode(theChild);
    end
end
