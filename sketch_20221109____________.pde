int[] list = new int[10000];

int i, j, index, tmp, max;

for (i = 0; i < list.length; i++) {
list[i] = (int) random(10000);
}
println();

for (i = 0; i < list.length; i++) {
print(list[i] + " ");
}
println();

for (i = 0; i < list.length; i++) {
max = -1;
index = -1;
for (j = 0; j < list.length - i; j++) {
if (max < list[j]) {
max = list[j];
index = j;
}
}
if (index != -1) {
tmp = list[list.length - 1 - i];
list[list.length - 1 - i] = max;
list[index] = tmp;
}
}

println();
for (i = 0; i < list.length; i++) {
print(list[i] + " ");
}
