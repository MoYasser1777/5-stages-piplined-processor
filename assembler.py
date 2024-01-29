import os
import re

def clean_string(input_string):    
    modified_string = re.sub(r'\s{2,}', ' ', input_string)          # Replace multiple spaces with a single space 
    modified_string = re.sub(r'\s*,\s*', ',', modified_string)      # Remove spaces next to commas
    return modified_string

def remove_spaces(input_string):
    return input_string.replace(' ', '')    


def HexToBinary(num):
    print(num)
    num = int(str(num), base=16)
    return "{0:b}".format(int(num))

def addressRegister(word):
    if word == "R0" :
        return "000"
    elif word == "R1":
        return "001"
    elif word == "R2":
        return "010"
    elif word == "R3":
        return "011"
    elif word == "R4":
        return "100"
    elif word == "R5":
        return "101"
    elif word == "R6":
        return "110"
    elif word == "R7":
        return "111"


f1 = open("Branch.asm", "r")
if os.path.exists("asm.data"):
    os.remove("asm.data")
    

lines = ["0000000000000000\n"] * 2048  





def fillFirst32(num, start):
    start = int(start, base=16)
    num2 = num
    print(start, num)
    for i in range(int(start - num )):
        lines[num] = opCode+"0000000000000000\n"
        num2 = num2 + 1
    print(num2)
    return num2


