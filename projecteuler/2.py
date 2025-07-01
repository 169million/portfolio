a,b,s=1,2,0
while b<4e6:s+=b*(b%2==0);b,a=a+b,b
print(s)
#while b is less than 4 million, a=b and b=a+b, s (add variable) adds b if it is even