# all numbers in hex format
# we always start by reset signal
#this is a commented line
#you should ignore empty lines

NOT R1         #R1 =FFFFFFFF , C--> no change, N --> 1, Z --> 0
inc R1	       #R1 =00000000 , C --> 1 , N --> 0 , Z --> 1
in R1	       #R1= 5,add 5 on the in port,flags no change	
in R2          #R2= 10,add 10 on the in port, flags no change
NOP
NOP
NOT R2	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
NOP
inc R1         #R1= 6, C --> 0, N -->0, Z-->0
Dec R2         #R2= FFFFFFEE,C-->1 , N-->1, Z-->0
out R1
out R2