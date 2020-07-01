matrixAFunction = system.equation.analyticMatrixA;

for ii = 1:5
   var = newTrace{ii};
   
   for jj = 1:50
      metrics = var.metrics(jj);
   
      scn_u = var.scn_u(jj,:);
      scn_el = var.scn_el(jj,:);
      scn_ssic = var.scn_ss_ic(jj,:);
      
      for kk = 1:system.numberof.elements
         numerical_diff = diffPertubation(matrixAFunction, scn_u, scn_el, scn_ssic, 1, kk, 0.001);
         for mm = 1:17
         	LSA(mm,kk) = metrics.W(:,mm).'*numerical_diff*metrics.V(:,mm)/(metrics.W(:,mm).'*metrics.V(:,mm));
         end
      end
      newTrace{ii}.metrics(jj).LSA2 = LSA;
   end
end 