function sysWithNumericStatespace = calculateNumericStatespace(system)

system.numeric.statespace.A = system.statespace.A;
system.numeric.statespace.B = system.statespace.B;
system.numeric.statespace.C = system.statespace.C;
system.numeric.statespace.D = system.statespace.D;

% constants
for n = 1:length(system.vector.elements)
    system.numeric.statespace.A = subs(system.numeric.statespace.A, system.vector.elements{n,1}, system.vector.elements{n,2});
    system.numeric.statespace.B = subs(system.numeric.statespace.B, system.vector.elements{n,1}, system.vector.elements{n,2});
    system.numeric.statespace.C = subs(system.numeric.statespace.C, system.vector.elements{n,1}, system.vector.elements{n,2});
    system.numeric.statespace.D = subs(system.numeric.statespace.D, system.vector.elements{n,1}, system.vector.elements{n,2});

end

% input
for n = 1:size(system.vector.systemInput,1)
    system.numeric.statespace.A = subs(system.numeric.statespace.A, system.vector.systemInput{n,1}, system.vector.systemInput{n,2});
    system.numeric.statespace.B = subs(system.numeric.statespace.B, system.vector.systemInput{n,1}, system.vector.systemInput{n,2});
    system.numeric.statespace.C = subs(system.numeric.statespace.C, system.vector.systemInput{n,1}, system.vector.systemInput{n,2});
    system.numeric.statespace.D = subs(system.numeric.statespace.D, system.vector.systemInput{n,1}, system.vector.systemInput{n,2});
end

% steady-state TODO: check. maybe need new steady-state vals for new params
for n = 1:length(system.vector.state)
    system.numeric.statespace.A = subs(system.numeric.statespace.A, system.vector.state{n,1}, system.numeric.x_ss(n,1));
    system.numeric.statespace.B = subs(system.numeric.statespace.B, system.vector.state{n,1}, system.numeric.x_ss(n,1));
    system.numeric.statespace.C = subs(system.numeric.statespace.C, system.vector.state{n,1}, system.numeric.x_ss(n,1));
    system.numeric.statespace.D = subs(system.numeric.statespace.D, system.vector.state{n,1}, system.numeric.x_ss(n,1));
end

system.numeric.statespace.A = double(system.numeric.statespace.A);
system.numeric.statespace.B = double(system.numeric.statespace.B);
system.numeric.statespace.C = double(system.numeric.statespace.C);
system.numeric.statespace.D = double(system.numeric.statespace.D);

sysWithNumericStatespace = system;

end