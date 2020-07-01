function traceNew = appendImpedancecustom(traceOld, Nsystem,N) 
%%
traceNew = traceOld;
%Nsystem = system_buck;

%%
for ii = 1:N
   for jj = 1:N
      
      %%
      Oscn_u = traceOld{ii}.scn_u(jj,:);
      Oscn_el = traceOld{ii}.scn_el(jj,:);
      Oscn_ss_ic = traceOld{ii}.scn_ss_ic(jj,:);

      Nscn_u = [Oscn_ss_ic(2), Oscn_u(2:3)];
      Nscn_el = Oscn_el(7:20);
      Nscn_ss_ic = Oscn_ss_ic(4:8); 
      
      %%
      matrixAFunction = Nsystem.equation.analyticMatrixA;
      matrixBFunction = Nsystem.equation.analyticMatrixB;
      matrixCFunction = Nsystem.equation.analyticMatrixC;
      matrixDFunction = Nsystem.equation.analyticMatrixD;

      C = num2cell([[Nscn_u]'; [Nscn_el]'; Nscn_ss_ic']);

      matA = matrixAFunction(C{:});
      matB = matrixBFunction(C{:});
      matC = matrixCFunction(C{:});
      matD = matrixDFunction(C{:});
      
      %Nsystem.statespace.y
      %Nsystem.statespace.u
      sys1 = ss(matA,matB,matC,matD);
      Zin = inv(sys1(2,1));
      
      %opts = bodeoptions('cstprefs');
      %opts.Grid = 'on';
      %opts.FreqUnits = 'Hz';
      %bode(Zin, opts)
      
      %%
      w_filter = 726.44*2*pi;
      
      [mag,phase,wout] = bode(Zin,w_filter);
      
      traceNew{ii}.metrics(jj).phase = phase;
      traceNew{ii}.metrics(jj).Zin = Zin;
      traceNew{ii}.metrics(jj).FreqZin = w_filter;
      traceNew{ii}.metrics(jj).MagZin = mag;
      
      
      %%
   end
end

%%
end