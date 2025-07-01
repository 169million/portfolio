x=20
while any(x%y for y in range(1,21)): x+=20
print(x)
# x starts at 20 bc that is the highest number in the range, then while if there is any number not divisible by 1 through 20 then add 1 to x if the any fails then the code continues to then printing the final product
