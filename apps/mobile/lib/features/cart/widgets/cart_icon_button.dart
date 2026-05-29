import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/cart_cubit.dart';

/// AppBar action: cart icon with an item-count badge. Taps → /cart.
class CartIconButton extends StatelessWidget {
  const CartIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<CartCubit>().state.totalItemCount;
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          tooltip: 'السلة',
          onPressed: () => context.push('/cart'),
        ),
        if (count > 0)
          PositionedDirectional(
            top: 6,
            end: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              constraints: const BoxConstraints(minWidth: 16),
              child: Text(
                '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontFamily: 'Cairo', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
