function genStrState(system)

   for ii = 1:length(system.vector.state)
      name = system.vector.state{ii};
      fprintf('index = %d;\nparam.x(index).name = getName(%s);\nparam.x(index).val = 0;\nparam.x(index).guess = %s_guess;\n\n',ii,system.vector.state{ii},system.vector.state{ii});
       
   end

end