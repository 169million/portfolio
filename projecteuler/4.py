print(max(x*y for x in range(999,99,-1) for y in range(999,99,-1) if str(x*y) == str(x*y)[::-1]))
# for every x going down from 999 to 99 and for every y going down from 999 to 99 if x * y is a pallindrome, put that number into the max function and if that number is the biggest, that is the number printed
# learned about the max function and takes what ever the biggest number is.