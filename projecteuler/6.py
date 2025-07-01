x=y=0
for z in range(101):x+=z;y+=z*z
x**=2;print(x-y)

# x and y are both set to 0, then counting up from 0-100, x adds z (the for loop variable) up and y adds the square of z then finally x is set to the power of 2 and prints x - y