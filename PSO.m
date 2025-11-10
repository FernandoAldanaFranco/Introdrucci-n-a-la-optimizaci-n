%PSO Versión 1.0
%Fernando Aldana Franco
%Abril 2025
%%
clc; %limpia línea de comandos
clear all; %Limpia espacio de trabajo
close all; %Cierra ventanas abiertas
%%
%Variables del programa
%De la función
syms x; %Variable simbólica
syms y; %Variable simbólica
syms z; %Variable simbólica
syms w; %Variable simbólica
f=(x-1)^2+(y-1)^2+(z-1)^2+(w-1)^2; %Declara la función
Resolution=100000; %Resolución de los pesos
nvariables=4;
%Del AG
NumberIndividuals=100; %Cantidad de individuos en una generación
NumberGenerations=100; %Número de generaciones
Resolution=100000; %Resolución de los pesos
fitness=zeros(1,NumberIndividuals); %Guarda la aptitud de la generación
stats=zeros(NumberGenerations,3); %Guarda las estadísticas de todo el proceso: best, average & worst
theBest=zeros(1,nvariables);%Guarda al mejor en cada generación
individual=zeros(NumberIndividuals,nvariables); %Guarda a los individuos de una generación
best=1; %Índice del mejor individuo por generación
worst=1; %Índice del peor individuo por generación
%%
%PSO
individualTemp=zeros(NumberIndividuals,nvariables);
fitnessTemp=zeros(1,NumberIndividuals); %Arreglo temporal de vuelos
vel=zeros(NumberIndividuals,nvariables);
cInercia=0.7;%W o coeficiente de incercia [0.4, 0.9]
c1=2;%Componente cognitivo [1.5, 2.5]
c2=2;%Componente social [1.5, 2.5]
r1=0;
r2=0;
max=1000;
lbest=1;
lbestIndividual=zeros(1,nvariables);%Local best
gbest=1;
gbestIndividual=zeros(1,nvariables);%Global best
pbest=zeros(1,NumberIndividuals);%Guarda las mejores puntuaciones individuales
pbestIndividuals=zeros(NumberIndividuals,nvariables); %Guarda a los individuos de una generación
%%
%Inicia la población
%rng(0,'twister'); %Inicia números aleatorios
rng(0,'philox');
for ci=1:NumberIndividuals %CI es contador de individuos
    for cw=1:nvariables %CW es contador de pesos
        individual(ci,cw)=(10*randi(Resolution))/Resolution; %Genera pesos aleatorios
        if randi(10)>5
            individual(ci,cw)=-1*individual(ci,cw); %Cambia el signo
        end
    end
end
%%
%Ciclo principal
for cg=1: NumberGenerations %CG es el contador de generaciones
    %Define r1 y r2
    r1=randi(max)/max;
    r2=randi(max)/max;
    %Prueba cada red de la generación presente
    for ci=1: NumberIndividuals
        %Prueba cada solución
        eval_fun=subs(f,[x,y,z,w],[individual(ci,1),individual(ci,2),individual(ci,3),individual(ci,4)]); %Evalua la función en el punto siguiente
        fitness(1,ci)=(100-double(eval_fun));%Guarda el fitness. Si el valor obtenido es mínimo, el fitness se incrementa
        %Aquí actualiza pbest
        if cg==1 %Para primera generación
            pbest(1,ci)=fitness(1,ci);%Copia directamente el valor del primer fitness como pbest
            pbestIndividuals(ci,:)=individual(ci,:);%Copia al individuo mejor ranqueado como pbest
        else %Para generaciones posteriores
            if pbest(1,ci)<fitness(1,ci) %Verifica si hay un nuevo pbest para el individuo
                pbest(1,ci)=fitness(1,ci);%Actualiza pbest
                pbestIndividuals(ci,:)=individual(ci,:);%Y conserva el vuelo pbest
            end
        end
    end
    %GBest
    best=1; %Guarda el índice del mejor individuo por generación
    worst=1; %Guarda el índice del peor individuo por generación
    for ci=2: NumberIndividuals
        %Busca al mejor
        if fitness(1,best)<fitness(1,ci)
            best=ci;
        end
        %Y al peor
        if fitness(1,worst)>fitness(1,ci)
            worst=ci;
        end
    end
    lbest=fitness(1,best);
    lbestIndividual(1,:)=individual(best,:);%Copia al mejor de este vuelo
    if(lbest>gbest)
        gbest=lbest;%Actualiza global best
        gbestIndividuals(1,:)=individual(best,:);%Copia al mejor de este vuelo
    end
    %Copia al mejor de los individuos
    for cw=1:nvariables
        theBest(1,cw)=individual(best,cw);
    end
    %Copia individuos un arreglo temporal
    individualTemp(:,:)=individualTemp(:,:);
    fitnessTemp(:,:)=fitness(:,:);
    %Calcula velocidad y nueva posicion
    for ci=1:NumberIndividuals
        for cw=1: nvariables
            vel(ci,cw)=(cInercia*vel(ci,cw))+(c1*r1*(pbestIndividuals(ci,cw)-individual(ci,cw)))+(c2*r2*(gbestIndividuals(1,cw)-individual(ci,cw)));
            individual(ci,cw)=individual(ci,cw)+vel(ci,cw);%Actualiza posición
        end
    end
    %Estadísticas de la generación
    stats(cg,1)=fitness(1,best);%Mejor
    stats(cg,3)=fitness(1,worst);%Peor
    aux=0;%Auxiliar
    for ci=1:NumberIndividuals %Recorre el fitness de cada individuo
        aux=aux+fitness(1,ci);%Suma el fitness del individiuo
        fitness(1,ci)=0;%Limpia fitness
    end
    stats(cg,2)=aux/NumberIndividuals;%Calcula el promedio
end
plot((1:NumberGenerations),stats(:,2));
hold on;
plot((1:NumberGenerations),stats(:,1));
plot((1:NumberGenerations),stats(:,3));
hold off;