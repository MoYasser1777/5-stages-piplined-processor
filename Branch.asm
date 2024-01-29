# all numbers in hex format
# we always start by reset signal
#if you don't handle hazards add 3 NOPs
#this is a commented line
# .ORG 500 means the following line should be added at the 500th entry in the instruction memory
#you should ignore empty lines

# Put the interrupt address in the memory
LDM R1, 100
STD R1, 2

in R1     #R1=30
in R2     #R2=50
in R3     #R3=100
in R4     #R4=300   
Push R4   #sp=7FD, M[7FE, 7FE]=300
call R1

INC R3 

.ORG 30
AND R5,R1,R5   #R5=0 , Z = 1
INC R7      #this statement shouldn't be executed

ret