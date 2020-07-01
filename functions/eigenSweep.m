function eigVals = eigenSweep(system, varIndex, mininmum, maximum, N)

%arr = eigenSweep(system.equation.analyticMatrixA, input, 2, 80, 90, 20);

arr.val = zeros(N, 1);
arr.eig = zeros(N, system.numberof.states);
arr.unstable = zeros(N, 1);
arr.unstableAndVal = zeros(N, 2);
arr.becomesUnstable = 0;

%%
diff = maximum - mininmum;
mid = (maximum + mininmum)/2;
del = diff/N;

  
for ii = 1:N
   param_val = mininmum + del*(ii-1);
   
   arr.val(ii) = param_val;
   arr.unstableAndVal(ii,2) = param_val;
   
   input = {};
   n = 1;
   for jj = 1:system.numberof.systemInputs
      input{n} = system.vector.systemInput{jj,2};
      n = n + 1;
   end
   for jj = 1:system.numberof.elements
      input{n} = system.vector.elements{jj,2};
      n = n + 1;
   end
   input{varIndex} = param_val;

   x_ss = system.equation.analyticSteadystateFunction(input{:});
   %y_ss = system.equation.analyticSteadystateOutputFunction(input{:});

   for jj = 1:system.numberof.states
      input{n} = x_ss(jj,1);
      n = n + 1;
   end
   
   matA = system.equation.analyticMatrixA(input{:});
   
  
   
   eigs = eig(matA);
   arr.unstable(ii) = 0;
   
   for jj = 1:length(eigs)
      arr.eig(ii,jj) = eigs(jj); 
      if (real(eigs(jj)) > 0)
         arr.unstable(ii) = 1;
         arr.unstableAndVal(ii,1) = 1;
         arr.becomesUnstable = 1;
      end
   end
   
end


%Find eigenvalue which is closes to zero
val = 0; %value to find
tmp = abs(real(arr.eig)-val);
[M1,I1] = min(tmp);
[M2,I2] = min(M1);

arr.nearZeroAtRow = I1;
arr.criticalEigenvalue = I2;

eigVals = arr;

end