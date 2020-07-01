%% LOCAL FUNCTION %%
function boolean = isValidStateEquations(system)
   % Checks if system valid (contains only state and input):
   %
   for k = 1:length(system.equation.differential)
       % only select inputs
       for m = 1:length(system.vector.toremoveinput)
           if( has(system.equation.differential{k,1}, system.vector.toremoveinput{m,1}) )
               fprintf('STATE %d HAS INPUT: %s\n',k, char(system.vector.toremoveinput{m,1}));
           end
       end
       % all previous outputs
       for m = 1:length(system.vector.output)
           if( has(system.equation.differential{k,1}, system.vector.output{m,1}) )
               fprintf('STATE %d HAS OUTPUT: %s\n',k, char(system.vector.output{m,1}));
           end
       end
   end
   boolean = true;
end