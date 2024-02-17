import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget pwtextoDosis(
  String texto,
  double? fontSize, {
  pw.FontWeight? fontWeight = pw.FontWeight.normal,
  pw.TextAlign? textAlign = pw.TextAlign.left,
  PdfColor? color = PdfColors.black,
  int? maxLines,
}) {
  return pw.Text(
    texto,
    maxLines: maxLines,
    style: pw.TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
    textAlign: textAlign,
  );
}
