function montemet = basicMonteMetrics(system, elements_to_test, monteScenario)

   tic
   N = size(monteScenario.totaldata_unit,1);
   for ii = 1:N
      montemet.A.metrics(ii) = calculateMetricsCustom(system, monteScenario.A.scn_u(ii,:), monteScenario.A.scn_el(ii,:), monteScenario.A.scn_ss_ic(ii,:), elements_to_test);
   end
   toc
   
end