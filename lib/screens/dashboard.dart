import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.post.isRepost) _buildRepostBanner(),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildContent(),
                if (widget.post.images.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildImageCarousel(),
                ],
                const SizedBox(height: 10),
                _buildActionBar(),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        ],
      ),
    );
  }

  Widget _buildRepostBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
      child: Row(
        children: [
          const Icon(Icons.repeat, size: 14, color: Color(0xFF666666)),
          const SizedBox(width: 6),
          Text(
            '${widget.post.repostedBy} Reposted',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF666666),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFE0E0E0),
          child: CachedNetworkImage(
            imageUrl:
            widget.post.images.isNotEmpty ? widget.post.images[0] : '',
            imageBuilder: (ctx, img) => CircleAvatar(
              radius: 20,
              backgroundImage: img,
            ),
            errorWidget: (ctx, url, err) => CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF2B3A8C),
              child: Text(
                widget.post.authorName[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.post.authorName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  if (widget.post.isVerified) ...[
                    const SizedBox(width: 4),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1DA1F2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 10, color: Colors.white),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 1),
              Text(
                widget.post.authorHandle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 11, color: Color(0xFF888888)),
                  const SizedBox(width: 2),
                  Text(
                    widget.post.authorLocation,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF888888),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Row(
          children: [
            Text(
              _formatTime(widget.post.postedAt),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF888888),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.more_vert, size: 18, color: Color(0xFF888888)),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    final text = widget.post.content;
    const maxLen = 220;
    final isTruncated = text.length > maxLen;
    final displayText = isTruncated ? '${text.substring(0, maxLen)}...' : text;

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF1A1A1A),
          height: 1.45,
          fontFamily: 'sans-serif',
        ),
        children: [
          TextSpan(text: displayText),
          if (isTruncated)
            const TextSpan(
              text: ' Read More',
              style: TextStyle(
                color: Color(0xFF2B3A8C),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    final images = widget.post.images;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: images.length,
              onPageChanged: (i) => setState(() => _currentImageIndex = i),
              itemBuilder: (ctx, i) => CachedNetworkImage(
                imageUrl: images[i],
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (ctx, url) => Container(
                  color: const Color(0xFFE8E8E8),
                  child: const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Color(0xFF2B3A8C)),
                  ),
                ),
                errorWidget: (ctx, url, err) => Container(
                  color: const Color(0xFFD0D5E8),
                  child: const Icon(Icons.image,
                      size: 48, color: Color(0xFF999999)),
                ),
              ),
            ),
          ),

          if (images.length > 1)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${_currentImageIndex + 1}/${images.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (images.length > 1)
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                      (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: i == _currentImageIndex ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: i == _currentImageIndex
                          ? Colors.white
                          : Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionItem(
          icon: _isLiked ? Icons.favorite : Icons.favorite_border,
          color: _isLiked ? const Color(0xFFE0245E) : const Color(0xFF888888),
          count: widget.post.likes + (_isLiked ? 1 : 0),
          onTap: () => setState(() => _isLiked = !_isLiked),
        ),
        _actionItem(
          icon: Icons.chat_bubble_outline,
          count: widget.post.comments,
          onTap: () {},
        ),
        _actionItem(
          icon: Icons.repeat,
          count: widget.post.reposts,
          onTap: () {},
        ),
        _actionItem(
          icon: Icons.remove_red_eye_outlined,
          count: widget.post.views,
          onTap: () {},
        ),
        _actionItem(
          icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          color: _isBookmarked
              ? const Color(0xFF2B3A8C)
              : const Color(0xFF888888),
          count: widget.post.bookmarks,
          onTap: () => setState(() => _isBookmarked = !_isBookmarked),
        ),
        GestureDetector(
          onTap: () {},
          child: const Row(
            children: [
              Icon(Icons.share_outlined, size: 15, color: Color(0xFF888888)),
              SizedBox(width: 3),
              Text(
                'Share',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888888),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _actionItem({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
    Color color = const Color(0xFF888888),
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 3),
          Text(
            _formatCount(count),
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}