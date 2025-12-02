# User input
minutes = int(input("Enter minutes: "))

# Logic 
hours = minutes // 60
remaining_minutes = minutes % 60

# Print output
print(hours, "hrs", remaining_minutes, "minutes")
