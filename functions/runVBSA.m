function [S, T, V] = runVBSA(X1, X2, Y, elements_to_test, paths)

variables = length(elements_to_test);

currentFolder = paths.currentFolder;
subfolder_data = 'r_data';
subfolder_function = 'r_functions';
sRscript = paths.sRscript;

file = 'X1.csv';
sx1 = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
csvwrite(sx1,X1);

file = 'X2.csv';
sx2 = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
csvwrite(sx2,X2);

file = 'Y.csv';
sy = sprintf('%s\\%s\\%s', currentFolder, subfolder_data, file);
csvwrite(sy,Y);

file = 'sobolSaltA.R';
data_location = sprintf('%s\\%s', currentFolder, subfolder_data);
data_location = strrep(data_location,'\','/');

toeval = sprintf('!"%s" "%s\\%s\\%s" "%s"', sRscript, currentFolder, subfolder_function, file, data_location);
eval(toeval);

fileID = fopen('S.csv','r');
formatSpec = '%f';
S = fscanf(fileID, formatSpec, [variables,inf])';
fileID = fopen('T.csv','r');
formatSpec = '%f';
T = fscanf(fileID, formatSpec, [variables,inf])';
fileID = fopen('V.csv','r');
formatSpec = '%f';
V = fscanf(fileID, formatSpec, [variables,inf])';
fclose('all');

end