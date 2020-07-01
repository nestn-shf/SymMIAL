function sysWithJacobian = addJacobian(system)

% Calculate Jacobian

%% Create state 'x' and differential equation 'F'
for ii = 1:length(system.vector.state)
    system.statespace.x(ii,1) = system.vector.state{ii,1};
    system.equation.F(ii,1) = solve(system.equation.differential{ii,1}, system.vector.diffstate{ii,1});
end

%% Create input 'u'
for ii = 1:length(system.vector.systemInput)
    system.statespace.u(ii,1) = system.vector.systemInput{ii,1};
end

%% Create output vector 'y' and output equations F

% y will be state;internalInput;output
yindex = 1;
%{
for ii = 1:length(system.vector.state)
    system.statespace.y(yindex,1) = system.vector.state{ii,1};
    system.equation.G(yindex,1) = system.vector.state{ii,1};
    yindex = yindex + 1;
end

for ii = 1:length(system.vector.internalInput)
   system.statespace.y(yindex,1) = system.vector.internalInput{ii,1};
   system.equation.G(yindex,1) = solve(system.equation.internalInputs{ii,1}, system.vector.internalInput{ii,1});
   yindex = yindex + 1;
end
%}

for ii = 1:length(system.vector.output)
   system.statespace.y(yindex,1) = system.vector.output{ii,1};
   system.equation.G(yindex,1) = solve(system.equation.output{ii,1}, system.vector.output{ii,1});
   yindex = yindex + 1;
end

%%
%system.equation.G(yindex,1) = solve(system.equation.output{ii,1}, system.vector.output{ii,1});
%}
%%

system.statespace.A = jacobian(system.equation.F, system.statespace.x);
system.statespace.B = jacobian(system.equation.F, system.statespace.u);
system.statespace.C = jacobian(system.equation.G, system.statespace.x);
system.statespace.D = jacobian(system.equation.G, system.statespace.u);

sysWithJacobian = system;

end