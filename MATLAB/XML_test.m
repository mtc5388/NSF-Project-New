%{
Maxfield Canto, mtc5388
7/2/21
Description: MATLAB script to create and populate an XML document with artificial temperature
data for integration with SOAR SML parser.
%}

A = 23 + (25-23).*rand(10,1);                                   % Creates array of 10 random temp values between 23 and 25 (degrees C)
fake_temps = string(A);                                         % Converts temp data to a text string

%% Create Top Level (Root) XML Document Node

docNode = com.mathworks.xml.XMLUtils.createDocument('UASData'); % This is the root node, top level

%% Populate with Child Nodes

temp_node = docNode.createElement('Temperature');               % Create an Temp element to represent a single temp from the UAS
docNode.getDocumentElement.appendChild(temp_node);              % Append as a child to the root node

xmlwrite(temp_node)                                             % Write document in command window

%% Populate the Temperature Child Node With Data

units_node = docNode.createElement('Units');                    % Creates Unit element under the parent "Temperature"
units_text = docNode.createTextNode('Degrees C');               % Adds a text label to the unit node
units_node.appendChild(units_text);                             % Appends text child to the unit node
temp_node.appendChild(units_node);                              % Appends unit child to the temperature node
%{
temp_value_node = docNode.createElement('TempValue');           % Creates temperature value element under parent "Temperature"
temp_value_text = docNode.createTextNode('fake_temps(1)');                 % Adds temperature value text to the temp_value node
temp_value_node.appendChild(temp_value_text);                   % Appends text child to temp_value node
temp_node.appendChild(temp_value_node);                         % Appends temp_value child to the temperature node
%}
xmlwrite(temp_node)                                             % Write document in command window

%% For Loop to Populate More Temperature Child Nodes with Temp Values

count = 0;

for idx = 1:numel(fake_temps)
    temp_number = append('TempValue',num2str(count))
    temp_value_node = docNode.createElement(num2str(temp_number));       % Creates temperature value element under parent "Temperature"
    
    temp_value_node.appendChild(docNode.createTextNode(fake_temps{idx}));   % Creates text node and appends child for each temp value in one step
    temp_node.appendChild(temp_value_node);                     % Appends the temp value element to the top node
    count = count + 1;
end
xmlwrite(temp_node)

%% Write XML Doc to File
xmlwrite('temp_values.xml',temp_node);
