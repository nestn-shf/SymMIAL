function [scn_u, scn_el, scn_ss_ic, eigVals, exitflags] = traceEigenvalues(system, param, parameterIndex, maxVal, minVal, N)
%%
   exitflags = zeros(N, 1);
   scn_ss_ic = zeros(N, system.numberof.states);
   
   systemFunction = system.equation.anonDifferential;
   matrixAFunction = system.equation.analyticMatrixA;
   options = optimoptions('fsolve','Display','none');

   %find steady-state for the nominal case, and update the guess
   reducedFunction = @(y) systemFunction(y, [param.u(:).val], [param.el(:).val]);
   x_ss = fsolve(reducedFunction, [param.x.guess], options)';
   for ii = length([param.x.guess])
      param.x(ii).guess = x_ss(ii);
   end

%%
   stepSize = (maxVal - minVal)/N;

   % copy nominal
   for jj = 1:N   
      for ii = 1:length(param.u)
         scn_u(jj,ii) = param.u(ii).val;
      end

      for ii = 1:length(param.el)
         scn_el(jj,ii) = param.el(ii).val;
      end   
   end

   % alter indexed
   for jj = 1:N   
      scn_el(jj,parameterIndex) = minVal + (jj-1)*stepSize;
   end
   % does reach final maxVal (1 stepSize before max)
   
%%     
   for ii = 1:N
      reducedFunction = @(y) systemFunction(y, scn_u(ii,:)', scn_el(ii,:)');
      [ss_ic,~,eflag,~] = fsolve(reducedFunction, [param.x.guess], options);
      exitflags(ii) = eflag;
      scn_ss_ic = ss_ic;
      tempcell = num2cell([scn_u(ii,:)'; scn_el(ii,:)'; ss_ic']);
      matA = matrixAFunction(tempcell{:});
      eigVals(ii,:) = eig(matA);
   end   

end