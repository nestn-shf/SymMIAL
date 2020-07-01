function sysWithSS = computeSteadyStates(system)
%COMPUTESTEADYSTATES Summary of this function goes here
%   Detailed explanation goes here

   input = {};
   n = 1;
   for ii = 1:system.numberof.systemInputs
      input{n} = system.vector.systemInput{ii,2};
      n = n + 1;
   end
   for ii = 1:system.numberof.elements
      input{n} = system.vector.elements{ii,2};
      n = n + 1;
   end

   system.numeric.x_ss = system.equation.analyticSteadystateFunction(input{:});

   system.numeric.y_ss = system.equation.analyticSteadystateOutputFunction(input{:});

   for ii = 1:system.numberof.states
      input{n} = system.numeric.x_ss(ii,1);
      n = n + 1;
   end
   
system.numeric.A = system.equation.analyticMatrixA(input{:});
system.numeric.B = system.equation.analyticMatrixB(input{:});
system.numeric.C = system.equation.analyticMatrixC(input{:});
system.numeric.D = system.equation.analyticMatrixD(input{:});

   sysWithSS = system;
   
end

