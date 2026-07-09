from main import app

@app.post("/add_members")
def add_members(nick_name: str, saved_name: str, role: str | None=None, description: str | None=None)-> None:
    #postgres logic for adding this into the users table
    role_description={
        "cook": """
            Responsible for all cooking and meal preparation.
            Primary responsibilities:
            - Preparing breakfast, lunch, dinner, snacks, tea, coffee, and other beverages.
            - Following meal or recipe instructions.
            - Preparing food for specific occasions or guests.
            - Handling requests related to meals and food preparation.
            - Managing cooking-related grocery or ingredient requests when instructed.
            This person should handle any request related to cooking, meals, or food preparation.
        """,

        "maid": """
            Responsible for routine household chores and cleanliness.
            Primary responsibilities:
            - Cleaning rooms and common areas.
            - Sweeping, mopping, dusting, and organizing.
            - Washing utensils, doing laundry, and other household chores.
            - Carrying out general cleaning and maintenance tasks.
            - Receiving household-related instructions from the user.
            This person should handle requests related to cleaning, laundry, and general household chores.
        """,

        "driver": """
        Responsible for transportation and travel assistance.
        Primary responsibilities:
        - Driving the user or family members.
        - Pickup and drop-off arrangements.
        - Airport, railway station, office, school, and other travel.
        - Preparing the vehicle before scheduled travel.
        - Handling transportation-related instructions.
        This person should handle requests involving travel, transportation, pickups, drop-offs, or vehicle-related assistance.
        """,

        "house_manager": """
            Primary household caretaker responsible for managing the home.
            Primary responsibilities:
            - Preparing the house before the user's arrival.
            - Cleaning, organizing, and coordinating household activities.
            - Switching household appliances on or off, such as ACs and lights.
            - Looking after pets, including feeding or walking them.
            - Handling general household assistance that does not belong to a more specialized role.
            This person should handle general household management requests and coordinate home-related tasks when no other specialized household member is more appropriate.
        """
    }
    # TODO: when the user adds a member check the roles and if matches then add the role_description if not leave it. add the description given by the user in user_description
    return
