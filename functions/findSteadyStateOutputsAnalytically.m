function sysWithSteadyState = findSteadyStateOutputsAnalytically(system)

eval(system.toGenWorkspaceVarsStr);

for ii = 1:length(system.equation.output)
   equals = solve(system.equation.output{ii}, system.vector.output{ii});
   system.equation.analyticSteadystateOutput(ii,1) = vpa(equals);
end   

for ii = 1:length(system.equation.output)
   for jj = 1:system.numberof.states
      system.equation.analyticSteadystateOutput(ii,1) = ...
         subs(system.equation.analyticSteadystateOutput(ii,1), system.vector.state(jj), system.equation.analyticSteadystate(jj,1));
   end
   
end

system.equation.analyticSteadystateOutput = simplify(system.equation.analyticSteadystateOutput);

sysWithSteadyState = system;

end