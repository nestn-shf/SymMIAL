function sysWithEqn = createSystemSteadyStateAnonFunctions(system)

%eval(system.toGenWorkspaceVarsStr);

%%
m = system.numberof.states;
xdot = sym(zeros(1, m));
for k=1:m
    xdot(k) = sym(sprintf('xdot%d', k));
end

m = system.numberof.states;
x = sym(zeros(1, m));
for k=1:m
    x(k) = sym(sprintf('x%d', k));
end

m = length(system.vector.elements);
el = sym(zeros(1, m));
for k=1:m
    el(k) = sym(sprintf('el%d', k));
end

m = length(system.vector.systemInput);
u = sym(zeros(1, m));
for k=1:m
    u(k) = sym(sprintf('u%d', k));
end

%%

equations = {};
strEquations  = {};
for jj = 1:system.numberof.states
   equations{jj} = system.equation.differential{jj};
   
   for ii = 1:system.numberof.states
      equations{jj} = subs(equations{jj}, system.vector.diffstate{ii}, xdot(ii));
      equations{jj} = subs(equations{jj}, system.vector.state{ii}, x(ii));
   end
   
   for ii = 1:length(system.vector.systemInput)
      equations{jj} = subs(equations{jj}, system.vector.systemInput{ii}, u(ii));
   end
   
   for ii = 1:length(system.vector.elements)
      equations{jj} = subs(equations{jj}, system.vector.elements{ii}, el(ii));
   end
   
   strEquations{jj} = char(equations{jj});

   for ii = system.numberof.states:-1:1
      strEquations{jj} = strrep(strEquations{jj}, char(xdot(ii)), sprintf('xdot(%d)', ii));
      strEquations{jj} = strrep(strEquations{jj}, char(x(ii)), sprintf('x(%d)', ii));
   end
   for ii = length(system.vector.systemInput):-1:1
      strEquations{jj} = strrep(strEquations{jj}, char(u(ii)), sprintf('u(%d)', ii));
   end
   for ii = length(system.vector.elements):-1:1
      strEquations{jj} = strrep(strEquations{jj}, char(el(ii)), sprintf('el(%d)', ii));
   end
end
%%
strSum = '';
for jj = 1:system.numberof.states
   if (jj == system.numberof.states)
      strSum = strcat(strSum, strEquations{jj});
   else
      strSum = strcat(strSum, strEquations{jj},'; ');
   end
end
%%

temp1 = eval(sprintf('@(xdot, x, u, el)[ %s ]',strSum));

for ii = system.numberof.states:-1:1
   s = sprintf('xdot(%d)', ii);
  	strSum = strrep(strSum, s, '');
   strSum = strrep(strSum, ' == ', '');
end

system.equation.anonDifferential = eval(sprintf('@(x, u, el)[ %s ]',strSum));

sysWithEqn = system;

end














