import '../../domain/entities/activity_item.dart';
import '../../domain/entities/onboarding_example.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/task_node.dart';

/// Static seed content ported from UI_design/app/page.tsx so the app opens
/// with the same illustrative data as the reference mockup.
class SeedData {
  const SeedData._();

  static const List<Person> initialPeople = [
    Person(id: 1, name: 'Anil ji', role: 'Driver', phone: '+91 98••• 2201', language: 'Hindi', note: 'Usually near the main gate', initials: 'AJ'),
    Person(id: 2, name: 'Bhim', role: 'Cook', phone: '+91 99••• 1842', language: 'Hindi', note: 'Dinner shift', initials: 'BH'),
    Person(id: 3, name: 'Amrita', role: 'Nanny', phone: '+91 97••• 4310', language: 'English', note: 'With Tara on weekdays', initials: 'AM'),
    Person(id: 4, name: 'Shanti', role: 'Househelp', phone: '+91 96••• 9084', language: 'Hindi', initials: 'SH'),
    Person(id: 5, name: 'Fresh Basket', role: 'Grocery', phone: '+91 11••• 7820', language: 'Hinglish', note: 'Society market', initials: 'FB'),
    Person(id: 6, name: 'Maintenance', role: 'Society office', phone: '+91 11••• 1108', language: 'English', initials: 'MO'),
  ];

  static const List<ActivityItem> activitySeed = [
    ActivityItem(time: '8:42 am', title: 'Anil ji will meet you at Gate 2.', meta: '1 call · 38 sec'),
    ActivityItem(time: 'Yesterday', title: 'Coco’s walk is set for 6:30 pm.', meta: '1 call · 1 min'),
    ActivityItem(time: 'Yesterday', title: 'Dinner coordinated for 8 pm.', meta: '4 calls · 7 min'),
  ];

  static const List<TaskNode> paneerNodes = [
    TaskNode(id: 'amrita', person: 'Amrita', action: 'Check what’s at home', state: NodeState.calling),
    TaskNode(id: 'grocery', person: 'Fresh Basket', action: 'Order what’s missing', state: NodeState.waiting),
    TaskNode(id: 'bhim', person: 'Bhim', action: 'Cook paneer butter masala', state: NodeState.waiting),
    TaskNode(id: 'shanti', person: 'Shanti', action: 'Coordinate cleaning', state: NodeState.waiting),
  ];

  static const List<OnboardingExample> onboardingExamples = [
    OnboardingExample(request: 'Ask my driver to meet me at the gate in five minutes.', source: 'Driver replied', result: '“I’ll be at Gate 2.”', initials: 'DR'),
    OnboardingExample(request: 'Find out what time the househelp is coming today.', source: 'Househelp replied', result: '“I’ll come around 6 pm.”', initials: 'HH'),
    OnboardingExample(request: 'Coordinate dinner so everything is ready by eight.', source: 'Dinner coordinated', result: 'Groceries by 6:15. Dinner by 8.', initials: '✓'),
    OnboardingExample(request: 'Ask maintenance for an electrician on Sunday afternoon.', source: 'Maintenance confirmed', result: 'Electrician booked for Sunday, 3 pm.', initials: 'MO'),
  ];

  static const List<String> personRoles = [
    'Driver',
    'Cook',
    'Nanny',
    'Househelp',
    'Dog walker',
    'Vendor',
    'Society office',
    'Other',
  ];

  static const List<String> languages = [
    'Hindi',
    'English',
    'Hinglish',
    'Punjabi',
    'Bengali',
    'Tamil',
    'Marathi',
  ];
}
