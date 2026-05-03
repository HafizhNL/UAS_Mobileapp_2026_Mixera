import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/presentation/widgets/address_card.dart';

void main() {
  const primaryAddr = AddressModel(
    id: 1,
    label: 'home',
    recipientName: 'Alex Primary',
    phoneNumber: '081111',
    streetAddress: 'Jl. Satu',
    city: 'Bandung',
    state: 'Jabar',
    postalCode: '40123',
    isPrimary: true,
  );

  const secondaryAddr = AddressModel(
    id: 2,
    label: 'office',
    recipientName: 'Alex Office',
    phoneNumber: '082222',
    streetAddress: 'Jl. Dua',
    city: 'Jakarta',
    state: 'DKI',
    postalCode: '10310',
    isPrimary: false,
  );

  testWidgets('primary address shows Edit and Delete', (tester) async {
    var edits = 0;
    var deletes = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddressCard(
            address: primaryAddr,
            onEdit: () => edits++,
            onDelete: () => deletes++,
          ),
        ),
      ),
    );

    expect(find.text('Home address'), findsOneWidget);
    expect(find.text('Alex Primary'), findsOneWidget);
    expect(find.textContaining('Primary Address'), findsOneWidget);

    await tester.tap(find.text('Edit'));
    await tester.tap(find.text('Delete'));
    expect(edits, 1);
    expect(deletes, 1);
  });

  testWidgets('non-primary shows Set As Primary and invokes callback', (tester) async {
    var primaryCalls = 0;
    var deletes = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AddressCard(
            address: secondaryAddr,
            onEdit: () {},
            onDelete: () => deletes++,
            onSetPrimary: () => primaryCalls++,
          ),
        ),
      ),
    );

    expect(find.text('Office address'), findsOneWidget);
    expect(find.text('Set As Primary'), findsOneWidget);

    await tester.tap(find.text('Set As Primary'));
    expect(primaryCalls, 1);
    expect(deletes, 0);
  });
}
