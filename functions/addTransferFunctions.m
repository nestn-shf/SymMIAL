function sysWithTransferFunctions = addTransferFunctions(system)

syms s;

Y = (system.statespace.C*inv(s*eye(system.numberof.states)-system.statespace.A)*system.statespace.B + system.statespace.D)*system.statespace.u;
%row = 1;
for ii = 1:length(system.statespace.y)
   system.transfer.Y(ii) = Y(ii);
   %for jj = 1:length(system.statespace.y)
   %   system.transfer.YoverY(ii, jj) = Y(ii)/Y(jj); % N.B. ideally we would like to simplify, however this has trouble computing 
   %   row = row + 1;
   %end
end

sysWithTransferFunctions = system;

end