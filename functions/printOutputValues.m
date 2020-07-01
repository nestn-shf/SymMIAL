function printOutputValues(system)
   fprintf('### OUTPUTS:\n');
   for ii = 1:length(system.vector.output)
      fprintf('%20.20s %12.3d\n', char(system.vector.output{ii}), system.numeric.y_ss2(ii)); 
   end
   
   
   fprintf('###\n');
end