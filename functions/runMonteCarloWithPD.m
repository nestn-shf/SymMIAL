function monteScenario = runMonteCarloWithPD(system, param, X_actual, inputs_to_test, elements_to_test)

num_scenarios = length(X_actual);

systemFunction = system.equation.anonDifferential;
matrixAFunction = system.equation.analyticMatrixA;

pdFunctions = system.pd.pd_matA_function;
options = optimoptions('fsolve','Display','none');

nominal_u = [param.u(:).val];
nominal_el = [param.el(:).val];
nominal_guess = [param.x.guess];


parfor (ii = 1:num_scenarios)

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
  
  %calculate PD
  
    for kk = 1:length(elements_to_test)
       el = elements_to_test(kk);

       % partial derivative
       % N.B. NO GUARANTEE that eigs of current and eigs of perturbed are in
       % the same order!!!
       %numerical_diff = diffPertubation(matrixAFunction, scn_u, scn_el, temp1, 1, el, 0.01);

       % partial derivative
       pd_matA_function = pdFunctions{el};
       pd_matA = pd_matA_function(C{:});

       WT = W';
       sens1 = WT*pd_matA*V/(WT*V);
       sens1mod = diag(sens1);
       LSA(ii).LSA(:,kk) = sens1mod;

       % calculate local senstivity
       %for jj = 1:length(D)
       %   LSA(ii).LSA(jj,kk) = W(:,jj).'*numerical_diff*V(:,jj)/(W(:,jj).'*V(:,jj));
       %end
    end
  
end
  
    

monteScenario.scn_u = Mscn_u;
monteScenario.scn_el = Mscn_el;
monteScenario.scn_ss_ic = Mscn_ss_ic;
monteScenario.exitflag = Mexitflag;
monteScenario.eigs = Meigs;
monteScenario.P = P;

monteScenario.LSA = LSA;

end