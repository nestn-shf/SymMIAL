function eigSens(system)

% [1:length(system.vector.state); [system.vector.state{:,1}]]'
% [1:length(system.vector.elements); [system.vector.elements{:,1}]]'

%%
   dAdKi = diff(system.statespace.A, system.vector.elements{84,1});
   
   anon_dAdKi = ...
      matlabFunction(dAdKi, ...
      'Optimize',false, ...
      'Vars',[system.vector.systemInput{:,1},system.vector.elements{:,1},system.vector.state{:,1}]);
   
   system.numeric.x_ss2 = findSteadyStateIteratively(system, system.numeric.x_guess);
   system.numeric.y_ss2 = system.equation.anonOutput(system.numeric.x_ss2', system.numeric.u, [system.vector.elements{:,2}]');
   C = num2cell([system.numeric.u; [system.vector.elements{:,2}]'; system.numeric.x_ss2']);
   system.numeric.A = system.equation.analyticMatrixA(C{:});
   [V,D,W] = eig(system.numeric.A);
   eigs = diag(D);
   
   num_dAdKi = anon_dAdKi(C{:});
   dLambdadKi = (W*num_dAdKi*V/dot(W,V));
  
   [B,index] = sort(real(eigs));
   
   sortedEigs = eigs(index);
   sortedParticipation = dLambdadKi(index);
   
   [sortedEigs, sortedParticipation]
   
%%

system.numeric.x_ss2 = findSteadyStateIteratively(system, system.numeric.x_guess);
system.numeric.y_ss2 = system.equation.anonOutput(system.numeric.x_ss2', system.numeric.u, [system.vector.elements{:,2}]');
C = num2cell([system.numeric.u; [system.vector.elements{:,2}]'; system.numeric.x_ss2']);
system.numeric.A = system.equation.analyticMatrixA(C{:});
[V,D,W] = eig(system.numeric.A);
eigs = diag(D);
[B,index] = sort(real(eigs));
sortedEigs = eigs(index);

all = [];
for ii = 1:length(system.vector.elements)
   diffA = diff(system.statespace.A, system.vector.elements{ii,1});
   
   anon_diffA = ...
      matlabFunction(diffA, ...
      'Optimize',false, ...
      'Vars',[system.vector.systemInput{:,1},system.vector.elements{:,1},system.vector.state{:,1}]);
   
   num_diffA = anon_diffA(C{:});
   sens = (W*num_diffA*V/dot(W,V));
  
   sortedSens = sens(index);
   
   all = [all, sortedSens];
   
end
%%
[M,I] = max(real(all),[],2);




%% pertubation of parameters

   x_ss = findSteadyStateIteratively(system, system.numeric.x_guess);
   tempcell = num2cell([system.numeric.u; [system.vector.elements{:,2}]'; x_ss']);
   A_nominal = system.equation.analyticMatrixA(tempcell{:});
   [V_nominal, D_nominal, W_nominal] = eig(A_nominal);
   eigs_nominal = diag(D_nominal);
   [B,index] = sort(real(eigs_nominal));
   sortedEigs_nominal = eigs_nominal(index);
   
   
   all2 = [];
for ii = 1:length(system.vector.elements)
   sys_copy = system;
   
   
   pertubationFactor = 0.01;
   pertubationValue = pertubationFactor*system.vector.elements{ii,2};
   
   system.vector.elements{ii,2} = system.vector.elements{ii,2} + pertubationValue;
   
   x_ss = findSteadyStateIteratively(system, system.numeric.x_guess);
   tempcell = num2cell([system.numeric.u; [system.vector.elements{:,2}]'; x_ss']);
   A_pert = system.equation.analyticMatrixA(tempcell{:});
   [V_pert, D_pert, W_pert] = eig(A_pert);
   eigs_pert = diag(D_pert);
   [B,index] = sort(real(eigs_pert));
   sortedEigs_pert = eigs_pert(index);
   
   sens = (sortedEigs_nominal - sortedEigs_pert)/pertubationValue;
   
   all2 = [all2, sens];
   
   system = sys_copy;
end

%%
end