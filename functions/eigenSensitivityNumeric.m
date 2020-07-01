function [sensitivityInputs, sensitivityElements] = eigenSensitivityNumeric(system)

   % [1:length(system.vector.systemInput); [system.vector.systemInput{:,1}]]'
   % [1:length(system.vector.state); [system.vector.state{:,1}]]'
   % [1:length(system.vector.elements); [system.vector.elements{:,1}]]'
   % [M,I] = max(real(sensitivityInputs),[],2);
   % [M,I] = max(real(sensitivityElements),[],2);

   % nominal case:
      x_ss = findSteadyStateIteratively(system, system.numeric.x_guess);
      tempcell = num2cell([system.numeric.u; [system.vector.elements{:,2}]'; x_ss']);
      A_nominal = system.equation.analyticMatrixA(tempcell{:});
      [V_nominal, D_nominal, W_nominal] = eig(A_nominal);
      eigs_nominal = diag(D_nominal);
      [B,index] = sort(real(eigs_nominal));
      sortedEigs_nominal = eigs_nominal(index);

   %%   
   % perturbuation input:
   sensitivityInputs = [];
   for ii = 1:length(system.vector.systemInput)
      sys_copy = system;

      pertubationFactor = 0.1; % *******************************************
      pertubationValue = pertubationFactor*system.vector.systemInput{ii,2};

      system.vector.systemInput{ii,2} = system.vector.systemInput{ii,2} + pertubationValue;

      x_ss = findSteadyStateIteratively(system, system.numeric.x_guess);
      tempcell = num2cell([[system.vector.systemInput{:,2}]'; [system.vector.elements{:,2}]'; x_ss']);
      A_pert = system.equation.analyticMatrixA(tempcell{:});
      [V_pert, D_pert, W_pert] = eig(A_pert);
      eigs_pert = diag(D_pert);
      [B,index] = sort(real(eigs_pert));
      sortedEigs_pert = eigs_pert(index);

      sens = (sortedEigs_nominal - sortedEigs_pert)/pertubationValue;

      sensitivityInputs = [sensitivityInputs, sens];

      system = sys_copy;
   end

   %%
   % perturbuation elements:
   sensitivityElements = [];
   for ii = 1:length(system.vector.elements)
      sys_copy = system;

      pertubationFactor = 0.001; % *******************************************
      pertubationValue = pertubationFactor*system.vector.elements{ii,2};

      system.vector.elements{ii,2} = system.vector.elements{ii,2} + pertubationValue;

      x_ss = findSteadyStateIteratively(system, system.numeric.x_guess);
      tempcell = num2cell([[system.vector.systemInput{:,2}]'; [system.vector.elements{:,2}]'; x_ss']);
      A_pert = system.equation.analyticMatrixA(tempcell{:});
      [V_pert, D_pert, W_pert] = eig(A_pert);
      eigs_pert = diag(D_pert);
      [B,index] = sort(real(eigs_pert));
      sortedEigs_pert = eigs_pert(index);

      sens = (sortedEigs_nominal - sortedEigs_pert)/pertubationValue;

      sensitivityElements = [sensitivityElements, sens];

      system = sys_copy;
   end

end