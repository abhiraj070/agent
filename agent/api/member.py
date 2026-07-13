from main import app
from agent.db.model.user import Member
from agent.db.connect import session
@app.post("/add_members")
def add_members(nick_name: str, saved_name: str, role: str | None=None, description: str="")-> None:
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
            - Looking after pets, including feeding.
            - Handling general household assistance that does not belong to a more specialized role.
            This person should handle general household management requests and coordinate home-related tasks when no other specialized household member is more appropriate.
        """,

        "gardner": """
        Responsible for maintaining the garden and outdoor plants.
            Primary responsibilities:
            - Watering plants, trees, and lawns.
            - Trimming, pruning, and maintaining plants.
            - Lawn mowing and general garden maintenance.
            - Planting new flowers, shrubs, or trees.
            - Removing weeds and keeping outdoor areas clean.
            - Monitoring plant health and reporting issues.
            This person should handle requests involving gardening, lawn care, plant maintenance, watering, pruning, or any outdoor landscape-related tasks.
        """,

        "nanny": """
        Responsible for childcare and the well-being of children.
            Primary responsibilities:
            - Supervising and caring for children.
            - Feeding, bathing, and dressing children.
            - Assisting with homework and educational activities.
            - Organizing playtime and recreational activities.
            - Preparing children for school or bedtime.
            - Monitoring children's safety and daily routines.
            This person should handle requests involving childcare, babysitting, children's daily routines, educational support, or child supervision.

        """,

        "dog_walker": """
            Responsible for caring for and exercising dogs.
            Primary responsibilities:
            - Walking dogs according to their schedule.
            - Cleaning up after the dog during walks.
            - Providing basic companionship and exercise.
            This person should handle requests involving dog walking, exercising.
        """,

        "maintenance": """
        Responsible for home repairs and maintenance tasks.
            Primary responsibilities:
            - Repairing household fixtures and appliances.
            - Fixing plumbing, electrical, or carpentry issues when appropriate.
            - Installing or assembling household items.
            - Performing routine maintenance and inspections.
            - Coordinating with external technicians for major repairs.
            - Troubleshooting household equipment and reporting unresolved issues.
            This person should handle requests involving repairs, installations, maintenance, troubleshooting, or technical household issues.
        """,

        "security": """
        Responsible for ensuring the safety and security of the property.
            Primary responsibilities:
            - Monitoring entry and exit of visitors.
            - Patrolling the property and checking for security concerns.
            - Verifying deliveries and visitor access.
            - Responding to suspicious activity or emergencies.
            - Locking and unlocking gates or entrances as instructed.
            - Reporting security incidents or unusual events.
            This person should handle requests involving property security, visitor management, access control, surveillance, or safety-related assistance.
        """
    }

    member= Member(contact_name=saved_name, nick_name=nick_name, user_description=description, role=role)
    if role is not None and role!='Family' and role!='Friend':
        member.description=role_description[role]
    member.users.append(member)
    session.add(member)
    session.commit()
    return
