function printEquations(system)
   fprintf('##########\n');
   for k = 1:system.numberof.states
       fprintf('%s\n',char(system.equation.differential{k,1}));
   end
   fprintf('---\n');
   for k = 1:system.numberof.outputs
       fprintf('%s\n',char(system.equation.output{k,1}));
   end
   fprintf('---\n');
   for k = 1:numel(system.equation.netlist)
       fprintf('%s\n',char(system.equation.netlist{k,1}));
   end
   fprintf('##########\n');
end