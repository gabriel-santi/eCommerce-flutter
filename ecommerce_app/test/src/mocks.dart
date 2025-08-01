import 'package:ecommerce_app/src/features/authentication/data/auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/checkout/application/fake_checkout_service.dart';
import 'package:ecommerce_app/src/features/products/data/products_fake_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockRemoteCartRepository extends Mock implements RemoteCartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockProductsRepository extends Mock implements ProductsFakeRepository {}

class MockCartService extends Mock implements CartService {}

class MockCheckoutService extends Mock implements FakeCheckoutService {}
