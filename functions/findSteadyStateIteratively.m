function answer = findSteadyStateIteratively(system, guess)
            
U = [system.vector.systemInput{:,2}];
EL = [system.vector.elements{:,2}];

func = @(y) system.equation.anonDifferential(y,U,EL);

options = optimoptions('fsolve','Display','none','StepTolerance',1e-7); %'final'

[x,~,exitflag,~] = fsolve(func, guess, options);

if (exitflag < 1)
   disp('***WARNING***: fsolve failed to find a solution!')
end

answer = x';

end