clc
clear
close all;

f1 = @(x) 4*(sin(5*pi*x+0.5).^6).*exp(log2((x-0.8).^2)); % Funcao

iteracoes = 240; % Numero de iterações
x_range = 1; % Amplitude do espaço
x_radius = x_range / 20; % Vizinhança
x_current = rand * x_range; % x_inicial
y_current = f1(x_current); % y_inicial

% auxiliar para armazenar resultados 
x_hist = zeros(iteracoes + 1, 1); 
y_hist = zeros(iteracoes + 1, 1);
temperatura_hist = zeros(iteracoes, 1);
probabilidade_hist = zeros(iteracoes, 1);

% Ponto de partida
x_hist(1) = x_current;
y_hist(1) = y_current;

% Parâmetros do Simulated Annealing
T = 90; % Temperatura inicial, máxima
nRep = 2; % Número de repetições para cada valor da temperatura
alfa = 0.95; % Fator de decaimento para a temperatura

for i = 1:iteracoes
    for l = 1:nRep
    % Posicao atual
    y_current = f1(x_current);

    % Novo ponto na vizinhança
    x_new = x_current + x_radius * (2*rand - 1);
    x_new = max(0, min(1, x_new)); %Garante que ele esta dentro dentro de [0,1]

    % Nova posição
    y_new = f1(x_new);

    %Calculo do gradiente de energia
    dE = y_new - y_current;

    %Calculo da probabilidade 
    p = exp(-(abs(dE) / T));

    if dE > 0 %Se este for ascendeste, aceita-se a sol. nova
        x_current = x_new;
        y_current = f1(x_new);
    else
        if (rand < p) %Caso contrário, recorre-se à dec. probabilistica
         x_current = x_new;
         y_current = f1(x_new);
        end
    end

    %Armazenar resultados
    x_hist(i + 1) = x_current;
    temperatura_hist(i) = T;
    probabilidade_hist(i) = p;
    end

    % Decaimento da temperatura
    T = alfa * T;
end

fprintf('Soluçao: x = %f ; y = %f\n', x_current, y_current)

x = linspace(0, 1, 500); %0 até 1 com 500 elementos, de maneira a ver-se bem a f1
y = f1(x);

% Mostrar o gráfico da função otimizada
plot(x, y, 'b');
hold on;
plot(0.066, 1.6332, 'o', 'markersize', 8, 'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'red')
plot(x_hist, f1(x_hist), 'o', 'Color', [0.5, 0.5, 0.5], 'MarkerSize', 4);
plot(x_hist(1), y_hist(1), 'o', 'markersize', 5, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black');
plot(x_current, y_current, 'o', 'markersize', 5, 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'black');
title('Simulated Annealing');
axis([0,1,-0.1,2]); % Delimitar os eixos
xlabel('x');
ylabel('f(x)');
legend('f1(x)', 'Máximo global', 'Iteracoes', 'Ponto de partida', 'Solução');
hold off;

% Gráfico da evolução da temperatura
figure;
subplot(2, 1, 1);
plot(1:iteracoes, temperatura_hist, 'r');
title('Evolução da Temperatura');
xlabel('Iterações');
ylabel('Temperatura');

% Gráfico da evolução da probabilidade
subplot(2, 1, 2);
plot(1:iteracoes, probabilidade_hist, 'b.');
title('Evolução da Probabilidade');
xlabel('Iterações');
ylabel('Probabilidade');





