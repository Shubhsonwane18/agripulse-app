import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/store_viewmodel.dart';

class StoreView extends StatelessWidget {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final authVm = context.watch<AuthViewModel>();
    final storeVm = context.watch<StoreViewModel>();
    final loc = authVm.locale;
    final isMr = loc == 'mr';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppStrings.get('storeTitle', locale: loc),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
        ),
      ),
      floatingActionButton: storeVm.cartCount > 0
          ? FloatingActionButton.extended(
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                '${storeVm.cartCount} ${AppStrings.tr(loc, en: "items", mr: "वस्तू", hi: "आइटम", te: "వస్తువులు", kn: "ವಸ್ತುಗಳು", gu: "વસ્તુઓ")} • ₹${storeVm.cartTotal.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _showCartSheet(context, storeVm, loc),
            )
          : null,
      body: Column(
        children: [
          // Category Filter Tabs
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryTab(storeVm, 'all', AppStrings.tr(loc, en: 'All', mr: 'सर्व', hi: 'सभी', te: 'అన్నీ', kn: 'ಎಲ್ಲಾ', gu: 'બધા')),
                _buildCategoryTab(storeVm, 'fertilizers', AppStrings.tr(loc, en: 'Fertilizers', mr: 'खते', hi: 'खाद', te: 'ఎరువులు', kn: 'ರಸಗೊಬ್ಬರಗಳು', gu: 'ખાતર')),
                _buildCategoryTab(storeVm, 'pesticides', AppStrings.tr(loc, en: 'Pesticides', mr: 'कीटकनाशके', hi: 'कीटनाशक', te: 'పురుగుమందులు', kn: 'ಕೀಟನಾಶಕಗಳು', gu: 'જંતુનાશક')),
                _buildCategoryTab(storeVm, 'seeds', AppStrings.tr(loc, en: 'Seeds', mr: 'बियाणे', hi: 'बीज', te: 'విత్తనాలు', kn: 'ಬೀಜಗಳು', gu: 'બિયારણ')),
              ],
            ),
          ),
          const Divider(height: 1),

          // Product Grid
          Expanded(
            child: storeVm.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: storeVm.products.length,
                    itemBuilder: (context, idx) {
                      final p = storeVm.products[idx];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariant,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 36),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isMr && p.localName.isNotEmpty ? p.localName : p.name,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              p.unit,
                              style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '₹${p.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_shopping_cart, color: AppColors.primary, size: 20),
                                  onPressed: () => storeVm.addToCart(p),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTab(StoreViewModel vm, String id, String label) {
    final isSel = vm.selectedCategory == id;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
        selected: isSel,
        selectedColor: AppColors.accentLight,
        onSelected: (_) => vm.setCategory(id),
      ),
    );
  }

  void _showCartSheet(BuildContext context, StoreViewModel storeVm, String loc) {
    final isMr = loc == 'mr';
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.tr(loc, en: 'My Cart', mr: 'माझी खरेदी (Cart)', hi: 'मेरी कार्ट', te: 'నా కార్ట్', kn: 'ನನ್ನ ಕಾರ್ಟ್', gu: 'મારી કાર્ટ'),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              ...storeVm.cart.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${isMr ? item.product.localName : item.product.name} x ${item.quantity}'),
                        Text('₹${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.tr(loc, en: 'Total Amount:', mr: 'एकूण रक्कम (Total):', hi: 'कुल राशि:', te: 'మొత్తం మొత్తం:', kn: 'ಒಟ್ಟು ಮೊತ್ತ:', gu: 'કુલ રકમ:'),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '₹${storeVm.cartTotal.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  storeVm.clearCart();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        AppStrings.tr(
                          loc,
                          en: 'Order placed successfully! We will contact you shortly.',
                          mr: 'खतांची मागणी नोंदवली गेली आहे! लवकरच संपर्क साधण्यात येईल.',
                          hi: 'आर्डर सफलतापूर्वक दर्ज किया गया! हम शीघ्र संपर्क करेंगे।',
                          te: 'ఆర్డర్ విజయవంతంగా నమోదు చేయబడింది!',
                          kn: 'ಆರ್ಡರ್ ಯಶಸ್ವಿಯಾಗಿ ನೀಡಲಾಗಿದೆ!',
                          gu: 'ઓર્ડર સફળતાપૂર્વક મૂકાયો!',
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size.fromHeight(44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  AppStrings.get('checkout', locale: loc),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
