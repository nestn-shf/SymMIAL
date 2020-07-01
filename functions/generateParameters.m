function param = generateParameters()

var_frac = 0.5;
var_load = 0.8;

%% ---States---

        VC_SBUCK_3 = 0;
        IL_SBUCK_3 = 0;
           VC_RC_1 = 0;
           VC_LC_1 = 0;
           IL_LC_1 = 0;
        VC_SBUCK_1 = 0;
        IL_SBUCK_1 = 0;
 X1_BUCKCTRLTIII_1 = 0;
 X2_BUCKCTRLTIII_1 = 0;
 X3_BUCKCTRLTIII_1 = 0;
           VC_LC_2 = 0;
           IL_LC_2 = 0;
        VC_SBUCK_2 = 0;
        IL_SBUCK_2 = 0;
 X1_BUCKCTRLTIII_2 = 0;
 X2_BUCKCTRLTIII_2 = 0;
 X3_BUCKCTRLTIII_2 = 0;

        VC_SBUCK_3_guess = 100;
        IL_SBUCK_3_guess = 1;
           VC_RC_1_guess = 100;
           VC_LC_1_guess = 100;
           IL_LC_1_guess = 1;
        VC_SBUCK_1_guess = 48;
        IL_SBUCK_1_guess = 1;
 X1_BUCKCTRLTIII_1_guess = 0;
 X2_BUCKCTRLTIII_1_guess = 0;
 X3_BUCKCTRLTIII_1_guess = 0;
           VC_LC_2_guess = 100;
           IL_LC_2_guess = 1;
        VC_SBUCK_2_guess = 48;
        IL_SBUCK_2_guess = 1;
 X1_BUCKCTRLTIII_2_guess = 0;
 X2_BUCKCTRLTIII_2_guess = 0;
 X3_BUCKCTRLTIII_2_guess = 0;

%% ---Inputs---

          V1_SBUCK_3 = 380;
           D_SBUCK_3 = 0.27;
 Vref_BUCKCTRLTIII_1 = 48;
 Vref_BUCKCTRLTIII_2 = 48;

index = 1;
param.u(index).name = getName(V1_SBUCK_3);
param.u(index).val = V1_SBUCK_3;
param.u(index).lowerbound = (1-var_frac)*param.u(index).val;
param.u(index).upperbound = (1+var_frac)*param.u(index).val;
param.u(index).pdf = makedist('Uniform', 'lower', param.u(index).lowerbound, 'upper', param.u(index).upperbound);

index = 2;
param.u(index).name = getName(D_SBUCK_3);
param.u(index).val = D_SBUCK_3;
param.u(index).lowerbound = (1-var_frac)*param.u(index).val;
param.u(index).upperbound = (1+var_frac)*param.u(index).val;
param.u(index).pdf = makedist('Uniform', 'lower', param.u(index).lowerbound, 'upper', param.u(index).upperbound);

index = 3;
param.u(index).name = getName(Vref_BUCKCTRLTIII_1);
param.u(index).val = Vref_BUCKCTRLTIII_1;
param.u(index).lowerbound = (1-var_frac)*param.u(index).val;
param.u(index).upperbound = (1+var_frac)*param.u(index).val;
param.u(index).pdf = makedist('Uniform', 'lower', param.u(index).lowerbound, 'upper', param.u(index).upperbound);

index = 4;
param.u(index).name = getName(Vref_BUCKCTRLTIII_2);
param.u(index).val = Vref_BUCKCTRLTIII_2;
param.u(index).lowerbound = (1-var_frac)*param.u(index).val;
param.u(index).upperbound = (1+var_frac)*param.u(index).val;
param.u(index).pdf = makedist('Uniform', 'lower', param.u(index).lowerbound, 'upper', param.u(index).upperbound);

