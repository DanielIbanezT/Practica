clc
clear all
close all

%================================== Practica: ==================================
%======================== Piscina semiolimpica temperada =======================
%=============================== para la comuna de ============================= 
%==================================== Arauco ===================================
%%
            %======================== Datos de la piscina ======================

L=25;         %Largo de la piscina [m]
A=12.9;       %Ancho de la piscina [m]
Meses=[1 2 3 4 5 6 7 8 9 10 11 12]; %Contador de meses del año [-]
lims=[1 12];  %Limite de meses para el grafico [-]
P=3;         %Profundidad de la piscina [m]
Cv=2257;      %Calor latente de vaporizacion [kJ/kg]
Ga=0.65;      %Saturacion del aire [-]
Ta=25;        %Temperatura del agua [°C]
Tair=27;      %Temperatura del aire [°C]
Tc=27;        %Temperatura de las paredes del recinto [°C] **SUPOSICION PARA CALCULOS**
We=0.0200755; %Humedad absoluta del aire saturado a la temperatura del agua [kgh20/kgaire]
Was=0.022652; %Humedad absoluta del aire saturado a la temperatura del aire interior [kgh20/kgaire]
S=A*L;        %Superficie de agua de la piscina en contacto con el aire[m2]
S2=(2*L*P)+(2*A*P)+(L*A); %Superficie de agua de la piscina en contacto con los bordes [m2]
V=L*A*P;      %Volumen de masa de agua de la piscina [m3]

%%
%============================= Calefaccion de la piscina ==========================

                %============== Calor de evaporacion ==============
             
%Piscina abierta
N=60; %Numero total de espectadores [-] **SUPOSICION PARA CALCULOS**
n=40; %Numero de nadadores por m2 de superficie de agua [-] **SUPOSICION PARA CALCULOS**

MeBer=S*(16*(We-Ga*Was));          %Flujo masico asociado a la piscina sin bañistas 
MeBer2=133*n*(We-Ga*Was);          %Flujo masico asociado a los bañistas 
MeBer3=0.1*(N-n);                  %Flujo masico asociado a los espectadores 
MeBer4=(MeBer+MeBer2+MeBer3)/3600; %Flujo masico de agua evaporada [kg/s]

QevBer=(MeBer4*Cv)*1000;           %Calor perdido por evaporacion [W]

%Piscina cerrada
MeBerc=MeBer/3600;                 %Flujo masico de agua evaporada sin bañistas [kg/s]

QevBerc=(MeBerc*Cv)*1000;          %Calor perdido por evaporacion [W]

%Promedio de gasto diario
hAc=12;  %Horas abierta (con bañistas)[h]
hIn=12;  %Horas cerrada (sin bañistas)[h]

Qev=((hAc*QevBer)+(hIn*QevBerc))/24;%Calor promedio perdido por evaporacion [W]

                %================ Calor de radiacion ===============

TaK=Ta+273.15;       %Temperatura del agua [°K]
TcK=Tc+273.15;       %Temperatura del aire [°K]
Sboltz=5.67*(10^-8); %Constante de Stefan-Boltzmann [W/m2k4]   
Emsv=0.95;           %Emisividad de la superficie del agua [-]

Qrad=Sboltz*Emsv*((TaK^4)-(TcK^4)); %Calor perdido por radiacion [W] (se considera despreciable en recintos cerrados)

%Para este caso, no se considerara radiacion solar, ya que no contribuye a
%las perdidas, pero se recomienda prever un aumento de la temperatura en el
%recinto y por ende en la piscina, pero como se fija en 25°C para un rango
%de 25-27°C, no se estima que genere inconvenientes, aun asi es recomendable instalar un sistema de 
%refrigeracion en el recinto.

                %================ Calor de conveccion ===============
                
Qcv=real(0.6246*((Ta-Tair)^(4/3))); %Calor perdido por conveccion [W]                
%Se considera despreciable en piscinas cubiertas, dado que el recinto esta
%en regimen permanente, y con el aire a mayor temperatura en relacion al
%agua, por lo que sera favorable y de magnitud pequeña dada la pequeña diferencia de temperaturas.

                %================ Calor de conduccion ===============
                
