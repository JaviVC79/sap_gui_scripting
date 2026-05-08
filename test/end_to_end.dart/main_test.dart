// End-to-end tests require a running SAP GUI instance and cannot run in CI.
// These tests are skipped by default. To run them, use:
//   dart test --tags=sap test/end_to_end.dart/

@TestOn('windows')
library;

import 'package:test/test.dart';

void main() {
  test('placeholder - SAP end-to-end tests require a live SAP GUI instance', () {
    // This test file exists as a template for manual end-to-end testing.
    // Uncomment and adapt the code below when SAP GUI is available.
  }, tags: ['sap']);
}
