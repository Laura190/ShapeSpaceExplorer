%% Choose word
word = ['cup'];
distData = allDistances.(word);

%% 1. Intra-word distances
intra = triu(distData.sameWord,1);  % upper triangle only
intra = intra(intra>0);

%% 2. Inter-word distances
inter = [];
otherWords = fieldnames(distData);
otherWords = setdiff(otherWords, 'sameWord');
for k = 1:numel(otherWords)
    inter = [inter; distData.(otherWords{k})(:)];
end

%% 3. Two-sample t-test
[h, p] = ttest2(intra, inter);

%% 4. Combine data for plotting
distances = [intra; inter];
groups = [repmat({[word ' Same']}, numel(intra), 1); repmat({[word ' Other']}, numel(inter), 1)];
groupsCat = categorical(groups);

%% 5. Plot swarm
figure;
swarmchart(groupsCat, distances, 'filled');
ylabel('Euclidean Distance');
title(['Distances for word: ', word]);
grid on;
hold on;

%% 6. Overlay mean ± std using errorbar
grpNames = categories(groupsCat);
meanVals = zeros(numel(grpNames),1);
stdVals = zeros(numel(grpNames),1);

for i = 1:numel(grpNames)
    idx = groupsCat == grpNames{i};
    meanVals(i) = mean(distances(idx));
    stdVals(i) = std(distances(idx));
end

errorbar(1:numel(grpNames), meanVals, stdVals, 'kx', 'LineWidth', 2, 'MarkerSize', 12);

%% 7. Add p-value text
%text(1.5, max(distances)*1.05, sprintf('p = %1.4e', p), 'FontSize', 12, 'HorizontalAlignment', 'center');

hold off;