num = 0
for line in f1:
    line = clean_string(line)
    # if this line is a comment
    if line[0] == "#":
        continue
    opCode = ""
    # check if this line going to another position
    

    # check if the line has a comment trim it
    if line.find("#") != -1:
        indexOfComment = line.index("#")
        line = line[:indexOfComment]
    instructionParts = line.split(" ")

    # remove leading and trailing spaces
    instructionParts[0] = instructionParts[0].strip()
    if len(instructionParts) == 2:
        instructionParts[1] = instructionParts[1].strip()
    
    instructionParts[0] = instructionParts[0].upper()
    print(instructionParts[0])
    if instructionParts[0] == "NOP" or instructionParts[0] == "nop":
        print("NOP")
        opCode = "0000000000000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "NOT" or instructionParts[0] == "not":
        print("NOT")
        opCode = "000001"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "NEG" or instructionParts[0] == "neg":
        print("NEG")
        opCode = "000010"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "INC" or instructionParts[0] == "inc":
        print("INC")
        opCode = "000011"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "DEC" or instructionParts[0] == "dec":
        print("DEC")
        opCode = "000100"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "OUT" or instructionParts[0] == "out":
        print("OUT")
        opCode = "000101"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "IN" or instructionParts[0] == "in":
        print("IN")
        opCode = "000110"
        opCode = opCode + addressRegister(instructionParts[1])  + "000" + addressRegister(instructionParts[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "SWAP" or instructionParts[0] == "swap":
        print("SWAP")
        opCode = "010000"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) +"000"+ addressRegister(registers[1])+"0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "ADD" or instructionParts[0] == "add":
        print("ADD")
        opCode = "010001"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) + addressRegister(registers[1]) + addressRegister(registers[2]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "ADDI" or instructionParts[0] == "addi":
        print("ADDI")
        registers = instructionParts[1].split(",")
        opCode = "010010" 
        opCode = opCode + addressRegister(registers[0]) +"000"+ addressRegister(registers[1]) + "1"
        immediateNumber = str(HexToBinary(registers[2])).zfill(16)
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "SUB" or instructionParts[0] == "sub":
        print("SUB")
        opCode = "010011"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) + addressRegister(registers[1]) + addressRegister(registers[2]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "AND" or instructionParts[0] == "and":
        print("AND")
        opCode = "010100"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) + addressRegister(registers[1]) + addressRegister(registers[2]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "OR" or instructionParts[0] == "or":
        print("OR")
        opCode = "010101"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) + addressRegister(registers[1]) + addressRegister(registers[2]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "XOR" or instructionParts[0] == "xor":
        print("XOR")
        opCode = "010110"
        registers = instructionParts[1].split(",")
        opCode = opCode + addressRegister(registers[0]) + addressRegister(registers[1]) + addressRegister(registers[2]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "CMP" or instructionParts[0] == "cmp":
        print("CMP")
        opCode = "010111"
        registers = instructionParts[1].split(",")
        opCode = opCode + "000" + addressRegister(registers[0]) + addressRegister(registers[1]) + "0"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "BITSET" or instructionParts[0] == "bitset":
        print("BITSET")
        registers = instructionParts[1].split(",")
        opCode = "011000"
        opCode = opCode + addressRegister(registers[0]) +"000"+ addressRegister(registers[0])+"1"
        immediateNumber = str(HexToBinary(registers[1])).zfill(16)
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "RCL" or instructionParts[0] == "rcl":
        print("RCL")
        registers = instructionParts[1].split(",")
        opCode = "011001"
        opCode = opCode + addressRegister(registers[0]) +"000"+ addressRegister(registers[0])+"1"
        immediateNumber = str(HexToBinary(registers[1])).zfill(16)
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "RCR" or instructionParts[0] == "rcr":
        print("RCR")
        registers = instructionParts[1].split(",")
        opCode = "011010"
        opCode = opCode + addressRegister(registers[0]) +"000"+ addressRegister(registers[0])+"1"
        immediateNumber = str(HexToBinary(registers[1])).zfill(16)
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "PUSH" or instructionParts[0] == "push":
        print("PUSH")
        opCode = "100000"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "POP" or instructionParts[0] == "pop":
        print("POP")
        opCode = "100001"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "LDM" or instructionParts[0] == "ldm":
        print("LDM")
        registers = instructionParts[1].split(",")
        opCode = "100010"
        opCode = opCode + addressRegister(registers[0]) + "0000001"
        immediateNumber = str(HexToBinary(registers[1])).zfill(16)
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "LDD" or instructionParts[0] == "ldd":
        print("LDD")
        registers = instructionParts[1].split(",")
        EA = str(HexToBinary(registers[1])).zfill(20)
        lsb = EA[-16:]
        msb = EA[:4]
        opCode = "100011"
        opCode = opCode + addressRegister(registers[0]) + "00" + msb + "1"
        immediateNumber = lsb
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "STD" or instructionParts[0] == "std":
        print("STD")
        registers = instructionParts[1].split(",")
        EA = str(HexToBinary(registers[1])).zfill(20)
        lsb = EA[-16:]
        msb = EA[:4]
        opCode = "100100"
        opCode = opCode + addressRegister(registers[0]) + "00" + msb + "1"
        immediateNumber = lsb
        lines[num] = opCode+"\n"
        num = num + 1
        lines[num] = immediateNumber+"\n"
    elif instructionParts[0] == "PROTECT" or instructionParts[0] == "protect":
        print("PROTECT")
        opCode = "100101"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "FREE" or instructionParts[0] == "free":
        print("FREE")
        opCode = "100110"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"  
    elif instructionParts[0] == "JZ" or instructionParts[0] == "jz":
        print("JZ")
        opCode = "110000"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "JMP" or instructionParts[0] == "jmp":
        print("JMP")
        opCode = "110001"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "CALL" or instructionParts[0] == "call":
        print("CALL")
        opCode = "110010"
        opCode = opCode + addressRegister(instructionParts[1]) + "0000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "RET" or instructionParts[0] == "ret":
        print("RET")
        opCode = "110011"
        opCode = opCode + "0000000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == "RTI" or instructionParts[0] == "rti":
        print("RTI")
        opCode = "110100"
        opCode = opCode + "0000000000"
        lines[num] = opCode+"\n"
    elif instructionParts[0] == ".ORG":
        num = int(instructionParts[1]) - 2    
    elif instructionParts[0] == "":
        num = num - 1       
    else:
        print("SYNTAX ERROR IN: "+line) 

    num = num + 1                     

f1.close()



with open("asm.data", "w") as f:
    f.writelines(lines)