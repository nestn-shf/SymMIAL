function printStateValues(system)
   fprintf('### STATES:\n');
   
   for ii = 1:system.numberof.states
      fprintf('%20.20s %12.3d\n', char(system.vector.state{ii}), system.numeric.x_ss2(ii)); 
   end
   
   
   fprintf('###\n');
end