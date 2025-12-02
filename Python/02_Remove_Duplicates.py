def remove_duplicates(text):
    unique = ""
    
    for char in text:
        if char not in unique:   
            unique += char

    return unique
