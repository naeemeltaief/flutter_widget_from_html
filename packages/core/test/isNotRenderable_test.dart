import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/dom.dart' as dom;

import '_.dart';

class _DoNotRenderSkipMe extends WidgetFactory {
  _DoNotRenderSkipMe(BuildContext context) : super(context);

  @override
  NodeMetadata parseElement(NodeMetadata meta, dom.Element e) =>
      e.className == 'skipMe'
          ? lazySet(meta, isNotRenderable: true)
          : super.parseElement(meta, e);
}

void main() {
  testWidgets('skips via callback', (WidgetTester tester) async {
    final html = '<span class="skipMe">Foo.</span>Bar.';
    final explained1 = await explain(tester, html);
    expect(explained1, equals('[Text:Foo.Bar.]'));

    final explained2 = await explain(
      tester,
      html,
      wf: (c) => _DoNotRenderSkipMe(c),
    );
    expect(explained2, equals('[Text:Bar.]'));
  });
}
