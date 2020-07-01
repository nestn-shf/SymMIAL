function combinedsystem = combine_subsystems(subsystemsVector, netlist, inputs, outputs)
% combine_subsystems  Description
%
%
%
%

system = struct;

%% Combine all seperate subsystems variables into a new system
system = amalgamateSubsystemVariables(system, subsystemsVector);

%% Generate an eval string to populate workspace with symbolic variables
system.toGenWorkspaceVarsStr = generateWorkspaceVariablesString(system);

%% Populate workspace with symbolic variables
eval(system.toGenWorkspaceVarsStr);
    
%% Copy netlist to system
system.equation.netlist = netlist;

%% Collect state, input, and output as combined output (ALL)

system.vector.outputAll = 

%% Copy specified system inputs and outputs to new system
% Inputs:
system.vector.newinput = inputs;

% Outputs (measurements):
system.vector.newoutput = outputs;

% record number of outputs & inputs
system.numberof.newinputs = length(system.vector.newinput);
system.numberof.newoutputs = length(system.vector.newoutput);



%% mark in system which variables to preserve
for ii = 1:system.numberof.newinputs
    for jj = 1:system.numberof.inputs
        if (system.vector.newinput{ii,1} == system.vector.input{jj,1})
            system.vector.input{jj,2} = 'is_input';
        end
        if (system.vector.newoutput{ii,1} == system.vector.input{jj,1})
            system.vector.input{jj,2} = 'is_output';
        end
    end
end

for ii = 1:system.numberof.newoutputs
    for jj = 1:system.numberof.outputs
        if (system.vector.newoutput{ii,1} == system.vector.output{jj,1})
            system.vector.output{jj,2} = 'is_output';
        end
    end
end
% may need to add marked inputs which become measured outputs

%% identify variables that need removing
% any value in vector.input which is unmarked
removenum = 0;
for k = 1:length(system.vector.input)
    if( isempty(system.vector.input{k,2}) )
        removenum = removenum + 1;
        system.vector.toremoveinput{removenum,1} = system.vector.input{k,1};
    end
end
% any value in output vector which does not exist in specified output
removenum = 0;
for k = 1:length(system.vector.output)
    if( isempty(system.vector.output{k,2}) )
        removenum = removenum + 1;
        system.vector.toremoveoutput{removenum,1} = system.vector.output{k,1};
    end
end

%% incorporate netlist rules into system by replacing amalgamated input equations
for k = 1:length(system.equation.netlist)
    for m = 1:length(system.vector.toremoveinput)
        if( has(system.equation.netlist{k,1}, system.vector.toremoveinput{m,1}) )
            toremoveinputequals = solve(system.equation.netlist{k,1},system.vector.toremoveinput{m,1});
            for n = 1:length(system.equation.differential)
                system.equation.differential{n,1} = subs(system.equation.differential{n,1}, system.vector.toremoveinput{m,1}, toremoveinputequals);
            end
            
            for n = 1:length(system.equation.output)
                system.equation.output{n,1} = subs(system.equation.output{n,1}, system.vector.toremoveinput{m,1}, toremoveinputequals);
            end      
        end
    end
end

%% transform via substitutions to make output equations valid

for arb = 1:5 %TODO: This is arbitrary permute, i.e. loop N times and hope it completes
    for n = 1:length(system.equation.output)
        outputval = system.vector.output{n,1};%symvar(system.equation.output{n,1},1);
        outputvalequals = solve(system.equation.output{n,1}, outputval, 'ReturnConditions', false);

        for m = 1:length(system.equation.output)
            if (m ~= n)
                system.equation.output{m,1} = subs(system.equation.output{m,1}, outputval, outputvalequals);
            end
        end

        system.equation.output{n,1} = (system.vector.output{n,1} == solve(system.equation.output{n,1}, system.vector.output{n,1}, 'ReturnConditions', false));
    end
end

%% incorporate outputs as system inputs

for n = 1:length(system.equation.output)
    outputval = system.vector.output{n,1};
    outputvalequals = solve(system.equation.output{n,1}, outputval);
    for m = 1:length(system.equation.differential)
        system.equation.differential{m,1} = subs(system.equation.differential{m,1}, outputval, outputvalequals);
    end
end    

isValidStateEquations(system);
isValidOutputEquations(system);
printEquations(system);

%% Copy system to new system

newsystem = struct;