%{
funbaby =matlabFunction(currentEquationNoEquals{1}, currentEquationNoEquals{2},currentEquationNoEquals{3},currentEquationNoEquals{4},currentEquationNoEquals{5},currentEquationNoEquals{7},currentEquationNoEquals{6},'Optimize',false,'Vars',[system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);



%%
% create comma separated equations 
strEqn = '';
currentEquationNoEquals = {};
for ii = 1:system.numberof.states
   
   currentEquation = system.equation.differential{ii};
   currentDifferential = system.vector.diffstate{ii};
   currentEquationNoEquals{ii} = solve(currentEquation, currentDifferential);
  
   strEquation = char(currentEquationNoEquals{ii});
   
   if (ii == system.numberof.states)
      strEqn = strcat(strEqn,strEquation);
   else
      strEqn = strcat(strEqn,strEquation,', ');
   end
end


%%
% create comma sperated inputs
strVars = '';
for ii = 1:system.numberof.states
   currstr = char(system.vector.state{ii});
   strVars = strcat(strVars,currstr,', ');
end
for ii = 1:length(system.vector.systemInput)
   currstr = char(system.vector.systemInput{ii});
   strVars = strcat(strVars,currstr,', ');
end
for ii = 1:length(system.vector.elements)
   currstr = char(system.vector.elements{ii});
   if (ii == length(system.vector.elements))
      strVars = strcat(strVars,currstr);
   else
      strVars = strcat(strVars,currstr,', ');
   end
end
anonymFunc = eval(sprintf('@( %s )[ %s ]', strVars, strEqn));
system.equation.anonDifferential =matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.diffstate{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);

%% modified form (vector known/unknown form):

strEqn = '';
for ii = 1:system.numberof.states
   currentEquation = system.equation.differential{ii};
   currentDifferential = system.vector.diffstate{ii};
   currentEquationNoEquals = solve(currentEquation, currentDifferential);
   
   strCurrentDifferential = char(currentDifferential);
   strEquationNoEquals = char(currentEquationNoEquals);
   
   if (ii == system.numberof.states)
      strEqn = strcat(strEqn,strEquation);
   else
      strEqn = strcat(strEqn,strEquationNoEquals,', ');
   end
end
fun = eval(sprintf('[%s]', strEqn));

anonFun =matlabFunction(fun,'Optimize',false,'Vars',[system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);
CONST = [system.vector.systemInput{:,1}, system.vector.elements{:,1}];
VARI = [system.vector.state{:,1}];
system.equation.anonDifferential2 = @(VARI) anonFun(y,CONST);


%%

strUnknowns = '';
unknowns = [];
for ii = 1:system.numberof.states
   currElement = system.vector.state{ii};
   unknowns = [unknowns, currElement];
   currstr = char(system.vector.state{ii});
   if (ii == system.numberof.states)
      strUnknowns = strcat(strUnknowns,currstr);
   else
      strUnknowns = strcat(strUnknowns,currstr,', ');
   end
end

strKnowns = '';
knowns = [];
for ii = 1:length(system.vector.systemInput)
   currElement = system.vector.systemInput{ii};
   knowns = [knowns, currElement];
   currstr = char(system.vector.systemInput{ii});
   strKnowns = strcat(strKnowns,currstr,', ');
end
for ii = 1:length(system.vector.elements)
   currElement = system.vector.elements{ii};
   knowns = [knowns, currElement];
   currstr = char(system.vector.elements{ii});
   if (ii == length(system.vector.elements))
      strKnowns = strcat(strKnowns,currstr);
   else
      strKnowns = strcat(strKnowns,currstr,', ');
   end
end
anonymFunc = eval(sprintf('@(xdot, )[ %s ]', strEqn));
system.equation.anonDifferential2 =matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.diffstate{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);

%%

system.equation.anonDifferential2 = matlabFunction([system.equation.differential{:}],'Optimize',false,'Vars',[system.vector.diffstate{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);

%system.equation.anonOutput2 = matlabFunction([system.equation.output{:}],'Optimize',false,'Vars',{[system.vector.output{:,1}], [system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]});


%{
strEqn = 'system.equation.differential';
for ii = 1:system.numberof.states
   
   currentEquation = system.equation.differential{ii};
   
   strVars = char(symvar(currentEquation));
   strVars = strrep(strVars,'[','');
   strVars = strrep(strVars,']','');
   strVars = strrep(strVars,'(','');
   strVars = strrep(strVars,')','');
   strVars = strrep(strVars,'matrix','');
   
   anonymFunc = eval(sprintf('@( %s )[ %s(%d) ]', strVars, strEqn, ii));
   
   func = matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.diffstate{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);
   
   system.equation.anonDifferential{ii,1} = func;
end

anonymFunc = eval(sprintf('@( %s )[ %s ]', strVars, strEqn, ii));
func = matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.diffstate{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);
   
%}
%{
strEqn = 'system.equation.output';
for ii = 1:length(system.equation.output)
   
   currentEquation = system.equation.output{ii};
   
   strVars = char(symvar(currentEquation));
   strVars = strrep(strVars,'[','');
   strVars = strrep(strVars,']','');
   strVars = strrep(strVars,'(','');
   strVars = strrep(strVars,')','');
   strVars = strrep(strVars,'matrix','');
   
   anonymFunc = eval(sprintf('@( %s )[ %s(%d) ]', strVars, strEqn, ii));
   
   func = matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.output{:,1}, system.vector.state{:,1}, system.vector.systemInput{:,1}, system.vector.elements{:,1}]);
   
   system.equation.anonOutput{ii,1} = func;
end
%}

sysWithEqn = system;

end

%}
