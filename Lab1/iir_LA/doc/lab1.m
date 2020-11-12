removed_bits = 4;
p=0;
surnames = ["lovesio", "poloni", "pont"];
%surnames = ["Bianchi", "Rossi", "pont"];
x=strlength(surnames(1));
y=strlength(surnames(2));
N = ((2^p)*(mod(x,2) +1)) + (6*p);
nb = mod(y,7) + 8 - removed_bits;

[bi, ai, bq, aq]=myiir_design(N,nb)
my_iir_filter

