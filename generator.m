SCALE = 20;
N_DIM = 6000;
INTV = [481, 540];
ENTRY_RATIO = [0.05, 0.10];                                                 % 5%-10% entries have a value
ENTRY_RATIO_IN_INTV = [0.10, 0.30];                                         % 10%-30% entries in [481, 540] have a value
RANGE = [0, 255];

LOWER_BOUND = INTV(1);
UPPER_BOUND = INTV(2);
n_intv = UPPER_BOUND - LOWER_BOUND + 1;                                             % #-entries in [481, 540]

matrix = uint8(zeros(20, N_DIM));

dirname = datestr(now,'yyyy-mm-dd HH-MM-SS');
mkdir(dirname)

for i = 1:20
    vector = uint8(zeros(1, N_DIM));
    n_entry = randi(N_DIM * ENTRY_RATIO, 1);
    
    if i ~= 20
        n_entry_in_intv = randi(uint16(n_intv * ENTRY_RATIO_IN_INTV), 1);
        n_entry_out_intv = n_entry - n_entry_in_intv;
        
        idx = LOWER_BOUND + randperm(n_intv, n_entry_in_intv);              % Draw a non-repeat sample in INTV
        vector(idx) = randi(RANGE, 1, n_entry_in_intv);
        
        idx = randperm(N_DIM - n_intv, n_entry_out_intv);
        j = find(idx >= LOWER_BOUND);
        idx(j) = idx(j) + n_intv;
        vector(idx) = randi(RANGE, 1, n_entry_out_intv);
    else
        idx = randperm(N_DIM, n_entry);
        vector(idx) = randi(RANGE, 1, n_entry);
    end
    
    image = uint8(zeros(SCALE, N_DIM * SCALE));
    idx = find(vector > 0);
    for j = 1:size(idx, 2)
        dy =  1 + (idx(j) - 1) * SCALE : idx(j) * SCALE;
        image(:, dy) = vector(idx(j));
    end
    filename = sprintf('%s/%d.png', dirname, i);
    imwrite(image, filename);
    
%     disp('Indices of entries (non-zero values):');
%     find(vector > 0);
%     
    matrix(i, :) = vector;
end