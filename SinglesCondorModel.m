clear all;



%%
%Condor model
function [t, Wjuveniles, Wadults, Wtotal, Cjuveniles, Cadults, Ctotal, TotalBirds, Y1, WY1] = runCondorModel()
% initialization of variables and Rates

CR =  1.8/2; % The Female birth Rate assuming double clutching /2 for no double clutching


WR = 0.3729/2; % wild female birth rate

num_years = 50; % simulation time in years

t = 0: num_years;

Kr = 1 - 0.8; % the keep rate of juvenile condors
Rr = 0.8;     % the release rate of juvenile condors

% mortality rates

% year(0:1) newborns
% year(1:2) juveniles
% year(1:6) captive immature, year(1:7) wild immature
% year(7:t) captive adults, year(8:t) wild adults
% 


% %part A
% ACMR = 0.086; % captive adult mortality rate
% AWMR = 0.086; % wild adult mortality rate
% 
% ICMR = 0.086; % captive mortality rate for immature condors
% IWMR = 0.086; % wild mortality rate for immature condors
% 
% JCMR = 0.086; % captive juvenile mortality rate
% JWMR = 0.086; % wild juvenile mortaltiy rate



% 
%Part B
% ACMR = 0.069; % captive adult mortality rate
% AWMR = 0.069; % wild adult mortality rate
% % 
% ICMR = 0.138; % captive mortality rate for immature condors
% IWMR = 0.138; % wild mortality rate for immature condors
% % 
% JCMR = 0.138; % captive juvenile mortality rate
% JWMR = 0.138; % wild juvenile mortaltiy rate




%survival rates

ACSR = 1 - ACMR;  %survival rate of captive adults
AWSR = 1 - AWMR;  %survival rate of wild adults

ICSR = 1 - ICMR; % captive survival rate for immature condors
IWSR = 1 - IWMR; % wild survival rate for immature condors

JCSR = 1 - JCMR;  % captive juvenile survival rate
JWSR = 1 - JWMR;  % wild juvenile survival rate



Captivecap = 150/2; % number of pairs of captive condors
Wildcap = 400/2;    % number of pairs of wild condors





% Define arrays and fill with 0's ahead of time to pre-allocate space
%arrays start at 1 in matlab not 0... odd 
%captive and wild groups, vectors 

%data stored as condor pairs

Y0 = zeros(1, num_years);
Y1 = zeros(1, num_years);
Y2 = zeros(1, num_years);
Y3 = zeros(1, num_years);
Y4 = zeros(1, num_years);
Y5 = zeros(1, num_years);
Y6 = zeros(1, num_years);
Y7 = zeros(1, num_years);
A  = zeros(1, num_years);




WY0 = zeros(1, num_years);
WY1 = zeros(1, num_years);
WY2 = zeros(1, num_years);
WY3 = zeros(1, num_years);
WY4 = zeros(1, num_years);
WY5 = zeros(1, num_years);
WY6 = zeros(1, num_years);
WY7 = zeros(1, num_years);
WY8 = zeros(1, num_years);
WA  = zeros(1, num_years);


% setting initial conditions

%for 2022 data

% Y0(1) = 44/2;
% Y1(1) = 39/2;
% Y2(1) = 45/12;
% Y3(1) = 45/12;
% Y4(1) = 45/12;
% Y5(1) = 45/12;
% Y6(1) = 45/12;
% Y7(1) = 45/12;
% A(1) = 86/2;


% for 1987 data
%A(1) = 22/2;




