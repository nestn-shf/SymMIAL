function sysWithSteadystateFunc = createSteadyStateAnalyticFunction(system)

strEqn = 'system.equation.analyticSteadystate';

strVars = char(symvar(system.equation.analyticSteadystate));
strVars = strrep(strVars,'[','');
strVars = strrep(strVars,']','');
strVars = strrep(strVars,'(','');
strVars = strrep(strVars,')','');
strVars = strrep(strVars,'matrix','');

anonymFunc = eval(sprintf('@( %s )[ %s ]', strVars, strEqn));

func = matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.systemInput{:,1},system.vector.elements{:,1}]);

system.equation.analyticSteadystateFunction = func;

sysWithSteadystateFunc = system;

end