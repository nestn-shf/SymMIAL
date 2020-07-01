function monteScenario = runMonteCarlo(system, param, X_actual, inputs_to_test, elements_to_test);

num_scenarios = length(X_actual);

systemFunction = system.equation.anonDifferential;
matrixAFunction = system.equation.analyticMatrixA;
options = optimoptions('fsolve','Display','none');

nominal_u = [param.u(:).val];
nominal_el = [param.el(:).val];
nominal_guess = [param.x.guess];

parfor (ii = 1:num_scenarios, 4)

  [scn_u, scn_el] = buildVectorMonte(X_actual(ii,:), inputs_to_test, elements_to_test, nominal_u, nominal_el);

  reducedFunction = @(y) systemFunction(y, scn_u, scn_el);

  [temp1,~,temp2,~] = fsolve(reducedFunction, nominal_guess, options);

  Mscn_u(ii,:) = scn_u;
  Mscn_el(ii,:) = scn_el;
  Mscn_ss_ic(ii,:) = temp1;
  Mexitflag(ii) = temp2;

  C = num2cell([scn_u'; scn_el'; temp1']);
  matA = matrixAFunction(C{:});

  [V,D,W] = eig(matA,'balance');
  [V,D,W] = rearrageEigenvectors(V,D,W);

  Meigs(ii,:) = diag(D);
  % calculate participation factors
  for kk = 1:length(D)
     sum = 0;
     for jj = 1:length(D)
        sum = sum + abs(W(jj,kk))*abs(V(jj,kk));
     end

     for jj = 1:length(D)
        P(ii).participation(jj,kk) = abs(W(jj,kk))*abs(V(jj,kk))/sum;
     end
  end
end

monteScenario.scn_u = Mscn_u;
monteScenario.scn_el = Mscn_el;
monteScenario.scn_ss_ic = Mscn_ss_ic;
monteScenario.exitflag = Mexitflag;
monteScenario.eigs = Meigs;
monteScenario.P = P;

end