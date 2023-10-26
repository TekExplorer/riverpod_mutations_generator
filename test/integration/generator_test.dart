import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_mutations_annotation/riverpod_mutations_annotation.dart';
import 'package:test/test.dart';

part 'generator_test.g.dart';

@mutation
Future<String> login(String username, String password) async {
  return '';
}

class E {
  @mutation
  static Future<String> login2(String username, String password) async {
    return '';
  }
}

@riverpod
class Demo extends _$Demo {
  @override
  FutureOr<int> build() => 0;

  @mutation
  Future<void> change(int i) async {
    state = AsyncData(i);
  }
}

@riverpod
class DemoFamily extends _$DemoFamily {
  @override
  FutureOr<int> build(Object key) => 0;

  @mutation
  Future<void> changeFamily(int i, String? e,
      {required bool b, num n = 1}) async {
    state = AsyncData(i);
  }
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}

void main() {
  test('test', () async {
    final container = createContainer();
    final demoProviderSub = container.listen(demoProvider, (previous, next) {});
    final demoProviderChangeSub =
        container.listen(demoProvider.change, (previous, next) {});

    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(0));

    expect(demoProviderChangeSub.read(), isA<ChangeMutationIdle>());

    demoProviderChangeSub.read().call(3);
    expect(demoProviderChangeSub.read(), isA<ChangeMutationLoading>());
    // await container.pump();

    await container.pump();

    expect(demoProviderChangeSub.read(), isA<ChangeMutationSuccess>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>());
    expect(demoProviderSub.read(), AsyncData<int>(3));

    demoProviderChangeSub.close();
    await container.pump();

    final demoProviderChangeSub2 =
        container.listen(demoProvider.change, (previous, next) {});

    expect(demoProviderChangeSub2.read(), isA<ChangeMutationIdle>());
    expect(demoProviderSub.read(), isA<AsyncData<int>>(), reason: 'unchanged');
    expect(demoProviderSub.read(), AsyncData<int>(3), reason: 'unchanged');
  });
}
