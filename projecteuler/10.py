n=int(2e6);a=[1]*n;a[0]=a[1]=f=0
for x in range(2,n):
 if a[x]:f+=x;[a.__setitem__(y,0)for y in range(x+x,n,x)]
print(f)