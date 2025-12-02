 # User input
string = input("Enter a string: ")

unique = ""  

# Logic using simple loop
for ch in string:
    if ch not in unique:
        unique += ch

# Print result
print("String after removing duplicates:", unique)

