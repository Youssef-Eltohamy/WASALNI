import '../../models/category.dart';
import '../../models/enums.dart';
import '../../models/listing.dart';
import '../../models/order_intent.dart';
import '../../models/product.dart';
import '../../models/village.dart';

typedef Row = Map<String, dynamic>;

ListingKind _kind(String v) => ListingKind.values.byName(v);
ListingStatus _status(String v) => ListingStatus.values.byName(v);
ListingPlan _plan(String v) => ListingPlan.values.byName(v);
double _toDouble(Object? v) => (v as num).toDouble();

Village villageFromRow(Row r) => Village(
      id: r['id'] as String,
      name: r['name'] as String,
      governorate: r['governorate'] as String,
      markaz: r['markaz'] as String,
    );

Category categoryFromRow(Row r) => Category(
      id: r['id'] as String,
      name: r['name'] as String,
      slug: r['slug'] as String,
      iconName: r['icon_name'] as String,
      kind: _kind(r['kind'] as String),
      sortOrder: (r['sort_order'] as num?)?.toInt() ?? 0,
    );

Listing listingFromRow(Row r) => Listing(
      id: r['id'] as String,
      kind: _kind(r['kind'] as String),
      ownerId: (r['owner_id'] as String?) ?? '',
      villageId: r['village_id'] as String,
      categoryId: r['category_id'] as String,
      name: r['name'] as String,
      bio: (r['bio'] as String?) ?? '',
      phoneWhatsapp: r['phone_whatsapp'] as String,
      logoUrl: r['logo_url'] as String?,
      status: _status(r['status'] as String),
      isVerified: (r['is_verified'] as bool?) ?? false,
      isFeatured: (r['is_featured'] as bool?) ?? false,
      plan: _plan(r['plan'] as String),
      isTemporarilyClosed: (r['is_temporarily_closed'] as bool?) ?? false,
      createdAt: DateTime.parse(r['created_at'] as String),
    );

Product productFromRow(Row r) => Product(
      id: r['id'] as String,
      listingId: r['listing_id'] as String,
      name: r['name'] as String,
      description: (r['description'] as String?) ?? '',
      priceEgp: _toDouble(r['price_egp']),
      imageUrl: r['image_url'] as String?,
      isAvailable: (r['is_available'] as bool?) ?? true,
      sortOrder: (r['sort_order'] as num?)?.toInt() ?? 0,
    );

Row orderIntentToRow(OrderIntent i, {required String userId}) => {
      'id': i.id,
      'user_id': userId,
      'shop_id': i.shopId,
      'shop_name': i.shopName,
      'shop_phone': i.shopPhone,
      'message': i.message,
      'total_egp': i.totalEgp,
      'item_count': i.itemCount,
      'created_at': i.createdAt.toIso8601String(),
    };
