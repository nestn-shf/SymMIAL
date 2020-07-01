function newTrace = sortTrace(trace)
%%
newTrace = trace;
%%
for ii = 1:length(trace)
   
   for jj = 2:length(trace{1,1}.metrics)    
      %
      % select two metrics next to eachother
      metrics_unmod = newTrace{1,ii}.metrics(jj-1);
      metrics_tomod = newTrace{1,ii}.metrics(jj);
      
      %
      for kk = 1:17
         for ll = 1:17
            %similarityMetric1(kk,ll) = pdist([metrics_unmod.participation(:,kk), metrics_tomod.participation(:,ll)]','squaredeuclidean');
            similarityMetric2(kk,ll) = abs(metrics_unmod.eigs(kk) - metrics_tomod.eigs(ll));
         end
         [M,I] = min(similarityMetric2(:,kk));
         newOrder(kk) =  I;

      end
      %%
      newOrder2 = newOrder;
      missing = [];
      rep = [];
      for mm = 1:length(newOrder2) 
         if(~ismember(mm,newOrder2))
            missing = [missing, mm];
         end
         
         repeated(mm) = length(find(newOrder2==mm,2));
         if (length(find(newOrder2==mm,2))>1)
            rep = [rep, mm];
         end
      end
      
%%
      for nn = 1:length(rep)
         for mm = 1:length(newOrder2)
            if (newOrder2(mm) == rep(nn))
               newOrder2(mm) = missing(nn);
               break
            end
         end
      end
      

      %%
      newEigs = metrics_tomod.eigs;
      newParticipation = metrics_tomod.participation;
      newLSA = metrics_tomod.LSA;
      for nn = 1:length(newOrder2)
         newIndex = newOrder2(nn);
         newEigs(nn) = metrics_tomod.eigs(newIndex);
         newParticipation(:,nn) = metrics_tomod.participation(:,newIndex);
         newLSA(:,nn) = metrics_tomod.LSA(:,nn);
      end
      newTrace{1,ii}.metrics(jj).eigs = newEigs;
      newTrace{1,ii}.metrics(jj).participation = newParticipation;
      newTrace{1,ii}.metrics(jj).LSA = newLSA;
      
      
   end
end


%%
end

% pdist([metrics_unmod.participation(:,1),metrics_tomod.participation(:,1)]')

%            similarityMetric2(kk,ll) = (real(metrics_unmod.eigs(kk))-real(metrics_tomod.eigs(ll)))^2+(imag(metrics_unmod.eigs(kk))-imag(metrics_tomod.eigs(ll)))^2;
                %similarityMetric1(kk,ll) = pdist([metrics_unmod.participation(:,kk), metrics_tomod.participation(:,ll)]','squaredeuclidean');
            %similarityMetric2(kk,ll) = pdist([real(metrics_unmod.eigs(kk)), real(metrics_tomod.eigs(ll))]','squaredeuclidean');
            %similarityMetric(kk,ll) = pdist([metrics_unmod.participation(:,kk), metrics_tomod.participation(:,ll)]','squaredeuclidean');  
%sum(abs(trace{1,9}.metrics(1).participation(:,5) - trace{1,9}.metrics(20).participation(:,4)))

%%  
%{
      for mm = 1:length(newOrder2)
         if (repeated(mm) > 1)
            for nn = 1:length(newOrder2)
               if (repeated(mm) == 0)
                  find(newOrder2==mm-1,2);
               end
            end
         end
      end
      
      %%
      for mm = 1:length(newOrder2)
         if(~ismember(mm,newOrder2))
            if (mm == 1)
               newOrder2(1) = 1;
            else
               ind_vect = find(newOrder2==mm-1,2);
               ind = ind_vect(2);
               newOrder2(ind) = mm;
            end
         end
      end
%}