class FApiConstants {

  // ── Base URLs ──────────────────────────────────────────────────
  static const String baseUrl = "https://api.foodlink.app/v1";
  static const String devBaseUrl = "https://dev.api.foodlink.app/v1";
  static const String stagingBaseUrl = "https://staging.api.foodlink.app/v1";

  // ── Timeouts ───────────────────────────────────────────────────
  static const int connectTimeout = 30000; // ms
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;

  // ── Auth Endpoints ─────────────────────────────────────────────
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String refreshToken = "/auth/refresh-token";
  static const String forgotPassword = "/auth/forgot-password";
  static const String resetPassword = "/auth/reset-password";
  static const String verifyEmail = "/auth/verify-email";
  static const String verifyOtp = "/auth/verify-otp";
  static const String resendOtp = "/auth/resend-otp";

  // ── User Endpoints ─────────────────────────────────────────────
  static const String userProfile = "/user/profile";
  static const String updateProfile = "/user/profile/update";
  static const String deleteAccount = "/user/delete";
  static const String uploadProfilePhoto = "/user/profile/photo";
  static const String userImpactStats = "/user/impact";
  static const String userRatings = "/user/ratings";

  // ── Listings Endpoints ─────────────────────────────────────────
  static const String listings = "/listings";
  static const String createListing = "/listings/create";
  static const String updateListing = "/listings/update";
  static const String deleteListing = "/listings/delete";
  static const String listingDetails = "/listings/details";
  static const String nearbyListings = "/listings/nearby";
  static const String searchListings = "/listings/search";
  static const String filterListings = "/listings/filter";
  static const String myListings = "/listings/my-listings";
  static const String savedListings = "/listings/saved";
  static const String saveListing = "/listings/save";
  static const String unsaveListing = "/listings/unsave";
  static const String uploadListingImages = "/listings/images/upload";

  // ── Claims Endpoints ───────────────────────────────────────────
  static const String claims = "/claims";
  static const String createClaim = "/claims/create";
  static const String approveClaim = "/claims/approve";
  static const String rejectClaim = "/claims/reject";
  static const String cancelClaim = "/claims/cancel";
  static const String claimDetails = "/claims/details";
  static const String myClaims = "/claims/my-claims";

  // ── Delivery / Volunteer Endpoints ─────────────────────────────
  static const String availableDeliveries = "/delivery/available";
  static const String acceptDelivery = "/delivery/accept";
  static const String updateDeliveryStatus = "/delivery/status/update";
  static const String deliveryHistory = "/delivery/history";
  static const String myDeliveries = "/delivery/my-deliveries";

  // ── Notifications Endpoints ────────────────────────────────────
  static const String notifications = "/notifications";
  static const String markNotificationRead = "/notifications/read";
  static const String markAllNotificationsRead = "/notifications/read-all";
  static const String deleteNotification = "/notifications/delete";
  static const String notificationSettings = "/notifications/settings";
  static const String registerFcmToken = "/notifications/fcm-token";

  // ── Ratings & Feedback ─────────────────────────────────────────
  static const String submitRating = "/ratings/submit";
  static const String getRatings = "/ratings";
  static const String submitFeedback = "/feedback/submit";

  // ── Maps / Location ────────────────────────────────────────────
  static const String geocode = "/location/geocode";
  static const String reverseGeocode = "/location/reverse-geocode";
  static const String updateUserLocation = "/location/update";

  // ── Categories ─────────────────────────────────────────────────
  static const String categories = "/categories";

  // ── Payment Endpoints ──────────────────────────────────────────
  static const String initiatePayment = "/payments/initiate";
  static const String verifyPayment = "/payments/verify";
  static const String paymentHistory = "/payments/history";
  static const String refundPayment = "/payments/refund";

  // ── Reports / Impact ───────────────────────────────────────────
  static const String communityImpact = "/impact/community";
  static const String leaderboard = "/impact/leaderboard";
  static const String reportListing = "/report/listing";
  static const String reportUser = "/report/user";

  // ── Header Keys ───────────────────────────────────────────────
  static const String authHeader = "Authorization";
  static const String contentType = "Content-Type";
  static const String acceptHeader = "Accept";
  static const String apiKeyHeader = "x-api-key";
  static const String bearerPrefix = "Bearer ";

  // ── Content Types ──────────────────────────────────────────────
  static const String applicationJson = "application/json";
  static const String multipartFormData = "multipart/form-data";

  // ── Query Param Keys ───────────────────────────────────────────
  static const String paramPage = "page";
  static const String paramLimit = "limit";
  static const String paramLatitude = "lat";
  static const String paramLongitude = "lng";
  static const String paramRadius = "radius";
  static const String paramCategory = "category";
  static const String paramStatus = "status";
  static const String paramSortBy = "sort_by";
  static const String paramSearch = "search";

  // ── Response Keys ──────────────────────────────────────────────
  static const String keySuccess = "success";
  static const String keyMessage = "message";
  static const String keyData = "data";
  static const String keyToken = "token";
  static const String keyRefreshToken = "refresh_token";
  static const String keyError = "error";
  static const String keyStatusCode = "status_code";
  static const String keyPagination = "pagination";
  static const String keyTotalCount = "total_count";

  // ── Status Codes ───────────────────────────────────────────────
  static const int status200 = 200;
  static const int status201 = 201;
  static const int status400 = 400;
  static const int status401 = 401;
  static const int status403 = 403;
  static const int status404 = 404;
  static const int status422 = 422;
  static const int status500 = 500;

  // ── Pagination Defaults ────────────────────────────────────────
  static const int defaultPage = 1;
  static const int defaultLimit = 10;
  static const int defaultRadius = 10; // km

  // ── Storage Keys (SharedPreferences / SecureStorage) ───────────
  static const String keyAuthToken = "auth_token";
  static const String keyRefreshTokenStore = "refresh_token";
  static const String keyUserId = "user_id";
  static const String keyUserRole = "user_role";
  static const String keyOnboardingSeen = "onboarding_seen";
  static const String keyThemeMode = "theme_mode";
  static const String keyFcmToken = "fcm_token";
  static const String keyUserLocation = "user_location";
}