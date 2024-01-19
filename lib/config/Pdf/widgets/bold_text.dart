import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.RichText pwboldLabel(String texto, String another, double? fontSize,
    {PdfColor? color = PdfColors.black}) {
  return pw.RichText(
    text: pw.TextSpan(
      // Here is the explicit parent TextStyle
      style: pw.TextStyle(
        fontSize: fontSize,
        color: color,
      ),
      children: <pw.TextSpan>[
        pw.TextSpan(
            text: texto, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.TextSpan(text: another),
      ],
    ),
  );
}