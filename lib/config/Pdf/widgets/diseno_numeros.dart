import 'package:gustazo_cubano_app/config/Pdf/widgets/texto_dosis.dart';
import 'package:gustazo_cubano_app/config/extensions/string_extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

int cantidadRepetido(List<int> parles, List<int> sorteo) {
  int cantidad = 0;
  for (final numero in parles) {
    if (sorteo.contains(numero)) {
      cantidad++;
    }
  }
  return cantidad;
}

pw.Widget numeroRedondo({
  required num? numero,
  bool mostrarBorde = true,
  bool isParles = false,
  int lenght = 2,
  double margin = 1,
  PdfColor? color,
  pw.FontWeight? fontWeight,
}) {
  return pw.Container(
    decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: _tieneBorde(mostrarBorde: mostrarBorde, numero: numero) ? PdfColors.black : PdfColors.white),
    width: !isParles ? 40 : null,
    height: !isParles ? 40 : null,
    child: pw.Container(
      margin: pw.EdgeInsets.all(margin),
      decoration: pw.BoxDecoration(
        shape: pw.BoxShape.circle,
        color: _tieneBorde(mostrarBorde: mostrarBorde, numero: numero) ? color ?? PdfColors.white : PdfColors.white,
      ),
      child: pw.Center(
          child: pwtextoDosis(numero?.toStringAsFixed(0).rellenarCon0(lenght) ?? '', _tamLetra(numero),
              fontWeight: fontWeight)),
    ),
  );
}

bool _tieneBorde({num? numero, required bool mostrarBorde}) {
  if (numero != null && mostrarBorde) return true;
  return false;
}

double _tamLetra(num? numero) {
  if (numero != null && numero.toStringAsFixed(0).length >= 4) return 10;
  return 15;
}
