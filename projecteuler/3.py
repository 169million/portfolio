n,f=600851475143,2
while f*f<=n: (n:=n//f) if n%f==0 else (f:=f+1 if f==2 else f+2)
print(n)

#while factor * factor is less than n, n is set to n / f IF n mod f is 0 OTHERWISE f is set to f+1 if f==2 otherwise f is set to f+2