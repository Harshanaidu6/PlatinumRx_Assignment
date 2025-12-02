def convert_minutes(total_minutes):
    hours = total_minutes // 60
    minutes = total_minutes % 60

    if hours > 1:
        hour_text = f"{hours} hrs"
    else:
        hour_text = f"{hours} hr"

    return f"{hour_text} {minutes} minutes"
