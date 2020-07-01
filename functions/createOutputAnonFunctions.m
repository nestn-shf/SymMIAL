function sysWithEqn = createOutputAnonFunctions(system)

%%
m = length(system.equation.output);
y = sym(zeros(1, m));
for k=1:m
    y(k) = sym(sprintf('y%d', k));
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
for jj = 1:length(system.equation.output)
   equations{jj} = system.equation.output{jj};
   
   for ii = 1:length(system.equation.output)
      equations{jj} = subs(equations{jj}, system.vector.output{ii}, y(ii));
   end
   
   for ii = 1:system.numberof.states
      equations{jj} = subs(equations{jj}, system.vector.state{ii}, x(ii));
   end
   
   for ii = 1:length(system.vector.systemInput)
      equations{jj} = subs(equations{jj}, system.vector.systemInput{ii}, u(ii));
   end
   
   for ii = 1:length(system.vector.elements)
      equations{jj} = subs(equations{jj}, system.vector.elements{ii}, el(ii));
   end
   
   strEquations{jj} = char(equations{jj});

   for ii = length(system.equation.output):-1:1
      strEquations{jj} = strrep(strEquations{jj}, char(y(ii)), sprintf('y(%d)', ii));
   end
   for ii = system.numberof.states:-1:1
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
for jj = 1:length(system.equation.output)
   if (jj == length(system.equation.output))
      strSum = strcat(strSum, strEquations{jj});
   else
      strSum = strcat(strSum, strEquations{jj},'; ');
   end
end
%%

temp1 = eval(sprintf('@(y, x, u, el)[ %s ]',strSum));

for ii = length(system.equation.output):-1:1
   s = sprintf('y(%d)', ii);
  	strSum = strrep(strSum, s, '');
   strSum = strrep(strSum, ' == ', '');
end

system.equation.anonOutput = eval(sprintf('@(x, u, el)[ %s ]',strSum));

sysWithEqn = system;

end