import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di.dart';
import '../../../core/connectivity/connectivity_cubit.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/empty_view.dart';
import '../../../data/models/cart.dart';
import '../../../data/models/order_intent.dart';
import '../../../data/models/product.dart';
import '../../../data/repositories/product_repository.dart';
import '../bloc/cart_cubit.dart';
import '../cart_sender.dart';
import '../widgets/shop_cart_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.productRepository, this.sender, this.userName = ''});
  final ProductRepository? productRepository;
  final CartSender? sender;
  final String userName;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _revalidate());
  }

  Future<void> _revalidate() async {
    final repo = widget.productRepository ?? getIt<ProductRepository>();
    final cart = context.read<CartCubit>();
    for (final shop in cart.state.shopCarts) {
      final latest = <String, Product?>{};
      for (final line in shop.lines) {
        try {
          latest[line.productId] = await repo.getProductById(line.productId);
        } catch (_) {
          latest[line.productId] = null; // treat as unavailable
        }
      }
      if (!mounted) return;
      cart.applyRevalidation(shop.shopId, latest);
    }
  }

  Future<void> _send(ShopCart shop) async {
    final sender = widget.sender ?? getIt<CartSender>();
    final cart = context.read<CartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    final isOnline = context.read<ConnectivityCubit>().state == ConnectivityStatus.online;

    final outcome = await sender.send(shop, userName: widget.userName, isOnline: isOnline);
    if (!mounted) return;
    switch (outcome) {
      case SendOutcome.sent:
        cart.clearShop(shop.shopId);
        messenger.showSnackBar(const SnackBar(content: Text('فتحنا واتساب بطلبك ✅')));
      case SendOutcome.queued:
        cart.clearShop(shop.shopId);
        messenger.showSnackBar(const SnackBar(
            content: Text('مفيش نت — هنبعت الطلب أول ما النت يرجع')));
      case SendOutcome.whatsappFailed:
        messenger.showSnackBar(const SnackBar(
            content: Text('تعذّر فتح واتساب — اتأكد إنه متنصّب')));
      case SendOutcome.noPhone:
        messenger.showSnackBar(const SnackBar(
            content: Text('المحل ده مالوش رقم واتساب')));
    }
  }

  Future<void> _confirmRemove(String shopId, String productId, String name) async {
    final cart = context.read<CartCubit>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الصنف'),
        content: Text('تحذف "$name" من السلة؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('رجوع')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (ok ?? false) cart.removeLine(shopId, productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('السلة')),
      body: BlocBuilder<CartCubit, Cart>(
        builder: (context, cart) {
          if (cart.isEmpty) {
            return const EmptyView(
              icon: Icons.shopping_cart_outlined,
              message: 'سلتك فاضية — ضيف منتجات من المحلات',
            );
          }
          final cubit = context.read<CartCubit>();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              for (final shop in cart.shopCarts)
                ShopCartCard(
                  shop: shop,
                  onIncrement: (pid) => cubit.increment(shop.shopId, pid),
                  onDecrement: (pid) => cubit.decrement(shop.shopId, pid),
                  onRemove: (pid) {
                    final line = shop.lines.firstWhere((l) => l.productId == pid);
                    _confirmRemove(shop.shopId, pid, line.name);
                  },
                  onSend: () => _send(shop),
                ),
              const SizedBox(height: AppSpacing.md),
              Text('كل محل بيستلم طلبه على واتساب لوحده',
                  textAlign: TextAlign.center, style: AppTextStyles.caption),
            ],
          );
        },
      ),
    );
  }
}
