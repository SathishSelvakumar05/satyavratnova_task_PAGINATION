class PostModel {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorLocation;
  final bool isVerified;
  final String content;
  final List<String> images;
  final DateTime postedAt;
  final int likes;
  final int comments;
  final int reposts;
  final int views;
  final int bookmarks;
  final bool isRepost;
  final String? repostedBy;

  PostModel({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorLocation,
    required this.isVerified,
    required this.content,
    required this.images,
    required this.postedAt,
    required this.likes,
    required this.comments,
    required this.reposts,
    required this.views,
    required this.bookmarks,
    this.isRepost = false,
    this.repostedBy,
  });
}

List<PostModel> getDummyPosts() {
  return [
    PostModel(
      id: '1',
      authorName: 'Revanth Reddy',
      authorHandle: '@Reva_reddy852',
      authorLocation: 'Mumbai, India',
      isVerified: true,
      content:
      'Hyderabad: Telangana Chief Minister, A. Revanth Reddy, on Thursday said that delimitation is going to be a limitation for the South...\n\nHe also alleged that the Centre was conspiring against South Indian states in the name of delimitation.\n\nHe said the Congress party has in principle decided to attend the meeting of political parties called by Tamil Nadu Chief Minister and DMK leader MK Stalin in Chennai on March 22 to discuss the impact of the proposed delimitation on the Southern states.\n\nRevanth Reddy, who is one of the seven chief ministers invited by CM Stalin for the meeting, said he would attend the meeting after taking permission from the Congress high comm...',
      images: [
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=800',
        'https://images.unsplash.com/photo-1556157382-97eda2d62296?w=800',
        'https://images.unsplash.com/photo-1573497019940-1c28c88b4f3e?w=800',
      ],
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      likes: 228,
      comments: 18,
      reposts: 48,
      views: 48,
      bookmarks: 20,
      isRepost: true,
      repostedBy: 'You',
    ),
    PostModel(
      id: '2',
      authorName: 'Shivraj singh',
      authorHandle: '@SSC_shivraj',
      authorLocation: 'Bhopal, India',
      isVerified: true,
      content:
      'Having presided over the BJP\'s thumping victory in the Madhya Pradesh Assembly polls.',
      images: [
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=800',
        'https://images.unsplash.com/photo-1556157382-97eda2d62296?w=800',
      ],
      postedAt: DateTime(2024, 1, 10),
      likes: 412,
      comments: 34,
      reposts: 89,
      views: 156,
      bookmarks: 45,
    ),
    PostModel(
      id: '3',
      authorName: 'Rahul Gandhi',
      authorHandle: '@RahulGandhi',
      authorLocation: 'New Delhi, India',
      isVerified: true,
      content:
      'India\'s strength lies in its diversity. We must protect the Constitution and uphold the values of equality and justice for all citizens. Democracy is not just about elections — it\'s about listening to people.',
      images: [],
      postedAt: DateTime.now().subtract(const Duration(hours: 3)),
      likes: 1820,
      comments: 245,
      reposts: 389,
      views: 4500,
      bookmarks: 310,
    ),
    PostModel(
      id: '4',
      authorName: 'Arvind Kejriwal',
      authorHandle: '@ArvindKejriwal',
      authorLocation: 'Delhi, India',
      isVerified: true,
      content:
      'Delhi\'s mohalla clinics have been a revolution in healthcare. Today, we inaugurated 10 more clinics in East Delhi. Free medicines, free tests — healthcare is a right, not a privilege. 🏥',
      images: [
        'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=800',
      ],
      postedAt: DateTime.now().subtract(const Duration(hours: 6)),
      likes: 3241,
      comments: 567,
      reposts: 892,
      views: 12000,
      bookmarks: 678,
    ),
    PostModel(
      id: '5',
      authorName: 'Smriti Irani',
      authorHandle: '@SmritiIrani',
      authorLocation: 'Mumbai, India',
      isVerified: true,
      content:
      'Proud to share that India\'s textile exports have grown by 18% this quarter. Our weavers and artisans are the backbone of our heritage. Supporting them means supporting Bharat! 🇮🇳',
      images: [],
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      likes: 982,
      comments: 123,
      reposts: 234,
      views: 3400,
      bookmarks: 167,
    ),
  ];
}