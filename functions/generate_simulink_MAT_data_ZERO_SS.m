function generate_simulink_MAT_data_ZERO_SS(param)
%%
currentFolder = pwd;
pathname = strcat(currentFolder,'\simulink');

% controller
file = fullfile(pathname, 'simulink_model_data.mat');
%save(file,'system_controller');

mhdl = matfile(file);
mhdl.Properties.Writable = true;

%{
for ii = 1:size(param.model,2)
   eval(sprintf('mhdl.%s = %d;', param.model(ii).name, param.model(ii).val));
end
%}

for ii = 1:size(param.u,2)
   eval(sprintf('mhdl.%s = %d;', param.u(ii).name, param.u(ii).val));
end

for ii = 1:size(param.el,2)
   eval(sprintf('mhdl.%s = %d;', param.el(ii).name, param.el(ii).val));
end

for ii = 1:size(param.x,2)
   eval(sprintf('mhdl.X0_%s = %d;', param.x(ii).name, 0));
   eval(sprintf('mhdl.X0(%d,1) = %d;', ii, 0));
end

for ii = 1:size(param.m,2)
   %str = sprintf('mhdl.%s', param.m(ii).name);
   %assignin('caller', str, param.m(ii).val)
   eval(sprintf('mhdl.%s = %s;', param.m(ii).name, mat2str(param.m(ii).val)));
end

mhdl.param = param; %copy all

%%
end