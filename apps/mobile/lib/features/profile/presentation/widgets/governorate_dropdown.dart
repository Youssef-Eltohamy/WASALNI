import 'package:flutter/material.dart';

import '../../../../core/constants/governorates.dart';

class GovernorateDropdown extends StatelessWidget {
  const GovernorateDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    this.errorText,
  });

  final Governorate? value;
  final ValueChanged<Governorate?> onChanged;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Governorate>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: 'المحافظة',
        errorText: errorText,
      ),
      items: egyptianGovernorates
          .map(
            (g) => DropdownMenuItem(
              value: g,
              child: Text(g.nameAr),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