%% ---Elements---

          C_SBUCK_3 = 620e-6;
          L_SBUCK_3 = 0.6e-3;
         RL_SBUCK_3 = 40e-3;
         RC_SBUCK_3 = 1e-3;
    RDSONQ1_SBUCK_3 = 10e-3;
    RDSONQ2_SBUCK_3 = 10e-3;
    
             C_RC_1 = 500e-6;
             R_RC_1 = 0.1;

             C_LC_1 = 420e-6;
             L_LC_1 = 0.2e-3;
            RL_LC_1 = 1e-3;
            RC_LC_1 = 1e-3;
          C_SBUCK_1 = 480e-6;
          L_SBUCK_1 = 680e-6;
         RL_SBUCK_1 = 10e-3;
         RC_SBUCK_1 = 1e-3;
    RDSONQ1_SBUCK_1 = 10e-3;
    RDSONQ2_SBUCK_1 = 10e-3;
  w0_BUCKCTRLTIII_1 = 650*(2*pi);
 Vin_BUCKCTRLTIII_1 = 100;
  z1_BUCKCTRLTIII_1 = (1/sqrt(C_SBUCK_1*L_SBUCK_1))*0.95;
  z2_BUCKCTRLTIII_1 = (1/sqrt(C_SBUCK_1*L_SBUCK_1))*1.05;
  p2_BUCKCTRLTIII_1 = 9600000;
  p3_BUCKCTRLTIII_1 = 31416;
          R_RLOAD_1 = 2.104;
  
             C_LC_2 = 420e-6; %%
             L_LC_2 = 0.2e-3;
            RL_LC_2 = 1e-3;
            RC_LC_2 = 1e-3;
          C_SBUCK_2 = 480e-6;
          L_SBUCK_2 = 680e-6;
         RL_SBUCK_2 = 10e-3;
         RC_SBUCK_2 = 1e-3;
    RDSONQ1_SBUCK_2 = 10e-3;
    RDSONQ2_SBUCK_2 = 10e-3;
  w0_BUCKCTRLTIII_2 = 750*(2*pi);
 Vin_BUCKCTRLTIII_2 = 100;
  z1_BUCKCTRLTIII_2 = (1/sqrt(C_SBUCK_2*L_SBUCK_2))*0.95;
  z2_BUCKCTRLTIII_2 = (1/sqrt(C_SBUCK_2*L_SBUCK_2))*1.05;
  p2_BUCKCTRLTIII_2 = 9600000;
  p3_BUCKCTRLTIII_2 = 31416;
          R_RLOAD_2 = 2.104;
            
%%          
index = 1;
param.x(index).name = getName(VC_SBUCK_3);
param.x(index).val = 0;
param.x(index).guess = VC_SBUCK_3_guess;

index = 2;
param.x(index).name = getName(IL_SBUCK_3);
param.x(index).val = 0;
param.x(index).guess = IL_SBUCK_3_guess;

index = 3;
param.x(index).name = getName(VC_RC_1);
param.x(index).val = 0;
param.x(index).guess = VC_RC_1_guess;

index = 4;
param.x(index).name = getName(VC_LC_1);
param.x(index).val = 0;
param.x(index).guess = VC_LC_1_guess;

index = 5;
param.x(index).name = getName(IL_LC_1);
param.x(index).val = 0;
param.x(index).guess = IL_LC_1_guess;

index = 6;
param.x(index).name = getName(VC_SBUCK_1);
param.x(index).val = 0;
param.x(index).guess = VC_SBUCK_1_guess;

index = 7;
param.x(index).name = getName(IL_SBUCK_1);
param.x(index).val = 0;
param.x(index).guess = IL_SBUCK_1_guess;

index = 8;
param.x(index).name = getName(X1_BUCKCTRLTIII_1);
param.x(index).val = 0;
param.x(index).guess = X1_BUCKCTRLTIII_1_guess;

index = 9;
param.x(index).name = getName(X2_BUCKCTRLTIII_1);
param.x(index).val = 0;
param.x(index).guess = X2_BUCKCTRLTIII_1_guess;

index = 10;
param.x(index).name = getName(X3_BUCKCTRLTIII_1);
param.x(index).val = 0;
param.x(index).guess = X3_BUCKCTRLTIII_1_guess;

index = 11;
param.x(index).name = getName(VC_LC_2);
param.x(index).val = 0;
param.x(index).guess = VC_LC_2_guess;

index = 12;
param.x(index).name = getName(IL_LC_2);
param.x(index).val = 0;
param.x(index).guess = IL_LC_2_guess;

index = 13;
param.x(index).name = getName(VC_SBUCK_2);
param.x(index).val = 0;
param.x(index).guess = VC_SBUCK_2_guess;

index = 14;
param.x(index).name = getName(IL_SBUCK_2);
param.x(index).val = 0;
param.x(index).guess = IL_SBUCK_2_guess;

index = 15;
param.x(index).name = getName(X1_BUCKCTRLTIII_2);
param.x(index).val = 0;
param.x(index).guess = X1_BUCKCTRLTIII_2_guess;

index = 16;
param.x(index).name = getName(X2_BUCKCTRLTIII_2);
param.x(index).val = 0;
param.x(index).guess = X2_BUCKCTRLTIII_2_guess;

index = 17;
param.x(index).name = getName(X3_BUCKCTRLTIII_2);
param.x(index).val = 0;
param.x(index).guess = X3_BUCKCTRLTIII_2_guess;

