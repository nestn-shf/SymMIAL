function [X1, X2, X] = generateSetForVBSA(elements_to_test, inputs_to_test, N, paths)

variables = length(elements_to_test);

set = sobolset(2*variables);
totaldata_unit = net(set,N);

X1 = totaldata_unit(:,1:variables);
X2 = totaldata_unit(:,(variables+1):(2*variables));

currentFolder = paths.currentFolder;
subfolder_data = 'r_data';
subfolder_function = 'r_functions';
sRscript = paths.sRscript;

file = 'X.csv';
sx = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
file = 'X1.csv';
sx1 = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
csvwrite(sx1,X1);
file = 'X2.csv';
sx2 = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
csvwrite(sx2,X2);

file = 'generateScenariosA.R';
data_location = sprintf('%s\\%s', currentFolder, subfolder_data);
data_location = strrep(data_location,'\','/');

toeval = sprintf('!"%s" "%s\\%s\\%s" "%s"',sRscript, currentFolder, subfolder_function, file, data_location);
eval(toeval);

fileID = fopen('X.csv','r');
formatSpec = '%f';
X = fscanf(fileID, formatSpec, [variables,inf])';
fclose('all');

delete(sx1);
delete(sx2);
delete(sx);

end