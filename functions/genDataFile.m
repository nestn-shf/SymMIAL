function genDataFile(system)

   for ii = 1:length(system.vector.systemInput)
      name = system.vector.systemInput{ii};
      fprintf('index = %d;\nparam.u(index).name = getName(%s);\nparam.u(index).val = %s;\nparam.u(index).lowerbound = (1-var_frac)*param.u(index).val;\nparam.u(index).upperbound = (1+var_frac)*param.u(index).val;\nparam.u(index).pdf = makedist(''Uniform'', ''lower'', param.u(index).lowerbound, ''upper'', param.u(index).upperbound);\n',ii, name, name);
   end
   
   
   for ii = 1:length(system.vector.elements)
      name = system.vector.elements{ii};
      fprintf('index = %d;\nparam.el(index).name = getName(%s);\nparam.el(index).val = %s;\nparam.el(index).lowerbound = (1-var_frac)*param.el(index).val;\nparam.el(index).upperbound = (1+var_frac)*param.el(index).val;\nparam.el(index).pdf = makedist(''Uniform'', ''lower'', param.el(index).lowerbound, ''upper'', param.el(index).upperbound);\n',ii, name, name);
   end

   for ii = 1:length(system.vector.state)
      name = system.vector.state{ii};
      fprintf('index = %d;\nparam.x(index).name = getName(%s);\nparam.x(index).val = 0;\nparam.x(index).guess = %s_guess;\n\n',ii,system.vector.state{ii},system.vector.state{ii});  
   end

end