k1cd=0.027;     %Coeficiente termico de Poliuretano expandido [W/mK]
k2cd=1.63;      %Coeficiente termico de Hormigon armado interior [W/mK]
k3cd=1.63;      %Coeficiente termico de Hormigon armado exterior [W/mK]
e1cd=0.5;       %Espesor de aislante k1 [m]
e2cd=0.5;       %Espesor de muro interior k2 [m]
e3cd=0.5;       %Espesor de muro exterior k3 [m]
R1cd=e1cd/k1cd; %Resistencia termica del aislante [m2K/W]
R2cd=e2cd/k2cd; %Resistencia termica interior [m2K/W]
R3cd=e3cd/k3cd; %Resistencia termica exterior [m2K/W]
Text=10+273.15; %Temperatura promedio de la tierra a 2 metros de profundidad [°K] **SUPOSICION POR FALTA DE DATOS**
dTcd=TaK-Text;
qcd=dTcd/(R1cd+R2cd+R3cd); %Flujo de calor por conduccion [W/m2]

Qcd=qcd*S2;                %Calor perdido por conduccion [W]

            %================ Calor de renovacion de agua ===============

Vre=(1/30)*V; %Volumen de agua minimo a reemplazar en una piscina segun Decreto 209
D=997;        %Densidad del agua a 25°C [kg/m3]
Ce=1.16;      %Calor especifico del agua [Wh/kg°C]
TaR=[12 11 11 10 9 9 8 9 9 10 11 12]; %Temperatura de agua de la red [°C] **SUPOSICION POR FALTA DE DATOS**
Qre2=(Vre*D*Ce*(Ta-TaR))/1000;        %Calor perdido por renovacion de agua [kWh/dia]
Qre=(Qre2*1000)/24;                   %Calor perdido por renovacion de agua [W]

         %================ Resumen de transferencia de calor ===============

Qtotal=QevBer+Qrad+Qcv+Qcd+Qre; %Perdida de calor total de la piscina [W]

Qest=((130-(3*Ta)+(0.2*(Ta^2)))*(S/1000))*1000; %Ecuacion de perdidas termicas 
%para piscinas en recinto techado.

if Qtotal>Qest %Error entre el balance termico realizado y la ecuacion especifica para perdidas en piscinas en recinto techado
    Qerr=((Qtotal-Qest)/Qtotal)*100;
else
    Qerr=((Qest-Qtotal)/Qest)*100; 
end

Day=3;                   %Dias de puesta en regimen de la piscina
T=24*Day;                %Tiempo en horas de puesta en regimen de la piscina
Qpr=(V*D*Ce*(Ta-TaR))/T; %Energia necesaria para poner en regimen la piscina

        %==================== Analisis economico piscina ===================
    
    PT=Qtotal/1000;      %Potencia termica de la piscina [kW]
    MDay=30;             %Dias del mes [-]
    temp=MDay*24;        %Tiempo de uso al mes [h]
    rIns=0.9;            %Rendimiento de la instalacion [-]
    PTmes=(PT/rIns)*temp;%Potencia termica requerida al mes [kWh]
    US=800;              %Valor del dolar en pesos chilenos [$] **SUPOSICION ESTIMATIVA**
   
    rCal=0.85;           %Rendimiento de caldera [-]
    PTmesCal=PTmes/rCal; %Potencia termica utilizada por la caldera a gas [kWh]
    pCal=12.8;           %Poder calorifico del gas utilizado [kWh/kg)
    cCal=900/US;         %Costo por kg del combustible [US$/kg] **SUPOSICION ESTIMATIVA*
    cCal2=pCal/cCal;     %Costo por kWh del combustible [kWh/US$] **SUPOSICION ESTIMATIVA**
    cCal3=PTmesCal/cCal2;%Costo en dolares si se elige caldera a gas [US$/mes]}
    cCal4=cCal3*US;      %Costo en pesos chilenos si se elige la caldera a gas [$/mes]
    
    COPbc=4.8;           %Coeficiente de operaciÃ³n de bombas de calor [-]
    PTmesbc=PTmes/COPbc; %Potencia tÃ©rmica utilizada por la bomba de calor [kWh]
    PTMesbcf=polyfit(Meses,PTmesbc,6);
    PTMesbcf2=polyval(PTMesbcf,Meses);

    pBc=317/US;      %Costo de energÃ­a elÃ©ctrica si se elige bomba de calor[US$/kWh]
    cBc=PTmesbc*pBc; %Costo de operaciÃ³n en dÃ³lares si se elige bomba de calor [US$/mes]
    cBc2=cBc*US;     %Costo de operaciÃ³n en pesos chilenos si se elige bomba de calor [CLP/mes]
    
    PTregbc=((Qpr/1000)/rIns)/COPbc;%Potencia tÃ©rmica utilizada para poner en rÃ©gimen la piscina [kWh]
    cBcreg=PTregbc*pBc;
    cBcreg2=cBcreg*US;              %Costo de poner en rÃ©gimen en pesos chilenos [CLP]
    
    PTregCal=((Qpr/1000)/rIns)/rCal;%Potencia tÃ©rmica utilizada para poner en rÃ©gimen la piscina [kWh]
    cBregCal=PTregCal*cCal2;        %Costo de operaciÃ³n en dolares de puesta en rÃ©gimen de la piscina si se elige caldera [US$/mes]
    cBregCal2=cBregCal*US;          %Costo de puesta en rÃ©gimen en pesos chilenos si se elige caldera
    
