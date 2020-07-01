function newTraceRow = sortTraceRow2(traceRow)
%%
   
   newTraceRow = traceRow;%trace2att{1};
   
   numStates = size(traceRow.metrics(1).eigs,1);
   N = length(newTraceRow.metrics);
   midpoint = N/2;
   nominal_index = midpoint + 1;

   %% sort right side
   
   for jj = nominal_index:1:N-1
      metrics_unmod = newTraceRow.metrics(jj);
      metrics_tomod = newTraceRow.metrics(jj+1);
      
      for kk = 1:numStates
         for ll = 1:numStates
            %similarityMetric1(kk,ll) = pdist([metrics_unmod.participation(:,kk), metrics_tomod.participation(:,ll)]','squaredeuclidean');
            %similarityMetric2(kk,ll) = abs(metrics_unmod.eigs(kk) - metrics_tomod.eigs(ll));
            similarityMetric4(kk,ll) = (real(metrics_unmod.eigs(kk)) - real(metrics_tomod.eigs(ll)))^2 + (imag(metrics_unmod.eigs(kk)) - imag(metrics_tomod.eigs(ll)))^2;
            
         end
      end

      %similarityMetric3 =  similarityMetric2+similarityMetric1;
      for kk = 1:numStates
         [M,I] = min(similarityMetric4(:,kk));
         newOrder(kk) =  I;
      end
      
     
     
      while ~(length(newOrder) == length(unique(newOrder)))
         rep = [];
         if ~(length(newOrder) == length(unique(newOrder))) % repeates exist
            for mm = 1:length(newOrder)
               if ((length(find(newOrder==mm,2)))>1)
                  rep = [rep, mm];
               end
            end
         end

         if (length(rep) >= 1)
            leftElement = rep(1)-1;
            %if (leftElement == 0)
            %   leftElement = rep
            %end
            rightElement = rep(1)+1;

            if ((length(find(newOrder==leftElement,1))) == 0) && (leftElement ~= 0)
               ind = find(newOrder==rep(1),1);
               newOrder(ind) = newOrder(ind)-1;
            else
               ind = find(newOrder==rep(1),1);
               newOrder(ind) = newOrder(ind)+1;
            end
            newOrder;
         end
      end

      
      % rearrange newOrder
      for kk = 1:numStates
         val = newOrder(kk);
         newOrder2(val) = kk;
      end
      if find(newOrder2==0,1)
         error = 1;
         newOrder2 = 1:1:15;
      end
      
      
      %apply new order
      newEigs = metrics_tomod.eigs;
      newLSA = metrics_tomod.LSA;
      for nn = 1:length(newOrder2)
         newIndex = newOrder2(nn);
         newEigs(nn) = metrics_tomod.eigs(newIndex);
         newLSA(nn,:) = metrics_tomod.LSA(newIndex,:);
      end
      newTraceRow.metrics(jj+1).eigs = newEigs;
      newTraceRow.metrics(jj+1).LSA = newLSA;
      
   end

   
  
   %% sort left side

   for jj = nominal_index:-1:2
      metrics_unmod = newTraceRow.metrics(jj);
      metrics_tomod = newTraceRow.metrics(jj-1);
      
      for kk = 1:numStates
         for ll = 1:numStates
            %similarityMetric1(kk,ll) = pdist([metrics_unmod.participation(:,kk), metrics_tomod.participation(:,ll)]','squaredeuclidean');
            %similarityMetric2(kk,ll) = abs(metrics_unmod.eigs(kk) - metrics_tomod.eigs(ll));
            similarityMetric4(kk,ll) = (real(metrics_unmod.eigs(kk)) - real(metrics_tomod.eigs(ll)))^2 + (imag(metrics_unmod.eigs(kk)) - imag(metrics_tomod.eigs(ll)))^2;
         end
      end
      %similarityMetric3 =  similarityMetric2+similarityMetric1;
      for kk = 1:numStates
         [M,I] = min(similarityMetric4(:,kk));
         newOrder(kk) =  I;
      end
      
      % rearrange newOrder
      for kk = 1:numStates
         val = newOrder(kk);
         newOrder2(val) = kk;
      end
      
      %apply new order
      newEigs = metrics_tomod.eigs;
      newLSA = metrics_tomod.LSA;
      for nn = 1:length(newOrder2)
         newIndex = newOrder2(nn);
         newEigs(nn) = metrics_tomod.eigs(newIndex);
         newLSA(nn,:) = metrics_tomod.LSA(newIndex,:);
      end
      newTraceRow.metrics(jj-1).eigs = newEigs;
      newTraceRow.metrics(jj-1).LSA = newLSA;
     
   end

end