function sysWithSteadyState = findSteadyStateAnalytically(system)

%
assume(symvar(assumptions),'clear')

%%
% create new equation, dF/dt = 0
system.equation.steadystate = system.equation.differential;
for n = 1:length(system.equation.steadystate)
    system.equation.steadystate = subs(system.equation.steadystate, system.vector.diffstate{n,1}, 0);
end

variablesInEquation = zeros(1,length(system.equation.steadystate));
for ii = 1:length(system.equation.steadystate)
   variablesInEquation(1,ii) = length(symvarOfVars(system.equation.steadystate(ii),system.vector.state));
end

sortedEquations = zeros(1,length(system.equation.steadystate));
isMinimalEquationVector = zeros(1,length(system.equation.steadystate));
parsedEquation = zeros(1,length(system.equation.steadystate));

%%

currentSumVariables = sum(variablesInEquation(1,:));
requiredSumVariables = length(symvarOfVars(system.equation.steadystate,system.vector.state));

%disp(symvar(system.equation.steadystate(ii)));
%disp('--')

previousMinLength = intmax('int8');
lengthIsDeadEnd = [];

%%
while ( currentSumVariables ~= requiredSumVariables )
   X = ['have: ', num2str(currentSumVariables), ' need:', num2str(requiredSumVariables)];
   disp(X);
   
   %%
   %display equations
   %disp(system.equation.steadystate);
   %disp('--');
   
   for ii = 1:length(system.equation.steadystate)
      variablesInEquation(1,ii) = length(symvarOfVars(system.equation.steadystate(ii),system.vector.state));
   end
   
   currentMinLength = intmax('int8');
   % find min variable length not including already deemed minimal
   for ii = 1:system.numberof.states
      if (~ismember(variablesInEquation(1,ii), lengthIsDeadEnd))
         if ( (variablesInEquation(1,ii) < currentMinLength) && (sortedEquations(1,ii) == false) )      
            currentMinLength = variablesInEquation(1,ii);
         end
      end
   end
   if (currentMinLength ~= previousMinLength)
      parsedEquation = zeros(1,length(system.equation.steadystate));
   end
   
   % label all equations which are minimum
   numberOfMin = 0;
   for ii = 1:system.numberof.states
      if ( variablesInEquation(1,ii) == currentMinLength )      
         isMinimalEquationVector(1,ii) = true;
         numberOfMin = numberOfMin + 1;
      end
   end
   %%
   % select 1st minimum
   for ii = 1:system.numberof.states
      if ( variablesInEquation(1,ii) == currentMinLength ) 
         parsedEquation(1,ii) = true;
         indexForMinLen = ii;
         break
      end
   end
   %%
   % Select equation to use in simplification
   if ((numberOfMin ~= 1) && (currentMinLength == previousMinLength))
      deadend = 0;
      for ii = 1:system.numberof.states
         if ( (isMinimalEquationVector(1,ii) == true) && (parsedEquation(1,ii) == false) )
            parsedEquation(1,ii) = true;
            indexForMinLen = ii;
            break
         else
            deadend = deadend + 1;
         end
      end
      if (deadend == system.numberof.states)
         lengthIsDeadEnd = [lengthIsDeadEnd, currentMinLength];
      end
   end
   %%
   if (currentMinLength == 1)
      sortedEquations(1,indexForMinLen) = 1;
   end

%%   
   %disp(indexForMinLen)
   %substitute
   vars = symvarOfVars(system.equation.steadystate(indexForMinLen),system.vector.state);
   var = vars(1);
   varEquals = solve(system.equation.steadystate(indexForMinLen), var);
   
   % TODO: select appropriate steady-state value. Not implemented. Explicit
   % selection!!! TODO!
   if (length(varEquals) == 2)
      varEquals = varEquals(2);
      disp('selected solution 2')
   end
   system.equation.steadystate(indexForMinLen) = (var == varEquals);
%%
   for ii = 1:length(system.equation.steadystate)
      if (ii ~= indexForMinLen)
         system.equation.steadystate(ii) = subs(system.equation.steadystate(ii), var, varEquals);
      end
   end
%%  
   
   currentSumVariables = sum(variablesInEquation(1,:));
   previousMinLength = currentMinLength; 
end

%sort solutions to be in order x
%%
eqn = vpa(simplify(system.equation.steadystate));
for ii = 1:length(system.vector.state)
   for jj = 1:length(system.equation.steadystate)
      val = solve(eqn(jj), system.vector.state{ii});
      if ~isempty(val)
         system.equation.analyticSteadystate(ii,1) = val;
      end
   end
end

%system.equation.analyticSteadystate = simplify(system.equation.analyticSteadystate);
%%

sysWithSteadyState = system;

end