# def cd(n):s=int(n**0.5);return sum(2 for i in range(1,s+1) if n%i==0) - (s*s==n)
n = 1
# while cd(t := n*(n+1)//2) <= 500: n += 1
while t:=sum(2 for i in range(1,int(n**0.5))) - (int(n**0.5)*int(n**0.5) == n) <= 500:n+=1
print(t)


