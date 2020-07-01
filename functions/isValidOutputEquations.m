function boolean = isValidOutputEquations(system)
   % Check if output equations valid (contains only state and input):
   %
   %
   for k = 1:length(system.equation.output)
       % only select inputs
       for m = 1:length(system.vector.toremoveinput)
           if( has(system.equation.output{k,1}, system.vector.toremoveinput{m,1}) )
               fprintf('OUTPUT EQN %d HAS INPUT: %s\n',k, char(system.vector.toremoveinput{m,1}));
           end
       end
       % only single output
       validout = system.vector.output{k,1};
       outputval = symvar(system.equation.output{k,1});

       for m = 1:length(system.vector.output)
           for n = 1:length(outputval)
               if ((outputval(n) ~= validout) && (outputval(n) == system.vector.output{m,1}))
                   fprintf('OUTPUT EQN %d HAS VESTIGIAL OUTPUT: %s\n',k, char(system.vector.output{m,1}));
               end  
           end
       end
   end
      boolean = true;   
end