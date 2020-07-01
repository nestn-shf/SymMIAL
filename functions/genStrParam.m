function genStrParam(system)

   for ii = 1:length(system.vector.elements)
      name = system.vector.elements{ii};
      fprintf('index = %d;\nparam.el(index).name = getName(%s);\nparam.el(index).val = %s;\nparam.el(index).lowerbound = (1-var_frac)*param.el(index).val;\nparam.el(index).upperbound = (1+var_frac)*param.el(index).val;\nparam.el(index).pdf = makedist(''Uniform'', ''lower'', param.el(index).lowerbound, ''upper'', param.el(index).upperbound);\n',ii, name, name);
   end
end