newsystem.numberof.states = system.numberof.states;
newsystem.numberof.elements = system.numberof.elements;
newsystem.numberof.inputs = system.numberof.newinputs;
newsystem.numberof.outputs = system.numberof.newoutputs;

newsystem.ident.diffstate = system.ident.diffstate;
newsystem.ident.state = system.ident.state;
newsystem.ident.element = system.ident.element;

newsystem.equation.differential = system.equation.differential;

newsystem.vector.diffstate = system.vector.diffstate;
newsystem.vector.state = system.vector.state;
newsystem.vector.input = system.vector.newinput;
newsystem.vector.output = system.vector.newoutput;
newsystem.vector.elements = system.vector.elements;

% only take relevant output equations
numout = 0;
for n = 1:length(system.vector.newoutput)
    for m = 1:length(system.equation.output)
        if (has(system.equation.output{m,1}, system.vector.newoutput{n,1}))
            numout = numout + 1;
            newsystem.equation.output{numout,1} = system.equation.output{m,1};
        end
    end
end

% only take relevant output var
numout = 0;
for n = 1:length(system.vector.output)
   if ( ~isempty(system.vector.output{n,2}) )
      numout = numout + 1;
      newsystem.ident.output{numout,1} = system.ident.output{n,1};
      newsystem.ident.output{numout,2} = system.ident.output{n,2};
   end
end

% only take relevant input var
numout = 0;
for n = 1:length(system.vector.input)
   if ( ~isempty(system.vector.input{n,2}) )
      numout = numout + 1;
      newsystem.ident.input{numout,1} = system.ident.input{n,1};
      newsystem.ident.input{numout,2} = system.ident.input{n,2};
   end
end

newsystem.toGenWorkspaceVarsStr = generateWorkspaceVariablesString(newsystem);

combinedsystem = newsystem;
end


%% LOCAL FUNCTION %%
function printEquations(system)
   fprintf('##########\n');
   for k = 1:system.numberof.states
       fprintf('%s\n',char(system.equation.differential{k,1}));
   end
   fprintf('---\n');
   for k = 1:system.numberof.outputs
       fprintf('%s\n',char(system.equation.output{k,1}));
   end
   fprintf('---\n');
   for k = 1:numel(system.equation.netlist)
       fprintf('%s\n',char(system.equation.netlist{k,1}));
   end
   fprintf('##########\n');
end

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

%% LOCAL FUNCTION %%
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

%% LOCAL FUNCTION %%
function modifiedSystem = amalgamateSubsystemVariables(system, subsystemsVector)
%% 
% 
% 
%
system.numberof.subsystems = length(subsystemsVector);
system.numberof.states = 0;
system.numberof.inputs = 0;
system.numberof.outputs = 0;
system.numberof.elements = 0;
runningState = 1;
runningInput = 1;
runningOutput = 1;
runningElement = 1;

for ii = 1:system.numberof.subsystems
   currentsubsystem = subsystemsVector(ii);
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
      system.vector.elements{runningElement, 2} = currentsubsystem.vector.elements{jj,2};
      system.vector.elements{runningElement, 3} = currentsubsystem.vector.elements{jj,3}{1,1};
      runningElement = runningElement + 1;      
   end
   
   system.numberof.states = system.numberof.states + currentsubsystem.numberof.states;
   system.numberof.inputs = system.numberof.inputs + currentsubsystem.numberof.inputs;
   system.numberof.outputs = system.numberof.outputs + currentsubsystem.numberof.outputs;
   system.numberof.elements = system.numberof.elements + currentsubsystem.numberof.elements;
end

modifiedSystem = system;
end

%% LOCAL FUNCTION %%
function evalStr = generateWorkspaceVariablesString(system)
%%
str = '';
for i = 1:(system.numberof.states)
   str = strcat(str, sprintf('syms %s %s;', system.ident.state{i,1}, system.ident.state{i,2}));    
   str = strcat(str, sprintf('syms %s %s;', system.ident.diffstate{i,1}, system.ident.diffstate{i,2}));
end

for i = 1:(system.numberof.inputs)
   str = strcat(str, sprintf('syms %s %s;', system.ident.input{i,1}, system.ident.input{i,2}));
end

for i = 1:(system.numberof.outputs)
   str = strcat(str, sprintf('syms %s %s;', system.ident.output{i,1}, system.ident.output{i,2}));
end

for i = 1:(system.numberof.elements)
   str = strcat(str, sprintf('syms %s %s;', system.ident.element{i,1}, system.ident.element{i,2}));
end

evalStr = str;
end
