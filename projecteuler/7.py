n=int(1e6);a=[1]*n;a[0]=a[1]=f=i=0;[a.__setitem__(y,0) for x in range(2,n) for y in range(x+x,n,x) if a[x]]
while f < 1e4+1:i+=1;f+=a[i];print(i)