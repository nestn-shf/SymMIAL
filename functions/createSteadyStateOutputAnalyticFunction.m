function sysWithSteadystateFunc = createSteadyStateOutputAnalyticFunction(system)

strEqn = 'system.equation.analyticSteadystateOutput';

strVars = char(symvar(system.equation.analyticSteadystateOutput));
strVars = strrep(strVars,'[','');
strVars = strrep(strVars,']','');
strVars = strrep(strVars,'(','');
strVars = strrep(strVars,')','');
strVars = strrep(strVars,'matrix','');

anonymFunc = eval(sprintf('@( %s )[ %s ]', strVars, strEqn));

func = matlabFunction(anonymFunc,'Optimize',false,'Vars',[system.vector.systemInput{:,1},system.vector.elements{:,1}]);

system.equation.analyticSteadystateOutputFunction = func;

sysWithSteadystateFunc = system;

end