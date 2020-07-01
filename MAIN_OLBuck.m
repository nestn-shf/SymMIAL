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
system_name = 'system_OLBuck';

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
data_name = 'data_OLBuck';

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

system = system_OLBuck;
param = data_OLBuck;

%[system.vector.systemInput{:,1}]'
%[system.vector.state{:,1}]'
%[system.vector.elements{:,1}]'

[1:length(system.vector.systemInput); [system.vector.systemInput{:,1}]; vpa([param.u(:).val])]'
[1:length(system.vector.state); [system.vector.state{:,1}]]'
[1:length(system.vector.elements); [system.vector.elements{:,1}]; vpa([param.el(:).val])]'

%% check stability -------------------------------------------------------

%param.el(7).val = 0.5;

fr_buck = 1/(2*pi*sqrt(param.el(1).val*param.el(2).val))


systemFunction = system.equation.anonDifferential;
matrixAFunction = system.equation.analyticMatrixA;
matrixBFunction = system.equation.analyticMatrixB;
matrixCFunction = system.equation.analyticMatrixC;
matrixDFunction = system.equation.analyticMatrixD;
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
matB = matrixBFunction(C{:});
matC = matrixCFunction(C{:});
matD = matrixDFunction(C{:});
eigenvals = sort(eig(matA));
ii = find(real(eigenvals)>=0);
eigenvals2 = sort(eigenvals)
isUnstable = any(real(eigenvals2(:)) > 0)

clear systemFunction matrixAFunction options reducedFunction C outputFunction ii eigenvals

%%
[system.vector.systemInput{:}]'
[system.vector.output{:}]'

sys = ss(matA,matB,matC,matD);

DtoVout = sys(1,2);

options = bodeoptions;
options.FreqUnits = 'Hz'; % or 'rad/second', 'rpm', etc.
figure(1)
bode(DtoVout, options)
grid on

%%
fs = 100e3;
Ts = 1/fs;
Td = 0.5*Ts;

%DiscreteplantwithZOH,KdandTd
Gpz = c2d(DtoVout,Ts,'zoh');

sisotool(Gpz)

%%
tf(controller)
%zpk(controller)
[num,den,Ts] = tfdata(controller);
tf(num,den,Ts,'variable','z^-1')

%sys_c_dt = ss(controller)
%pid(controller)

sys_c_ct = ss(d2c(controller,'tustin'))