%===============================================================================

     %======================== Agua caliente sanitaria =====================
     
Duchas=250;        %NÃºmero mÃ¡ximo de duchas por dÃ­a, asumiendo una ducha por baÃ±ista [-]
vDuc=30;           %VolÃºmen de agua por cada ducha, para gimnasios [m3]
vDucd=Duchas*vDuc; %VolÃºmen de agua por dÃ­a utilizada en duchas [m3]
TDuc=45;           %Temperatura de salida del agua caliente de la ducha [Â°C]
Ce2=1.16*(10^-3);  %Calor especÃ­fico del agua [kWh/kgK]
QACS=(vDucd*(TDuc-TaR)*Ce2)*(MDay-4); %Calor utilizado en calentar el agua sanitaria durante un dÃ­a de mÃ¡xima capacidad de baÃ±istas al mes. [kWh]
QACSf=polyfit(Meses,QACS,6);
QACSf2=polyval(QACSf,Meses);

     %==================== Aporte de paneles termosolares ==================

     SoNTub=18;       %NÃºmero de tubos del colector solar [-]
     SoA=1.7;         %Area efectiva por cada panel solar [m2]
     Son=0.789;       %Rendimiento del captador solar [-]
     SoNP=52;         %NÃºmero de paneles solares
     SoEf=(SoNP*SoA); %Area solar efectiva de todos los paneles solares [m2]
     SoA2=((1570/10)/100)*((1990/10)/100); %Area total de cada panel solar [m2]
     SoE=[7.07 6.9 6.35 4.67 3.28 2.89 2.93 3.56 5.11 5.78 6.72 7]*MDay; %EnergÃ­a solar disponible en zona de emplazamiento de paneles al mes [kWh/m2] 
     SoA3=SoA2*SoNP;  %Area total del techo ocupada por paneles solares [m2]
     SoEt=SoEf*SoE;   %EnergÃ­a solar disponible en un mes [kWh]
     SoC=531369;      %Costo de cada panel solar [$]
     SoCt=SoNP*SoC;   %Costo de la totalidad de paneles solares [$]

     %figure (1)
     %hold on
     %xlim(lims)
     %plot(Meses,SoEt)
     %plot(Meses,QACSf2)
     %plot(Meses,PTMesbcf2)
     %ylabel('Potencia al mes [kWh]')
     %legend('EnergÃ­a solar [kWh]','Agua caliente sanitaria [kWH]', 'CalefacciÃ³n de piscina [kWh]')
     %xlabel('Mes del aÃ±o [-]')
     %hold off

     PTTot=(QACSf2+PTMesbcf2)-SoEt; %Gasto energÃ©tico neto de temperar la piscina y ACS [kWh]
     PTTot2=(QACSf2+PTMesbcf2); %Gasto energetico neto de temperar la piscina y ACS sin paneles solares [kWh]
     cPTTot=PTTot*87; %Costo en pesos chilenos de temperar piscina y ACS
     