%%
index = 1;
param.el(index).name = getName(C_SBUCK_3);
param.el(index).val = C_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 2;
param.el(index).name = getName(L_SBUCK_3);
param.el(index).val = L_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 3;
param.el(index).name = getName(RL_SBUCK_3);
param.el(index).val = RL_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 4;
param.el(index).name = getName(RC_SBUCK_3);
param.el(index).val = RC_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 5;
param.el(index).name = getName(RDSONQ1_SBUCK_3);
param.el(index).val = RDSONQ1_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 6;
param.el(index).name = getName(RDSONQ2_SBUCK_3);
param.el(index).val = RDSONQ2_SBUCK_3;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 7;
param.el(index).name = getName(C_RC_1);
param.el(index).val = C_RC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 8;
param.el(index).name = getName(R_RC_1);
param.el(index).val = R_RC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 9;
param.el(index).name = getName(C_LC_1);
param.el(index).val = C_LC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 10;
param.el(index).name = getName(L_LC_1);
param.el(index).val = L_LC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 11;
param.el(index).name = getName(RL_LC_1);
param.el(index).val = RL_LC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 12;
param.el(index).name = getName(RC_LC_1);
param.el(index).val = RC_LC_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 13;
param.el(index).name = getName(C_SBUCK_1);
param.el(index).val = C_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 14;
param.el(index).name = getName(L_SBUCK_1);
param.el(index).val = L_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 15;
param.el(index).name = getName(RL_SBUCK_1);
param.el(index).val = RL_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 16;
param.el(index).name = getName(RC_SBUCK_1);
param.el(index).val = RC_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 17;
param.el(index).name = getName(RDSONQ1_SBUCK_1);
param.el(index).val = RDSONQ1_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 18;
param.el(index).name = getName(RDSONQ2_SBUCK_1);
param.el(index).val = RDSONQ2_SBUCK_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 19;
param.el(index).name = getName(w0_BUCKCTRLTIII_1);
param.el(index).val = w0_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 20;
param.el(index).name = getName(Vin_BUCKCTRLTIII_1);
param.el(index).val = Vin_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 21;
param.el(index).name = getName(z1_BUCKCTRLTIII_1);
param.el(index).val = z1_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 22;
param.el(index).name = getName(z2_BUCKCTRLTIII_1);
param.el(index).val = z2_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 23;
param.el(index).name = getName(p2_BUCKCTRLTIII_1);
param.el(index).val = p2_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 24;
param.el(index).name = getName(p3_BUCKCTRLTIII_1);
param.el(index).val = p3_BUCKCTRLTIII_1;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 25;
param.el(index).name = getName(R_RLOAD_1);
param.el(index).val = R_RLOAD_1;
param.el(index).lowerbound = (1-var_load)*param.el(index).val;
param.el(index).upperbound = (1+var_load)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 26;
param.el(index).name = getName(C_LC_2);
param.el(index).val = C_LC_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 27;
param.el(index).name = getName(L_LC_2);
param.el(index).val = L_LC_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 28;
param.el(index).name = getName(RL_LC_2);
param.el(index).val = RL_LC_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 29;
param.el(index).name = getName(RC_LC_2);
param.el(index).val = RC_LC_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 30;
param.el(index).name = getName(C_SBUCK_2);
param.el(index).val = C_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 31;
param.el(index).name = getName(L_SBUCK_2);
param.el(index).val = L_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 32;
param.el(index).name = getName(RL_SBUCK_2);
param.el(index).val = RL_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 33;
param.el(index).name = getName(RC_SBUCK_2);
param.el(index).val = RC_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 34;
param.el(index).name = getName(RDSONQ1_SBUCK_2);
param.el(index).val = RDSONQ1_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 35;
param.el(index).name = getName(RDSONQ2_SBUCK_2);
param.el(index).val = RDSONQ2_SBUCK_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 36;
param.el(index).name = getName(w0_BUCKCTRLTIII_2);
param.el(index).val = w0_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 37;
param.el(index).name = getName(Vin_BUCKCTRLTIII_2);
param.el(index).val = Vin_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 38;
param.el(index).name = getName(z1_BUCKCTRLTIII_2);
param.el(index).val = z1_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 39;
param.el(index).name = getName(z2_BUCKCTRLTIII_2);
param.el(index).val = z2_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 40;
param.el(index).name = getName(p2_BUCKCTRLTIII_2);
param.el(index).val = p2_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 41;
param.el(index).name = getName(p3_BUCKCTRLTIII_2);
param.el(index).val = p3_BUCKCTRLTIII_2;
param.el(index).lowerbound = (1-var_frac)*param.el(index).val;
param.el(index).upperbound = (1+var_frac)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);
index = 42;
param.el(index).name = getName(R_RLOAD_2);
param.el(index).val = R_RLOAD_2;
param.el(index).lowerbound = (1-var_load)*param.el(index).val;
param.el(index).upperbound = (1+var_load)*param.el(index).val;
param.el(index).pdf = makedist('Uniform', 'lower', param.el(index).lowerbound, 'upper', param.el(index).upperbound);

