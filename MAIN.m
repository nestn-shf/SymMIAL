%% Add neccesary paths ---------------------------------------------------

currentFolder = pwd;
addpath(strcat(currentFolder,'\subsystems'));
addpath(strcat(currentFolder,'\systems'));
addpath(strcat(currentFolder,'\functions'));
addpath(strcat(currentFolder,'\functions_development'));
addpath(strcat(currentFolder,'\system_data'));
addpath(strcat(currentFolder,'\data'));
addpath(strcat(currentFolder,'\simulink'));
clear currentFolder;
warning('off', 'symbolic:solve:SolutionsDependOnConditions');

%% Generate/load system model --------------------------------------------
system_name = 'system_LC_CLBuck_V3';

currentFolder = pwd;
pathname = strcat(currentFolder,'\data');
dotmat = '.mat';
s = strcat(system_name,dotmat);
systemfile = fullfile(pathname, s);
if (~exist(systemfile))
   eval(sprintf('%s = generateSystems(system_name);', system_name));
   save(systemfile,system_name);
else
   load(systemfile);
end
clear systemfile pathname currentFolder dotmat s system_name;

%% Generate/load system parameters ---------------------------------------
data_name = 'data_LC_CLBuck_V3';

currentFolder = pwd;
pathname = strcat(currentFolder,'\data');
dotmat = '.mat';
s = strcat(data_name ,dotmat);
paramfile = fullfile(pathname, s);
%if (~exist(paramfile))
   eval(sprintf('%s = %s();', data_name , data_name ));
   save(paramfile,data_name);
%else
   %load(paramfile);
%end
clear paramfile pathname currentFolder dotmat s data_name;


%% set to working data ---------------------------------------------------

system = system_LC_CLBuck_V3;
param = data_LC_CLBuck_V3;

%[system.vector.systemInput{:,1}]'
%[system.vector.state{:,1}]'
%[system.vector.elements{:,1}]'

[1:length(system.vector.systemInput); [system.vector.systemInput{:,1}]; vpa([param.u(:).val])]'
[1:length(system.vector.state); [system.vector.state{:,1}]]'
[1:length(system.vector.elements); [system.vector.elements{:,1}]; vpa([param.el(:).val])]'

%param.el(1).val = 330e-6;
%param.el(2).val = 500e-6;
fr_filter = 1/(2*pi*sqrt(param.el(1).val*param.el(2).val))


fr_buck = 1/(2*pi*sqrt(param.el(5).val*param.el(6).val))

%% check stability -------------------------------------------------------
%param.u(2).val = 24;
param.el(1).val = 440e-6;
param.el(2).val = 2.2e-3;
param.el(3).val = 0.2;

%param.el(7).val = 100e-6;
%param.el(9).val = 20e-6;
%param.el(10).val = 20e-6;
fr_filter = 1/(2*pi*sqrt(param.el(1).val*param.el(2).val))

param.el(27).val = 5;

systemFunction = system.equation.anonDifferential;
matrixAFunction = system.equation.analyticMatrixA;
options = optimoptions('fsolve','Display','none');
reducedFunction = @(y) systemFunction(y, [param.u(:).val], [param.el(:).val]);

[x_ss,~,exitflag,~] = fsolve(reducedFunction, [param.x.guess], options);
if (exitflag < 1)
   disp('!!!!! no solution !!!!!!!!');
end
x_ss = x_ss';

outputFunction = system.equation.anonOutput;
y_ss = outputFunction(x_ss, [param.u(:).val], [param.el(:).val]);

C = num2cell([[param.u(:).val]'; [param.el(:).val]'; x_ss]);
matA = matrixAFunction(C{:});
eigenvals = sort(eig(matA));
ii = find(real(eigenvals)>=0);
eigenvals2 = sort(eigenvals)
isUnstable = any(real(eigenvals2(:)) > 0)

clear systemFunction matrixAFunction options reducedFunction C outputFunction matA ii eigenvals

%%

