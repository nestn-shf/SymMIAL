function genStrInput(system)

   for ii = 1:length(system.vector.systemInput)
      name = system.vector.systemInput{ii};
      fprintf('index = %d;\nparam.u(index).name = getName(%s);\nparam.u(index).val = %s;\nparam.u(index).lowerbound = (1-var_frac)*param.u(index).val;\nparam.u(index).upperbound = (1+var_frac)*param.u(index).val;\nparam.u(index).pdf = makedist(''Uniform'', ''lower'', param.u(index).lowerbound, ''upper'', param.u(index).upperbound);\n',ii, name, name);
       
   end

end