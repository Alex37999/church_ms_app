import 'package:get/get.dart';

class AnnouncementsController extends GetxController {
  final RxList<AnnouncementModel> announcements = <AnnouncementModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAnnouncements();
  }

  void fetchAnnouncements() {
    isLoading.value = true;
    try {
      // Initialize with sample data
      announcements.assignAll([
        AnnouncementModel(
          title: "Sunday Service Time Change",
          description:
              "Starting next week, Sunday service will begin at 9:00 AM instead of 10:00 AM. This change has been made to better accommodate our large congregation and reduce overcrowding. We kindly ask all members to adjust their schedules accordingly. The earlier service time will also allow us to host our fellowship breakfast from 10:30 AM to 11:30 AM. Please note that all other activities remain unchanged. Children's Sunday School will still start at 9:15 AM and continue until 10:00 AM. If you have any questions or concerns about this change, please contact the office.\n\nWe look forward to seeing you at the new service time!\n\nGod bless you and your family.",
          source: "Church Admin",
          date: "2026-02-15",
          isNew: true,
        ),
        AnnouncementModel(
          title: "Annual Youth Camp Registration Now Open",
          description:
              "Calling all youth aged 13-18! Registration for our annual Youth Camp is now open. This year's camp will be held from July 15-19, 2026 at Camp Galilee, a beautiful lakeside facility in the mountains.\n\nCamp highlights:\n• Swimming and water sports\n• Team building activities and games\n• Worship and prayer sessions\n• Campfire gatherings with music\n• Leadership and mentorship training\n• Adventure activities including hiking and rock climbing\n• Evening talent shows and entertainment\n\nThe camp fee is \$350 per person, which includes accommodation, meals, and all activities. Limited slots available (only 80 spots), so register early to secure your place. Financial assistance is available for those in need.\n\nRegistration deadline: May 31, 2026\n\nFor more information or to register, contact the Youth Department or visit the church office.",
          source: "Youth Department",
          date: "2026-02-10",
          isNew: true,
        ),
        AnnouncementModel(
          title: "Monthly Prayer Meeting - Friday Evening",
          description:
              "You are cordially invited to join us for our monthly prayer meeting this Friday, February 21st at 6:00 PM in the prayer chapel. This is a wonderful opportunity to lift up our community, church, and nation in prayer.\n\nDuring this month's session, we will be focusing on:\n• Prayers for healing and health\n• Intercession for our leaders and government officials\n• Thanksgiving for answered prayers from last month\n• Special prayer requests from our congregation members\n\nWhether you are experienced in prayer or looking to deepen your prayer life, all are welcome. The meeting typically lasts about one hour. Light refreshments will be served afterward.\n\nBring your prayer requests and an open heart. This is a confidential and supportive environment where we grow together in faith and trust.",
          source: "Prayer Team",
          date: "2026-02-05",
          isNew: false,
        ),
        AnnouncementModel(
          title: "Building Fund Update - 75% Goal Reached",
          description:
              "Praise God! We are thrilled to announce that our building fund has reached 75% of our \$500,000 goal. This is a remarkable achievement made possible through the generous giving and prayers of our church family.\n\nCurrent status:\nAmount Raised: \$375,000\nGoal Amount: \$500,000\nRemaining: \$125,000\n\nWith these funds, we have already begun:\n• Foundation work and site preparation\n• Architectural planning and permits\n• Initial construction contracts\n\nWe are on track to break ground on Phase 1 of the new fellowship hall by April 2026. This new facility will provide much-needed space for youth programs, community outreach, and fellowship events.\n\nWe are grateful for every contribution, whether large or small. If you haven't had an opportunity to give, there are many ways you can participate in this blessing:\n• One-time donations\n• Monthly giving pledges\n• Fundraising event participation\n\nThank you for your faithfulness and generous support of God's vision for our church!",
          source: "Finance Team",
          date: "2026-02-01",
          isNew: false,
        ),
        AnnouncementModel(
          title: "Volunteer Opportunity: Community Outreach",
          description:
              "Our church is launching a new community outreach program and we need YOU! We are seeking passionate volunteers to help serve families in need throughout our neighborhood.\n\nPositions available:\n• Food bank organizers and distribution volunteers\n• Tutoring coordinators for children\n• Home repair assistants\n• Meal preparation helpers\n• Administrative support\n\nNo special skills required - just a willing heart and a desire to make a difference. We provide all necessary training and materials.\n\nVolunteer opportunities available:\n• Weekends: 9:00 AM - 12:00 PM\n• Weeknights: 6:00 PM - 8:00 PM\n• Flexible hours available\n\nInterested? Attend our volunteer orientation session on Sunday, February 28th at 2:00 PM in Fellowship Hall. Light lunch will be provided.\n\nFor more information, email volunteers@church.org or call (555) 123-4567.",
          source: "Community Outreach",
          date: "2026-01-28",
          isNew: false,
        ),
        AnnouncementModel(
          title: "Women's Bible Study Group Resuming",
          description:
              "The Women's Bible Study group is excited to announce that we are resuming our weekly meetings beginning March 2, 2026!\n\nWe will be studying the book of Esther: \"For Such a Time as This\" - exploring themes of courage, faith, and God's providence in our lives.\n\nMeeting details:\n• When: Every Tuesday evening\n• Time: 7:00 PM - 8:30 PM\n• Where: Church library\n• Prerequisites: None! All women are welcome, regardless of Bible knowledge\n\nWhat to bring:\n• Your Bible (any translation)\n• Notebook for notes\n• Open hearts and minds\n\nStudy materials will be provided or can be purchased for \$12. We also offer childcare in our nursery for those who need it.\n\nThis is a wonderful opportunity to connect with other women in our congregation, deepen your faith, and grow in God's Word. Join us for friendship, learning, and spiritual growth!\n\nFor questions or to register, contact Sarah Johnson at sarah@church.org",
          source: "Women's Ministry",
          date: "2026-01-25",
          isNew: false,
        ),
      ]);
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to fetch announcements: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class AnnouncementModel {
  final String title;
  final String description;
  final String source;
  final String date;
  final bool isNew;

  AnnouncementModel({
    required this.title,
    required this.description,
    required this.source,
    required this.date,
    required this.isNew,
  });
}
