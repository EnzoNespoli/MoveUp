import 'dart:async';
import 'dart:io';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart'
    show SubscriptionOfferDetails;

class PurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _sub;
  List<ProductDetails> _products = [];

  Future<void> init() async {
    if (!Platform.isAndroid) return;
    final available = await _iap.isAvailable();
    if (!available) throw Exception('Google Play not available');
    _sub = _iap.purchaseStream.listen(_onPurchaseUpdate,
        onDone: () => _sub?.cancel(), onError: (e) {});
  }

  Future<void> dispose() async => _sub?.cancel();

  Future<void> loadProducts(Set<String> ids) async {
    final resp = await _iap.queryProductDetails(ids);
    if (resp.error != null) throw Exception(resp.error!.message);
    _products = resp.productDetails;
  }

  ProductDetails? _byId(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  // ---- NUOVO: acquisto ABBONAMENTO (con base plan / offer) ----
  Future<void> buySubscription({
    required String productId, // es. "move.premium"
    String? basePlanId, // es. "month"
    String? offerId, // es. "trial7d" (opzionale)
    String? accountId,
  }) async {
    // carica il prodotto
    final resp = await _iap.queryProductDetails({productId});
    if (resp.productDetails.isEmpty) {
      throw Exception('Product $productId not found on Play');
    }
    final product = resp.productDetails.first;


 List<dynamic> _androidOffers(GooglePlayProductDetails gp) {
  final d = gp as dynamic;
  try { final v = d.subscriptionOfferDetails; if (v is List) return List<dynamic>.from(v); } catch (_) {}
  try { final v = d.productDetails?.subscriptionOfferDetails; if (v is List) return List<dynamic>.from(v); } catch (_) {}
  try { final v = d.billingClientProductDetails?.subscriptionOfferDetails; if (v is List) return List<dynamic>.from(v); } catch (_) {}
  return const <dynamic>[];
}

String? _offerTokenOf(dynamic offer) {
  try { return offer.offerToken as String; } catch (_) {}
  try { return offer.offerIdToken as String; } catch (_) {} // alcune versioni usano questo nome
  return null;
}

String? _offerIdOf(dynamic offer) {
  try { return offer.offerId as String; } catch (_) { return null; }
}

String? _basePlanIdOf(dynamic offer) {
  try { return offer.basePlanId as String; } catch (_) { return null; }
}

//----------------------------------

String? offerToken;

if (product is GooglePlayProductDetails) {
  final gp = product as GooglePlayProductDetails;
  final offers = _androidOffers(gp); // mai toccare getter “fissi”

  if (offers.isNotEmpty) {
    // scegli l’offerta: prima per offerId, poi per basePlanId, altrimenti la prima
    dynamic chosen = offers.first;

    if (offerId != null) {
      final byOffer = offers.where((o) => _offerIdOf(o) == offerId).toList();
      if (byOffer.isNotEmpty) chosen = byOffer.first;
    } else if (basePlanId != null) {
      final byPlan = offers.where((o) => _basePlanIdOf(o) == basePlanId).toList();
      if (byPlan.isNotEmpty) chosen = byPlan.first;
    }

    offerToken = _offerTokenOf(chosen);
  }
}

final param = GooglePlayPurchaseParam(
  productDetails: product,
  applicationUserName: accountId,
  // passa il token solo se siamo riusciti a estrarlo
  offerToken: offerToken,
);

await _iap.buyNonConsumable(purchaseParam: param);
  
  }

  // ---- vecchio buy per una tantum/consumabili, lo puoi tenere ----
  Future<void> buy({
    required String productId,
    bool consumable = false,
    String? accountId,
  }) async {
    var product = _byId(productId);
    if (product == null) {
      final r = await _iap.queryProductDetails({productId});
      if (r.productDetails.isEmpty) {
        throw Exception('Prodotto $productId non trovato su Play');
      }
      product = r.productDetails.first;
    }
    final param = GooglePlayPurchaseParam(
      productDetails: product,
      applicationUserName: accountId,
    );
    if (consumable) {
      await _iap.buyConsumable(purchaseParam: param);
    } else {
      await _iap.buyNonConsumable(purchaseParam: param);
    }
  }

  Future<void> _onPurchaseUpdate(List<PurchaseDetails> updates) async {
    for (final p in updates) {
      switch (p.status) {
        case PurchaseStatus.pending:
          break;
        case PurchaseStatus.error:
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          final ok = await _verifyWithServer(p);
          if (ok) {
            await _deliverEntitlement(p);
            if (p.pendingCompletePurchase) {
              await _iap.completePurchase(p);
            }
          }
          break;
        default:
          break;
      }
    }
  }

  Future<bool> _verifyWithServer(PurchaseDetails p) async {
    return true;
  }

  Future<void> _deliverEntitlement(PurchaseDetails p) async {}
}
