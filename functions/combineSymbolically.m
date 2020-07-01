function combinedsystem = combineSymbolically(subsystems, netlist, input)
% combine_subsystems  Description
%
%

newsystem = struct;

%% Combine all seperate subsystems variables into a new system
newsystem = amalgamateSubsystemVariables(newsystem, subsystems);

%% Generate an eval string to populate workspace with symbolic variables
newsystem.toGenWorkspaceVarsStr = generateWorkspaceVariablesString(newsystem);

%% Populate workspace with symbolic variables
eval(newsystem.toGenWorkspaceVarsStr);
    
%% Copy netlist to system
newsystem.equation.netlist = netlist;

%% Copy specified input to system
newsystem.vector.specifiedInput = input;

%% Collect state, input, and output as combined output (ALL)
%newsystem.vector.outputAll = [newsystem.vector.state; newsystem.vector.input; newsystem.vector.output];

%% incorporate netlist rules into system by replacing amalgamated input equations

for ii = 1:length(newsystem.equation.netlist) %for all netlist
   
   for jj = 1:length(newsystem.vector.input) %for all inputs
      if( has(newsystem.equation.netlist{ii}, newsystem.vector.input{jj}))
         lhs = newsystem.vector.input{jj};
      end
   end
   %remove those that are inputs (lhs)
   
   rhs = solve(newsystem.equation.netlist{ii},lhs); %lhs = rhs
   
   for jj = 1:length(newsystem.equation.differential)
       newsystem.equation.differential{jj,1} = subs(newsystem.equation.differential{jj,1}, lhs, rhs);
   end

   for jj = 1:length(newsystem.equation.output)
       newsystem.equation.output{jj,1} = subs(newsystem.equation.output{jj,1}, lhs, rhs);
   end  
end

%% transform via substitutions to make output equations valid

for arb = 1:20 %TODO: This is arbitrary permute, i.e. loop N times and hope it completes
    for n = 1:length(newsystem.equation.output)
        outputval = newsystem.vector.output{n,1};%symvar(system.equation.output{n,1},1);
        outputvalequals = solve(newsystem.equation.output{n,1}, outputval, 'ReturnConditions', false);

        for m = 1:length(newsystem.equation.output)
            if (m ~= n)
                newsystem.equation.output{m,1} = subs(newsystem.equation.output{m,1}, outputval, outputvalequals);
            end
        end

        newsystem.equation.output{n,1} = (newsystem.vector.output{n,1} == solve(newsystem.equation.output{n,1}, newsystem.vector.output{n,1}, 'ReturnConditions', false));
    end
end

%% incorporate outputs as system inputs

for n = 1:length(newsystem.equation.output)
    outputval = newsystem.vector.output{n,1};
    outputvalequals = solve(newsystem.equation.output{n,1}, outputval);
    for m = 1:length(newsystem.equation.differential)
        newsystem.equation.differential{m,1} = subs(newsystem.equation.differential{m,1}, outputval, outputvalequals);
    end
end    

%% internal input equations
newsystem.equation.internalInputs = newsystem.equation.netlist;

for ii = 1:length(newsystem.vector.output) %for all output
   lhs = newsystem.vector.output{ii};
   rhs = solve(newsystem.equation.output{ii},lhs); %lhs = rhs#
   
   for jj = 1:length(newsystem.equation.internalInputs) %for all internal inputs
      newsystem.equation.internalInputs{jj,1} = subs(newsystem.equation.internalInputs{jj,1}, lhs, rhs);
   end
end

%% split input vector into internal input and system input vectors
index = 1;
for ii = 1:length(newsystem.vector.input)
   toRemove = 0;
   for jj = 1:length(newsystem.vector.specifiedInput)
      if (newsystem.vector.input{ii} == newsystem.vector.specifiedInput{jj})
         toRemove = 1;
         
         newsystem.ident.systemInput{jj,1} = newsystem.ident.input{ii,1};
         newsystem.ident.systemInput{jj,2} = newsystem.ident.input{ii,2};
      end
   end
   if (toRemove == 0)
      newsystem.vector.internalInput{index,1} = newsystem.vector.input{ii,1};
      newsystem.ident.internalInput{index,1} = newsystem.ident.input{ii,1};
      newsystem.ident.internalInput{index,2} = newsystem.ident.input{ii,2};
      index = index + 1;
   end
end

%% rearrange internal input equations:

internalInputs = newsystem.equation.internalInputs;

if (~isempty(newsystem.equation.internalInputs))
   for ii = 1:length(newsystem.vector.internalInput)
      for jj = 1:length(internalInputs)
         if( has(internalInputs{jj}, newsystem.vector.internalInput{ii}))
            newsystem.equation.internalInputs{ii} = internalInputs{jj};
         end
      end
   end
else
   newsystem.vector.internalInput = {};
   newsystem.ident.internalInput = {};
end

%%
%%printEquations(newsystem);

%% Copy system to new system

s = struct;

s.numberof.states = newsystem.numberof.states;
s.numberof.elements = newsystem.numberof.elements;
s.numberof.internalInputs = length(newsystem.vector.internalInput);
s.numberof.systemInputs = length(newsystem.vector.specifiedInput);
s.numberof.outputs = length(newsystem.vector.specifiedInput);

s.ident.diffstate = newsystem.ident.diffstate;
s.ident.state = newsystem.ident.state;
s.ident.element = newsystem.ident.element;
s.ident.internalInput = newsystem.ident.internalInput;
s.ident.systemInput = newsystem.ident.systemInput;
s.ident.output = newsystem.ident.output;

s.equation.differential = newsystem.equation.differential;
s.equation.output = newsystem.equation.output;
s.equation.internalInputs = newsystem.equation.internalInputs;

s.vector.diffstate = newsystem.vector.diffstate;
s.vector.state = newsystem.vector.state;
s.vector.elements = newsystem.vector.elements;
s.vector.internalInput = newsystem.vector.internalInput;
s.vector.systemInput = newsystem.vector.specifiedInput;
s.vector.output = newsystem.vector.output;

s.toGenWorkspaceVarsStr = newsystem.toGenWorkspaceVarsStr;

combinedsystem = s;
end
