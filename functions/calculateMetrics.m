function metrics = calculateMetrics(system, scn_u, scn_el, scn_ssic, elements_to_test)

% initialize
matrixAFunction = system.equation.analyticMatrixA;

% calculate eigenvectors and eigenvalues;
C = num2cell([scn_u'; scn_el'; scn_ssic']);
matA = matrixAFunction(C{:});
[V,D,W] = eig(matA,'balance');

[V,D,W] = rearrageEigenvectors(V,D,W);


eigenvalues = diag(D);

for kk = 1:length(elements_to_test)
   el = elements_to_test(kk);
  
   % partial derivative
   % N.B. NO GUARANTEE that eigs of current and eigs of perturbed are in
   % the same order!!!
   %numerical_diff = diffPertubation(matrixAFunction, scn_u, scn_el, scn_ssic, 1, el, 0.01);
   
   % partial derivative
   pd_matA_function = system.pd.pd_matA_function{el};
   pd_matA = pd_matA_function(C{:});

   WT = W';
   sens1 = WT*pd_matA*V/(WT*V);
   sens1mod = diag(sens1);
   
   LSA(:,kk) = sens1mod;
   
   % calculate local senstivity
   %for ii = 1:length(eigenvalues)
   %   LSA(ii,kk) = W(:,ii).'*numerical_diff*V(:,ii)/(W(:,ii).'*V(:,ii));
   %end
end

% calculate participation factors
for ii = 1:length(D)
      sum = 0;
      for jj = 1:length(D)
         sum = sum + abs(W(jj,ii))*abs(V(jj,ii));
      end

      for jj = 1:length(D)
         participation(jj,ii) = abs(W(jj,ii))*abs(V(jj,ii))/sum;
      end
end 

% calculate controllability/observability gramians
isUnstable = any(real(eigenvalues(:)) > 0);
if (isUnstable == 0)
   matA = system.equation.analyticMatrixA(C{:});
   matB = system.equation.analyticMatrixB(C{:});
   matC = system.equation.analyticMatrixC(C{:});
   
   
   for ii = 1:system.numberof.systemInputs
      metrics.Wc{ii} = diag(lyap(matA,matB(:,ii)*matB(:,ii)'));
   end
   
   for ii = 1:length(system.vector.output)
      metrics.Wo{ii} = diag(lyap(matA,matC(ii,:)'*matC(ii,:)));
   end
else % isUnsable == 1
   for ii = 1:system.numberof.systemInputs
      metrics.Wc{ii} = 0;
   end
   for ii = 1:length(system.vector.output)
      metrics.Wo{ii} = 0;
   end
end

metrics.isUnstable = isUnstable;
metrics.eigs = eigenvalues;
metrics.V = V;
metrics.W = W;
metrics.LSA = LSA;
metrics.participation = participation;

end