for yr = 2: num_years + 1
    
    Ctotal_prev = Y0(yr-1) + Y1(yr-1) + Y2(yr-1) + Y3(yr-1) + Y4(yr-1) + Y5(yr-1) + Y6(yr-1) + A(yr-1);

    Wtotal_prev = WY0(yr-1) + WY1(yr-1) + WY2(yr-1) + WY3(yr-1) + WY4(yr-1) + WY5(yr-1) + WY6(yr-1) + WY7(yr-1) + WA(yr-1);
    
    WCC = 1 - (Wtotal_prev / Wildcap); % we might have to add a clamp here to prevent a negative value subtracting born chicks

 
    


    if Ctotal_prev <= Captivecap 

        Kr = 1 - 0.8;
        Rr = 1 - Kr;

    else 
        Kr = 1 - 1;
        Rr = 1 - Kr;
    end

    %if Ctotal_prev <= Captivecap 
        
        %captive condor section
        
        adultsEligibleToReproduce = A(yr-1);
        
        Y0(yr) = (adultsEligibleToReproduce * CR);  % just born
        
        Y1(yr) = Y0(yr-1);         % living out their first year, no release
    
        Y2(yr) = Y1(yr-1) *  Kr * JCSR;   % start of pre-adult years
        Y3(yr) = Y2(yr-1) *  ICSR;
        Y4(yr) = Y3(yr-1) *  ICSR;
        Y5(yr) = Y4(yr-1) *  ICSR;
        Y6(yr) = Y5(yr-1) *  ICSR;   
        Y7(yr) = 0;   % end of pre-adult years
        A(yr) = A(yr-1) * ACSR + Y6(yr-1) * ICSR;  % adults
    
    
    
    
        %wild condors
    
        WildadultsEligibleToReproduce = WA(yr-1);
    
        WY0(yr) = (WildadultsEligibleToReproduce * WR * WCC);  % just born
    
        WY1(yr) = WY0(yr-1); % juveniles         
    
        WY2(yr) = (WY1(yr-1) * JWSR + Y1(yr-1) * Rr * JCSR);
        WY3(yr) = WY2(yr-1) * IWSR;
        WY4(yr) = WY3(yr-1) * IWSR;
        WY5(yr) = WY4(yr-1) * IWSR;
        WY6(yr) = WY5(yr-1) * IWSR;   
        WY7(yr) = WY6(yr-1) * IWSR; 
        WY8(yr) = 0;        % end of juv years
        WA(yr) = WA(yr-1) * AWSR + WY7(yr-1) * IWSR;  % adults
    
    
    end
    
% Group totals for plotting
% combining arrays to account for the correct groups for captive 



% this area converts pairs into singles by multiplying by two
Cjuveniles = (Y1 + Y2 + Y3 + Y4 + Y5 + Y6) * 2;
Cadults    = (A) * 2;

Wjuveniles = (WY1 + WY2 + WY3 + WY4 + WY5 + WY6 + WY7) * 2;
Wadults    = (WA) * 2;

Ctotal     = (Y0 + Cjuveniles + Cadults);
Wtotal     = (WY0 + Wjuveniles + Wadults);


TotalBirds = (Wtotal + Ctotal);
end
%%

Captivecap = 150;
Wildcap = 400;

[t, Wjuveniles, Wadults, Wtotal, Cjuveniles, Cadults, Ctotal, TotalBirds, Y1, WY1] = runCondorModel();
figure;
plot(t, Ctotal, 'Color', '#052F73', 'LineWidth', 1.5); hold on;
plot(t, Wtotal,'Color',  '#052f73', 'LineWidth', 1.5, 'LineStyle', '--');
plot(t, Cadults, 'b', 'LineWidth', 1.2);
plot(t, Wadults, '--b', 'LineWidth', 1.2);
plot(t, TotalBirds, 'g', 'LineWidth', 1.8);

yline(Captivecap,'--c', 'LineWidth', 2.5);
yline(Wildcap,'--k', 'LineWidth', 2.5);
grid on;

legend('Captive Total', 'Wild Total', 'Captive Adults', 'Wild Adults','TotalBirds','Captivecap', 'Wildcap','Location', 'northwest');
xlabel('Years');
ylabel('Number of Condor Pairs');
title('Captive and Wild Condor Populations (Project 3)');
%%

figure;
plot(t, WY1, '--c', 'LineWidth', 1.5); 
hold on;                                     % Keeps the green line visible
plot(t, Y1, 'c', 'LineWidth', 1.5); 
yline(Captivecap, '--k', 'LineWidth', 2.5);
yline(Wildcap, '--r', 'LineWidth', 2.5);
hold off;

grid on;
legend('Wild Juveniles', 'Captive Juveniles', 'Captivecap', 'Wildcap', 'Location', 'northwest');
xlabel('Years');
ylabel('Number of Condor');
title('Captive and Wild Condor Populations (Project 3)');
