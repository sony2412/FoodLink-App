
enum TextSizes { small, medium, large }
enum OrderStatus { processing, shipped, delivered }
enum PaymentMethods { paypal, googlePay, applePay, visa, masterCard, creditCard, payStack, razorPay, paytm }



enum UserRole { donor, recipient, volunteer, ngo }

enum FoodCategory {
  cookedFood,
  rawIngredients,
  bakery,
  dairy,
  fruitsAndVegetables,
  packagedFood,
  beverages,
  other,
}

enum DietaryType { vegetarian, nonVegetarian, vegan, glutenFree, dairyFree }

enum ListingStatus { available, claimed, expired, cancelled }

enum ClaimStatus { pending, approved, rejected, cancelled, completed }

enum DeliveryStatus { notStarted, inProgress, pickedUp, delivered, failed }

enum NotificationType {
  newListingNearby,
  claimApproved,
  claimReceived,
  claimRejected,
  listingExpiringSoon,
  deliveryAssigned,
  newMessage,
}

enum AppTheme { light, dark, system }

enum SortOrder { newest, oldest, nearestFirst, expiringFirst }

enum QuantityUnit { kg, grams, litres, ml, plates, boxes, packets, pieces, servings }