%%     
     %==================== ClimatizaciÃ³n del aire ==================
     
      %==================== Datos del recinto ==================
        
        Lar=33;             %Largo del recinto [m]
        Anc=30.5;           %Ancho del recinto [m]
        Ang=1;              %Ã�ngulo de inclinaciÃ³n del techo en grados [-]
        Ang2=Ang*(pi/180);  %Ã�ngulo de inclinaciÃ³n del techo [rad]
        AncT=Anc*sin(Ang2); %DisminuciÃ³n de altura del recinto [m]
        AncT2=Anc*cos(Ang2);%Ancho real del techo [m]
        Alt=9;              %Altura mÃ¡xima del recinto [m]
        AltT=Alt-AncT;      %Altura mÃ­nima del recinto [m]
        LarV1=2;            %Largo de ventana tipo 1 [m]
        LarV2=2;            %Largo de ventana tipo 2 [m]
        LarV3=1.5;          %Largo de ventana tipo 3 [m]
        AnV1=10;            %Ancho de ventana tipo 1 [m]
        AnV2= 4.5;          %Ancho de ventana tipo 2 [m]
        AnV3=10;            %Ancho de ventana tipo 3 [m]
        
        ArTe=(Lar*AncT2);                   %Area del techo [m2]
        ArExt=((Alt*Anc)-((Anc*AncT)/2))*2; %Ã�rea de los extremos [m2]
        ArLad=(Lar*Alt)+(Lar*AltT);         %Area de los lados [m2]
        ArTot=ArTe+ArExt+ArLad;             %Area total del recinto cerrado [m2]
        ArV1=LarV1*AnV1;                    %Area de ventana tipo 1 [m2]
        ArV2=LarV2*AnV2;                    %Area de ventana tipo 2 [m2]
        ArV3=LarV3*AnV3;                    %Ã�rea de ventana tipo 3 [m2]
        nVen1=2;                            %NÃºmero de ventanas tipo 1 [-]
        nVen2=2;                            %NÃºmero de ventanas tipo 2 [-]
        nVen3=2;                            %NÃºmero de ventanas tipo 3 [-]
        ArTV=(nVen1*ArV1)+(nVen2*ArV2)+(nVen3*ArV3); %Ã�rea total ocupada por ventanas [m2]
        
        kMat1=0.027; %Coeficiente tÃ©rmico de material aislante [W/m2K]
        kMat2=1.63;  %Coeficiente tÃ©rmico de material estructural (hormigÃ³n) [W/m2K]
        kMat3=2.5;   %Coeficiente tÃ©rmico de material de ventanas termopanel [W/m2K]
        e1=0.5;      %Espesor del material aislante [m]
        e2=0.2;      %Espesor del material estructural [m]
        e3=0.1;      %Espesor del material de ventanas termopanel [m]
        R1=e1/kMat1; %Resistencia tÃ©rmica del material aislante [m2W/K]
        R2=e2/kMat2; %Resistencia tÃ©rmica del material estructural [m2W/K]
        RE=R1+R2;    %Resistencia tÃ©rmica de estructura [m2W/K]
        R3=e3/kMat3; %Resistencia tÃ©rmica del material de ventanas termopanel [m2/K]
        
        TairEx=[17.69 17.56 16.15 13.47 11.43 10.14 9.45 9.97 11.06 12.35 14.24 15.98]; %Temperatura ambiente en Arauco cada mes [Â°C]
        hrA=[0.66 0.68 0.69 0.74 0.80 0.83 0.83 0.82 0.78 0.76 0.73 0.70];              %Humedad del aire en Arauco [-]
        TairD=Tair-TairEx;    %Diferencia de temperatura interior-exterior del aire [Â°C]
        qE1=(TairD)/RE;       %Flujo de calor en la estructura [W/m2]
        qE2=(TairD)/R3;       %Flujo de calor en las ventanas [W/m2]
        QE1=qE1*ArTot;        %Calor transmitido por conducciÃ³n en la estructura [W]
        QE2=qE2*ArTV;         %Calor transmitido por conducciÃ³n en ventanas [W]
        QET=((QE1+QE2)/1000); %Calor transmitido por conducciÃ³n en todo el recinto, considerando rÃ©gimen permanente, es todo el calor perdido. [kW]

        %AquÃ­ se utilizÃ³ el cÃ³digo Deshumidificador.EES para obtener estos valores a partir de QET y TairD.
        Qheat=[22.87 22.96 23.64 23.44 22.13 20.84 20.01 19.46 21.80 22.16 23.69 23.68]; %Potencia utilizada por baterÃ­a caliente del sistema de acondicionamiento de aire [kW]
        Qcool=[-5.042 -5.112 -5.876 -7.327 -8.432 -9.131 -9.504 -9.223 -8.633 -7.700 -6.910 -5.968]; %Potencia utilizada por baterÃ­a frÃ­a del sistema de acondicionamiento de aire [kW]
        Qheco=Qheat+(-Qcool); %Potencia aproximada a utilizar por el equipo de acondicionamiento de aire [kW]
        COPbcair=3.38; %COP de bomba de calor para el aire.
        Qheco2=Qheco/COPbcair; %Potencia utilizada por red elÃ©ctrica trifÃ¡sica
        Qhecot=Qheco2*temp; %Potencia utilizada en un mes [kWh]
        Qhecotf=polyfit(Meses,Qhecot,6);
        Qhecot2=polyval(Qhecotf,Meses);
        Qhecoc=Qhecot*317; %Precio de electricidad utilizada
        
