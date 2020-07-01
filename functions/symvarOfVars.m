function vars = symvarOfVars(eqn, varsToFind)

   varsA = {};
   allVars = symvar(eqn);
   n = 1;
   for ii = 1:length(allVars)
      for jj = 1:length(varsToFind)
         
         if (allVars(ii) == varsToFind(jj))
            varsA(n) = varsToFind(jj);
            n = n+1;
         end
            
      end
   end
   
   for ii = 1:length(varsA)
      vars(ii) = varsA{ii};
   end

end