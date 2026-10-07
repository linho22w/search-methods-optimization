clc
clear
close all;

f1 = @(x) 4*(sin(5*pi*x+0.5).^6).*exp(log2((x-0.8).^2)); %Funcao

iteracoes = 480; %Numero de iteraçoes
x_range = 1; %Amplitude do espaço
x_radius = x_range / 20; %Vizinhança
x_current = rand * x_range; %x_inicial
y_current = f1(x_current);%y_inicial

% Auxiliar para armazenar resultados (hill climbers)
% Através de uma matriz de zeros com iteracoes + 1 linhas e 1 coluna
x_hist = zeros(iteracoes + 1, 1); 
y_hist = zeros(iteracoes + 1, 1);

%Ponto de partida
x_hist(1) = x_current;
y_hist(1) = y_current;

for i = 1:iteracoes
    %posicao atual
    y_current = f1(x_current);

    %nova posicao na vizinhança
    x_new = x_current + x_radius * (2*rand - 1);

    %garantir que o x_new pertence dentro do intervalo [0, 1]
    x_new = max(0, min(1, x_new));

    %nova posicao
    y_new = f1(x_new);

    %Verificar se a nova posicao é melhor ou igual a posicao atual
    if y_new >= y_current
        x_current = x_new;
    end

    x_hist(i + 1) = x_current;
    
end

fprintf('Soluçao: x = %f ; y = %f ', x_current, y_current)

x = linspace(0,1,500); %0 até 1 com 500 elementos, de maneira a ver-se bem a f1
y = f1(x);

% Mostrar resultados
plot(x, y, 'b');
hold on;
plot(0.066,1.6332,'o', 'markersize', 9, 'MarkerFaceColor', 'yellow', 'MarkerEdgeColor', 'red')
plot(x_hist, f1(x_hist), 'o', 'Color', [0.5, 0.5, 0.5], 'MarkerSize', 6);
plot(x_hist(1), y_hist(1), 'o', 'markersize', 4, 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'black');
plot(x_current,y_current,'o','markersize', 6, 'MarkerFaceColor','green', 'MarkerEdgeColor', 'black');
title('Hill Climbing');
axis([0,1,-0.1,2]); % Delimitar os eixos
xlabel('x');
ylabel('f(x)');
legend('f1(x)', 'Máximo global','Iteracoes', 'Ponto de partida', 'Solução');
hold off;