%%
mA_LC1 = [0, 1/C_LC_1; -1/L_LC_1, -(RC_LC_1+RL_LC_1)/L_LC_1];
mB_LC1 = [0, -1/C_LC_1; 1/L_LC_1, RC_LC_1/L_LC_1];
mC_LC1 = [1, RC_LC_1; 0, 1;    1, 0; 0, 1];
mD_LC1 = [0, -RC_LC_1; 0, 0;   0, 0; 0, 0];

mA_LC2 = [0, 1/C_LC_2; -1/L_LC_2, -(RC_LC_2+RL_LC_2)/L_LC_2];
mB_LC2 = [0, -1/C_LC_2; 1/L_LC_2, RC_LC_2/L_LC_2];
mC_LC2 = [1, RC_LC_2; 0, 1;    1, 0; 0, 1];
mD_LC2 = [0, -RC_LC_2; 0, 0;   0, 0; 0, 0];

mA_CTRL1 = [-p2_BUCKCTRLTIII_1-p3_BUCKCTRLTIII_1, 1, 0; -p2_BUCKCTRLTIII_1*p3_BUCKCTRLTIII_1, 0, 1; 0, 0, 0];         
mB_CTRL1 = (1/Vin_BUCKCTRLTIII_1 )*[(p2_BUCKCTRLTIII_1 *p3_BUCKCTRLTIII_1 )/(z1_BUCKCTRLTIII_1 *z2_BUCKCTRLTIII_1 ) ; ...
                                    (p2_BUCKCTRLTIII_1 *p3_BUCKCTRLTIII_1 *(1/z1_BUCKCTRLTIII_1 + 1/z2_BUCKCTRLTIII_1)) ; ...
                                    (p2_BUCKCTRLTIII_1*p3_BUCKCTRLTIII_1)];                
mC_CTRL1 = [w0_BUCKCTRLTIII_1, 0, 0];
mD_CTRL1 = 0;

mA_CTRL2 = [-p2_BUCKCTRLTIII_2-p3_BUCKCTRLTIII_2, 1, 0; -p2_BUCKCTRLTIII_2*p3_BUCKCTRLTIII_2, 0, 1; 0, 0, 0];         
mB_CTRL2 = (1/Vin_BUCKCTRLTIII_2 )*[(p2_BUCKCTRLTIII_2 *p3_BUCKCTRLTIII_2 )/(z1_BUCKCTRLTIII_2 *z2_BUCKCTRLTIII_2 ) ; ...
                                    (p2_BUCKCTRLTIII_2 *p3_BUCKCTRLTIII_2 *(1/z1_BUCKCTRLTIII_2 + 1/z2_BUCKCTRLTIII_2)) ; ...
                                    (p2_BUCKCTRLTIII_2*p3_BUCKCTRLTIII_2)];                
mC_CTRL2 = [w0_BUCKCTRLTIII_2, 0, 0];
mD_CTRL2 = 0;

index = 1;
param.m(index).name = getName(mA_LC1);
param.m(index).val = mA_LC1;

index = index + 1;
param.m(index).name = getName(mB_LC1 );
param.m(index).val = mB_LC1 ;

index = index + 1;
param.m(index).name = getName(mC_LC1);
param.m(index).val = mC_LC1;

index = index + 1;
param.m(index).name = getName(mD_LC1);
param.m(index).val = mD_LC1;

index = index + 1;
param.m(index).name = getName(mA_LC2);
param.m(index).val = mA_LC2;

index = index + 1;
param.m(index).name = getName(mB_LC2 );
param.m(index).val = mB_LC2 ;

index = index + 1;
param.m(index).name = getName(mC_LC2);
param.m(index).val = mC_LC2;

index = index + 1;
param.m(index).name = getName(mD_LC2);
param.m(index).val = mD_LC2;

index = index + 1;
param.m(index).name = getName(mA_CTRL1);
param.m(index).val = mA_CTRL1;

index = index + 1;
param.m(index).name = getName(mB_CTRL1);
param.m(index).val = mB_CTRL1;

index = index + 1;
param.m(index).name = getName(mC_CTRL1);
param.m(index).val = mC_CTRL1;

index = index + 1;
param.m(index).name = getName(mD_CTRL1);
param.m(index).val = mD_CTRL1;

index = index + 1;
param.m(index).name = getName(mA_CTRL2);
param.m(index).val = mA_CTRL2;

index = index + 1;
param.m(index).name = getName(mB_CTRL2);
param.m(index).val = mB_CTRL2;

index = index + 1;
param.m(index).name = getName(mC_CTRL2);
param.m(index).val = mC_CTRL2;

index = index + 1;
param.m(index).name = getName(mD_CTRL2);
param.m(index).val = mD_CTRL2;

end
              