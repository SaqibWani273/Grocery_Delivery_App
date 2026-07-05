# 🛒 Grocery Delivery App

A pixel-perfect Flutter implementation of a beautiful [Dribbble](https://dribbble.com) grocery delivery concept — built to explore advanced UI, custom shapes, and smooth animations.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.10-0175C2?logo=dart&logoColor=white)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android-lightgrey)

## 📽️ Demo

<!-- TODO: add screen recording -->
*Screen recording coming soon.*

## ✨ Screens

- **Dashboard** — collapsing curved header with a scroll-driven, parabolic category row
- **All Products** — collapsing header, product grid, and a fly-to-cart animation
- **Product Details** — inward-curved header, store offers, expandable sections, quantity + add to cart
- **Choose Store** — dome-top bottom sheet with staggered store list
- **Store Profile** — overlapping header card, animated Delivery/Pickup toggle, best-selling products
- **All Categories** — curved header with a staggered category grid

## 🧠 Key concepts learned

Building this design from scratch meant going well beyond stock widgets:

| Concept | Where it's used |
|---|---|
| `CustomScrollView` + slivers (`SliverGrid`, `SliverToBoxAdapter`) | Every scrollable screen |
| `SliverPersistentHeaderDelegate` | Collapsing dashboard header & fixed pinned curved headers |
| **Quadratic bézier curves** via `CustomClipper<Path>` | Outward/inward header curves, dome-top bottom sheet |
| Bézier **flight paths** with `Overlay` + `AnimationController` | Fly-to-cart animation |
| `GlobalKey` + `RenderBox.localToGlobal` | Measuring take-off/landing positions across the widget tree |
| `Hero` animations | Product image, search bar & cart icon gliding between screens |
| `CustomPainter` | Scalloped store awnings, drag-handle arc |
| Scroll-driven transforms | Category circles riding a parabolic curve as you scroll |
| Implicit animations (`AnimatedContainer`, `AnimatedSize`, `AnimatedRotation`, `AnimatedSwitcher`, `AnimatedAlign`) | Store selection, expandables, quantity stepper, toggle thumb |
| Staggered entrances with `flutter_animate` | Section and list reveals on every screen |
| `provider` state management | App-wide cart state + route-scoped screen state |

## 🚀 Getting started

```bash
# 1. Clone
git clone https://github.com/SaqibWani273/Grocery_Delivery_App.git
cd Grocery_Delivery_App

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or simulator
flutter run
```

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart ≥ 3.10).

## ⭐ Support

If you found this project helpful or picked up something new, consider giving it a **star** — it helps others discover it and keeps me motivated to build more.

---

*Built with Flutter, curiosity, and a lot of bézier curves.*
