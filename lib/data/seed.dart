import 'package:latlong2/latlong.dart';

import '../util/geo.dart';
import 'models.dart';

/// Demo data from the design prototype (Sellwood, Portland OR). Street
/// addresses are real OSM addresses; people's names are made up.
///
/// 49 contacts on the Free plan, so the second contact a tester adds hits
/// the 50-contact limit.
abstract final class Seed {
  static LatLng _u(double x, double y) => fromPrototypeUnits(x, y);

  /// The seller's location in the demo.
  static final me = _u(691, 512);

  /// Default map center.
  static final center = _u(786, 477);

  static final sellwood = Area(
    id: 'sellwood',
    name: 'Sellwood',
    polygon: [_u(691, 330), _u(882, 330), _u(882, 624), _u(691, 624)],
  );

  /// A second outline south of Sellwood, used by the "outline" start states.
  static final southDraft = [_u(691, 632), _u(882, 632), _u(882, 812), _u(691, 812)];

  static const _outcomes = ['Not home', 'Left a flyer', 'Spoke with them', 'Not interested'];
  static const _days = ['Mon', 'Sat', 'Tue', 'Fri'];

  static Stop _f(int id, double x, double y, String street, String name, String phone, String note, String when,
          FollowUpDue due, int order, List<VisitEntry> history) =>
      Stop(
        id: id,
        position: _u(x, y),
        street: street,
        name: name,
        phone: phone,
        note: note,
        state: StopState.followUp,
        due: due,
        when: when,
        order: order,
        history: history,
      );

  static Stop _n(int id, double x, double y, String street) =>
      Stop(id: id, position: _u(x, y), street: street, name: street, state: StopState.unvisited);

  static Stop _v(int id, double x, double y, String street, int i, [String? name, String phone = '']) {
    final o = _outcomes[i % 4], d = _days[i % 4];
    return Stop(
      id: id,
      position: _u(x, y),
      street: street,
      name: name ?? street,
      phone: phone,
      state: StopState.visited,
      statusLine: 'Visited $d · ${o.toLowerCase()}',
      history: [VisitEntry(d, o)],
    );
  }

  static const _visited = <(double, double, String, String?, String?)>[
    (860, 352, '7855 SE 16th Ave', null, null),
    (714, 353, '7856 SE 15th Ave', null, null),
    (748, 354, '1526 SE Bidwell St', null, null),
    (826, 357, '1564 SE Bidwell St', null, null),
    (768, 362, '1534 SE Bidwell St', null, null),
    (784, 366, '1544 SE Bidwell St', null, null),
    (715, 370, '7864 SE 15th Ave', null, null),
    (718, 396, '1507 SE Lexington St', null, null),
    (785, 398, '1541 SE Lexington St', null, null),
    (803, 398, '1551 SE Lexington St', null, null),
    (861, 398, '1583 SE Lexington St', null, null),
    (824, 399, '1563 SE Lexington St', null, null),
    (748, 402, '1523 SE Lexington St', null, null),
    (843, 405, '1573 SE Lexington St', null, null),
    (721, 449, '7906 SE 15th Ave', 'Hannah Cole', '(503) 555-0129'),
    (827, 449, '1564 SE Lexington St', null, null),
    (809, 452, '1556 SE Lexington St', null, null),
    (841, 452, '1574 SE Lexington St', null, null),
    (748, 454, '1524 SE Lexington St', null, null),
    (768, 454, '1534 SE Lexington St', null, null),
    (787, 454, '1544 SE Lexington St', null, null),
    (859, 454, '1584 SE Lexington St', null, null),
    (718, 465, '7916 SE 15th Ave', null, null),
    (860, 487, '7925 SE 16th Ave', null, null),
    (715, 494, '1505 SE Miller St', null, null),
    (771, 496, '1535 SE Miller St', null, null),
    (809, 497, '1553 SE Miller St', null, null),
    (753, 498, '1525 SE Miller St', 'Dale Whitaker', '(503) 555-0175'),
    (731, 499, '1515 SE Miller St', null, null),
    (785, 501, '1543 SE Miller St', null, null),
    (843, 544, '1574 SE Miller St', null, null),
    (828, 545, '1566 SE Miller St', null, null),
    (805, 549, '1556 SE Miller St', null, null),
  ];

  static List<Stop> stops() => [
        _f(1, 785, 548, '1544 SE Miller St', 'Maria Lopez', '(503) 555-0142', 'Interested in a quote. Call after 5pm.',
            '4pm', FollowUpDue.today, 16, const [VisitEntry('Tue', 'Spoke with them · left a flyer')]),
        _f(
            2,
            768,
            397,
            '1533 SE Lexington St',
            'Tom & Priya Nguyen',
            '(503) 555-0110',
            'Asked for a second visit with both home.',
            '6pm',
            FollowUpDue.today,
            18,
            const [VisitEntry('Mon', 'Spoke with Priya')]),
        _f(
            3,
            858,
            371,
            '7865 SE 16th Ave',
            'Grace Whitfield',
            '(503) 555-0187',
            'Wants pricing for the side yard. Bring the sheet.',
            '11am',
            FollowUpDue.today,
            11,
            const [VisitEntry('Mon', 'Spoke with them')]),
        _f(4, 826, 501, '1565 SE Miller St', 'Ruiz family', '(503) 555-0163', 'Wants a quote before spring.',
            'Thu, 10am', FollowUpDue.week, 100, const [VisitEntry('Mon', 'Not home · left a flyer')]),
        _n(5, 830, 595, '1569 SE Nehalem St'),
        _n(6, 848, 591, '1579 SE Nehalem St'),
        _n(7, 806, 590, '1553 SE Nehalem St'),
        _n(8, 856, 504, '7933 SE 16th Ave'),
        _n(9, 861, 546, '1584 SE Miller St'),
        _n(10, 806, 353, '1554 SE Bidwell St'),
        for (var i = 0; i < _visited.length; i++)
          _v(11 + i, _visited[i].$1, _visited[i].$2, _visited[i].$3, i, _visited[i].$4, _visited[i].$5 ?? ''),
        _v(44, 542, 449, '1316 SE Lexington St', 1, 'Ben Okafor', '(503) 555-0118'),
        _v(45, 560, 549, '1326 SE Miller St', 2, 'Lena Park', '(503) 555-0151'),
        _v(46, 597, 494, '1345 SE Miller St', 2, 'Sam & Jo Avery', '(503) 555-0194'),
        _v(47, 618, 491, '1407 SE Miller St', 1, 'Owen Brooks', '(503) 555-0137'),
        _v(48, 575, 548, '1338 SE Miller St', 2, 'Iris Chen', '(503) 555-0166'),
        _f(49, 617, 450, '1406 SE Lexington St', 'Carla Mendes', '(503) 555-0105', 'Call back about the referral.',
            'Sat', FollowUpDue.overdue, -1, const [VisitEntry('Thu', 'Spoke with them')]),
      ];

  /// The 50th contact, used by the "limit-contacts" start state.
  static Stop fiftieth() => _v(50, 594, 451, '1342 SE Lexington St', 2, 'Nora Elling', '(503) 555-0148');

  /// A point near 1579 SE Nehalem St for the drop-a-pin start states.
  static final nehalemPin = _u(848, 572);
}