%%        
                 %==================== Resumen gráfico ================== 
                 
     figure (1)
        hold on
        xlim(lims)
        xlabel('Mes del año [-]')
        ylabel('Energía eléctrica [kWh]')
        title('Consumo mensual de energía eléctrica para temperar agua, sin paneles solares.')
        plot(Meses,PTTot2)
        hold off
     
     figure (2)
        hold on
        xlim(lims)
        xlabel('Mes del año [-]')
        ylabel('Energía eléctrica [kWh]')
        title('Consumo mensual de energía eléctrica para temperar agua, con paneles solares.')
        plot(Meses,PTTot)
        hold off
     
     figure (3)
        hold on
        xlim(lims)
        plot(Meses,Qhecot2)
        ylabel('Energía eléctrica [kWh]')
        legend('Calefacción del aire [kWh]')
        title('Consumo mensual de energía eléctrica para temperar aire.')
        xlabel('Mes del año [-]')
        hold off
        
     figure (4)
        hold on
        xlim(lims)
        plot(Meses,SoEt)
        plot(Meses,QACSf2)
        plot(Meses,PTMesbcf2)
        plot(Meses,Qhecot2)
        ylabel('Energía [kWh]')
        legend('Aporte de energía solar [kWh]','Agua caliente sanitaria [kWh]', 'Calefacción de la piscina [kWh]','Calefacción del aire [kWh]')
        xlabel('Mes del año [-]')
        title('Resumen energético del recinto deportivo.')
        hold off
        
        QTTot=(Qhecot2+PTMesbcf2+QACSf2)-SoEt;
        QTTot2=(Qhecot2+PTMesbcf2+QACSf2);

        figure (5)
        hold on
        plot(Meses,QTTot)
        ylabel('Energía eléctrica [kWh]')
        xlim(lims)
        xlabel('Mes del año [-]')
        title('Consumo neto de energía eléctrica del recinto deportivo.')
        hold off
        
        QTTot3=((Qhecot2)*87)+((PTMesbcf2+QACSf2-SoEt)*317);
        QTTot3m=mean(QTTot3);
        QTTot4=((Qhecot2)*87)+((PTMesbcf2+QACSf2)*317);
        QTTot4m=mean(((Qhecot2)*87)+((PTMesbcf2+QACSf2)*317));
        figure (6)
        hold on
        xlim(lims)
        plot(Meses,QTTot3)
        plot(Meses,QTTot4)
        ylabel('Costo de energía eléctrica [CLP]')
        xlabel('Mes del año [-]')
        title('Gasto mensual de energía eléctrica de la piscina semiolímpica.')
        legend('Con paneles solares','Sin paneles solares')
        hold off
 
        %%
             %==================== Selección de equipos y cantidad de material aislante ==================
             
        selQc=max(Qheat); %Selección de batería caliente para aire [kW]
        selQf=max(abs(Qcool)); %Selección de batería fría para aire [kW]
        selBC=max(PT)+max(QACS/(24*26)); %Selección de bomba de calor piscina y ACS [kW]
        Vais1=(ArTot*e1); %Volúmen de aislante utilizado en recinto. [m3]
        Vais2=S2*e1cd; %Volumen de aislante utilizado en piscina. [m3]
        Vaist=Vais1+Vais2; %Volumen de aislante utilizado. [m3]