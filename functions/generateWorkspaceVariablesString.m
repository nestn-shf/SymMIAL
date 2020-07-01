function evalStr = generateWorkspaceVariablesString(system)

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