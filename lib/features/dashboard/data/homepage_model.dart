class Homepage {
  bool? success;
  Data? data;

  Homepage({this.success, this.data});

  factory Homepage.fromJson(Map<String, dynamic> json) => Homepage(
    success: json['success'] as bool?,
    data: json['data'] != null ? Data.fromJson(json['data']) : null,
  );

  Map<String, dynamic> toJson() => {'success': success, 'data': data?.toJson()};
}

class Data {
  String? memberNumber;
  int? totalContributions;
  String? lastContributionDate;
  String? branchName;
  int? upcomingEventsCount;
  int? unreadNotifications;
  List<RecentActivity>? recentActivity;
  String? currencySymbol;
  String? churchName;

  Data({
    this.memberNumber,
    this.totalContributions,
    this.lastContributionDate,
    this.branchName,
    this.upcomingEventsCount,
    this.unreadNotifications,
    this.recentActivity,
    this.currencySymbol,
    this.churchName,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    memberNumber: json['member_number'] as String?,
    totalContributions: json['total_contributions'] as int?,
    lastContributionDate: json['last_contribution_date'] as String?,
    branchName: json['branch_name'] as String?,
    upcomingEventsCount: json['upcoming_events_count'] as int?,
    unreadNotifications: json['unread_notifications'] as int?,
    recentActivity: json['recent_activity'] != null
        ? (json['recent_activity'] as List)
              .map((e) => RecentActivity.fromJson(e as Map<String, dynamic>))
              .toList()
        : null,
    currencySymbol: json['currency_symbol'] as String?,
    churchName: json['church_name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'member_number': memberNumber,
    'total_contributions': totalContributions,
    'last_contribution_date': lastContributionDate,
    'branch_name': branchName,
    'upcoming_events_count': upcomingEventsCount,
    'unread_notifications': unreadNotifications,
    'recent_activity': recentActivity?.map((e) => e.toJson()).toList(),
    'currency_symbol': currencySymbol,
    'church_name': churchName,
  };
}

class RecentActivity {
  String? type;
  String? title;
  String? description;
  DateTime? time;
  String? icon;
  String? color;

  RecentActivity({
    this.type,
    this.title,
    this.description,
    this.time,
    this.icon,
    this.color,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) => RecentActivity(
    type: json['type'] as String?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    time: json['time'] != null
        ? DateTime.tryParse(json['time'] as String)
        : null,
    icon: json['icon'] as String?,
    color: json['color'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'title': title,
    'description': description,
    'time': time?.toIso8601String(),
    'icon': icon,
    'color': color,
  };
}
