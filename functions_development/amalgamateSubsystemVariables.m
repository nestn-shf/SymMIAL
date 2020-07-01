function modifiedSystem = amalgamateSubsystemVariables(system, subsystems)

system.numberof.subsystems = length(subsystems);
system.numberof.states = 0;
system.numberof.inputs = 0;
system.numberof.outputs = 0;
system.numberof.elements = 0;
runningState = 1;
runningInput = 1;
runningOutput = 1;
runningElement = 1;

for ii = 1:system.numberof.subsystems
   currentsubsystem = subsystems(ii);
   for jj = 1:currentsubsystem.numberof.states
      for kk = 1:size(currentsubsystem.ident.state,2)
         system.ident.diffstate{runningState,kk} = currentsubsystem.ident.diffstate{jj,kk};
         system.ident.state{runningState,kk} = currentsubsystem.ident.state{jj,kk};
      end
      system.equation.differential{runningState, 1} = currentsubsystem.equation.differential{jj,1};
      system.vector.diffstate{runningState, 1} = currentsubsystem.vector.diffstate{jj,1};
      system.vector.state{runningState, 1} = currentsubsystem.vector.state{jj,1};
      runningState = runningState + 1;
   end
   
   for jj = 1:(currentsubsystem.numberof.inputs)
      for kk = 1:size(currentsubsystem.ident.input,2)
         system.ident.input{runningInput,kk} = currentsubsystem.ident.input{jj,kk};
      end
      system.vector.input{runningInput, 1} = currentsubsystem.vector.input{jj,1};
      runningInput = runningInput + 1;
   end
   
   for jj = 1:(currentsubsystem.numberof.outputs)
      for kk = 1:size(currentsubsystem.ident.output,2)
         system.ident.output{runningOutput,kk} = currentsubsystem.ident.output{jj,kk};
      end
      system.equation.output{runningOutput,1} = currentsubsystem.equation.output{jj,1};
      system.vector.output{runningOutput, 1} = currentsubsystem.vector.output{jj,1};
      runningOutput = runningOutput + 1;
   end
   
   for jj = 1:(currentsubsystem.numberof.elements)
      for kk = 1:size(currentsubsystem.ident.element,2)
         system.ident.element{runningElement,kk} = currentsubsystem.ident.element{jj,kk};
      end
      system.vector.elements{runningElement, 1} = currentsubsystem.vector.elements{jj,1};
      runningElement = runningElement + 1;      
   end
   
   system.numberof.states = system.numberof.states + currentsubsystem.numberof.states;
   system.numberof.inputs = system.numberof.inputs + currentsubsystem.numberof.inputs;
   system.numberof.outputs = system.numberof.outputs + currentsubsystem.numberof.outputs;
   system.numberof.elements = system.numberof.elements + currentsubsystem.numberof.elements;
end

modifiedSystem = system;
end